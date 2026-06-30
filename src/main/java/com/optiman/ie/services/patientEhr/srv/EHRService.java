package com.optiman.ie.services.patientEhr.srv;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.patientAccount.repository.PatientAccount;
import com.optiman.ie.services.patientAccount.repository.PatientAccountDao;
import com.optiman.ie.services.patientEhr.model.*;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.charset.StandardCharsets;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import static com.optiman.ie.constant.GlobalConst.EHR_RECORDS;
import static com.optiman.ie.constant.ProjectDataMapping.DATA_FOLDER;


@Slf4j
@Service
public class EHRService {

    private static final byte ENCRYPTION_VERSION_V1 = 0x01;
    private static final int GCM_IV_LENGTH = 12;   // 96 bits (recommended)
    private static final int GCM_TAG_LENGTH = 128; // bits

    private static final String EHR_DATA_DIR = DATA_FOLDER + File.separator + EHR_RECORDS + File.separator;

    private static final String SECRET_KEY = "vG8tjLw5Qz2xRf1B"; // Demo key; use env var in prod.
    private static final JAXBContext JAXB_CONTEXT;

    static {
        try {
            JAXB_CONTEXT = JAXBContext.newInstance(PatientEhr.class);
        } catch (Exception e) {
            e.printStackTrace(); // important: shows the 2 exact illegal annotations
            throw new RuntimeException("Failed to initialize JAXBContext", e);
        }
    }


    private final ConcurrentHashMap<String, Object> patientLocks = new ConcurrentHashMap<>();
    private PatientAccountDao paitentAccountDao;

    public EHRService(PatientAccountDao paitentAccountDao) {
        this.paitentAccountDao = paitentAccountDao;
        File dir = new File(EHR_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    public File getPatientFile(String patientId) {
        return new File(EHR_DATA_DIR, patientId + ".xml");
    }



    public void createEhrXmlFileIfNotExists(PatientAccount patientAccount) throws Exception {

        String patientId = patientAccount.getUserId();

        File file = getPatientFile(patientId);
        File backupFile = new File(file.getParent(), file.getName() + ".bak");

        // If main file already exists, nothing to do
        if (file.exists()) {
            return;
        }

        // If main file missing but backup exists → restore
        if (backupFile.exists()) {

            Files.copy(
                    backupFile.toPath(),
                    file.toPath(),
                    StandardCopyOption.REPLACE_EXISTING
            );

            log.warn("EHR file restored from backup for patientId={}", patientId);
            return;
        }

        // Otherwise create a new EHR
        PatientEhr ehr = mapPatientDetailWithEHRObject(patientAccount);

        writeXml(ehr, ehr.getPatientDetail().getPatientId());

        log.info("Created new EHR XML file for patient: {}", ehr.getPatientDetail());
    }

    /**
     * Serializes the PatientEhr object to XML, encrypts it,
     * and writes it safely using atomic file replacement.
     */
    public void writeXml(PatientEhr ehr, String patientId) throws Exception {

        synchronized (getPatientLock(patientId)) {

            File file = getPatientFile(patientId);
            Files.createDirectories(file.getParentFile().toPath());

            // Temporary file in same directory (required for atomic move)
            File tempFile = new File(file.getParent(), file.getName() + ".tmp");

            Marshaller marshaller = JAXB_CONTEXT.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");

            // Marshal XML to memory
            ByteArrayOutputStream xmlOut = new ByteArrayOutputStream();
            marshaller.marshal(ehr, xmlOut);

            byte[] encrypted = encryptBytes(xmlOut.toByteArray());

            // Write to temp file first
            try (FileChannel channel = FileChannel.open(
                    tempFile.toPath(),
                    StandardOpenOption.CREATE,
                    StandardOpenOption.WRITE,
                    StandardOpenOption.TRUNCATE_EXISTING);
                 FileLock lock = channel.lock()) {

                channel.write(ByteBuffer.wrap(encrypted));
                channel.force(true); // ensure flush to disk
            }


            // Create/update backup of the current file
            File backupFile = new File(file.getParent(), file.getName() + ".bak");
            if (file.exists()) {
                Files.copy(
                        file.toPath(),
                        backupFile.toPath(),
                        StandardCopyOption.REPLACE_EXISTING
                );
            }


            // Atomic replace original file
            try {
                Files.move(
                        tempFile.toPath(),
                        file.toPath(),
                        StandardCopyOption.REPLACE_EXISTING,
                        StandardCopyOption.ATOMIC_MOVE
                );
            } catch (AtomicMoveNotSupportedException e) {
                Files.move(
                        tempFile.toPath(),
                        file.toPath(),
                        StandardCopyOption.REPLACE_EXISTING
                );
            }
        }

        // Update last action date in PatientAccount database table
        updatePatientLastActionDate(patientId);
    }


    private Object getPatientLock(String patientId) {
        return patientLocks.computeIfAbsent(patientId, k -> new Object());
    }


    /**
     * Reads and decrypts the PatientEhr XML file for the given patientId.
     *
     * @param patientId The patient ID
     * @return The PatientEhr object, or null if not found or error occurs
     */
    public PatientEhr readXml(String patientId) {

        File file = getPatientFile(patientId);
        //log.info("Attempting to read EHR XML file for patientId={}", patientId);
        if (!file.exists()) return null;
        try {

            byte[] encryptedBytes = Files.readAllBytes(file.toPath());
            byte[] decryptedBytes = decryptBytes(encryptedBytes);
            Unmarshaller unmarshaller = JAXB_CONTEXT.createUnmarshaller();

            try (ByteArrayInputStream in = new ByteArrayInputStream(decryptedBytes)) {
                return (PatientEhr) unmarshaller.unmarshal(in);
            }

        } catch (Exception e) {
            log.error("Primary EHR corrupted. Attempting recovery for patientId={}", patientId);
            try {
                File backup = new File(EHR_DATA_DIR, patientId + ".xml.bak");
                if (backup.exists()) {
                    byte[] encryptedBytes = Files.readAllBytes(backup.toPath());
                    byte[] decryptedBytes = decryptBytes(encryptedBytes);

                    Unmarshaller unmarshaller = JAXB_CONTEXT.createUnmarshaller();
                    return (PatientEhr) unmarshaller.unmarshal(new ByteArrayInputStream(decryptedBytes));
                }
            } catch (Exception ex) {
                log.error("Backup recovery failed for patientId={}", patientId, ex);
            }
        }
        return null;
    }


    /**
     * Assigns a value to any field in PatientEhr (single or collection), and writes the XML file.
     *
     * @param ehr       The PatientEhr object to update
     * @param fieldName The name of the field in PatientEhr (e.g., "medicalLogs", "allergy", etc)
     * @param value     The value to set. For collections, pass a List. For single value, pass the instance.
     * @throws Exception Any reflection or IO errors
     *                   <p>
     *                   How to use this method
     *                   -- To set a single PatientDetail
     *                   ehrService.assignAndWriteXml(ehr, "patientDetail", patientDetailInstance);
     *                   -- To add a single MedicalLogs entry
     *                   ehrService.assignAndWriteXml(ehr, "medicalLogs", medicalLogsInstance);
     *                   -- To add a list of allergies
     *                   ehrService.assignAndWriteXml(ehr, "allergy", Arrays.asList(allergy1, allergy2));
     */
    public void addAndWriteXml(PatientEhr ehr, String fieldName, Object value) throws Exception {
        Field field = PatientEhr.class.getDeclaredField(fieldName);
        field.setAccessible(true);

        // If the field is a Collection, and value is a single item or List, add it to the collection with duplicate check
        if (java.util.Collection.class.isAssignableFrom(field.getType())) {
            Object existing = field.get(ehr);
            List list;
            if (existing == null) {
                list = new ArrayList();
                field.set(ehr, list);
            } else {
                list = (List) existing;
            }

            if (value instanceof List) {
                for (Object item : (List) value) {
                    if (!list.contains(item)) {
                        list.add(item);
                    }
                }
            } else {
                if (!list.contains(value)) {
                    list.add(value);
                }
            }
        } else {
            // For single value fields, just set
            field.set(ehr, value);
        }

        // Write out the updated XML
        writeXml(ehr, ehr.getPatientDetail().getPatientId());
    }

    public void removeAndWriteXml(PatientEhr ehr, String fieldName, Object value) throws Exception {
        Field field = PatientEhr.class.getDeclaredField(fieldName);
        field.setAccessible(true);

        // If the field is a Collection, remove the value(s) if present
        if (java.util.Collection.class.isAssignableFrom(field.getType())) {
            Object existing = field.get(ehr);
            if (existing != null) {
                List list = (List) existing;
                if (value instanceof List) {
                    list.removeAll((List) value);
                } else {
                    list.remove(value);
                }
            }
        } else {
            // For single value fields, set to null if value matches
            Object currentValue = field.get(ehr);
            if (currentValue != null && currentValue.equals(value)) {
                field.set(ehr, null);
            }
        }

        // Write out the updated XML
        writeXml(ehr, ehr.getPatientDetail().getPatientId());
    }


    /**
     * Retrieves patient's medical information such as allergies, medications, and medical history.
     *
     * @param userId The patient user ID
     * @return A map with keys "allergies", "medications", "medicalHistory" and their corresponding values.
     */
    public Map<String, List<?>> getPatientMedicalInfo(String userId) {
        Map<String, List<?>> medicalInfo = new java.util.HashMap<>();
        try {
            PatientEhr ehr = readXml(userId);
            if (ehr != null) {
                List<Allergy> allergies = ehr.getPatientDetail().getAllergies();
                List<Medication> medications = ehr.getPatientDetail().getRepeatMedication();
                List<MedicalCondition> medicalHistory = ehr.getPatientDetail().getMedicalConditions();
                medicalInfo.put("allergies", allergies != null ? allergies : new ArrayList<>());
                medicalInfo.put("medications", medications != null ? medications : new ArrayList<>());
                medicalInfo.put("medicalHistory", medicalHistory != null ? medicalHistory : new ArrayList<>());
            }
        } catch (Exception e) {
            log.error("Error reading patient EHR for patient ID {}  Here is error : {}", userId, e.getMessage());
        }
        return medicalInfo;
    }


    /**
     * Retrieves patient's medical information such as allergies, medications, and medical history.
     *
     * @param userId The patient user ID
     * @return A map with keys "allergies", "medications", "medicalHistory" and their corresponding values.
     */
    public String getPatientMedicalSummary(String userId) {

        StringBuilder summary = new StringBuilder();
        try {

            PatientEhr ehr = readXml(userId);
            if (ehr == null) {
                return summary.append("").toString();
            }

            List<Allergy> allergies = ehr.getPatientDetail().getAllergies();
            List<Medication> medications = ehr.getPatientDetail().getRepeatMedication();
            List<MedicalCondition> medicalHistory = ehr.getPatientDetail().getMedicalConditions();

            if (medicalHistory != null && !medicalHistory.isEmpty()) {
                summary.append("\n Medical History \n");
                for (MedicalCondition condition : medicalHistory) {

                    if(condition.getIsChronic()) {
                        summary.append(String.format("%-50s %-30s\n",
                                "- " + condition.getConditionName(),
                                "Diagnosed on: " + covertLocalDateToString(condition.getDiagnosedDate())));
                    }
                }
            } else {
                //summary.append(String.format("%-30s\n", "- No significant medical history."));
            }


            if (allergies != null && !allergies.isEmpty()) {
                summary.append("\nAllergies:\n");
                for (Allergy allergy : allergies) {
                    summary.append(String.format("%-50s %-30s\n", "- " + allergy.getAllergen(), "Severity : " + allergy.getSeverity()));
                }
            } else {
                //summary.append("-  No known allergies.\n");
            }


            if (medications != null && !medications.isEmpty()) {
                summary.append("\nRepeat Medications:\n");
                for (Medication medication : medications) {
                    summary.append(String.format("%-50s %-30s\n", "- " + medication.getMedicationName(), " Dosage : " + medication.getDosage()));
                }
            } else {
                //summary.append("\n\n-  No repeat medications.\n");
            }


        } catch (Exception e) {
            log.error("Error reading patient EHR for patient ID {}  Here is error : {}", userId, e.getMessage());
        }

        return summary.toString();
    }




    private String covertLocalDateToString(LocalDate localDate) {
        if (localDate == null) {
            return "";
        }
        return localDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }


    /**
     * Logs an entry into the patient's medical logs.
     *
     * @param adminUser  The ClinicUser performing the action
     * @param patientEhr The PatientEhr object to update
     * @param logNote    The note to log
     * @throws Exception Any reflection or IO errors
     */
    public void logEntryFromGp(ClinicUser adminUser, PatientEhr patientEhr, String serviceType, String documentType, String documentName, String logNote) throws Exception {
        // Add a MedicalLogs entry
        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(MessageType.DOCTOR_MESSAGE.getDisplayName());
        medicalLogs.setServiceType(serviceType);
        medicalLogs.setDocumentType(documentType);
        medicalLogs.setDocumentName(documentName);
        medicalLogs.setDoctorName(adminUser.getFullName());
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);
    }


    /**
     * Logs an entry into the patient's medical logs.
     *
     * @param adminName  The ClinicUser performing the action
     * @param patientEhr The PatientEhr object to update
     * @param logNote    The note to log
     * @throws Exception Any reflection or IO errors
     */
    public void logEntryFromAdmin(String adminName, PatientEhr patientEhr, String serviceType, String documentType, String documentName, String logNote) throws Exception {
        // Add a MedicalLogs entry
        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(MessageType.ADMIN_MESSAGE.getDisplayName());
        medicalLogs.setServiceType(serviceType);
        medicalLogs.setDocumentType(documentType);
        medicalLogs.setDocumentName(documentName);
        medicalLogs.setDoctorName(adminName);
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);
    }


    public void logEntryFromGp(ClinicUser adminUser, PatientEhr patientEhr, String messageType , String serviceType, String documentType, String documentName, String logNote) throws Exception {

        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(messageType);
        medicalLogs.setServiceType(serviceType);
        medicalLogs.setDocumentType(documentType);
        medicalLogs.setDocumentName(documentName);
        medicalLogs.setDoctorName(adminUser.getFullName());
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);

    }


    //--  This entry is used when messageId is already known (e.g., from MessageNotification)
    @Async
    public void logEntryFromGp(String messageId, ClinicUser adminUser, PatientEhr patientEhr, String serviceType, String documentType, String documentName, String logNote) throws Exception {
        // Add a MedicalLogs entry
        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setLogId(messageId);
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(MessageType.DOCTOR_MESSAGE.getDisplayName());
        medicalLogs.setServiceType(serviceType);
        medicalLogs.setDocumentType(documentType);
        medicalLogs.setDocumentName(documentName);
        medicalLogs.setDoctorName(adminUser.getFullName());
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);
    }


    public void logEntryFromPatient(PatientEhr patientEhr, String serviceType, String documentType, String documentName, String logNote) throws Exception {
        // Add a MedicalLogs entry
        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(MessageType.PATIENT_MESSAGE.getDisplayName());
        medicalLogs.setServiceType(serviceType);
        medicalLogs.setDocumentType(documentType);
        medicalLogs.setDocumentName(documentName);
        medicalLogs.setDoctorName(patientEhr.getPatientDetail().getFirstName() + " " + patientEhr.getPatientDetail().getLastName());
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);
    }


    public void logEntryByPatient(String userName, PatientEhr patientEhr, String messageType ,String logNote) throws Exception {
        // Add a MedicalLogs entry
        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(messageType);
        medicalLogs.setDoctorName(userName);
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);
    }

    public void logEntryByPatient(String userName, PatientEhr patientEhr, String logNote) throws Exception {
        // Add a MedicalLogs entry
        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(MessageType.PATIENT_MESSAGE.getDisplayName());
        medicalLogs.setDoctorName(userName);
        medicalLogs.setNotes(logNote);
        addAndWriteXml(patientEhr, "medicalLogs", medicalLogs);
    }


    /**
     * Finds a MedicalLogs entry by documentName and returns it as Optional.
     *
     * @param ehr PatientEhr object containing medical logs
     * @param documentName The document name to search for
     * @return Optional containing the matching MedicalLogs, or Optional.empty() if not found
     */
    /**
     * Finds a MedicalLogs entry by patientId and documentName.
     *
     * @param patientId    The patient ID whose EHR will be read
     * @param documentName The document name to search for
     * @return Optional containing the matching MedicalLogs, or Optional.empty() if not found
     */
    public Optional<MedicalLogs> findMedicalLogByDocumentName(String patientId, String documentName) {

        if (patientId == null || documentName == null || documentName.trim().isEmpty()) {
            return Optional.empty();
        }

        try {
            PatientEhr ehr = readXml(patientId);
            if (ehr == null || ehr.getMedicalLogs() == null || ehr.getMedicalLogs().isEmpty()) {
                return Optional.empty();
            }

            return ehr.getMedicalLogs().stream()
                    .filter(log -> log.getDocumentName() != null &&
                            log.getDocumentName().equalsIgnoreCase(documentName))
                    .findFirst();

        } catch (Exception e) {
            log.error("Error reading EHR for patientId {}: {}", patientId, e.getMessage());
            return Optional.empty();
        }
    }


    /**
     * Retrieves a list of MedicalLogs entries by document type.
     *
     * @param patientId    The patient ID whose EHR will be read
     * @param documentType The document type to search for (e.g., "Medical Cert", "Referral Letter")
     * @return A list of MedicalLogs matching the document type, or an empty list if none found
     */
    public List<MedicalLogs> findMedicalLogsByDocumentType(String patientId, String documentType) {
        List<MedicalLogs> matchingLogs = new ArrayList<>();

        if (patientId == null || documentType == null || documentType.trim().isEmpty()) {
            return matchingLogs;
        }

        try {
            PatientEhr ehr = readXml(patientId);
            if (ehr == null || ehr.getMedicalLogs() == null || ehr.getMedicalLogs().isEmpty()) {
                return matchingLogs;
            }

            matchingLogs = ehr.getMedicalLogs().stream()
                    .filter(log -> log.getDocumentType() != null &&
                            log.getDocumentType().equalsIgnoreCase(documentType))
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.error("Error reading EHR for patientId {}: {}", patientId, e.getMessage());
        }

        return matchingLogs;
    }



    private PatientEhr mapPatientDetailWithEHRObject(PatientAccount account) {

        PatientDetail detail = new PatientDetail();

        // Direct mappings
        detail.setPatientId(account.getUserId()); // Or account.getUserId() if you want USERID
        detail.setFirstName(account.getFirstName());
        detail.setLastName(account.getLastName());
        detail.setGender(account.getSex());
        detail.setIHINumber(account.getIhiNumber());

        // Date mapping: java.util.Date -> java.time.LocalDate
        if (account.getBirthDate() != null) {
            detail.setDateOfBirth(account.getBirthDate());
        }

        // createdAt, updatedAt: example mapping from createDate and lastLoginDate
        if (account.getCreateDate() != null) {
            detail.setCreatedAt(account.getCreateDate());
        }
        if (account.getLastLoginDate() != null) {
            detail.setUpdatedAt(account.getLastLoginDate());
        }

        detail.setUpdatedBy(account.getUserId()); // Or another field if needed

        // Address mapping
        Address address = new Address();
        address.setAddressDetail(account.getFullAddress());
        address.setEirCode(account.getEirCode());
        // You can split address/city/state if available in fullAddress, otherwise leave blank
        detail.setAddress(address);

        // ContactInfo mapping
        ContactInfo contactInfo = new ContactInfo();
        contactInfo.setPrimaryPhone(account.getPhoneNumber());
        contactInfo.setEmail(account.getEmailId());
        detail.setContactInfo(contactInfo);

        // Demographics mapping
        Demographics demographics = new Demographics();
        // You may want to set preferredLanguage, ethnicity, etc. if available in PatientAccount
        detail.setDemographics(demographics);

        // The rest: medicalConditions, allergies, medications, transactions are left null (empty)
        // Extend if you have sources for these in the PatientAccount

        PatientEhr patientEhr = new PatientEhr();
        patientEhr.setPatientDetail(detail);
        return patientEhr;
    }


    private byte[] encryptBytes(byte[] plain) throws Exception {

        byte[] iv = new byte[GCM_IV_LENGTH];
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKeySpec key = new SecretKeySpec(
                SECRET_KEY.getBytes(StandardCharsets.UTF_8),
                "AES"
        );

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);

        byte[] cipherText = cipher.doFinal(plain);

        // [VERSION][IV][CIPHERTEXT]
        ByteBuffer buffer = ByteBuffer.allocate(
                1 + iv.length + cipherText.length
        );

        buffer.put(ENCRYPTION_VERSION_V1);
        buffer.put(iv);
        buffer.put(cipherText);

        return buffer.array();
    }


    private byte[] decryptBytes(byte[] encrypted) throws Exception {

        // Defensive check
        if (encrypted == null || encrypted.length == 0) {
            throw new IllegalArgumentException("Encrypted data is empty");
        }

        byte firstByte = encrypted[0];

        // New format: versioned AES-GCM
        if (firstByte == ENCRYPTION_VERSION_V1) {
            return decryptGcmV1(encrypted);
        }

        // Old format: legacy AES/ECB
        log.warn("Decrypting legacy AES (ECB) encrypted EHR file");
        return decryptLegacyAes(encrypted);
    }


    private byte[] decryptGcmV1(byte[] encrypted) throws Exception {

        ByteBuffer buffer = ByteBuffer.wrap(encrypted);

        byte version = buffer.get();
        if (version != ENCRYPTION_VERSION_V1) {
            throw new IllegalStateException("Unsupported EHR encryption version: " + version);
        }

        byte[] iv = new byte[GCM_IV_LENGTH];
        buffer.get(iv);

        byte[] cipherText = new byte[buffer.remaining()];
        buffer.get(cipherText);

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKeySpec key = new SecretKeySpec(
                SECRET_KEY.getBytes(StandardCharsets.UTF_8),
                "AES"
        );

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, spec);

        return cipher.doFinal(cipherText); // AEADBadTagException if tampered
    }


    //--- Will be used for the old file decryption only
    private byte[] decryptLegacyAes(byte[] encrypted) throws Exception {
        Cipher cipher = Cipher.getInstance("AES");
        SecretKeySpec key = new SecretKeySpec(
                SECRET_KEY.getBytes(StandardCharsets.UTF_8),
                "AES"
        );
        cipher.init(Cipher.DECRYPT_MODE, key);
        return cipher.doFinal(encrypted);
    }



    private void updatePatientLastActionDate(String patientId){
        PatientAccount paitentAccountObj = paitentAccountDao.findByuserId(patientId);
        if(paitentAccountObj != null){
            paitentAccountObj.setLastActionDate(LocalDateTime.now());
            paitentAccountDao.save(paitentAccountObj);
        }
    }

}
package com.optiman.ie.services.patientEhr.srv;

import ch.qos.logback.core.util.StringUtil;
import com.optiman.ie.contant.ServiceType;
import com.optiman.ie.services.patientEhr.model.*;
import com.optiman.ie.util.CommonUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.optiman.ie.contant.ProjectDataMapping.DATA_FOLDER;


@Slf4j
@Service
public class EhrDataManager {



    private EHRService ehrService;

    public EhrDataManager(EHRService ehrService) {
        this.ehrService = ehrService;
    }

    /**
     * Removes a MedicalLogs entry from the patient's EHR XML file given patientId and logId,
     * and removes the corresponding physical PDF file from the local file system if present.
     *
     * @param patientId The patient ID whose EHR to update
     * @param logId     The logId of the MedicalLogs entry to remove
     * @throws Exception Any IO, JAXB, or encryption errors
     */
    public void removeMedicalLogAndFileById(String patientId, String logId) throws Exception {
        // Read (decrypt and load) current PatientEhr
        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            log.warn("Patient EHR file does not exist for patientId: {}", patientId);
            return;
        }

        List<MedicalLogs> medicalLogsList = ehr.getMedicalLogs();
        if (medicalLogsList == null || medicalLogsList.isEmpty()) {
            log.info("No medicalLogs found for patientId: {}", patientId);
            return;
        }

        // Find the MedicalLogs object and remove it
        MedicalLogs logToRemove = null;
        for (MedicalLogs ml : medicalLogsList) {
            if (logId != null && logId.equals(ml.getLogId())) {
                logToRemove = ml;
                break;
            }
        }

        if (logToRemove == null) {
            log.info("No MedicalLogs with logId {} found for patientId: {}", logId, patientId);
            return;
        }

        // Remove from XML
        medicalLogsList.remove(logToRemove);
        ehrService.writeXml(ehr, patientId);
        log.info("Removed MedicalLogs with logId {} from EHR of PatientId: {}", logId, patientId);

        // Remove physical PDF file if referenced in MedicalLogs
        String documentNameOrFileName = logToRemove.getDocumentName();
        if (documentNameOrFileName != null) {
            if (!documentNameOrFileName.trim().isEmpty()) {
                removeFileFromFileSystem(documentNameOrFileName);
            }
        }

        // Remove pdf file entry from the patient_document table if exists
        //patientDocumentDao.deleteDocumentByName(patientId,documentNameOrFileName);

    }


    /**
     * Updates the ptViewDateTime field of a MedicalLogs object with the current date and time
     * if the logId matches the input parameter.
     *
     * @param userId  Patient ID  to search
     * @param logId   The logId to match
     */
    public void updatePtViewDateTimeByLogId(String userId, String logId) throws Exception {

        PatientEhr patientEhr = ehrService.readXml(userId);

        List<MedicalLogs>  medicalLogsList = null;
        if(patientEhr != null){
            medicalLogsList = patientEhr.getMedicalLogs();
        }

        if(medicalLogsList != null && medicalLogsList.isEmpty()){
            //log.info("No MedicalLogs found for patientId: {} with the id:{}", userId, logId);
            return;
        }

        for (MedicalLogs medicalLog : medicalLogsList) {
            if (logId.equalsIgnoreCase(medicalLog.getLogId())) {
                LocalDateTime now = LocalDateTime.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
                medicalLog.setPtViewDateTime("Seen by patient @ "+ now.format(formatter));
                patientEhr.setMedicalLogs(medicalLogsList);
                ehrService.writeXml(patientEhr, userId);
                //log.info("Updated ptViewDateTime for logId {} to current date and time.", logId);
                return;
            }

        }

        //log.info("No MedicalLogs found with logId: {}", logId);
    }



    /**
     * Updates the ptViewDateTime field of a MedicalLogs object with the current date and time
     * if the logId matches the input parameter.
     *
     * @param userId  Patient ID  to search
     * @param documentName    The logId to match
     */
    public void updatePtViewDateTimeByDocumentName(String userId, String documentName) throws Exception {

        PatientEhr patientEhr = ehrService.readXml(userId);

        List<MedicalLogs>  medicalLogsList = null;
        if(patientEhr != null){
            medicalLogsList = patientEhr.getMedicalLogs();
        }

        if(medicalLogsList != null && medicalLogsList.isEmpty()){
            //log.info("No MedicalLogs found for patientId: {} with the id:{}", userId, logId);
            return;
        }

        for (MedicalLogs medicalLog : medicalLogsList) {

           if(!StringUtil.isNullOrEmpty(medicalLog.getDocumentName())) {

               if (documentName.equalsIgnoreCase(medicalLog.getDocumentName())) {
                   LocalDateTime now = LocalDateTime.now();
                   DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
                   medicalLog.setPtViewDateTime("Seen by patient @ " + now.format(formatter));
                   patientEhr.setMedicalLogs(medicalLogsList);
                   ehrService.writeXml(patientEhr, userId);
                   log.info("Updated ptViewDateTime for document name  {} to current date and time.", documentName);
                   return;
               }

           }

        }

        log.info("No MedicalLogs found with document name : {}", documentName);
    }





    //=============== MANAGE MEDICAL CONDITION =======================
    /**
     * Removes a MedicalCondition from the patient's EHR based on codeName.
     *
     * @param patientId The patient ID whose EHR to update
     * @param codeName  The codeName of the MedicalCondition to remove
     * @throws Exception Any IO, JAXB, or encryption errors
     */
    public String removeMedicalConditionByCodeName(String patientId, String codeName) throws Exception {
        // Read (decrypt and load) current PatientEhr
        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            return " Patient EHR file does not exist for patientId:" + patientId;
        }

        // Get medical conditions from patientDetail, not from top-level field
        List<MedicalCondition> medicalConditions = ehr.getPatientDetail().getMedicalConditions();

        if (medicalConditions == null || medicalConditions.isEmpty()) {
            return "No medical conditions found for patientId:" + patientId;
        }

        // Find and remove the MedicalCondition with matching codeName
        MedicalCondition medicalConditionToRemove = null;
        for (MedicalCondition medicalConditionObj : medicalConditions) {
            if (codeName != null && codeName.equals(medicalConditionObj.getCodeName())) {
                medicalConditionToRemove = medicalConditionObj;
                break;
            }
        }

        if (medicalConditionToRemove != null) {
            //-- Remove object
            medicalConditions.remove(medicalConditionToRemove);
            // Write out the updated XML
            ehrService.writeXml(ehr, patientId);
            return "Removed MedicalCondition with codeName : " + codeName + " from EHR of PatientId " + patientId;

        } else {
            return "No MedicalCondition with codeName : " + codeName + " from EHR of PatientId " + patientId;
        }
    }


    /**
     * Finds a MedicalCondition by codeName
     *
     * @param patientId The patient ID
     * @param codeName  The codeName to search for
     * @return Optional containing the matching MedicalCondition, or Optional.empty() if not found
     */
    public Optional<MedicalCondition> findMedicalConditionByCodeName(String patientId, String codeName) {
        if (patientId == null || codeName == null || codeName.trim().isEmpty()) {
            return Optional.empty();
        }

        try {
            // Read (decrypt and load) current PatientEhr
            PatientEhr ehr = ehrService.readXml(patientId);
            if (ehr == null) {
                return Optional.empty();
            }

            // Get medical conditions from patientDetail, not from top-level field
            List<MedicalCondition> medicalConditions = ehr.getPatientDetail().getMedicalConditions();

            // Find and remove the MedicalCondition with matching codeName
            MedicalCondition medicalConditionToRemove = null;
            for (MedicalCondition medicalConditionObj : medicalConditions) {
                if (codeName != null && codeName.equalsIgnoreCase(medicalConditionObj.getCodeName())) {
                    return Optional.of(medicalConditionObj);
                }
            }

        } catch (Exception e) {
            log.error("Error reading EHR for patientId {}: {}", patientId, e.getMessage());
            return Optional.empty();
        }
        return Optional.empty();
    }



    /**
     * Adds a new MedicalCondition to the patient's EHR if the conditionName does not already exist.
     *
     * @param patientId     The patient ID whose EHR to update
     * @param newCondition  The MedicalCondition to add
     * @return Status message indicating whether the condition was added or already exists
     * @throws Exception IO/JAXB/encryption errors
     */
    public String addMedicalConditionIfNotExists(String patientId, MedicalCondition newCondition) throws Exception {
        if (newCondition == null || newCondition.getConditionName() == null || newCondition.getConditionName().trim().isEmpty()) {
            return "Invalid MedicalCondition object or conditionName";
        }

        // Read (decrypt and load) current PatientEhr
        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            return "Patient EHR file does not exist for patientId: " + patientId;
        }

        // Get medical conditions from patientDetail
        List<MedicalCondition> medicalConditions = ehr.getPatientDetail().getMedicalConditions();
        if (medicalConditions == null) {
            medicalConditions = new ArrayList<>();
            ehr.getPatientDetail().setMedicalConditions(medicalConditions);
        }

        // Check if conditionName already exists
        for (MedicalCondition condition : medicalConditions) {
            if (condition.getConditionName() != null && condition.getConditionName().equalsIgnoreCase(newCondition.getConditionName())) {
                return "MedicalCondition with conditionName '" + newCondition.getConditionName() + "' already exists for patientId: " + patientId;
            }
        }

        // Add new condition
        medicalConditions.add(newCondition);
        ehrService.writeXml(ehr, patientId);
        return "Added MedicalCondition with conditionName '" + newCondition.getConditionName() + "' for patientId: " + patientId;
    }





    //=============== MANAGE ALLERGY  =======================
    /**
     * Removes an Allergy from the patient's EHR by allergen (optionally filtered by diagnosedDate).
     *
     * @param patientId The patient ID whose EHR to update
     * @param allergen  The allergen name to remove (exact match)
     * @return Status message
     * @throws Exception IO/JAXB/encryption errors
     */
    public String removeAllergyByAllergen(String patientId, String allergen) throws Exception {

        log.info("Attempting to remove allergy with allergen '{}' for patientId '{}'", allergen, patientId);

        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            return "Patient EHR file does not exist for patientId: " + patientId;
        }

        List<Allergy> allergies = ehr.getPatientDetail().getAllergies();
        if (allergies == null || allergies.isEmpty()) {
            return "No allergies found for patientId: " + patientId;
        }

        Allergy toRemove = null;
        for (Allergy allergy : allergies) {
            boolean allergenMatch = allergen != null && allergen.equalsIgnoreCase(allergy.getAllergen());
            if (allergenMatch) {
                toRemove = allergy;
                break;
            }
        }

        if (toRemove != null) {
            allergies.remove(toRemove);
            ehrService.writeXml(ehr, patientId);
            return "Removed allergy '" + allergen + "' for patientId " + patientId;
        } else {
            return "No allergy found for patientId " + patientId + " with allergen " + allergen;
        }
    }



    /**
     * Removes a Medication entry from the patient's EHR by its id.
     *
     * @param patientId    The patient ID whose EHR to update
     * @param medicationId The Medication.id to remove
     * @return Status message
     * @throws Exception IO/JAXB/encryption errors
     */
    public String removeMedicationById(String patientId, String medicationId) throws Exception {
        if (medicationId == null) {
            return "Medication id cannot be null";
        }

        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            return "Patient EHR file does not exist for patientId: " + patientId;
        }

        // Update this accessor if your model differs
        List<Medication> medications = ehr.getPatientDetail().getRepeatMedication();
        if (medications == null || medications.isEmpty()) {
            return "No medications found for patientId: " + patientId;
        }

        Medication toRemove = null;
        for (Medication med : medications) {
            if (med != null && med.getMedicationId() != null && med.getMedicationId().equalsIgnoreCase(medicationId)) {
                toRemove = med;
                break;
            }
        }

        if (toRemove != null) {
            medications.remove(toRemove);
            ehrService.writeXml(ehr, patientId);
            return "Removed medication with id " + medicationId + " for patientId " + patientId;
        } else {
            return "No medication found with id " + medicationId + " for patientId " + patientId;
        }
    }




    /**
     * Removes a Medication from the patient's EHR by medicationName (optionally filtered by startDate).
     *
     * @param patientId      The patient ID whose EHR to update
     * @param medicationName The medication name to remove (exact match)
     * @param startDate      Optional ISO date (yyyy-MM-dd) to disambiguate; pass null/blank to ignore
     * @return Status message
     * @throws Exception IO/JAXB/encryption errors
     */
    public String removeMedicationByName(String patientId, String medicationName, String startDate) throws Exception {
        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            return "Patient EHR file does not exist for patientId: " + patientId;
        }

        List<Medication> medications = ehr.getPatientDetail().getRepeatMedication();
        if (medications == null || medications.isEmpty()) {
            return "No medications found for patientId: " + patientId;
        }

        LocalDate targetStart = null;
        if (startDate != null && !startDate.isBlank()) {
            targetStart = LocalDate.parse(startDate); // expects yyyy-MM-dd
        }

        Medication toRemove = null;
        for (Medication med : medications) {
            boolean nameMatch = medicationName != null && medicationName.equals(med.getMedicationName());
            boolean dateMatch = (targetStart == null) ||
                    (med.getStartDate() != null && targetStart.equals(med.getStartDate()));
            if (nameMatch && dateMatch) {
                toRemove = med;
                break;
            }
        }

        if (toRemove != null) {
            medications.remove(toRemove);
            ehrService.writeXml(ehr, patientId);
            return "Removed medication '" + medicationName + "' for patientId " + patientId +
                    (targetStart != null ? " starting on " + targetStart : "");
        } else {
            return "No medication found for patientId " + patientId + " with name '" + medicationName + "'" +
                    (targetStart != null ? " starting on " + targetStart : "");
        }
    }


    public Optional<Allergy> findAllergyByAllergen(String patientId, String allergen) {
        if (patientId == null || allergen == null || allergen.trim().isEmpty()) {
            return Optional.empty();
        }

        try {
            // Read (decrypt and load) current PatientEhr
            PatientEhr ehr = ehrService.readXml(patientId);
            if (ehr == null || ehr.getPatientDetail() == null) {
                return Optional.empty();
            }

            // Get allergies from patientDetail
            List<Allergy> allergies = ehr.getPatientDetail().getAllergies();
            if (allergies == null || allergies.isEmpty()) {
                return Optional.empty();
            }

            // Find matching allergy by allergen
            for (Allergy allergyObj : allergies) {
                if (allergyObj != null
                        && allergyObj.getAllergen() != null
                        && allergen.trim().equalsIgnoreCase(allergyObj.getAllergen().trim())) {
                    return Optional.of(allergyObj);
                }
            }

        } catch (Exception e) {
            log.error("Error reading EHR allergies for patientId {}: {}", patientId, e.getMessage(), e);
            return Optional.empty();
        }

        return Optional.empty();
    }


    //==========================================================
    //=============== MANAGE MEDICATION  =======================
    //===========================================================
    public Optional<Medication> findMedicationById(String patientId, String medicationId) {
        if (patientId == null || medicationId == null || medicationId.trim().isEmpty()) {
            return Optional.empty();
        }

        try {
            // Read (decrypt and load) current PatientEhr
            PatientEhr ehr = ehrService.readXml(patientId);
            if (ehr == null || ehr.getPatientDetail() == null) {
                return Optional.empty();
            }

            // Get medications from patientDetail
            List<Medication> medications = ehr.getPatientDetail().getRepeatMedication();
            if (medications == null || medications.isEmpty()) {
                return Optional.empty();
            }

            // Find matching medication by medicationId
            for (Medication medication : medications) {
                if (medication != null
                        && medication.getMedicationId() != null
                        && medicationId.trim().equalsIgnoreCase(medication.getMedicationId().trim())) {
                    return Optional.of(medication);
                }
            }

        } catch (Exception e) {
            log.error("Error reading EHR medications for patientId {}: {}", patientId, e.getMessage(), e);
            return Optional.empty();
        }

        return Optional.empty();
    }



    /**
     * Adds a new HealthTrendRecord to the patient's EHR.
     *
     * @param patientId         The patient ID whose EHR to update
     * @param healthTrendRecord The HealthTrendRecord to add
     * @return Status message
     * @throws Exception IO/JAXB/encryption errors
     */
    public String addHealthTrendRecord(String patientId, HealthTrendRecord healthTrendRecord) throws Exception {
        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null) {
            return "Patient EHR file does not exist for patientId: " + patientId;
        }

        List<HealthTrendRecord> healthTrendRecords = ehr.getHealthTrendRecords();
        if (healthTrendRecords == null) {
            healthTrendRecords = new ArrayList<>();
            ehr.setHealthTrendRecords(healthTrendRecords);
        }

        healthTrendRecords.add(healthTrendRecord);
        ehrService.writeXml(ehr, patientId);
        return "Added HealthTrendRecord for patientId: " + patientId;
    }

    /**
     * Retrieves the list of HealthTrendRecords for a given patientId.
     *
     * @param patientId The patient ID
     * @return List of HealthTrendRecords, or an empty list if none exist
     * @throws Exception IO/JAXB/encryption errors
     */
    public List<HealthTrendRecord> getHealthTrendRecordsByPatientId(String patientId) throws Exception {
        PatientEhr ehr = ehrService.readXml(patientId);
        if (ehr == null || ehr.getHealthTrendRecords() == null) {
            return Collections.emptyList();
        }
        return ehr.getHealthTrendRecords();
    }



    public void ConsultationRecordEntry(ConsultationRecord  consultationRecord,HealthTrendRecord healthTrendRecord,String consultantName) throws Exception {

        PatientEhr ehrObj = ehrService.readXml(consultationRecord.getPatientId());

        //1. ADD CONSULTATION RECORD ENTRY
        List<ConsultationRecord> consultationRecords = ehrObj.getConsultationRecords();
        if (consultationRecords == null) {
            consultationRecords = new ArrayList<>();
            ehrObj.setConsultationRecords(consultationRecords);
        }
        consultationRecords.add(consultationRecord);
        ehrObj.setConsultationRecords(consultationRecords);


        //2. UPDATE HEALTH TREND RECORD IF EXIST
        if(healthTrendRecord != null) {
            List<HealthTrendRecord> healthTrendRecords = ehrObj.getHealthTrendRecords();
            if (healthTrendRecords == null) {
                healthTrendRecords = new ArrayList<>();
                ehrObj.setHealthTrendRecords(healthTrendRecords);
            }
            healthTrendRecords.add(healthTrendRecord);
            ehrObj.setHealthTrendRecords(healthTrendRecords);
        }

        // 2.1 Patient main profile height and weight update
        if(ehrObj.getPatientDetail() != null) {
            if(healthTrendRecord != null) {
                if(healthTrendRecord.getHeightM() != null) {
                    ehrObj.getPatientDetail().setHeight(healthTrendRecord.getHeightM().toString());
                }
                if(healthTrendRecord.getWeightKg() != null) {
                    ehrObj.getPatientDetail().setWeight(healthTrendRecord.getWeightKg().toString());
                }
            }
        }


        //3. UPDATE  MEDICAL LOGS OF THE PATIENT EHR
        String serviceType = "";

        if (consultationRecord.getConsultationMode().equalsIgnoreCase("IN-CLINIC")) {
            serviceType = ServiceType.GP_FACE_TO_FACE_CONSULT.getDisplayName();
        }

        if (consultationRecord.getConsultationMode().equalsIgnoreCase("VIDEO-CAL")) {
            serviceType = ServiceType.GP_VIDEO_CONSULTATION.getDisplayName();
        }

        if (consultationRecord.getConsultationMode().equalsIgnoreCase("PHONE-CAL")) {
            serviceType = ServiceType.GP_PHONE_CONSULTATION.getDisplayName();
        }

        MedicalLogs medicalLogs = new MedicalLogs();
        medicalLogs.setTransDateTime(LocalDateTime.now());
        medicalLogs.setMessageType(MessageType.TREATMENT_NOTE.getDisplayName());
        medicalLogs.setServiceType(serviceType);
        medicalLogs.setDocumentType(null);
        medicalLogs.setDocumentName(null);
        medicalLogs.setDoctorName(consultantName);
        //medicalLogs.setNotes("Detail of consultation  id : " + consultationRecord.getConsultationId() + "\n"+consultationRecord);
        medicalLogs.setNotes(formatConsultationLog(consultationRecord));
        List<MedicalLogs> medicalLogsList = ehrObj.getMedicalLogs();
        if (medicalLogsList == null) {
            medicalLogsList = new ArrayList<>();
            ehrObj.setMedicalLogs(medicalLogsList);
        }
        medicalLogsList.add(medicalLogs);
        ehrObj.setMedicalLogs(medicalLogsList);


        //-- WRITE BACK TO XML
        ehrService.writeXml(ehrObj,consultationRecord.getPatientId());
        log.info("EHR Been updated with ConsultationRecord entry and updated HealthTrendRecord and MedicalLogs for patientId: {}", consultationRecord.getPatientId());

    }




    /**
     * Removes a physical file from the local file system, given its file name.
     * Uses logic to determine folder structure based on file name prefix.
     *
     * @param fileNameToBeRemoved PDF file name to be removed
     */
    private void removeFileFromFileSystem(String fileNameToBeRemoved) {
        try {
            String fileName = fileNameToBeRemoved;
            String pdfFolderName = CommonUtil.resolvePdfFolder(fileNameToBeRemoved);
            File fileObj = new File(DATA_FOLDER + File.separator + pdfFolderName + File.separator + fileName);
            if (fileObj.exists() && fileObj.isFile() && fileObj.canRead()) {
                Files.delete(Path.of(fileObj.getAbsolutePath()));
            }
        } catch (IOException e) {
            log.error("Error in reading file File : {}", e);
        }
    }


    public String formatConsultationLog(ConsultationRecord c ) {

        if (c == null) return "No consultation data available.";

        //DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");

        StringBuilder sb = new StringBuilder();

        sb.append("Summary of consultation id # <b>"+ c.getConsultationId() +" </b> <br><br>");

        /*sb.append("ID           : ").append(c.getConsultationId()).append("<br>");
        sb.append("Mode         : ").append(formatMode(c.getConsultationMode())).append("<br>");
        sb.append("Patient ID   : ").append(c.getPatientId()).append("<br>");
        sb.append("Doctor ID    : ").append(c.getClinicUserId()).append("<br>");
        sb.append("Status       : ").append(c.getStatus()).append("<br><br>");
*/
        sb.append("Subjective   : ").append(nullSafe(c.getSubjective())).append("<br>");
        sb.append("Objective    : ").append(nullSafe(c.getObjective())).append("<br>");
        sb.append("Assessment   : ").append(cleanText(c.getAssessment())).append("<br>");
        sb.append("Action Plan  : ").append(nullSafe(c.getTreatmentPlan())).append("<br>");
        sb.append("GP Notes     : ").append(nullSafe(c.getNotes())).append("<br><br>");

        if (c.getSafetyNote() != null && !c.getSafetyNote().isBlank()) {
            sb.append("Safety Advice:<br>");
            sb.append(formatSafetyText(c.getSafetyNote())).append("<br>");
        }

      /*  sb.append("<br>Created At   : ")
                .append(c.getCreatedAt() != null ? c.getCreatedAt().format(fmt) : "N/A");

        sb.append("<br>Updated At   : ")
                .append(c.getUpdatedAt() != null ? c.getUpdatedAt().format(fmt) : "N/A");

        sb.append("<br>=====================================================<br>");*/

        return sb.toString();
    }

    private String nullSafe(String value) {
        return (value == null || value.isBlank()) ? "N/A" : value;
    }

    private String formatMode(String mode) {
        if (mode == null) return "N/A";
        return mode.replace("-", " ").toUpperCase();
    }

    private String cleanText(String text) {
        if (text == null) return "N/A";
        return text.replaceAll(",+", ",").trim(); // removes duplicate commas
    }

    private String formatSafetyText(String text) {
        // Break long paragraph into readable bullet points
        return text
                .replaceAll("(?i)\\bif\\b", "<br>- If")
                .replaceAll("(?i)\\bwhen\\b", "<br>- When")
                .replaceAll("(?i)\\bsevere\\b", "<br>  • Severe")
                .trim();
    }

}

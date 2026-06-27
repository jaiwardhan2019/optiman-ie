package com.optiman.ie.services.patientAccount;

import com.optiman.ie.services.patientAccount.repository.PatientAccountDao;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUserDao;
import com.optiman.ie.util.CommonUtil;
import com.optiman.ie.util.ModelViewUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

@Slf4j
@RestController
public class PatientController extends ModelViewUtil {

    private final PatientAccountDao patientAccountDao;
    private final ClinicUserDao clinicUserRepo;

    @Autowired
    CommonUtil commonUtil;

    public PatientController(PatientAccountDao patientAccountDao, ClinicUserDao clinicUserRepo) {
        this.patientAccountDao = patientAccountDao;
        this.clinicUserRepo = clinicUserRepo;
    }


    //--- Render All patient
    @GetMapping("patient-list")
    public ModelAndView renderAllPatient(HttpServletRequest request) {

        ModelAndView mv = securityCheckforAdmin(request);
        if (mv != null) {
            return mv; // 🔥 STOP execution and go to login page
        }

        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
        ModelAndView modelView = new ModelAndView("patient-list");
        modelView.addObject("paitentList", patientAccountDao.findAllByOrderByLastActionDateAndCreateDateDesc());

        return modelView;

    } //  End of method


    // 1. Render the create new patient page
    @RequestMapping(value = "create-new-patient", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView createNewPatient(HttpServletRequest request, @RequestBody(required = false) Map<String, String> requestData) throws Exception {
        ModelAndView modelViewObj = new ModelAndView("create-new-patient");
        return modelViewObj;
    }


    //2. Save Patient detail to Database and EHR
    @PostMapping("create-new-patient-save")
    public ResponseEntity<?> createNewPatientSave(HttpServletRequest reqObj , @RequestBody Map<String, String> requestData) {

        ClinicUser adminUser = (ClinicUser) reqObj.getSession().getAttribute("ADMIN_SESSION");
        try {

            String return_status = patientAccountSrv.createNewPaitent(adminUser,requestData);

            if (return_status.toLowerCase().contains("already exist")) {
                return ResponseEntity.status(500).body(return_status);
            }

            return ResponseEntity.ok(return_status);


        } catch (Exception e) {
            log.error("Error in method createNewPatientSave creating patient: {}", e);
            String errorMessage = e.getMessage();
            if(errorMessage.contains("duplicate key value violates unique constraint")){
                return ResponseEntity.status(500).body("Patient with same email id or phone number already exist.");
            }

            return ResponseEntity.status(500).body("Error creating new Patient : " + e.getMessage());
        }
    }





}


//
//    @GetMapping("/search-patients")
//    public List<PatientAccount> searchPatients(@RequestParam("query") String query) {
//        if (query == null || query.isBlank()) {
//            return List.of();
//        }
//        List<PatientAccount> results = patientAccountDao.searchByKeyword("%" + query.trim().toLowerCase() + "%");
//        return results;
//    }
//
//
//    @RequestMapping(value = "manage-patient", method = {RequestMethod.POST, RequestMethod.GET})
//    public ModelAndView managePatient(HttpServletRequest request) throws Exception {
//        if (request.getSession().getAttribute("ADMIN_SESSION") == null) {
//            return renderViewPage("admin/admin-login");
//        }
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//
//        //PatientEhr patientEhr = null;
//        String patientDemo = "";
//
//        PatientAccount patientAccount = patientAccountDao.findByuserId(request.getParameter("patientId"));
//        if (patientAccount != null) {
//
//            //-- Create EHR xml if not exist for patient
//            try {
//                //ehrService.createEhrXmlFileIfNotExists(patientAccount);
//            } catch (Exception e) {
//                log.error("Error reported in method managePatient while creating EHR XML File : {} ", e);
//            }
//
//            //patientEhr = ehrService.readXml(patientAccount.getUserId());
//            patientDemo = patientAccount.getFirstName() + " " + patientAccount.getLastName() + ",  " + patientAccount.getSex() +
//                    ",  " + patientAccount.getAge() + ",  " + patientAccount.getDateOfBirthFormatted();
//        }
//
//        List<MedicalLogs> medicalLogs = null;
//        if (patientEhr != null) {
//            medicalLogs = patientEhr.getMedicalLogs();
//            if (medicalLogs != null) {
//                medicalLogs.sort(Comparator.comparing(MedicalLogs::getTransDateTime).reversed());
//            }
//        }
//
//
//        //-- Filter only DOCTOR TYPE USER --
//        List<ClinicUser> gpUserList = ClinicUserRepo.findAllByOrderByLastNameAsc()
//                .stream()
//                .filter(user -> user.getAccountType().equals("DOCTOR") || user.getAccountType().equals("ADMIN"))
//                .collect(Collectors.toList());
//
//
//        //-- CHECK IF THIS PATIENT HAVE ANY BOOKING TODAY ??
//        List<AppointmentBooking> appointmentBooking = null;
//        List<AppointmentBooking> Booking = appointmentBookingService.getAppointmentByDateAndPatient(LocalDate.now(), patientAccount.getUserId());
//        if (Booking != null) {
//            if (Booking.size() > 0) {
//                appointmentBooking = Booking;
//            }
//        }
//
//
//
//        EhrUtility ehrUtility = new EhrUtility();
//        ModelAndView modelView = new ModelAndView("admin/manage-patient-detail");
//        modelView.addObject("appointmentBooking", appointmentBooking);
//        modelView.addObject("testTypeSnippet", testTypeSnippet);
//        modelView.addObject("patientDemo", patientDemo);
//        modelView.addObject("patientEhr", patientEhr);
//        modelView.addObject("ehrUtility", ehrUtility);
//        modelView.addObject("medicalLogs", medicalLogs);
//        modelView.addObject("patientDetail", patientAccount);
//        modelView.addObject("allDocumentType", DOC_TYPE_MAP);
//        modelView.addObject("messageSnippet", dataTemplatesDao.findByDataCategoryOrderByHeadingNameAsc("Patient Message"));
//        modelView.addObject("medicationList", getMedicationList());
//        modelView.addObject("clinicServices", clinicServiceDao.findAllByOrderByServiceNameAsc());
//        modelView.addObject("patientIdEncrypted",  commonUtil.encryptString(patientAccount.getUserId()));
//        modelView.addObject("gpUserList", gpUserList);
//
//        return modelView;
//    }
//
//    @PostMapping("/update-patient-detail")
//    public ResponseEntity<?> updatePatientDdetail(HttpServletRequest request, @RequestBody Map<String, String> patientData) throws MessagingException, IOException, ParseException, InterruptedException, DocumentException {
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//        try {
//              return ResponseEntity.ok(patientAccountSrv.updatePaitentDetail(adminUser,patientData));
//        } catch (Exception e) {
//            log.error("Error reported in method updatePatientDdetail : {} ",e);
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
//
//    @GetMapping("patient-log")
//    @RequestMapping(value = "patient-log", method = {RequestMethod.POST, RequestMethod.GET})
//    public ModelAndView renderPatientLog(HttpServletRequest request) {
//        if(request.getSession().getAttribute("ADMIN_SESSION") == null){return renderViewPage("admin/admin-login");}
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//        ModelAndView modelView = new ModelAndView("admin/patient-log");
//        modelView.addObject("paitentLog",  serviceRequestDao.findAllByUserIdOrderByCreateDateDesc(request.getParameter("patientId")));
//        return modelView;
//    }
//
//    @GetMapping("get-updated-ehr")
//    public ModelAndView reloadProblemsSection(@RequestParam String patientId) throws JsonProcessingException {
//        PatientEhr patientEhrObj = ehrService.readXml(patientId);
//        ModelAndView modelAndView = new ModelAndView("admin/ehr-history-update");
//        modelAndView.addObject("medicationList", getMedicationList());
//        modelAndView.addObject("patientEhr", patientEhrObj);
//        return modelAndView;
//    }
//
//
//    //-- This will load updated log
//    @GetMapping("get-updated-ehr-log")
//    public ModelAndView reloaEhrLog(@RequestParam String patientId) throws JsonProcessingException {
//        PatientEhr patientEhrObj = ehrService.readXml(patientId);
//
//        //-- Get EHR log to render in the consultation page
//        List<MedicalLogs> medicalLogs = null;
//        if (patientEhrObj != null) {
//            medicalLogs = patientEhrObj.getMedicalLogs();
//            if (medicalLogs != null) {
//                medicalLogs.sort(Comparator.comparing(MedicalLogs::getTransDateTime).reversed());
//            }
//        }
//
//        ModelAndView modelAndView = new ModelAndView("admin/ehr-log");
//        modelAndView.addObject("patientEhr", patientEhrObj);
//        modelAndView.addObject("ehrUtility", new EhrUtility());
//        modelAndView.addObject("medicalLogs", medicalLogs);
//        modelAndView.addObject("allDocumentType", DOC_TYPE_MAP);
//        return modelAndView;
//    }
//
//
//
//    //-- This will fetch all problem desease code from backend
//    @GetMapping(value = "all_icd_code", produces = "application/json")
//    public ResponseEntity<?> getAllIcdCode(HttpServletRequest request) throws MessagingException, IOException, ParseException, InterruptedException, DocumentException {
//        try {
//
//            log.info("Request received to fetch all ICD codes for patient management !!");
//
//            return ResponseEntity.ok(icdDataBankDao.findAllByOrderByLocalGpCodeAsc());
//        } catch (Exception e) {
//            log.error("Error reported in method updatePatientDdetail : {} ",e);
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
//
//    //-- CREATE NEW ENTRY OF PROBLEM  DETAIL IN EHR XML
//    @PostMapping("/update-patient-ehr-problem-detail")
//    public ResponseEntity<?> updatePatientEhrXml(HttpServletRequest request, @RequestBody Map<String, String> patientData) throws MessagingException, IOException, ParseException, InterruptedException, DocumentException {
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//
//        log.info("Request received to update problem detail in EHR XML for Patient ID : {} and Problem Code : {} ",patientData.get("patientId"),patientData.get("problemCodeDetail"));
//
//        try {
//
//            PatientDetail.MedicalCondition newCondition = new PatientDetail.MedicalCondition();
//            newCondition.setCodeName(patientData.get("problemDetail"));
//            newCondition.setConditionName(icdDataBankDao.findByIcd10Code(patientData.get("problemDetail")).getLocalDescription());
//            newCondition.setSeverity(patientData.get("severity"));
//            newCondition.setIsChronic(patientData.get("cronic").equalsIgnoreCase("yes") ? true : false);
//            LocalDate date = LocalDate.parse(patientData.get("dateOfDiagnosis"));         // parses ISO yyyy-MM-dd by default
//            newCondition.setDiagnosedDate(date);
//            newCondition.setNotes(patientData.get("noteToPatient"));
//            newCondition.setStatus(patientData.get("conditionStatus"));
//
//
//            //-- Read EHR XML File
//            PatientEhr patientEhr = ehrService.readXml(patientData.get("patientId"));
//            if(patientEhr == null){
//                return ResponseEntity.badRequest().body("EHR record not found for Patient ID: " + patientData.get("patientId"));
//            }
//
//            //--- IF THE ACTION CODE IS "ADD" THEN ADD NEW ENTRY TO EHR XML, OTHERWISE IT WILL JUST UPDATE THE EXISTING ENTRY IN EHR XML
//            if(patientData.get("actionCode").equalsIgnoreCase("ADD")) {
//                // Add new entry to the EHR XML
//                List<PatientDetail.MedicalCondition> medicalConditions = patientEhr.getPatientDetail().getMedicalConditions();
//                if (medicalConditions == null) {
//                    medicalConditions = new ArrayList<>();
//                    patientEhr.getPatientDetail().setMedicalConditions(medicalConditions);
//                }
//
//                //--- For free text entry
//                if(patientData.get("problemDetail").equalsIgnoreCase("others")){
//                    newCondition.setCodeName(new CommonUtil().createEightDigitRandomNo().toString());
//                    newCondition.setConditionName(patientData.get("noteToPatient"));
//                }
//
//                medicalConditions.add(newCondition);
//                ehrService.writeXml(patientEhr, patientData.get("patientId"));
//
//            } else if(patientData.get("actionCode").equalsIgnoreCase("UPDATE")){
//                // Update existing entry in the EHR XML
//                List<PatientDetail.MedicalCondition> medicalConditions = patientEhr.getPatientDetail().getMedicalConditions();
//                if (medicalConditions != null) {
//                    for (int i = 0; i < medicalConditions.size(); i++) {
//                        PatientDetail.MedicalCondition condition = medicalConditions.get(i);
//                        if (condition.getCodeName().equalsIgnoreCase(patientData.get("problemDetail"))) {
//                            // Update the details of this condition
//                            condition.setSeverity(newCondition.getSeverity());
//                            condition.setIsChronic(newCondition.getIsChronic());
//                            condition.setDiagnosedDate(newCondition.getDiagnosedDate());
//                            condition.setNotes(newCondition.getNotes());
//                            condition.setStatus(newCondition.getStatus());
//                            break;
//                        }
//                    }
//                    ehrService.writeXml(patientEhr, patientData.get("patientId"));
//                } else {
//                    return ResponseEntity.badRequest().body("No existing medical conditions found to update for Patient ID: " + patientData.get("patientId"));
//                }
//
//            }
//
//            return ResponseEntity.ok("EHR Update is successful");
//
//        } catch (Exception e) {
//            log.error("Error reported in method updatePatientDdetail : {} ",e);
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
//
//    //-- GET PROBLEM  DETAIL FROM EHR XML
//    @PostMapping(value = "/get-patient-ehr-problem-detail")
//    public ResponseEntity<?> loadItemFromPatientEhrXml(@RequestBody Map<String, String> patientData) {
//        try {
//            //-- Loading from DB
//            Optional<PatientDetail.MedicalCondition> dto = ehrDataManager.findMedicalConditionByCodeName(patientData.get("patientId"),patientData.get("itemId"));
//            if (dto.isEmpty()) {
//                return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                        .body(Map.of("message", "Problem detail not found"));
//            }
//            return ResponseEntity.ok(dto.get());
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(Map.of("message", e.getMessage()));
//        }
//    }
//
//    //-- REMOVE NEW ENTRY OF PROBLEM  DETAIL IN EHR XML
//    @PostMapping("/remove-problem-item-from-ehr")
//    public ResponseEntity<?> removeItemFromPatientEhrXml(HttpServletRequest request, @RequestBody Map<String, String> patientData) throws MessagingException, IOException, ParseException, InterruptedException, DocumentException {
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//        try {
//            return ResponseEntity.ok(ehrDataManager.removeMedicalConditionByCodeName(patientData.get("patientId").trim(),patientData.get("itemId").trim()));
//        } catch (Exception e) {
//            log.error("Error reported in method updatePatientDdetail : {} ",e);
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
//
//    //-- CREATE NEW ENTRY OR UPDATE EXISTING OF ALLERGY DETAIL IN EHR XML
//    @PostMapping("/update-patient-ehr-allergy-detail")
//    public ResponseEntity<?> updatePatientEhrXmlWitAllergy(HttpServletRequest request, @RequestBody Map<String, String> patientData) throws MessagingException, IOException, ParseException, InterruptedException, DocumentException {
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//
//        try {
//
//            PatientDetail.Allergy newAllergy = new PatientDetail.Allergy();
//            if(patientData.get("type").equalsIgnoreCase("Medicine")){
//                newAllergy.setMainGroup(GlobalConst.allergy_group.MEDICINE.getDisplayName());
//            }
//            if(patientData.get("type").equalsIgnoreCase("General")){
//                newAllergy.setMainGroup(GlobalConst.allergy_group.GENERAL.getDisplayName());
//            }
//            newAllergy.setAllergen(patientData.get("allergen"));
//            newAllergy.setReaction(patientData.get("reaction"));
//            newAllergy.setSeverity(patientData.get("severity"));
//            newAllergy.setNotes(patientData.get("notes"));
//            LocalDate date = LocalDate.parse(patientData.get("dateOfDiagnosis"));         // parses ISO yyyy-MM-dd by default
//            newAllergy.setDiagnosedDate(date);
//
//
//            //-- Read EHR XML File
//            PatientEhr patientEhr = ehrService.readXml(patientData.get("patientId"));
//            if(patientEhr == null){
//                return ResponseEntity.badRequest().body("EHR record not found for Patient ID: " + patientData.get("patientId"));
//            }
//
//            //-- Update detail to EHR XML
//            if(patientData.get("operation").equalsIgnoreCase("update")){
//                log.info("Request received to update allergy detail in EHR XML for Patient ID : {} and Allergen : {} ",patientData.get("patientId"),patientData.get("allergen"));
//                // Update existing entry in the EHR XML
//                List<PatientDetail.Allergy> allergies = patientEhr.getPatientDetail().getAllergies();
//                if (allergies != null) {
//                    for (int i = 0; i < allergies.size(); i++) {
//                        PatientDetail.Allergy allergy = allergies.get(i);
//                        if (allergy.getAllergen().equalsIgnoreCase(patientData.get("allergen"))) {
//                            // Update the details of this allergy
//                            allergy.setMainGroup(newAllergy.getMainGroup());
//                            allergy.setReaction(newAllergy.getReaction());
//                            allergy.setSeverity(newAllergy.getSeverity());
//                            allergy.setNotes(newAllergy.getNotes());
//                            allergy.setDiagnosedDate(newAllergy.getDiagnosedDate());
//                            break;
//                        }
//                    }
//                    ehrService.writeXml(patientEhr, patientData.get("patientId"));
//                } else {
//                    return ResponseEntity.badRequest().body("No existing allergies found to update for Patient ID: " + patientData.get("patientId"));
//                }
//
//            }//-- End of  update if condition
//
//            if(patientData.get("operation").equalsIgnoreCase("add")){
//                // Add this detail to EHR XML
//                List<PatientDetail.Allergy> allergies = patientEhr.getPatientDetail().getAllergies();
//                if (allergies == null) {
//                    allergies = new ArrayList<>();
//                    patientEhr.getPatientDetail().setAllergies(allergies);
//                }
//                allergies.add(newAllergy);
//                ehrService.writeXml(patientEhr, patientData.get("patientId"));
//            }//-- End of add if condition
//
//
//            return ResponseEntity.ok("EHR Update is successful");
//
//        } catch (Exception e) {
//            log.error("Error reported in method updatePatientDdetail : {} ",e);
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
//
//    @PostMapping("manage-general-allergy")
//    public ResponseEntity<String> manageGeneralAllergy(HttpServletRequest reqObj) throws IOException {
//
//        ClinicUser adminUser = (ClinicUser) reqObj.getSession().getAttribute("ADMIN_SESSION");
//        if (adminUser == null) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized access.");
//        }
//
//        BufferedReader reader = reqObj.getReader();
//        Gson gson = new Gson();
//        Map<String, String> data = gson.fromJson(reader, new TypeToken<Map<String, String>>() {
//        }.getType());
//
//        PatientDetail.Allergy newAllergy = new PatientDetail.Allergy();
//        newAllergy.setAllergen(data.get("allergyName"));
//        newAllergy.setReaction("--");
//        newAllergy.setSeverity("--");
//        newAllergy.setNotes("--");
//        newAllergy.setDiagnosedDate(LocalDate.now());
//
//
//        String code_status = "";
//        try {
//            PatientEhr patientEhr = ehrService.readXml(data.get("patientId"));
//            if (patientEhr == null) {
//                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("EHR record not found for Patient ID: " + data.get("patientId"));
//            }
//
//            if(data.get("operation").equalsIgnoreCase("remove")){
//                // Remove this detail from  EHR XML
//                ehrService.removeAndWriteXml(patientEhr, "allergy", newAllergy);
//                ehrService.logEntryFromGp(adminUser, patientEhr, ServiceType.OTHER_SERVICE.getDisplayName(), null,null,"General Allergy :" + data.get("allergyName") + " Removed !! "); // Log the action
//            } else {
//                // Add this detail from  EHR XML
//                List<PatientDetail.Allergy> allergies = patientEhr.getPatientDetail().getAllergies();
//                if (allergies == null) {
//                    allergies = new ArrayList<>();
//                    patientEhr.getPatientDetail().setAllergies(allergies);
//                }
//                allergies.add(newAllergy);
//                ehrService.writeXml(patientEhr, data.get("patientId"));
//            }
//
//
//            if(data.get("operation").equalsIgnoreCase("update")){
//                //TODO JAI write update code here
//            }
//
//
//            code_status = "EHR Update is successful";
//
//        } catch (Exception e) {
//            code_status = "Error saving code Diagnosis : " + e.getMessage();
//            log.error("Error reported in method createTaskForStaff {}", e);
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(code_status);
//        }
//
//        return ResponseEntity.ok(code_status);
//    }
//
//    //-- REMOVE  ENTRY OF ALLERGY DETAIL FROM EHR XML
//    @PostMapping("/remove-allergy-item-from-ehr")
//    public ResponseEntity<?> removeAllergyItemFromPatientEhrXml(HttpServletRequest request, @RequestBody Map<String, String> patientData)  {
//        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
//        try {
//             return ResponseEntity.ok(ehrDataManager.removeAllergyByAllergen(patientData.get("patientId").trim(),patientData.get("allergyName")));
//        } catch (Exception e) {
//            log.error("Error reported in method updatePatientDdetail : {} ",e);
//            return ResponseEntity.badRequest().body(e.getMessage());
//        }
//    }
//
//    @PostMapping(value = "/get-patient-ehr-allergy-detail")
//    public ResponseEntity<?> loadAlergyItemFromPatientEhrXml(@RequestBody Map<String, String> patientData) {
//        try {
//            Optional<PatientDetail.Allergy> dto = ehrDataManager.findAllergyByAllergen(patientData.get("patientId"),patientData.get("allergyName"));
//            if (dto.isEmpty()) {
//                return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                        .body(Map.of("message", "Problem detail not found"));
//            }
//            return ResponseEntity.ok(dto.get());
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(Map.of("message", e.getMessage()));
//        }
//    }
//
//    @PostMapping("/update-bmi-to-ehr")
//    public ResponseEntity<Map<String, Object>> updateBmiRecord(@RequestBody Map<String, String> bmiData) {
//
//        Map<String, Object> response = new HashMap<>();
//        try {
//
//            // Extract data from the request body
//            String patientId = bmiData.get("patientId");
//            String patientName = bmiData.get("patientName");
//            String weight = bmiData.get("weight");
//            String weightUnit = bmiData.get("weightUnit");
//            String height = bmiData.get("height");
//            String heightUnit = bmiData.get("heightUnit");
//
//
//            // Validate required fields
//            if (patientId == null || weight == null || height == null) {
//                response.put("success", false);
//                response.put("message", "Missing required fields !! patientId, weight and height are required");
//                return ResponseEntity.badRequest().body(response);
//            }
//
//            //-- Calculate HealthTrendRecord with latest consultation details for future use in health trend analysis and patient monitoring
//            HealthTrendRecord  healthTrendRecord = new HealthTrendRecord();
//            healthTrendRecord.setTrendRecordId(UUID.randomUUID().toString());
//            healthTrendRecord.setConsultationId("NA");
//            healthTrendRecord.setPatientId(patientId);
//
//            //-- Calculate and set BMI if weight and height are provided
//            Double weightKg = trendReportService.convertWeightToKg(Double.parseDouble(weight), weightUnit);
//            Double heightM = trendReportService.convertHeightToMeters(Double.parseDouble(height), heightUnit);
//            healthTrendRecord.setWeightKg(weightKg);
//            healthTrendRecord.setHeightM(heightM);
//            healthTrendRecord.setBmi(trendReportService.calculateBMI(weightKg, heightM));
//            //log.info("BMI value is :{}",trendReportService.calculateBMI(weightKg, heightM));
//
//            //-- Update EHR Health Trend Record in the database for the patient
//            String statusUpdate = ehrDataManager.addHealthTrendRecord(patientId,healthTrendRecord);
//            //log.info("Status of BMI record update in EHR for Patient ID {} is : {} ", patientId, statusUpdate);
//
//            //-- Update EHR Log with this action
//            PatientEhr patientEhr = ehrService.readXml(patientId);
//            if(patientEhr != null) {
//                ehrService.logEntryByPatient(patientName,patientEhr,MessageType.AUTOMATED_MESSAGE.getDisplayName(),
//                        " Have updated his BMI Index "+ " with Weight : " + weightKg + " kg and Height : " + heightM + " m, and BMI value is : " + String.format("%.2f", healthTrendRecord.getBmi().doubleValue())
//                );
//            }
//
//
//            response.put("success", true);
//            response.put("message", "BMI record updated successfully");
//            return ResponseEntity.ok()
//                    .contentType(MediaType.APPLICATION_JSON)
//                    .body(response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.put("success", false);
//            response.put("message", "Error updating BMI record: " + e.getMessage());
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
//        }
//    }
//
//    @PostMapping("/update-bp-to-ehr")
//    public ResponseEntity<Map<String, Object>> updateBpRecord(@RequestBody Map<String, String> bpData) {
//
//        Map<String, Object> response = new HashMap<>();
//        try {
//
//            // Extract data from the request body
//            String patientId = bpData.get("patientId");
//            String patientName = bpData.get("patientName");
//            String systolicBP = bpData.get("systolicBP");
//            String diastolicBP = bpData.get("diastolicBP");
//            String pulseRate = bpData.get("pulseRate");
//
//            // Validate required fields
//            if (patientId == null || systolicBP == null || diastolicBP == null || pulseRate == null) {
//                response.put("success", false);
//                response.put("message", "Missing required fields! patientId, systolicBP, diastolicBP, and pulseRate are required.");
//                return ResponseEntity.badRequest().body(response);
//            }
//
//            //-- Create HealthTrendRecord for BP
//            HealthTrendRecord healthTrendRecord = new HealthTrendRecord();
//            healthTrendRecord.setTrendRecordId(UUID.randomUUID().toString());
//            healthTrendRecord.setConsultationId("NA");
//            healthTrendRecord.setPatientId(patientId);
//            healthTrendRecord.setSystolicBp(Integer.parseInt(systolicBP));
//            healthTrendRecord.setDiastolicBp(Integer.parseInt(diastolicBP));
//            healthTrendRecord.setPulseRate(Integer.parseInt(pulseRate));
//
//            //-- Update EHR Health Trend Record in the database for the patient
//            String statusUpdate = ehrDataManager.addHealthTrendRecord(patientId, healthTrendRecord);
//
//            //-- Update EHR Log with this action
//            PatientEhr patientEhr = ehrService.readXml(patientId);
//            if (patientEhr != null) {
//                ehrService.logEntryByPatient(patientName, patientEhr, MessageType.AUTOMATED_MESSAGE.getDisplayName(),
//                        "Updated BP Record: Systolic BP: " + systolicBP + " mmHg, Diastolic BP: " + diastolicBP + " mmHg, Pulse Rate: " + pulseRate + " bpm.");
//            }
//
//            response.put("success", true);
//            response.put("message", "BP record updated successfully");
//            return ResponseEntity.ok()
//                    .contentType(MediaType.APPLICATION_JSON)
//                    .body(response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.put("success", false);
//            response.put("message", "Error updating BP record: " + e.getMessage());
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
//        }
//    }
//
//
//
//    @RequestMapping(value = {"create-document-page"}, method = {RequestMethod.POST, RequestMethod.GET})
//    public ModelAndView openCreateDocumentPage(HttpServletRequest request, @RequestParam(value = "patientId", required = false) String patientId) throws Exception {
//
//        ModelAndView modelView = new ModelAndView("admin/create-document-page");
//        String patientDemo = "";
//
//        if(!StringUtil.isNullOrEmpty(patientId)){
//            patientId = commonUtil.decryptString(patientId).trim();
//            modelView.addObject("patientId", patientId);
//            PatientAccount patientAccounts = patientAccountDao.findByuserId(patientId);
//            patientDemo = patientAccounts.getFirstName()+" "+ patientAccounts.getLastName() + " , ( "+ patientAccounts.getSex()+" ) "+
//                    " , "+ patientAccounts.getDateOfBirthFormatted();
//        }
//
//        modelView.addObject("patientDemo", patientDemo);
//        return modelView;
//    }
//
//
//
//
//    //---  POPULATE MEDICATION LIST FROM BACKEND
//    private String getMedicationList() throws JsonProcessingException {
//        List<Medicine> medicationList = medicineDao.findAllByOrderByMedicineNameAsc();
//
//        List<String> medicationName = new ArrayList<>();
//        for (Medicine medObj : medicationList) {
//            medicationName.add(medObj.getMedicineName());
//        }
//        ObjectMapper objectMapper = new ObjectMapper();
//        return objectMapper.writeValueAsString(medicationName);
//    }
//
//
//
//
//}
//*/

package com.optiman.ie.services.patientAccount;

import com.optiman.ie.constant.TestTypeSnippet;
import com.optiman.ie.repository.ClinicServiceDao;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUserDao;
import com.optiman.ie.services.patientAccount.repository.PatientAccount;
import com.optiman.ie.services.patientAccount.repository.PatientAccountDao;
import com.optiman.ie.services.patientAccount.srv.PatientAccountSrv;
import com.optiman.ie.services.patientEhr.EhrUtility;
import com.optiman.ie.services.patientEhr.model.MedicalLogs;
import com.optiman.ie.services.patientEhr.model.PatientEhr;
import com.optiman.ie.services.patientEhr.srv.EHRService;
import com.optiman.ie.util.CommonUtil;
import com.optiman.ie.util.ModelViewUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.optiman.ie.constant.DocumentCategoryStatus.DOC_TYPE_MAP;

@Slf4j
@RestController
public class PatientController extends ModelViewUtil {

    private final PatientAccountDao patientAccountDao;
    private PatientAccountSrv patientAccountSrv;
    private CommonUtil commonUtil;
    private EHRService ehrService;
    private ClinicUserDao clinicUserDao;
    private TestTypeSnippet testTypeSnippet;
    private ClinicServiceDao clinicServiceDao;




    public PatientController(PatientAccountDao patientAccountDao, PatientAccountSrv patientAccountSrv, CommonUtil commonUtil, EHRService ehrService, ClinicUserDao clinicUserDao, TestTypeSnippet testTypeSnippet, ClinicServiceDao clinicServiceDao) {
        this.patientAccountDao = patientAccountDao;
        this.patientAccountSrv = patientAccountSrv;
        this.commonUtil = commonUtil;
        this.ehrService = ehrService;
        this.clinicUserDao = clinicUserDao;
        this.testTypeSnippet = testTypeSnippet;
        this.clinicServiceDao = clinicServiceDao;
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

        ModelAndView mv = securityCheckforAdmin(request);
        if (mv != null) {
            return mv; // 🔥 STOP execution and go to login page
        }

        ModelAndView modelViewObj = new ModelAndView("create-new-patient");
        return modelViewObj;
    }


    //2. Save Patient detail to Database and EHR
    @PostMapping("create-new-patient-save")
    public ResponseEntity<?> createNewPatientSave(HttpServletRequest reqObj, @RequestBody Map<String, String> requestData) {

        ClinicUser adminUser = (ClinicUser) reqObj.getSession().getAttribute("ADMIN_SESSION");
        try {

            String return_status = patientAccountSrv.createNewPaitent(adminUser, requestData);
            if (return_status.toLowerCase().contains("already exist")) {
                return ResponseEntity.status(500).body(return_status);
            }

            return ResponseEntity.ok(return_status);


        } catch (Exception e) {
            log.error("Error in method createNewPatientSave creating patient: {}", e);
            String errorMessage = e.getMessage();
            if (errorMessage.contains("duplicate key value violates unique constraint")) {
                return ResponseEntity.status(500).body("Patient with same email id or phone number already exist.");
            }
            return ResponseEntity.status(500).body("Error creating new Patient : " + e.getMessage());
        }
    }


    @RequestMapping(value = "manage-patient", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView managePatient(HttpServletRequest request) throws Exception {

        ModelAndView mv = securityCheckforAdmin(request);
        if (mv != null) {
            return mv; // 🔥 STOP execution and go to login page
        }

        PatientEhr patientEhr = null;
        String patientDemo = "";

        PatientAccount patientAccount = patientAccountDao.findByuserId(request.getParameter("patientId"));
        if (patientAccount != null) {

            //-- Create EHR xml if not exist for patient
            try {
                ehrService.createEhrXmlFileIfNotExists(patientAccount);
            } catch (Exception e) {
                log.error("Error reported in method managePatient while creating EHR XML File : {} ", e);
            }

            patientEhr = ehrService.readXml(patientAccount.getUserId());
            patientDemo = patientAccount.getFirstName() + " " + patientAccount.getLastName() + ",  " + patientAccount.getSex() +
                    ",  " + patientAccount.getAge() + ",  " + patientAccount.getDateOfBirthFormatted();
        }

        List<MedicalLogs> medicalLogs = null;
        if (patientEhr != null) {
            medicalLogs = patientEhr.getMedicalLogs();
            if (medicalLogs != null) {
                medicalLogs.sort(Comparator.comparing(MedicalLogs::getTransDateTime).reversed());
            }
        }


        //-- Filter only DOCTOR TYPE USER --
        List<ClinicUser> gpUserList = clinicUserDao.findAllByOrderByLastNameAsc()
                .stream()
                .filter(user -> user.getAccountType().equals("DOCTOR") || user.getAccountType().equals("ADMIN"))
                .collect(Collectors.toList());


        /*
                //-- CHECK IF THIS PATIENT HAVE ANY BOOKING TODAY ??
                List<AppointmentBooking> appointmentBooking = null;
                List<AppointmentBooking> Booking = appointmentBookingService.getAppointmentByDateAndPatient(LocalDate.now(), patientAccount.getUserId());
                if (Booking != null) {
                    if (Booking.size() > 0) {
                        appointmentBooking = Booking;
                    }
                }

        */


        EhrUtility ehrUtility = new EhrUtility();
        ModelAndView modelView = new ModelAndView("manage-patient-detail");
        //modelView.addObject("appointmentBooking", appointmentBooking);
        modelView.addObject("testTypeSnippet", testTypeSnippet);
        modelView.addObject("patientDemo", patientDemo);
        modelView.addObject("patientEhr", patientEhr);
        modelView.addObject("ehrUtility", ehrUtility);
        modelView.addObject("medicalLogs", medicalLogs);
        modelView.addObject("patientDetail", patientAccount);
        modelView.addObject("allDocumentType", DOC_TYPE_MAP);
        //modelView.addObject("messageSnippet", dataTemplatesDao.findByDataCategoryOrderByHeadingNameAsc("Patient Message"));
        //modelView.addObject("medicationList", getMedicationList());
        modelView.addObject("clinicServices", clinicServiceDao.findAllByOrderByServiceNameAsc());
        modelView.addObject("patientIdEncrypted",  commonUtil.encryptString(patientAccount.getUserId()));
        modelView.addObject("gpUserList", gpUserList);

        return modelView;
    }

    @PostMapping("/update-patient-detail")
    public ResponseEntity<?> updatePatientDdetail(HttpServletRequest request, @RequestBody Map<String, String> patientData) {
        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");
        try {
            return ResponseEntity.ok(patientAccountSrv.updatePaitentDetail(adminUser,patientData));
        } catch (Exception e) {
            log.error("Error reported in method updatePatientDdetail : {} ",e);
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }



}

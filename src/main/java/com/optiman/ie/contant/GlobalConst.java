package com.optiman.ie.contant;

import java.io.File;

import static com.optiman.ie.contant.ProjectDataMapping.DATA_FOLDER;

public class GlobalConst {



    public static final String USER_LOGIN_PASSWORD_VALIDATED = "USER_LOGIN_PASSWORD_VALIDATED";

    public static final String ADMIN_SESSION = "ADMIN_SESSION";

    public static final String USER_SESSION = "USER_SESSION";
    //-------------------------------------------------------------------------
    public static final String USER_VALIDATED = "VALIDATED";
    public static String EHR_RECORDS  = "ehr_records";
    public static String ADMIN_IMAGE  = "admin_image";
    public static String SICK_NOTE_REQUEST = "Sick Note";
    public static float SICK_NOTE_COST = 25;
    public static String PRESCRIPTION_REQUEST = "Prescription";
    public static float PRESCRIPTION_COST = 25;
    public static String REQUEST_NOT_PAID = "Not Paid"; // When user place request and not paid yet
    public static String REQUEST_NEW = "New";       // When user place request and payment is done
    public static String REQUEST_IN_PROCESS = "In Process"; // When request is assign to any staff
    public static String REQUEST_FINISHED = "Finished";    // When request is finished by  staff ready to go
    public static String REQUEST_SENT = " Sent ";    // When request is finished by  staff
    public static String REQUEST_REFUNDED = "Refunded";    // When request is finished by  staff
    public static String SR_PAID = "Paid";
    public static String SR_REFUNDED = "Refunded";
    public static String SR_NOT_PAID = "Not paid";
    public static String MORE_THEN_THREE_IN_LAST_THREE_MONTH = "Sorry there is more then 3 Request in last 3 month !";
    public static String FROM_EMAIL = "no-reply@gp4less.ie";
    public static String GP_NOTIFICATION_EMAIL = "GPDOCMC@PM.ME";
    public static String READY_TOGO_PDF = "Ready";
    public static String USER = "User";
    public static String SICK_NOTE_ATTACHMENT = "medical_cert_attachments";
    public static String PRESCRIPTION_ATTACHMENT = "prescription_attachments";
    public static String MEDICAL_CERT = "medical_cert";
    public static String PRESCRIPTION = "prescription";
    public static String PATIENT_DOCUMENTS = "patient_documents";
    public static String PT_DOC_PDF = "pdf_file";
    public static String PT_INV_PDF = "invoice-receipt";
    public static String REFERRAL_LETTER = "referral-letter";

    public static String EXECUTIVE_REPORT = "executive-report";

    public static String CLINIC_VOICE_MESSAGE_FOLDER = DATA_FOLDER + File.separator + "voice_message" + File.separator;

    public static String ADMIN_USER_IMAGE_FOLDER = DATA_FOLDER + File.separator + "admin_image";
    public static String MEDICAL_CERT_FOLDER_PATH =  DATA_FOLDER + File.separator + MEDICAL_CERT;
    public static String PRESCRIPTION_FOLDER_PATH = DATA_FOLDER + File.separator + PRESCRIPTION;
    public static String PATIENT_DOCUMENT_PATH =  DATA_FOLDER + File.separator + PATIENT_DOCUMENTS;
    public static String PATIENT_PDF_DOCUMENT_PATH = DATA_FOLDER + File.separator + PATIENT_DOCUMENTS + File.separator + PT_DOC_PDF;
    public static String PATIENT_INVOICE_PATH =  DATA_FOLDER + File.separator + PATIENT_DOCUMENTS + File.separator + PT_INV_PDF;
    public static String CHAT_UPLOAD_FILE_PATH =  DATA_FOLDER + File.separator + "chat_upload";
    //---------- Used for Task Master Module
    public static String TASK_NEW = "New";
    //---------- Used for Message Templets for the admin
    public static String TASK_IN_PROCESS = "In Process";
    public static String TASK_ON_HOLD = "On hold";
    public static String TASK_COMPLETED = "Completed";
    public static String TASK_REFUNDED = "Refunded";
    public static String CLINIC_ADMIN_TASK = "Clinic task";



    //---------- Used for Contact Us form
    public enum Contactus_form_Status {
        RECEIVED,
        REPLYED,
        SUSPENDED;
    }

    public enum allergy_group {
        MEDICINE("Medicine"),
        GENERAL("General");
        private final String displayName;
        allergy_group(String displayName) {
            this.displayName = displayName;
        }
        public String getDisplayName() {
            return displayName;
        }
    }

    public enum DocumentType {
        ECG("ECG Report"),
        HOSPITAL_LETTER("Hospital Letter"),
        REFERRAL_LETTER("Referral Letter"),
        SICK_NOTE("Sick Note"),
        MEDICAL_PRESCRIPTION("Prescription"),
        BLOOD_TEST_RESULT("Blood Test Result"),
        RADIOLOGY_IMAGING_RESULT("Radiology / Imaging Result"),
        MICROBIOLOGY_RESULT("Microbiology Result"),
        HISTOLOGY_RESULT("Histology Result"),
        ILLNESS_BENEFIT_CERTS("Illness Benefit Certs"),
        GENERAL_LETTER("General Letter"),
        STC_CLAIMS("Stc Claims"),
        INSURANCE_REPORTS("Insurance Reports"),
        TEST_RESULT("Test Result"),
        APPOINTMENT_LETTER("Appointment Letter"),
        INVOICE("Invoice"),
        OTHERS("Others"),
        CONSENT("Consent");
        private final String displayName;

        DocumentType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }


    /**
     * Enum representing the status of clinic documents with descriptions.
     */
    public enum ClinicDocumentStatus {


        /**
         * You can see only unprocessed/unviewed status file
         */
        UNPROCESSED_UNVIEWED("Unprocessed / Unreviewed"),

        /**
         * You can see those file which is filed to EHR, but not shared with patient
         */
        FILED_TO_EHR_NOT_SHARED("Filed to EHR, not shared"),

        /**
         * You can see those file which is filed to EHR and shared with patient
         */
        FILED_TO_EHR_SHARED_WITH_PATIENT("Filed to EHR,shared with patient"),

        NEW("New"),   //--  1. When any document is uploaded and not viewed by staff yet

        UNPROCESSED("Un Processed"), //-- 2. When any document is viewed by staff and verified and not actioned yet

        GP_ASSIGNED("Assigned to GP"), //-- 3. When any document is assigned to GP for actioning (Prescription, referral letter, medical cert)

        GP_REVIEW_FINISH("Completed"); //-- 4. When any document is actioned by GP and ready to go to patient (Prescription, referral letter, medical cert) or file to EHR (ECG, blood test result, hospital letter)


        private final String displayName;

        ClinicDocumentStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum ServiceCategoryEnum { //  Taken this detail from setmore service category

        ALL_SERVICES("All Services"),
        SICK_NOTE_REQUEST("Sick Note"),
        PRESCRIPTION_REQUEST("Prescription"),
        OTHERS("Others"),
        PRIVATE_GP_CONSULTATION("Private gp consultation"),
        COLLEGE_STUDENT_GP_CONSULTATION("College student gp consultation"),
        EAR_WAX_REMOVAL_SERVICE("Ear wax removal service"),
        BLOOD_TESTS_AND_HEALTH_SCREENINGS("Blood Tests and Health Screenings"),
        FREE_GP_SERVICES("Free gp services"),
        NURSE_SERVICES("Nurse services"),
        MINOR_SURGERY("Minor surgery"),
        AESTHETIC_COSMETIC_PROCEDURE("Aesthetic / Cosmetic Procedure"),
        VACCINATIONS("Vaccinations"),
        INSURANCE_BOOKING_NOT_FOR_PATIENT_USE("Insurance booking (not for patient use)"),
        WEIGHT_LOSS_CLINIC("Weight loss clinic"),
        COMPANY_BOOKING("Company booking"),
        ADMINISTRATIVE("Administrative"),
        SSKIN_CLINIC_FACIALS("Skin Clinic Facials");

        private final String categoryName;

        ServiceCategoryEnum(String categoryName) {
            this.categoryName = categoryName;
        }

        public static ServiceCategoryEnum fromCategoryName(String categoryName) {
            for (ServiceCategoryEnum category : values()) {
                if (category.categoryName.equalsIgnoreCase(categoryName)) {
                    return category;
                }
            }
            throw new IllegalArgumentException("Unknown category name: " + categoryName);
        }

        public String getCategoryName() {
            return categoryName;
        }
    }


}

package com.optiman.ie.constant;

public enum ServiceType {

    GP_PHONE_CONSULTATION("GP Phone consultation"),
    GP_FACE_TO_FACE_CONSULT("GP face to face consult"),
    GP_VIDEO_CONSULTATION("GP video consultation"),
    GENERAL_CONSULTATION("General Consultation"),
    AESTHETIC_COSMETIC_PROCEDURE("Aesthetic / Cosmetic Procedure"),
    ADMINISTRATIVE("Administrative"),
    BLOOD_TESTS_AND_HEALTH_SCREENINGS("Blood Tests and Health Screenings"),
    COLLEGE_STUDENT_GP_CONSULTATION("College student gp consultation"),
    COMPANY_BOOKING("Company booking"),
    EAR_WAX_REMOVAL_SERVICE("Ear wax removal service"),
    FREE_GP_SERVICES("Free gp services"),

    INSURANCE_BOOKING_NOT_FOR_PATIENT_USE("Insurance booking (not for patient use)"),
    LAB_TEST("Lab Test"),
    MEDICAL_CERT_ONLINE_SERVICE("Medical Cert online"),
    MINOR_SURGERY("Minor surgery"),
    NURSE_SERVICES("Nurse services"),
    OTHER_SERVICE("Other Service"),
    OTHERS("Others"),
    PATENT_DOCUMENT("Patient document"),
    PRESCRIPTION_REQUEST("Prescription"),
    PRESCRIPTION_SERVICE("Prescription Service"),
    PRIVATE_GP_CONSULTATION("Private gp consultation"),
    REPORT_FILE("Report File"),
    SICK_NOTE_REQUEST("Sick Note"),
    SSKIN_CLINIC_FACIALS("Skin Clinic Facials"),
    SPECIALIST_CONSULTATION("Specialist Consultation"),
    SURGERY("Surgery"),
    THERAPY("Therapy"),
    VACCINATIONS("Vaccinations"),
    WEIGHT_LOSS_CLINIC("Weight loss clinic");

    private final String displayName;

    ServiceType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}

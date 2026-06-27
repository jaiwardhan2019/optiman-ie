package com.optiman.ie.services.patientEhr.model;

public enum MessageType {
    DOCTOR_MESSAGE("Doctor Message"),
    PATIENT_MESSAGE("Patient Message"),
    ADMIN_MESSAGE("Admin Message"),
    TREATMENT_NOTE("Treatment Note"),
    CONSULTATION_NOTE("Consultation Note"),
    AUTOMATED_MESSAGE("Automated Message");

    private final String displayName;

    MessageType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}

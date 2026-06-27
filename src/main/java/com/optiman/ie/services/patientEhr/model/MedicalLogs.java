package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class MedicalLogs {

    @XmlElement
    private String logId;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime transDateTime;

    @XmlElement
    private String ptViewDateTime; // This will store information about the date and time when the patient viewed the message or document


    @XmlElement
    private String messageType; // Doctor Message , Patient Message , Admin Message , Treatment Note , Consultation Note , Automated Message

    @XmlElement
    private String documentType; // Test Report , Sick Note , Referral , Others

    @XmlElement
    private String serviceType; // Prescription Service , General Consultation, Specialist Consultation, Lab Test, Therapy, Surgery

    @XmlElement
    private String notes;

    @XmlElement
    private String documentName;

    @XmlElement
    private String doctorName;

    public MedicalLogs() {
        this.logId = UUID.randomUUID().toString();
    }

    public String formatLocalDateTime() {
        if (this.transDateTime == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm a");
        return this.transDateTime.format(formatter);
    }

    public  String extractMedicationInfo() {
        if (this.notes == null) return "";

        // Find the line that starts with the details marker
        String marker = "Below are the details of your prescribed medication:";
        int markerIndex = this.notes.indexOf(marker);
        if (markerIndex < 0) return "";

        // From that point, find the first ':' and the next ':'
        int firstColon = this.notes.indexOf(':', markerIndex + marker.length());
        if (firstColon < 0) return "";

        int secondColon = this.notes.indexOf(':', firstColon + 1);
        if (secondColon < 0) return "";

        // Extract and trim the medication info
        String extracted = this.notes.substring(firstColon + 1, secondColon).trim();
        return extracted;
    }
}
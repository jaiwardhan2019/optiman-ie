package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class Medication {
    @XmlElement private String medicationId;
    @XmlElement private String medicationName;
    @XmlElement private String dosage;
    @XmlElement private String frequency;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate startDate;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate endDate;

    @XmlElement private String prescribedBy;
    @XmlElement private String purpose;
    @XmlElement private String instructions;
    @XmlElement private Boolean isRepeatMedication;
    @XmlElement private Boolean isControlledDrugMedication;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate lastDispensedDate;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate nextDispenseDate;

    @XmlElement
    private Integer quantityPerDispense;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime createdDate;

    public String getFormattedStartDate() {
        if (this.startDate == null) return null;
        return startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public String getFormattedCreatedDate() {
        if (this.createdDate == null) return null;
        return createdDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a"));
    }
}
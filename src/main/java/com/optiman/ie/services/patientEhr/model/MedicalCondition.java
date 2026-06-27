package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class MedicalCondition {
    @XmlElement private String codeName;
    @XmlElement private String conditionName;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate diagnosedDate;

    @XmlElement private String severity;
    @XmlElement private String notes;
    @XmlElement private Boolean isChronic;
    @XmlElement private String status;

    public String getFormattedMedicalConditionDate() {
        if (this.diagnosedDate == null) return null;
        return diagnosedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}
package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class Allergy {
    @XmlElement private String mainGroup;
    @XmlElement private String allergen;
    @XmlElement private String reaction;
    @XmlElement private String severity;
    @XmlElement private String notes;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate diagnosedDate;

    public String getFormattedAllergyDate() {
        if (this.diagnosedDate == null) return null;
        return diagnosedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}
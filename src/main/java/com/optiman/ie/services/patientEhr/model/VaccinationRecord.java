package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class VaccinationRecord implements Serializable {
    @XmlElement private String vaccineCode;
    @XmlElement private String vaccineName;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate dateAdministered;

    @XmlElement private String dose;
    @XmlElement private String notes;

    public VaccinationRecord() {}
}
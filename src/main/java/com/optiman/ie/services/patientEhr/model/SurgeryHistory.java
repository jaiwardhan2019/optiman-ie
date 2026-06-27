package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class SurgeryHistory {
    @XmlElement private String procedureName;
    @XmlElement private String procedureCode;
    @XmlElement private String surgeonName;
    @XmlElement private String hospitalName;
    @XmlElement private String anesthesiaType;
    @XmlElement private String bodySite;
    @XmlElement private String complications;
    @XmlElement private String outcome;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime createdDate;
}
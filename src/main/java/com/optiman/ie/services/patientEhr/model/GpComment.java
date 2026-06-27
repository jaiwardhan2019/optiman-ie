package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class GpComment {
    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime commentDate;

    @XmlElement private String commentBy;
    @XmlElement private String commentText;
}
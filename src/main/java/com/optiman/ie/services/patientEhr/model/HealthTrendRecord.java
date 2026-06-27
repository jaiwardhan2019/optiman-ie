package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@XmlRootElement(name = "HealthTrendRecord")
@XmlAccessorType(XmlAccessType.FIELD)
public class HealthTrendRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    @XmlElement
    private String trendRecordId; // Unique identifier for the health trend record

    @XmlElement
    private String consultationId; // Unique identifier for the consultation or visit

    @XmlElement
    private String patientId; // Unique patient identifier example -> JW-06021974-231234

    // -- BMI FIELDS
    @XmlElement
    private Double weightKg;

    @XmlElement
    private Double heightM;

    @XmlElement
    private Double bmi;

    // -- BLOOD PRESSURE & PULSE
    @XmlElement
    private Integer systolicBp;

    @XmlElement
    private Integer diastolicBp;

    @XmlElement
    private Integer pulseRate;

    // -- TEMP FIELDS FOR FUTURE USE
    @XmlElement
    private Double bodyTemperatureC;

    @XmlElement
    private Double bloodOxygenLevel;

    @XmlElement
    private String activityLevel;

    @XmlElement
    private String recordedBy;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime recordedAt = LocalDateTime.now();

    public HealthTrendRecord() {
        // No-arg constructor required by JAXB
    }
}
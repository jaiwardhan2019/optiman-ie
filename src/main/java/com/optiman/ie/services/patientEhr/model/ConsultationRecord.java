package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.time.LocalDateTime;


@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class ConsultationRecord implements java.io.Serializable {

    @XmlElement
    private String consultationId;

    @XmlElement
    private String consultationMode;

    // Instead of full PatientAccount object, just store ID
    @XmlElement
    private String patientId;

    @XmlElement
    private String subjective;

    @XmlElement
    private String objective;

    @XmlElement
    private String healthtrend;

    @XmlElement
    private String assessment;

    @XmlElement
    private String treatmentPlan;

    @XmlElement
    private String notes;

    @XmlElement
    private String safetyNote;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime createdAt;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime updatedAt;

    // Instead of full ClinicUser object
    @XmlElement
    private String clinicUserId;

    @XmlElement
    private String status;
}
package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@XmlRootElement(name = "PatientDetail")
@XmlAccessorType(XmlAccessType.FIELD)
public class PatientDetail implements Serializable {

    private static final long serialVersionUID = 1L;

    @XmlElement
    private String patientId;

    @XmlElement
    private String firstName;

    @XmlElement
    private String lastName;

    @XmlElement
    private String gender;

    @XmlElement
    private String height;  // e.g. cm

    @XmlElement
    private String weight; // e.g. kg

    @XmlElement
    private String maritalStatus;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    private LocalDate dateOfBirth;

    @XmlElement
    private String IHINumber;

    @XmlElement
    private Demographics demographics;

    @XmlElement
    private ContactInfo contactInfo;

    @XmlElement
    private Address address;

    @XmlElementWrapper(name = "medicalConditions")
    @XmlElement(name = "medicalCondition")
    private List<MedicalCondition> medicalConditions;

    @XmlElementWrapper(name = "allergies")
    @XmlElement(name = "allergy")
    private List<Allergy> allergies;

    @XmlElementWrapper(name = "repeatMedications")
    @XmlElement(name = "repeatMedication")
    private List<Medication> repeatMedication;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime createdAt;

    @XmlElement
    @XmlJavaTypeAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime updatedAt;

    @XmlElement
    private String updatedBy;

    public PatientDetail() {}
}
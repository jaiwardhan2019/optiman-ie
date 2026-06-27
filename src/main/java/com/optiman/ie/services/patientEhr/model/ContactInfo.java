package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import lombok.Data;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class ContactInfo {
    @XmlElement private String primaryPhone;
    @XmlElement private String secondaryPhone;
    @XmlElement private String email;
    @XmlElement private String preferredContactMethod;

    @XmlElement
    private EmergencyContact emergencyContact;
}
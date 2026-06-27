package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import lombok.Data;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class EmergencyContact {
    @XmlElement private String name;
    @XmlElement private String phone;
    @XmlElement private String relationship;
    @XmlElement private String address;
}
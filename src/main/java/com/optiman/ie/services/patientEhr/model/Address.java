package com.optiman.ie.services.patientEhr.model;


import jakarta.xml.bind.annotation.*;
import lombok.Data;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class Address {
    @XmlElement private String addressDetail;
    @XmlElement private String city;
    @XmlElement private String state;
    @XmlElement private String eirCode;
    @XmlElement private String country;
}
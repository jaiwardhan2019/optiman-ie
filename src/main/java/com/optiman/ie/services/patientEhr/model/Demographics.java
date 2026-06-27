package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import lombok.Data;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class Demographics {
    @XmlElement private String preferredLanguage;
    @XmlElement private String race;
    @XmlElement private String ethnicity;
    @XmlElement private String maritalStatus;
    @XmlElement private String religion;
}
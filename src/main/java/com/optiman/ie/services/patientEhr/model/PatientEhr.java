package com.optiman.ie.services.patientEhr.model;

import jakarta.xml.bind.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

@Data
@XmlRootElement(name = "PatientEhrRecord")
@XmlType(propOrder = {
        "patientDetail",
        "medicalConditions",
        "surgeryHistories",
        "allergyHistories",
        "vaccinationRecords",
        "healthTrendRecords",
        "consultationRecords",
        "GpComment",
        "medicalLogs"
})
@XmlAccessorType(XmlAccessType.FIELD)
public class PatientEhr implements Serializable {

    private static final long serialVersionUID = 1L;

    @XmlAttribute(name = "version")
    private String version = "2";

    @XmlElement(name = "PatientDetail")
    private PatientDetail patientDetail;

    @XmlElementWrapper(name = "MedicalConditions")
    @XmlElement(name = "MedicalCondition")
    private List<MedicalCondition> medicalConditions;

    @XmlElementWrapper(name = "SurgeryHistories")
    @XmlElement(name = "SurgeryHistory")
    private List<SurgeryHistory> surgeryHistories;

    @XmlElementWrapper(name = "AllergyHistories")
    @XmlElement(name = "AllergyHistory")
    private List<Allergy> allergyHistories;

    @XmlElementWrapper(name = "VaccinationRecords")
    @XmlElement(name = "VaccinationRecord")
    private List<VaccinationRecord> vaccinationRecords;

    @XmlElementWrapper(name = "HealthTrendRecords")
    @XmlElement(name = "HealthTrendRecord")
    private List<HealthTrendRecord> healthTrendRecords;

    @XmlElementWrapper(name = "ConsultationRecords")
    @XmlElement(name = "ConsultationRecord")
    private List<ConsultationRecord> consultationRecords;

    @XmlElementWrapper(name = "GpComment")
    @XmlElement(name = "GpComment")
    private List<GpComment> gpComment;

    @XmlElementWrapper(name = "MedicalLogs")
    @XmlElement(name = "MedicalLog")
    private List<MedicalLogs> medicalLogs;

}
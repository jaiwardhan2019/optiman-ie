package com.optiman.ie.services.clinic_document.repository;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@Data
@Entity
@Table(name = "clinic_document_master",
        indexes = {
                @Index(name = "idx_document_id", columnList = "DOCUMENTID"),
                @Index(name = "idx_document_name", columnList = "DOCUMENTNAME")
        },
        uniqueConstraints = {@UniqueConstraint(columnNames = {"DOCUMENTID"})})
public class ClinicDocumentMaster implements Serializable {

    private static final long serialVersionUID = 1L;

    private static final String[] patterns = {
            "yyyy-MM-dd",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "MMM dd, yyyy",
            "dd MMM yyyy",
            "MMMM dd, yyyy",
            "yyyy/MM/dd",
            "dd-MM-yyyy"
    };


    @Id
    @Column(name = "DOCUMENTID", columnDefinition = "VARCHAR(25)")
    private String documentId;
    @Column(name = "USERID",  length = 25, nullable = true)
    private String userId;
    @Column(name = "FIRST_NAME", length = 100)
    private String firstName;
    @Column(name = "LAST_NAME", length = 100)
    private String lastName;
    @Column(name = "BIRTHDATE")
    private LocalDate birthDate;
    @Column(name = "SEX")
    private String sex;
    @Column(name = "FULLADDRESS", length = 1000)
    private String fullAddress;
    @Column(name = "EMAILID", length = 100)
    private String emailId;
    @Column(name = "IHI_NUMBER",  length = 50, nullable = true)
    private String ihiNumber;
    @Column(name = "DOCUMENT_TYPE")
    private String documentType;
    @Column(name = "TEST_TYPE", length = 50)
    private String testType;
    @Column(name = "DOCUMENTNAME",  length = 100, nullable = true)
    private String documentName;
    @Column(name = "xmldocumentname", length = 100, nullable = true)
    private String xmlDocumentName;

    @Column(name = "TESTDATE")
    private LocalDateTime testDate;

    @Column(name = "GPNAME", columnDefinition = "VARCHAR(100)")
    private String gpName;
    @Column(name = "REQUEST_STATUS", length = 50)
    private String requestStatus;
    @Column(name = "SRVBYUSERID", columnDefinition = "VARCHAR(25)")
    private String srvbyUserid;
    @Column(name = "SRVBYUSERNAME", columnDefinition = "VARCHAR(100)")
    private String srvbyUserName;
    @Column(name = "SERVDDATE")
    private LocalDateTime servdDate;
    @Column(name = "CREATE_DATE")
    private LocalDateTime createDate;
    @Column(name = "DOCUMENTVIEWCOUNT")
    private int documentViewCount = 0;
    @Column(name = "DOCUMENTVIEWDATE")
    private LocalDateTime documentViewDate;


    public String getDateOfBirthForForm() {
        if (this.birthDate == null) {
            return null;
        }
        // Format as ISO for HTML date input
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE; // yyyy-MM-dd
        return this.birthDate.format(formatter);
    }



    public String getActionDateFormatted() {
        if(this.servdDate == null) {
            return "";
        }
        LocalDateTime dateTime = LocalDateTime.parse(this.servdDate.toString());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm a");
        return dateTime.format(formatter);
    }

    public String getCreateDateFormatted() {
        if(this.createDate == null) {
            return "";
        }
        LocalDateTime dateTime = LocalDateTime.parse(this.createDate.toString());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm a");
        return dateTime.format(formatter);
    }

    public String getTestDateFormatted() {
        if(this.testDate == null) {
            return "";
        }
        LocalDateTime dateTime = LocalDateTime.parse(this.testDate.toString());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm a");
        return dateTime.format(formatter);
    }

    public String getBirthDateFormatted() {
        if (this.birthDate == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return this.birthDate.format(formatter);
    }

    public void setTestDate(String dateString) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        if (dateString == null || dateString.trim().isEmpty()) {
            // Set current date and time
            this.testDate = LocalDateTime.now();
        } else {
            try {
                // Parse string in "dd/MM/yyyy HH:mm" format
                this.testDate = LocalDateTime.parse(dateString, formatter);
            } catch (DateTimeParseException e) {
                //System.printlnlog.ethrow new IllegalArgumentException("Invalid date format. Expected dd/MM/yyyy HH:mm",

            }
        }
    }

}
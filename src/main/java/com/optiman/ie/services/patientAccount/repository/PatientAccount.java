package com.optiman.ie.services.patientAccount.repository;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.*;
import java.time.format.DateTimeFormatter;


@Data
@Entity
@Table(
        name = "patient_account",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_patient_email", columnNames = "EMAILID"),
                @UniqueConstraint(name = "uk_patient_userid", columnNames = "USERID")
        },
        indexes = {
                @Index(name = "idx_patient_phone", columnList = "PHONENUMBER"),
                @Index(name = "idx_patient_username", columnList = "USERNAME"),
                @Index(name = "idx_patient_mrn", columnList = "PATIENT_MRN"),
                @Index(name = "idx_patient_pps", columnList = "PPSNUMBER"),
                @Index(name = "idx_patient_ihi", columnList = "IHI_NUMBER"),
                @Index(name = "idx_patient_created", columnList = "CREATEDATE"),
                @Index(name = "idx_patient_last_action", columnList = "LAST_ACTION_DATE"),
                @Index(name = "idx_patient_name", columnList = "FIRST_NAME, LAST_NAME"),
                @Index(name = "idx_patient_active_created", columnList = "ACTIVE, CREATEDATE")
        }
)
public class PatientAccount implements Serializable {

    private static final long serialVersionUID = 1L;

    private static final DateTimeFormatter DOB_DDMMYYYY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DOB_FORM = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter LAST_ACTION_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter REG_FMT = DateTimeFormatter.ofPattern("dd-MMM-yyyy hh:mm a");

    @Id
    @Column(name = "USERID", length = 25, nullable = false)
    private String userId;

    @Column(name = "PATIENT_MRN", length = 25)
    private String patientMrn;

    @Column(name = "IHI_NUMBER", length = 50)
    private String ihiNumber;

    @Column(name = "ACCOUNT_TYPE", length = 20)
    private String accountType;

    @Column(name = "FIRST_NAME", length = 100)
    private String firstName;

    @Column(name = "LAST_NAME", length = 100)
    private String lastName;

    @Temporal(TemporalType.DATE)
    @Column(name = "BIRTHDATE")
    private LocalDate birthDate;

    @Column(name = "SEX", length = 10)
    private String sex;

    @Column(name = "GISMNUMBER", length = 50)
    private String gismNumber;

    @Column(name = "GPVISITCARD", length = 50)
    private String gpVisitCard;

    @Column(name = "PPSNUMBER", length = 25)
    private String ppsNumber;

    @Column(name = "EMAILID", length = 50)
    private String emailId;

    @Column(name = "PHONENUMBER", length = 15)
    private String phoneNumber;

    @Column(name = "EIRCODE", length = 15)
    private String eirCode;

    @Column(name = "ADDRESS", length = 300)
    private String fullAddress;

    @Column(name = "USERNAME", length = 100)
    private String username;

    @Column(name = "PASSWORD", length = 500)
    private String password;

    @Column(name = "USERLOCATION", length = 200)
    private String userLocation;

    @Column(name = "GDPRCONSENT", length = 5)
    private String gdprConsent;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "GDPRCONSENT_DATE")
    private LocalDateTime gdprConsentDate;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LASTLOGINDATE")
    private LocalDateTime lastLoginDate;

    @Column(name = "USERLOGINCOUNT")
    private Integer userLoginCount = 0; // wrapper + default

    @Column(name = "ACTIVE")
    private Boolean userIsActive = Boolean.TRUE;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATEDATE")
    private LocalDateTime createDate;

    @Column(name = "ABOUTPATIENT", length = 1000)
    private String aboutPatient;

    @Column(name = "COMMENT", length = 500)
    private String comment;

    @Column(name = "SUBSCRIPTION_TYPE", length = 25)
    private String subscriptionType;

    @Column(name = "LAST_ACTION_DATE")
    private LocalDateTime lastActionDate;

    @Column(name = "TWO_FA_CODE", length = 10)
    private String twoFaCode = "";

    @Column(name = "TWO_FA_EXPIRY")
    private LocalDateTime twoFaExpiry;

    @PrePersist
    protected void onCreate() {
        if (this.gdprConsentDate == null) this.gdprConsentDate = LocalDateTime.now();
        if (this.createDate == null) this.createDate = now;
        if (this.lastActionDate == null) this.lastActionDate = LocalDateTime.now();
        if (this.userIsActive == null) this.userIsActive = Boolean.TRUE;
        if (this.userLoginCount == null) this.userLoginCount = 0;
    }

    public String getDateOfBirthFormatted() {
        if (birthDate == null) return "";
        return birthDate.format(DOB_DDMMYYYY);
    }


    public String getDateOfBirth() {
        return getDateOfBirthFormatted();
    }

    public int getAge() {
        if (birthDate == null) return 0;
        LocalDate dob = birthDate;
        return Period.between(dob, LocalDate.now()).getYears();
    }

    public String getDateOfBirthForForm() {
        if (birthDate == null) return "";
        return birthDate.format(DOB_FORM);
    }


    public String getRegistrationDate() {
        if (createDate == null) return "";
        ZonedDateTime zdt = createDate.atZone(ZoneId.systemDefault());
        return zdt.format(REG_FMT);
    }


    public String getLastActionDateFormatted() {
        if (lastActionDate == null) return "";
        return lastActionDate.format(LAST_ACTION_FMT);
    }


    public String getMaskedName() {
        String fn = (firstName != null && !firstName.isBlank()) ? firstName.substring(0, 1) : "*";
        String ln = (lastName != null && !lastName.isBlank()) ? lastName.substring(0, 1) : "*";
        return fn + "**** " + ln + "****";
    }

    public String getInitialAndLastName() {
        String fn = (firstName != null && !firstName.isBlank()) ? firstName.substring(0, 1) : "";
        String ln = (lastName != null) ? lastName : "";
        return fn + ". " + ln;
    }

    public String getFullName() {
        String fn = firstName != null ? firstName : "";
        String ln = lastName != null ? lastName : "";
        return (fn + " " + ln).trim();
    }
}
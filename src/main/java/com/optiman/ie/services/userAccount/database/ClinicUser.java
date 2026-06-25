package com.optiman.ie.services.userAccount.database;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@Data
@Entity
@Table(name = "clinic_user",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = "email_id"),
                @UniqueConstraint(columnNames = "user_id")
})
public class ClinicUser implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "user_id", nullable = false, unique = true, length = 15)
    private String userId;

    @Column(name = "account_type", length = 100)
    private String accountType;

    @Column(name = "first_name", length = 100)
    private String firstName;

    @Column(name = "last_name", length = 100)
    private String lastName;

    @Column(name = "gsm_number", length = 20)
    private String gsmNumber;

    @Column(name = "mcr_number", length = 50)
    private String mcrNumber;

    @Column(name = "qualification", length = 100)
    private String qualifiCation;

    @Column(name = "email_id",  unique = true, length = 150)
    private String emailId;

    @Column(name = "phone_number", length = 15)
    private String phoneNumber;

    @Column(name = "password", length = 255)
    private String password;

    @Column(name = "last_login_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastLoginDate;

    @Column(name = "user_login_count")
    private int userLoginCount;

    @Column(name = "user_is_active")
    private Boolean userIsActive;

    @Column(name = "logon_status", length = 50)
    private String logonStatus;

    @Column(name = "profile_image_name", length = 100)
    private String profileImageName;

    @Column(name = "signature_image_name", length = 100)
    private String signatureImageName;

    @Column(name = "stamp_image_name", length = 100)
    private String stampImageName;

    @Column(name = "access_details", length = 1000)
    private String accessDetails;

    @Column(name = "gdpr_consent", length = 5)
    private String gdprConsent;

    @Column(name = "two_fa_code", length = 10)
    private String twoFaCode;

    @Column(name = "two_fa_expiry")
    private LocalDateTime twoFaExpiry;


    @Column(name = "gdpr_consent_date")
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime gdprConsentDate;

    @Column(name = "registration_date")
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime registrationDate;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (gdprConsentDate == null) gdprConsentDate = now;
        if (registrationDate == null) registrationDate = now;
    }


    public String getRegDate() {
        if (registrationDate == null) {
            return "";
        }
        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm");
        return registrationDate.format(formatter);
    }

    public String getFullName(){
        return this.firstName +" "+ this.lastName;
    }

    public String getRoomNumber(){
        if(this.userId.equalsIgnoreCase("SP-00035709")){
            return "3";
        } else if(this.userId.equalsIgnoreCase("LL-068556")){
            return "5";
        } else if (this.userId.equalsIgnoreCase("KC-013578")){
            return "2";
        }else if (this.userId.equalsIgnoreCase("JW-002986")) {
            return "1";
        } else if(this.userId.equalsIgnoreCase("AT-042931")){
            return "4";
        } else {
            return "0";
        }
    }



}
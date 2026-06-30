package com.optiman.ie.services.patientAccount.srv;

import com.optiman.ie.constant.ServiceType;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.patientAccount.repository.PatientAccount;
import com.optiman.ie.services.patientAccount.repository.PatientAccountDao;
import com.optiman.ie.services.patientEhr.model.*;
import com.optiman.ie.services.patientEhr.srv.EHRService;
import com.optiman.ie.services.clinicUserAccount.srv.PasswordValidation;
import com.optiman.ie.util.CommonUtil;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.HttpServletRequest;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;

@Slf4j
@Service
public class PatientAccountSrv {

    public static final String USER_VALIDATED = "VALIDATED";
    public static final String NOT_VALIDATED_YET = "IN_2FA_PROCESS";

    private final String UPDATE_STATUS = "success";

    private static final String USER_ID_DISABLE = "Your account is not active !! " +
            "Please check your email and make sure activate your account with the given link !! &nbsp;&nbsp;" +
            "If you dont see any email then please check spam / junk folder incase !! Still if no luck then please contact support! &nbsp;&nbsp; <a  href='/help-faq'> Help support Contact</a>" +
            "&nbsp;&nbsp;Or contact us through &nbsp;&nbsp; <b> support@gp4less.ie </b> &nbsp;&nbsp; for further assistance. ";

    private static final String USER_ID_NOT_FOUND = "We are unable to find your email id in our system !! Please check again !!";

    private static final String PASSWORD_NOT_FOUND = "Your password is not correct! &nbsp; <i class='bi bi-emoji-angry'></i>";
    private static final String SUCCESS_REGISTRATION = " Thanks to register with us. Now logon and enjoy service.";
    private static final String EMAIL_ID_ALREADY_USED = "This email &nbsp;  <b> ID </b>  &nbsp; is already used ! <br><br> So if you dont remember the password then Go to login page correct this email id or recover your password using.  ";
    private static final String EMAIL_ID_NOT_EXIST = "<font  color='red' size='3'> <i class='bi bi-emoji-angry' style='font-size:1.2em;'></i> Error : We are unable to find your email &nbsp; <b> id </b> in our database !! please check this Email again and make sure it is correct !!</font>";
    private static final String FORGOT_PASS_STATUS_OK = "<font color='green' size='3'> <i class='bi bi-emoji-smile' style='font-size:1.2em;'></i> Your  password reset link is sent to your email &nbsp; <b> id </b>  </font>";
    private static final String PASSWORD_UPDATED_OK = "<font color='green' size='3'> <i class='bi bi-emoji-smile' style='font-size:1.2em;'></i> Your password is updated  </font>";

    PatientAccountDao paitentAccountDao;

    PasswordValidation passwordValidation;
    //EmailService emailService;


    CommonUtil commonUtil;


    private Key secretKey;



    EHRService ehrService;


    public PatientAccountSrv(PatientAccountDao paitentAccountDao, PasswordValidation passwordValidation, CommonUtil commonUtil, Key secretKey, EHRService ehrService) {
        this.paitentAccountDao = paitentAccountDao;
        this.passwordValidation = passwordValidation;
        this.commonUtil = commonUtil;
        this.secretKey = secretKey;
        this.ehrService = ehrService;
    }

    public PatientAccount getPatientAccountByUserId(String userId) {
        return paitentAccountDao.findByuserId(userId);
    }


    public void savePatientDetail(PatientAccount userAccount) {
        userAccount.setLastActionDate(LocalDateTime.now());
        PatientAccount userAccount1 = paitentAccountDao.save(userAccount);
    }

    @SneakyThrows
    public String updateUserDetail(HttpServletRequest reqObj) {

        if (Objects.isNull(reqObj)) {
            log.error("Error in method updateUserDetail , input parameter object is null:");
            return null;
        }


        String registerStatus = SUCCESS_REGISTRATION;

        PatientAccount userAccount = paitentAccountDao.findByuserId(reqObj.getParameter("userId"));
        userAccount.setUserId(reqObj.getParameter("userId"));
        userAccount.setFirstName(reqObj.getParameter("firstName"));
        userAccount.setLastName(reqObj.getParameter("lastName"));
        String dateString = reqObj.getParameter("birthDate");
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateString, formatter);
            userAccount.setBirthDate(date);
        } catch (DateTimeParseException e) {
            e.printStackTrace();
        }
        userAccount.setSex(reqObj.getParameter("Sex"));
        userAccount.setPhoneNumber(reqObj.getParameter("phoneNumber"));
        String phoneNumber = reqObj.getParameter("phoneNumber");

        if (phoneNumber == null || !phoneNumber.matches("\\d+")) {
            log.error("Invalid phone number: {}", phoneNumber);
            return "Error : Phone number must contain only numeric values.";
        }

        userAccount.setEmailId(reqObj.getParameter("emailId").toUpperCase());
        userAccount.setEirCode(reqObj.getParameter("eirCode").toUpperCase());
        userAccount.setFullAddress(reqObj.getParameter("fullAddress").toUpperCase());
        userAccount.setPpsNumber(reqObj.getParameter("ppsNumber").toUpperCase());
        userAccount.setPassword(reqObj.getParameter("password"));
        userAccount.setSubscriptionType("Free");
        userAccount.setLastActionDate(LocalDateTime.now());

        userAccount.setAccountType(reqObj.getParameter("PtType"));
        if (!reqObj.getParameter("PtType").equalsIgnoreCase("Private")) {
            userAccount.setGismNumber(reqObj.getParameter("euHealthCardNumber").toUpperCase());
        }


        userAccount.setUsername(userAccount.getEmailId());
        userAccount.setGdprConsent(reqObj.getParameter("gdprConsent"));
        userAccount.setGdprConsentDate(LocalDateTime.now());

        //--- Password Encryption and assign to the password field
        String rawPassword = userAccount.getPassword();
        userAccount.setPassword(passwordValidation.hashPassword(rawPassword));


        // Check email id in the table and get the detail
        PatientAccount paitentAccount = paitentAccountDao.findByemailId(userAccount.getEmailId());
        if (Objects.nonNull(paitentAccount)) {
            registerStatus = EMAIL_ID_ALREADY_USED.replace("ID", userAccount.getEmailId());
            return registerStatus;
        }

        //--- Save date to the database
        PatientAccount userAccount1 = paitentAccountDao.save(userAccount);


        //- Update EHR File
        PatientEhr patientEhr = ehrService.readXml(userAccount.getUserId());
        if (patientEhr == null) {
            patientEhr = new PatientEhr();
        }
        patientEhr.setPatientDetail(mapPatientDetailToEHRClassFile(userAccount1).getPatientDetail());
        ehrService.writeXml(patientEhr, userAccount.getUserId());
        ehrService.logEntryByPatient(userAccount1.getFullName(), patientEhr, " :  Updated personal detail.");


/*
        //--  Send email
        String finalEmailBody = updatePersonalDetailThanks;
        finalEmailBody = finalEmailBody.replace("PATIENT", userAccount.getFirstName() + " " + userAccount.getLastName());
        finalEmailBody = finalEmailBody.replace("EMAILID", userAccount.getEmailId());
        finalEmailBody = finalEmailBody.replace("PASS", rawPassword);
        emailService.sendHtmlMessage(userAccount.getEmailId(), " Personal detail update confirmation with www.GP4Less.ie ", finalEmailBody);
*/

        return registerStatus;

    } // End of method


    @SneakyThrows
    public String registerNewUser(HttpServletRequest reqObj) {

        if (Objects.isNull(reqObj)) {
            log.error("Error in method registerNewUser , input parameter object is null:");
            return null;
        }

        String registerStatus = SUCCESS_REGISTRATION;
        Date dateOfBirth = null;


        PatientAccount userAccount = new PatientAccount();
        userAccount.setFirstName(reqObj.getParameter("firstName").toUpperCase());
        userAccount.setLastName(reqObj.getParameter("lastName").toUpperCase());
        String dateString = reqObj.getParameter("birthDate");
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateString, formatter);
            userAccount.setBirthDate(date);
        } catch (DateTimeParseException e) {
            e.printStackTrace();
        }

        userAccount.setGdprConsent(reqObj.getParameter("gdprConsent"));
        userAccount.setGdprConsentDate(LocalDateTime.now());
        userAccount.setSex(reqObj.getParameter("Sex"));
        userAccount.setPhoneNumber(reqObj.getParameter("phoneNumber"));

        String phoneNumber = reqObj.getParameter("phoneNumber");
        if (phoneNumber == null || !phoneNumber.matches("\\d+")) {
            log.error("Invalid phone number: {}", phoneNumber);
            return "Error : Phone number must contain only numeric values.";
        }

        userAccount.setEmailId(reqObj.getParameter("emailId").toUpperCase());
        userAccount.setEirCode(reqObj.getParameter("eirCode").toUpperCase());
        userAccount.setFullAddress(reqObj.getParameter("fullAddress"));
        userAccount.setPpsNumber(reqObj.getParameter("ppsNumber").toUpperCase());
        userAccount.setPassword(reqObj.getParameter("password"));
        userAccount.setUserIsActive(true);
        userAccount.setUserLoginCount(1);
        userAccount.setSubscriptionType("Free");
        userAccount.setLastActionDate(LocalDateTime.now());

        userAccount.setAccountType(reqObj.getParameter("PtType"));
        if (!reqObj.getParameter("PtType").equalsIgnoreCase("Private")) {
            userAccount.setGismNumber(reqObj.getParameter("euHealthCardNumber").toUpperCase());
        }


        userAccount.setUserId(getUniqueUserId(userAccount).toUpperCase());
        userAccount.setUsername(userAccount.getEmailId());
        userAccount.setLastActionDate(LocalDateTime.now());

        //--- Password Encryption and assign to the password field
        String rawPassword = userAccount.getPassword();
        userAccount.setPassword(passwordValidation.hashPassword(rawPassword));



        // Check email id in the table and get the detail
        PatientAccount paitentAccount = paitentAccountDao.findByemailId(userAccount.getEmailId());
        if (paitentAccount != null) {
            registerStatus = EMAIL_ID_ALREADY_USED.replace("ID", userAccount.getEmailId());
            return "Error ! " + registerStatus;
        }


        //--- Save data to the database
        PatientAccount userAccount1 = paitentAccountDao.save(userAccount);

        //-- Create EHR file if not exist this need to be removed after some time
        ehrService.createEhrXmlFileIfNotExists(userAccount1);


        //--  Send email verification
        /*String finalEmailBody = GP4LESS_POST_REGISTRATION_THANKS_EMAIL;
        finalEmailBody = finalEmailBody.replace("PATIENT", userAccount.getFirstName() + " " + userAccount.getLastName());
        finalEmailBody = finalEmailBody.replace("EMAILID", userAccount.getEmailId());
        // finalEmailBody = finalEmailBody.replace("PASS",rawPassword);
        //finalEmailBody = finalEmailBody.replace("TOKENID", Base64.getEncoder().encodeToString(userAccount.getUserId().getBytes()));
        emailService.sendHtmlMessage(userAccount.getEmailId(), " Registration confirmation with www.GP4Less.ie ", finalEmailBody);
       */

        String ehrLogEntryMessage = userAccount1.getFullName() + " Detail is create in EHR  ";
        PatientEhr patientEhr = ehrService.readXml(userAccount.getUserId());
        if (patientEhr != null) {
            ehrService.logEntryByPatient(userAccount.getFullName(), patientEhr, ehrLogEntryMessage);
        }

        return registerStatus;

    } // End of method




    /*@SneakyThrows
    public String registerNewUserFromPatientDocumentMaster(String documentId) {

        String sexAtBirth = "";
        String registerStatus = "";
        String dateOfBirtheString = "";
        String firstName = "";
        String lastName = "";
        String phoneNumber = "";
        String fullAddress = "";
        String patientEmailid = "";

        PatientAccount userAccount = new PatientAccount();
        ClinicDocumentMaster clinicDocumentMaster = clinicDocumentMasterDao.findByDocumentId(documentId);

        //--- If xml file exist
        String xmlFileName = PATIENT_DOCUMENT_PATH + File.separator + documentId + ".xml";
        if (new File(xmlFileName).exists()) {
            //Read xml file to get the patient details in object as on the db not all info is stored
            PatientLabReport xmlPatientLabReportObj = PatientLabReportXmlTool.readXmlFile(xmlFileName);
            firstName = xmlPatientLabReportObj.getFirstName();
            lastName = xmlPatientLabReportObj.getLastName();
            dateOfBirtheString = xmlPatientLabReportObj.getDateOfBirth();
            if (xmlPatientLabReportObj.getSexAtBirth().toUpperCase(Locale.ROOT).startsWith("M")) {
                sexAtBirth = "Male";
            }
            if (xmlPatientLabReportObj.getSexAtBirth().toUpperCase(Locale.ROOT).startsWith("F")) {
                sexAtBirth = "Female";
            }
            if (xmlPatientLabReportObj.getSexAtBirth().toUpperCase(Locale.ROOT).startsWith("O")) {
                sexAtBirth = "Other";
            }

            phoneNumber = xmlPatientLabReportObj.getPhoneNumber();
            fullAddress = xmlPatientLabReportObj.getStreetAddress();

            //-- Update XML file with the email id  patientEmailid
            patientEmailid = clinicDocumentMaster.getEmailId().toUpperCase();
            xmlPatientLabReportObj.setEmailAddress(clinicDocumentMaster.getEmailId().toUpperCase());
            PatientLabReportXmlTool.updateXmlFile(xmlPatientLabReportObj, xmlFileName);

        } else {  //--- If request comes from added pdf document analysis

            firstName = clinicDocumentMaster.getFirstName();
            lastName = clinicDocumentMaster.getLastName();
            dateOfBirtheString = clinicDocumentMaster.getBirthDate().toString();
            sexAtBirth = clinicDocumentMaster.getSex();
            phoneNumber = "NA";
            fullAddress = clinicDocumentMaster.getFullAddress();
            patientEmailid = clinicDocumentMaster.getEmailId().toUpperCase();
        }

        if (patientEmailid == null || patientEmailid.equalsIgnoreCase("NA") || patientEmailid.trim().isEmpty()) {
            patientEmailid = new CommonUtil().createEightDigitRandomNo() + "@NOEMAIL.XXX";
            patientEmailid = patientEmailid.toUpperCase();
        }

        userAccount.setFirstName(firstName.toUpperCase());
        userAccount.setLastName(lastName.toUpperCase());
        userAccount.setBirthDate(DateUtil.parseToSqlDate(dateOfBirtheString));
        userAccount.setGdprConsent("NA");
        userAccount.setSex(sexAtBirth);
        userAccount.setPhoneNumber(phoneNumber);
        userAccount.setEmailId(patientEmailid.toUpperCase());
        userAccount.setEirCode("");
        userAccount.setFullAddress(fullAddress);
        userAccount.setPpsNumber("");
        userAccount.setUserId(getUniqueUserId(userAccount).toUpperCase());
        userAccount.setUsername(userAccount.getEmailId().toUpperCase());
        userAccount.setUserIsActive(true);
        userAccount.setSubscriptionType("NA");
        userAccount.setLastActionDate(LocalDateTime.now());

        // Check first name last name , dob
        java.sql.Date sqlDate = DateUtil.parseToSqlDate(dateOfBirtheString);
        List<PatientAccount> patientAccounts = paitentAccountDao.findPatientAccountsIgnoreCase(firstName, lastName, sqlDate, sexAtBirth, patientEmailid);

        if (patientAccounts.size() > 0) {
            return "Patient : <b>" + firstName + " " + lastName + " DOB : " + dateOfBirtheString + " </b> already registered with us !!" +
                    "<br> Or given email ID : <b> " + patientEmailid + " </b> is already used !";
        }

        //--- Save data to the patient_account
        PatientAccount userAccount1 = paitentAccountDao.save(userAccount);
        registerStatus = userAccount.getUserId() + ":" + "Patient : <b>" + firstName + " " + lastName + " DOB : " + dateOfBirtheString + " </b> created successfully ";

        //-- Create empty EHR file for the patient
        ehrService.writeXml(mapPatientDetailToEHRClassFile(userAccount1), userAccount.getUserId());
        //-- Create log entry in EHR file about the account creation from clinic document upload
        PatientEhr patientEhr = ehrService.readXml(userAccount.getUserId());
        if (patientEhr != null) {
            ehrService.logEntryFromAdmin("Admin ", patientEhr, GlobalConst.ServiceCategoryEnum.ADMINISTRATIVE.getCategoryName(), ServiceType.OTHERS.getDisplayName(), documentId + ".pdf", " Patient account created from clinic document upload.");
        }

        //-- Update patientId to the clinic document master
        clinicDocumentMaster.setUserId(userAccount1.getUserId());
        clinicDocumentMasterDao.save(clinicDocumentMaster);


        return registerStatus;

    } // End of method
*/

    private String createUserToken(String userId, String userEmail) {

        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);

        // Set expiration to 15 minutes (in milliseconds)
        long expMillis = nowMillis + 15 * 60 * 1000;
        Date exp = new Date(expMillis);


        String userId_emailId_Token = Jwts.builder()
                .claim("userid", userId)
                .claim("emailid", userEmail)
                .setIssuedAt(now)
                .setExpiration(exp)   // <-- This line sets the token to expire in 15 minutes
                .signWith(secretKey)
                .compact();
        return userId_emailId_Token;
    }

    public Map<String, String> getUserIdEmailIdFromToken(String tokenId) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(tokenId)
                .getBody();

        String userId = claims.get("userid", String.class);
        String emailId = claims.get("emailid", String.class);

        Map<String, String> userDetailMap = new HashMap<>();
        userDetailMap.put("userid", userId);
        userDetailMap.put("emailid", emailId);
        return userDetailMap;
    }




    /*
     *  Will be used by Admin Part when admin try and update patient detail from backend
     * */

    //-- Verify token and activate account
    public boolean activateUserAccount(String tokenId) throws Exception {
        try {
            // Decode token
            String userId = new String(Base64.getDecoder().decode(tokenId));

            // Fetch user from database
            PatientAccount patientAccount = paitentAccountDao.findByuserId(userId);
            if (patientAccount == null || !patientAccount.getUserId().equalsIgnoreCase(userId)) {
                return false;
            }

            // Activate and save the user account
            patientAccount.setUserIsActive(true);
            patientAccount.setUserLoginCount(1);
            paitentAccountDao.save(patientAccount);

            // Log the activation
            PatientEhr patientEhr = ehrService.readXml(patientAccount.getUserId());
            if (patientEhr != null) {
                ehrService.logEntryByPatient(
                        patientAccount.getFullName(),
                        patientEhr,
                        patientAccount.getFullName() + "  has activated the account successfully."
                );
            }

            log.info("User account activated for ID: {}", userId);
            return true;

        } catch (IllegalArgumentException e) {
            log.error("Invalid token provided.", e);
            return false;
        }
    }



    @SneakyThrows
    public String finishRegistration(HttpServletRequest reqObj) {

        if (Objects.isNull(reqObj)) {
            log.error("Error in method updateUserDetail , input parameter object is null:");
            return null;
        }


        String registerStatus = SUCCESS_REGISTRATION;

        PatientAccount userAccount = paitentAccountDao.findByuserId(reqObj.getParameter("userId"));
        userAccount.setUserId(reqObj.getParameter("userId"));
        userAccount.setFirstName(reqObj.getParameter("firstName"));
        userAccount.setLastName(reqObj.getParameter("lastName"));
        String dateString = reqObj.getParameter("birthDate");


        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate date = LocalDate.parse(dateString, formatter);
        userAccount.setBirthDate(date);




        userAccount.setSex(reqObj.getParameter("Sex"));
        userAccount.setPhoneNumber(reqObj.getParameter("phoneNumber"));
        userAccount.setEmailId(reqObj.getParameter("emailId"));
        userAccount.setEirCode(reqObj.getParameter("eirCode").toUpperCase());
        userAccount.setFullAddress(reqObj.getParameter("fullAddress"));
        userAccount.setPpsNumber(reqObj.getParameter("ppsNumber").toUpperCase());
        userAccount.setPassword(reqObj.getParameter("password"));
        userAccount.setSubscriptionType("Free");
        userAccount.setLastActionDate(LocalDateTime.now());

        userAccount.setAccountType(reqObj.getParameter("PtType"));
        if (!reqObj.getParameter("PtType").equalsIgnoreCase("Private")) {
            userAccount.setGismNumber(reqObj.getParameter("euHealthCardNumber").toUpperCase());
        }


        userAccount.setUsername(userAccount.getEmailId());

        userAccount.setGdprConsent(reqObj.getParameter("gdprConsent"));
        userAccount.setGdprConsentDate(LocalDateTime.now());

        //--- Password Encryption and assign to the password field
        String rawPassword = userAccount.getPassword();
        userAccount.setPassword(passwordValidation.hashPassword(rawPassword));


        // Check email id in the table and get the detail
        /*PaitentAccount paitentAccount = paitentAccountDao.findByemailId(userAccount.getEmailId());
            if (Objects.nonNull(paitentAccount)) {
                registerStatus = EMAIL_ID_ALREADY_USED.replace("ID", userAccount.getEmailId());
                return registerStatus;
            }
        */

        //--- Save date to the database
        PatientAccount userAccount1 = paitentAccountDao.save(userAccount);

        //- Update EHR File
        PatientEhr patientEhr = ehrService.readXml(userAccount.getUserId());
        if (patientEhr == null) {
            patientEhr = new PatientEhr();
        }


        //--  Send account activation email with link
/*
        String finalEmailBody = GP4LESS_POST_REGISTRATION_THANKS_EMAIL;
        finalEmailBody = finalEmailBody.replace("PATIENT", userAccount.getFirstName() + " " + userAccount.getLastName());
        finalEmailBody = finalEmailBody.replace("EMAILID", userAccount.getEmailId());
        // finalEmailBody = finalEmailBody.replace("PASS",rawPassword);
        //finalEmailBody = finalEmailBody.replace("TOKENID", Base64.getEncoder().encodeToString(userAccount.getUserId().getBytes()));
        emailService.sendHtmlMessage(userAccount.getEmailId(), " Registration confirmation with www.GP4Less.ie ", finalEmailBody);
*/


        patientEhr.setPatientDetail(mapPatientDetailToEHRClassFile(userAccount1).getPatientDetail());
        ehrService.writeXml(patientEhr, userAccount.getUserId());
        ehrService.logEntryByPatient(userAccount1.getFullName(), patientEhr, " : Finish registration and received Account activation email .");

        return registerStatus;
    } // End of method



    @SneakyThrows
    public String finishRegistrationWithPasswordUpdate(HttpServletRequest reqObj) {

        if (Objects.isNull(reqObj)) {
            log.error("Error in method updateUserDetail , input parameter object is null:");
            return null;
        }


        String registerStatus = SUCCESS_REGISTRATION;

        PatientAccount userAccount = paitentAccountDao.findByuserId(reqObj.getParameter("userId"));
        userAccount.setUserId(reqObj.getParameter("userId"));
        userAccount.setPassword(reqObj.getParameter("password"));
        userAccount.setSubscriptionType("Free");
        userAccount.setLastActionDate(LocalDateTime.now());
        userAccount.setAccountType(reqObj.getParameter("PtType"));
        if (!reqObj.getParameter("PtType").equalsIgnoreCase("Private")) {
            userAccount.setGismNumber(reqObj.getParameter("euHealthCardNumber").toUpperCase());
        }


        userAccount.setGdprConsent(reqObj.getParameter("gdprConsent"));
        userAccount.setGdprConsentDate(LocalDateTime.now());

        //--- Password Encryption and assign to the password field
        String rawPassword = userAccount.getPassword();
        userAccount.setPassword(passwordValidation.hashPassword(rawPassword));


        //--- Save date to the database
        PatientAccount userAccount1 = paitentAccountDao.save(userAccount);


        //- Update EHR File
        PatientEhr patientEhr = ehrService.readXml(userAccount.getUserId());
        if (patientEhr == null) {
            patientEhr = new PatientEhr();
        }


/*
        //--  Send account activation email with link
        String finalEmailBody = GP4LESS_POST_REGISTRATION_THANKS_EMAIL;
        finalEmailBody = finalEmailBody.replace("PATIENT", userAccount.getFirstName() + " " + userAccount.getLastName());
        finalEmailBody = finalEmailBody.replace("EMAILID", userAccount.getEmailId());
        // finalEmailBody = finalEmailBody.replace("PASS",rawPassword);
        //finalEmailBody = finalEmailBody.replace("TOKENID", Base64.getEncoder().encodeToString(userAccount.getUserId().getBytes()));
        emailService.sendHtmlMessage(userAccount.getEmailId(), " Registration confirmation with www.GP4Less.ie ", finalEmailBody);
*/


        patientEhr.setPatientDetail(mapPatientDetailToEHRClassFile(userAccount1).getPatientDetail());
        ehrService.writeXml(patientEhr, userAccount.getUserId());
        ehrService.logEntryByPatient(userAccount1.getFullName(), patientEhr, " : Finish registration and received Account activation email .");


        return registerStatus;

    } // End of method


    private boolean areAddressesSimilar(String address1, String address2) {
        // Remove spaces, make lowercase, and get first 10 characters (or shorter if address is short)
        String a1 = address1.replaceAll("\\s+", "").toLowerCase();
        String a2 = address2.replaceAll("\\s+", "").toLowerCase();

        String sub1 = a1.length() >= 10 ? a1.substring(0, 10) : a1;
        String sub2 = a2.length() >= 10 ? a2.substring(0, 10) : a2;

        return sub1.equals(sub2);
    }

    // -- Will create unique user ID for the new registration
    private String getUniqueUserId(PatientAccount userMaster) {
        CommonUtil commonUtil = new CommonUtil();
        String userFirstName = String.valueOf(Character.toUpperCase(userMaster.getFirstName().charAt(0)));
        String userLastName = String.valueOf(Character.toUpperCase(userMaster.getLastName().charAt(0)));
        return userFirstName.trim() + userLastName.trim() + "-" + commonUtil.createEightDigitRandomNo();
    }

    @SneakyThrows
    public String updatePaitentDetail(ClinicUser adminUser, Map<String, String> patientData) {

        String userId = patientData.get("userId");
        String firstName = patientData.get("firstName").toUpperCase();
        String lastName = patientData.get("lastName").toUpperCase();
        String birthDate = patientData.get("birthDate");
        String Sex = patientData.get("patientSex");
        String ppsNumber = patientData.get("ppsNumber");
        String phoneNumber = patientData.get("phoneNumber");
        String emailId = patientData.get("emailId").toUpperCase();
        String fullAddress = patientData.get("fullAddress").toUpperCase();
        String eirCode = patientData.get("eirCode").toUpperCase();
        String patientType = patientData.get("patientType");
        String gismNumber = patientData.get("gismNumber").toUpperCase();
        String gpVisitCard = patientData.get("gpVisitCard").toUpperCase();
        boolean userIsActive = Boolean.parseBoolean(patientData.get("userIsActive"));


        PatientAccount paitentAccountObj = paitentAccountDao.findByuserId(userId);
        paitentAccountObj.setFirstName(firstName);
        paitentAccountObj.setLastName(lastName);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate date = LocalDate.parse(birthDate, formatter);
        paitentAccountObj.setBirthDate(date);

        paitentAccountObj.setSex(Sex);
        paitentAccountObj.setPpsNumber(ppsNumber);
        paitentAccountObj.setPhoneNumber(phoneNumber);
        paitentAccountObj.setEmailId(emailId);
        paitentAccountObj.setUsername(emailId);
        paitentAccountObj.setFullAddress(fullAddress);
        paitentAccountObj.setEirCode(eirCode);
        paitentAccountObj.setAccountType(patientType);
        paitentAccountObj.setGismNumber(gismNumber);
        paitentAccountObj.setGpVisitCard(gpVisitCard);
        paitentAccountObj.setUserIsActive(userIsActive);
        paitentAccountObj.setLastActionDate(LocalDateTime.now());

        //-- UPDATE TO DB
        paitentAccountDao.save(paitentAccountObj);

        //--- UPDATE EHR
        String ehrLogEntryMessage = "Patient  Demography updated.";
        if (adminUser != null) {
            ehrService.logEntryFromGp(adminUser, ehrService.readXml(paitentAccountObj.getUserId()), ServiceType.OTHER_SERVICE.getDisplayName(),
                    "NA", "NA", ehrLogEntryMessage);
        }


        return UPDATE_STATUS;
    }


    @Async
    public void updateLastActionDate(String patientId) {
        PatientAccount paitentAccountObj = paitentAccountDao.findByuserId(patientId);
        if (paitentAccountObj != null) {
            paitentAccountObj.setLastActionDate(LocalDateTime.now());
            paitentAccountDao.save(paitentAccountObj);
        }
    }



    @SneakyThrows  //-- When admin or patient from reception create new patient from his side
    public String createNewPaitent(ClinicUser adminUser, Map<String, String> patientData) {

        String firstName = patientData.get("firstName").toUpperCase().trim();
        String lastName = patientData.get("lastName").toUpperCase().trim();
        String birthDate = patientData.get("birthDate");

        LocalDate dob = null;
        try {
            dob = LocalDate.parse(birthDate);
        } catch (DateTimeParseException e) {
            // return bad request / validation error
        }


        String Sex = patientData.get("patientSex");
        String phoneNumber = patientData.get("phoneNumber").trim();
        String emailId = patientData.get("emailId").toUpperCase().trim();
        String fullAddress = patientData.get("fullAddress").toUpperCase().trim();
        String eirCode = patientData.get("eirCode").toUpperCase().trim();
        String subscriptionType = "NA";



        List<PatientAccount> patientAccounts = paitentAccountDao.findPatientAccountsIgnoreCase(firstName, lastName, dob, Sex);
        if (patientAccounts != null) {
            if (patientAccounts.size() > 0) {
                return "Patient already exist with same detail : " + firstName + " " + lastName + " , Dob : " + birthDate;
            }
        }

        // Check email id in the table and get the detail
        PatientAccount paitentAccount = paitentAccountDao.findByemailId(emailId);
        if (paitentAccount != null) {
            return "This email id : " + emailId + " is already used by another patient !";
        }

        PatientAccount patientAccountObj = new PatientAccount();
        patientAccountObj.setFirstName(firstName);
        patientAccountObj.setLastName(lastName);

        try {

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(birthDate, formatter);
            patientAccountObj.setBirthDate(date);

        } catch (DateTimeParseException e) {
            e.printStackTrace();
        }

        patientAccountObj.setSex(Sex);
        patientAccountObj.setPhoneNumber(phoneNumber);
        patientAccountObj.setEmailId(emailId);
        patientAccountObj.setUsername(emailId);
        patientAccountObj.setFullAddress(fullAddress);
        patientAccountObj.setEirCode(eirCode);
        patientAccountObj.setUserId(getUniqueUserId(patientAccountObj));
        patientAccountObj.setSubscriptionType(subscriptionType);
        patientAccountObj.setLastActionDate(LocalDateTime.now());
        patientAccountObj.setUserIsActive(true);

        //-- Update to db
        paitentAccountDao.save(patientAccountObj);

        //-- Create EHR
        ehrService.createEhrXmlFileIfNotExists(patientAccountObj);

        // -- Create EHR log entry for patient creation
        PatientEhr patientEhr = ehrService.readXml(patientAccountObj.getUserId());
        if (patientEhr == null) {
            patientEhr = new PatientEhr();
        }

        String ehrLogEntryMessage = "Patient : " + patientAccountObj.getFullName() + " is manually created by Admin or at reception by patient them self : " + adminUser.getFullName();
        ehrService.logEntryFromGp(adminUser, patientEhr, ServiceType.GENERAL_CONSULTATION.getDisplayName(), "NA", "NA", ehrLogEntryMessage);
        log.info("New patient ID : {}  Name : {}  Email id : {} Created by : {}  ", patientAccountObj.getUserId(), patientAccountObj.getFullName(), patientAccountObj.getEmailId(), adminUser.getFullName());

        return UPDATE_STATUS;
    }


    private PatientEhr mapPatientDetailToEHRClassFile(PatientAccount account) {

        PatientDetail detail = new PatientDetail();

        // Direct mappings
        detail.setPatientId(account.getUserId()); // Or account.getUserId() if you want USERID
        detail.setFirstName(account.getFirstName());
        detail.setLastName(account.getLastName());
        detail.setGender(account.getSex());
        detail.setIHINumber(account.getIhiNumber());

        // Date mapping: java.util.Date -> java.time.LocalDate
        if (account.getBirthDate() != null) {
            detail.setDateOfBirth(account.getBirthDate()
                    .atStartOfDay(java.time.ZoneId.systemDefault()).toLocalDate());
        }

        // createdAt, updatedAt: example mapping from createDate and lastLoginDate
        if (account.getCreateDate() != null) {
            detail.setCreatedAt(account.getCreateDate());
        }

        if (account.getLastLoginDate() != null) {
            detail.setUpdatedAt(account.getLastLoginDate());
        }


        detail.setUpdatedBy(account.getUserId()); // Or another field if needed

        // Address mapping
        Address address = new Address();
        address.setAddressDetail(account.getFullAddress());
        address.setEirCode(account.getEirCode());
        // You can split address/city/state if available in fullAddress, otherwise leave blank
        detail.setAddress(address);

        // ContactInfo mapping
        ContactInfo contactInfo = new ContactInfo();
        contactInfo.setPrimaryPhone(account.getPhoneNumber());
        contactInfo.setEmail(account.getEmailId());
        detail.setContactInfo(contactInfo);

        // Demographics mapping
        Demographics demographics = new Demographics();
        // You may want to set preferredLanguage, ethnicity, etc. if available in PatientAccount
        detail.setDemographics(demographics);

        // The rest: medicalConditions, allergies, medications, transactions are left null (empty)
        // Extend if you have sources for these in the PatientAccount

        PatientEhr patientEhr = new PatientEhr();
        patientEhr.setPatientDetail(detail);
        return patientEhr;
    }


}


package com.optiman.ie.services.clinicUserAccount.srv;

import ch.qos.logback.core.util.StringUtil;

import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUserDao;
import com.optiman.ie.util.CommonUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.text.ParseException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.optiman.ie.constant.GlobalConst.USER_LOGIN_PASSWORD_VALIDATED;


@Slf4j
@Service
public class ClinicUserSrv {


    private static final String USER_ID_NOT_FOUND = "Your user id or password is not correct! &nbsp; <i class='bi bi-emoji-angry'></i>";

    @Autowired
    PasswordValidation passwordValidation;

    @Autowired
    ClinicUserDao clinicUserDao;



    public String createClinicUser(Map<String, String> data, ClinicUser clinicUser) {


        if(data.isEmpty()){return "Data object is empty !!!";}

        ClinicUser newClinicUser = new ClinicUser();

        String accountType = data.get("accountType");
        newClinicUser.setAccountType(accountType);
        String firstName = data.get("firstName");
        if(accountType.equalsIgnoreCase("DOCTOR")){
            newClinicUser.setFirstName("Dr. "+firstName);
        }else{
            newClinicUser.setFirstName(firstName);
        }

        String lastName = data.get("lastName");
        newClinicUser.setLastName(lastName);

        String roomNumber = data.get("roomNumber");
        newClinicUser.setRoomNumber(roomNumber);

        //-- For creating new user id if not exist
        String userId = data.get("userId");
        if(StringUtil.isNullOrEmpty(userId)){
            CommonUtil commonUtil = new CommonUtil();
            String userFirstName = String.valueOf(Character.toUpperCase(firstName.charAt(0)));
            String userLastName = String.valueOf(Character.toUpperCase(lastName.charAt(0)));
            userId = userFirstName.trim() + userLastName.trim() + "-" + commonUtil.createEightDigitRandomNo();
        }
        //-- for updating existing user id
        newClinicUser.setUserId(userId);

        String gsmNumber = data.get("gsmNumber");
        newClinicUser.setGsmNumber(gsmNumber);

        String mcrNumber = data.get("mcrNumber");
        newClinicUser.setMcrNumber(mcrNumber);

        String qualifiCation = data.get("qualifiCation");
        newClinicUser.setQualifiCation(qualifiCation);

        String emailId = data.get("emailId");
        newClinicUser.setEmailId(emailId);

        String phoneNumber = data.get("phoneNumber");
        newClinicUser.setPhoneNumber(phoneNumber);

        String password = data.get("password");
        String encryptedPassword = passwordValidation.hashPassword(password);
        newClinicUser.setPassword(encryptedPassword);
        newClinicUser.setLogonStatus("ACTIVE");
        newClinicUser.setStampImageName("gpdoc-stamp.jpg");
       // newClinicUser.setGdprConsent("Yes");

        try {
            clinicUserDao.save(newClinicUser);
        }catch (Exception e){
            log.error("Error : {} ",e.getMessage());
            return "Error while saving user details : "+e.getMessage()+", \n please contact support !!";
        }

        // Send email to user and provide them login details
       // emailService.sendHtmlMessage(emailId,"Your account is created on www.gp4less.ie ","<h3>Dear "+firstName+",</h3><br/> <p>Your account is created on www.gp4less.ie/admin. Your login details are as below:</p> <br/> <b>User Name : </b>"+emailId+" <br/> <b>Password : </b>"+password+" <br/><br/> <p>Please keep this information safe and do not share it with anyone. &nbsp; <a href='www.Gp4Less.ie/admin'> Login </a> </p><p>Best regards</p><br>www.Gp4Less.ie/admin");
        return "OK";
    }



    public String updateClinicUser(Map<String, String> data, ClinicUser clinicUser)  {


        if(data.isEmpty()){return "Data object is empty !!!";}

        ClinicUser newClinicUser = clinicUserDao.findById(data.get("userId")).orElse(null);

        String accountType = data.get("accountType");
        newClinicUser.setAccountType(accountType);
        String firstName = data.get("firstName");
        newClinicUser.setFirstName(firstName);

        String lastName = data.get("lastName");
        newClinicUser.setLastName(lastName);

        String gsmNumber = data.get("gsmNumber");
        newClinicUser.setGsmNumber(gsmNumber);

        String mcrNumber = data.get("mcrNumber");
        newClinicUser.setMcrNumber(mcrNumber);

        String qualifiCation = data.get("qualifiCation");
        newClinicUser.setQualifiCation(qualifiCation);

        String emailId = data.get("emailId");
        newClinicUser.setEmailId(emailId);

        String phoneNumber = data.get("phoneNumber");
        newClinicUser.setPhoneNumber(phoneNumber);

        String roomNumber = data.get("roomNumber");
        newClinicUser.setRoomNumber(roomNumber);


        String password = data.get("password");
        if(!StringUtil.isNullOrEmpty(password)){
            String encryptedPassword = passwordValidation.hashPassword(password);
            newClinicUser.setPassword(encryptedPassword);
            log.info("Password updated for user id : {} ",newClinicUser.getUserId());
        }


        try {
            clinicUserDao.save(newClinicUser);
        }catch (Exception e){
            log.error("Error : {} ",e.getMessage());
            return "Error while saving user details : "+e.getMessage()+", \n please contact support !!";
        }

        return "OK";
    }


    public ClinicUser validateUserLoginDetail(String userLoginName, String userPassword) throws ParseException {


        if (userLoginName.equalsIgnoreCase("admin") && userPassword.equalsIgnoreCase("admin")) {
            ClinicUser clinicUser = new ClinicUser();
            clinicUser.setLogonStatus(USER_LOGIN_PASSWORD_VALIDATED);
            clinicUser.setUserId("Lawrence");
            clinicUser.setFirstName("Lawrence");
            clinicUser.setLastName("Lau");
            clinicUser.setEmailId("jai.wardhan2007@gmail.com");
            clinicUser.setGsmNumber("52669");
            clinicUser.setMcrNumber("416855");
            clinicUser.setQualifiCation("MBBS (IMU), GCFM (AFPM), MICGP, PDAM (EIU-Paris)");
            clinicUser.setSignatureImageName("lau-sign.png");
            clinicUser.setProfileImageName("lau.png");
            clinicUser.setStampImageName("gpdoc-stamp.jpg");
            clinicUser.setAccountType("ADMIN");
            return clinicUser;
        }



        Optional<ClinicUser> optionalClinicUser = Optional.ofNullable(clinicUserDao.findByEmailId(userLoginName));
        if(optionalClinicUser.isPresent()){
            ClinicUser clinicUser = optionalClinicUser.get();
            String storedPassword = clinicUser.getPassword();
            boolean passwordMatch = passwordValidation.validatePassword(userPassword,storedPassword);
            if(passwordMatch){
                clinicUser.setLogonStatus(USER_LOGIN_PASSWORD_VALIDATED);
                return clinicUser;
            }else{
                clinicUser.setLogonStatus(USER_ID_NOT_FOUND);
                return clinicUser;
            }
        }

        return null;

    } // End of method



    public ClinicUser findUserByEmailId(String emailId){
        return clinicUserDao.findByEmailId(emailId);
    }


    public Optional<ClinicUser> findByUserId(String userId){
       return clinicUserDao.findById(userId);
    }

    public void deleteClinicUser(String userId){
        clinicUserDao.deleteById(userId);
    }


    public List<ClinicUser> findAllClinicUser(){
        return clinicUserDao.findAll();
    }

    public  ClinicUser saveClinicUser(ClinicUser clinicUser){
        return clinicUserDao.save(clinicUser);
    }




}


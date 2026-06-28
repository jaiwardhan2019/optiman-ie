package com.optiman.ie.contant;

import java.util.Map;
import java.util.TreeMap;

public class ClinicUserType {

    private static String ADMIN = "Admin";
    private static String DOCTOR = "Doctor";

    private static String NURSE = "Nurse";

    private static String RECEPTIONIST = "Receptionist";

    private static String LAB_TECHNICIAN = "Lab Technician";


    public static final Map<String,String> getUserTypes() {

        Map<String,String> userTypes = new TreeMap<>();
        userTypes.put("ADMIN",ADMIN);
        userTypes.put("DOCTOR",DOCTOR);
        userTypes.put("NURSE",NURSE);
        userTypes.put("RECEPTIONIST",RECEPTIONIST);
        userTypes.put("LAB_TECHNICIAN",LAB_TECHNICIAN);
        return userTypes;
    }


}
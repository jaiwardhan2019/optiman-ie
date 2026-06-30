package com.optiman.ie.util;

import io.jsonwebtoken.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.security.Key;
import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

import static com.optiman.ie.constant.GlobalConst.*;

@Service
public class CommonUtil {


    @Autowired
    private Key secretKey;

    // -- Will create unique request reference number
    public static String getUniqueRequestReferenceNumber() {
        String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        int STRING_LENGTH = 12;
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(STRING_LENGTH);
        for (int i = 0; i < STRING_LENGTH; i++) {
            int index = random.nextInt(CHARACTERS.length());
            sb.append(CHARACTERS.charAt(index));
        }

        return sb.toString().toUpperCase();
    }

    public static Date convertStringToDateYYYYMMDD(String dateStr) throws ParseException {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            return formatter.parse(dateStr);
    }

    public static String resolvePdfFolder(String fileName) {
        if (fileName == null) return null;
        String upper = fileName.toUpperCase(Locale.ROOT);
        if (upper.startsWith("MC") || upper.startsWith("QR")) return MEDICAL_CERT;
        if (upper.startsWith("PR")) return PRESCRIPTION;
        if (upper.startsWith("HLD")) return PATIENT_DOCUMENTS;
        if (upper.startsWith("PTDOC")) return PATIENT_DOCUMENTS + File.separator + PT_DOC_PDF;
        if (upper.startsWith("REFER")) return PATIENT_DOCUMENTS + File.separator + REFERRAL_LETTER;
        if (upper.startsWith("EXE_REP")) return PATIENT_DOCUMENTS + File.separator + EXECUTIVE_REPORT;
        if (upper.startsWith("INV")) return PATIENT_DOCUMENTS + File.separator + PT_INV_PDF;

        return null;
    }

    public static String resolveQuoraCodeDocuments(String fileName) {
        if (fileName == null) return null;
        String upper = fileName.toUpperCase(Locale.ROOT);
        if (upper.startsWith("MC") || upper.startsWith("QR")) return MEDICAL_CERT;
        return null;
    }

    public static String constructPrescMediCertFileName(String fileNameInitial) {
        SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
        String dateStr = sdf.format(new Date());
        Random random = new Random();
        int uniqueNumber = 100000 + random.nextInt(900000);
        return fileNameInitial+"_"+dateStr + "_" + uniqueNumber + ".pdf";
    }




    // Generate Random unique id

    public String padLeftZeros(String inputString, int length) {
        if (inputString.length() >= length) {
            return inputString;
        }
        StringBuilder sb = new StringBuilder();
        while (sb.length() < length - inputString.length()) {
            sb.append('0');
        }
        sb.append(inputString);

        return sb.toString();
    }

    public void createFolderIfNotExist(String folderPath) {
        File rootFolder = new File(folderPath);
        if (!rootFolder.exists()) {
            rootFolder.mkdir();
        }
    }

    public void removeFileFromFolder(String filePath) {
        File fileRootPath = new File(filePath);
        if (fileRootPath.exists()) {
            fileRootPath.delete();
        }
    }

    public String getAlfaNumericUniqueId(int lenght) {

        // Define the characters that can be used in the random ID
        String CHARACTERS = "abcdefghijklmnopqrstuvwxyz0123456789";

        // Define the length of the random ID
        int LENGTH = lenght;

        // SecureRandom instance to generate random numbers
        SecureRandom random = new SecureRandom();

        StringBuilder sb = new StringBuilder(LENGTH);
        for (int i = 0; i < LENGTH; i++) {
            int randomIndex = random.nextInt(CHARACTERS.length());
            char randomChar = CHARACTERS.charAt(randomIndex);
            sb.append(randomChar);
        }

        return sb.toString();
    }

    public String createTempPassWord() {
        return getAlfaNumericUniqueId(6).toUpperCase();
    }

    public String createEightDigitRandomNo() {
        Random rand = new Random();
        return String.format("%08d", rand.nextInt(100000));
    }

    public String createFiveDigitRandomNo() {
        Random rand = new Random();
        return String.format("%05d", rand.nextInt(100000));
    }

    public String getValueFromCheckBox(String[] checkBoxList){
        if (checkBoxList != null) {
            for (String selectedValue : checkBoxList) {
                return selectedValue;
            }
        }
        return null;
    }

    public String constructSecureFileName(String fileName) {
        SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyy");
        String dateStr = sdf.format(new Date());
        Random random = new Random();
        int uniqueNumber = 100000 + random.nextInt(900000);
        return fileName+"_"+dateStr + "_" + uniqueNumber + ".pdf";
    }

    public String encryptString(String userId){

        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);
        long expMillis = nowMillis + 7L * 24 * 60 * 60 * 1000; // 7 days
        Date exp = new Date(expMillis);
        String userId_emailId_Token = Jwts.builder()
                .claim("userid", userId)
                .setIssuedAt(now)
                .setExpiration(exp)   // <-- This line sets the token to expire in 65 minutes
                .signWith(secretKey)
                .compact();
        return userId_emailId_Token;
    }



    public String decryptString(String tokenId) {

        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(tokenId)
                    .getBody();

            return claims.get("userid", String.class);

        } catch (ExpiredJwtException e) {
            throw new RuntimeException("Token has expired. ");

        } catch (UnsupportedJwtException e) {
            throw new RuntimeException("Unsupported JWT token.");

        } catch (MalformedJwtException e) {
            throw new RuntimeException("Invalid JWT token format.");

        } catch (SignatureException e) {
            throw new RuntimeException("Invalid JWT signature.");

        } catch (IllegalArgumentException e) {
            throw new RuntimeException("JWT token is empty or null.");
        }
    }


}

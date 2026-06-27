package com.optiman.ie.services.patientAccount.repository;

import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;

public interface PatientAccountDao extends CrudRepository<PatientAccount, Integer> {

    @Query("SELECT COUNT(p) FROM PatientAccount p")
    long countAll();

    PatientAccount findByusername(String userlLogin);

    PatientAccount findByuserId(String userId);


    //Optional<PatientAccount> findByuserId(String userId);

    @Query("SELECT p FROM PatientAccount p WHERE LOWER(p.emailId) = LOWER(:userEmail)")
    PatientAccount findByemailId(@Param("userEmail") String userEmail);

    PatientAccount findByemailIdAndUserId(String emailId ,String userId);

    @Query("SELECT p FROM PatientAccount p ORDER BY p.createDate DESC")
    List<PatientAccount> findAllByOrderByRegisterDateDesc();

    @Modifying
    @Query("UPDATE PatientAccount u SET u.lastLoginDate = CURRENT_TIMESTAMP, u.userLoginCount = u.userLoginCount + 1 WHERE u.emailId = :emailId")
    void updateLoginInfoAndLoginCount(@Param("emailId") String emailId);

    //-- Check weather a patient account exists with the given details, ignoring case
    @Query("SELECT pa FROM PatientAccount pa " +
            "WHERE LOWER(pa.firstName) = LOWER(:firstName) " +
            "AND LOWER(pa.lastName) = LOWER(:lastName) " +
            "AND pa.birthDate = :birthDate " +
            "AND LOWER(pa.sex) = LOWER(:sex)")
    List<PatientAccount> findPatientAccountsIgnoreCase(
            @Param("firstName") String firstName,
            @Param("lastName") String lastName,
            @Param("birthDate") Date birthDate,
            @Param("sex") String sex
    );

    @Query("""
       SELECT pa FROM PatientAccount pa
       WHERE (LOWER(pa.firstName) = LOWER(:firstName)
          AND LOWER(pa.lastName)  = LOWER(:lastName)
          AND pa.birthDate        = :birthDate
          AND LOWER(pa.sex)       = LOWER(:sex))
          OR LOWER(pa.emailId)    = LOWER(:emailId)
       """)
    List<PatientAccount> findPatientAccountsIgnoreCase(
            @Param("firstName") String firstName,
            @Param("lastName") String lastName,
            @Param("birthDate") Date birthDate,
            @Param("sex") String sex,
            @Param("emailId") String emailId
    );

    @Query("SELECT p FROM PatientAccount p ORDER BY p.lastActionDate DESC")
    List<PatientAccount> findAllByOrderBylastActionDateDesc();

    @Query("SELECT p FROM PatientAccount p ORDER BY p.lastActionDate DESC, p.createDate DESC")
    List<PatientAccount> findAllByOrderByLastActionDateAndCreateDateDesc();

    @Query("SELECT p FROM PatientAccount p ORDER BY p.lastActionDate DESC")
    List<PatientAccount> findAllByOrderByLastActionDate();


    @Query("select p from PatientAccount p where lower(p.firstName) like :q  or lower(p.lastName)  like :q " +
            "or lower(p.emailId)  like :q  or lower(p.phoneNumber) like :q ")
    List<PatientAccount> searchByKeyword(@Param("q") String keywordLike);


    @Query("SELECT p FROM PatientAccount p WHERE LOWER(p.ihiNumber) = LOWER(:ihiNumber)")
    PatientAccount findByIhiNumber(@Param("ihiNumber") String ihiNumber);


    @Modifying
    @Query("UPDATE PatientAccount p SET p.subscriptionType = 'Free' WHERE p.subscriptionType = 'NA' AND p.userLoginCount > 0")
    void updateSubscriptionTypeForActiveUsers();

    @Modifying
    @Transactional
    @Query("""
    UPDATE PatientAccount p
       SET p.twoFaCode = :twoFaCode,
           p.twoFaExpiry = :twoFaCodeExpiry
     WHERE p.emailId = :emailId
""")
    void updateTwoFaCodeExpiryTime(
            @Param("emailId") String emailId,
            @Param("twoFaCode") String twoFaCode,
            @Param("twoFaCodeExpiry") LocalDateTime twoFaCodeExpiry
    );


    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END " +
           "FROM PatientAccount p " +
           "WHERE LOWER(p.emailId) = LOWER(:emailId) " +
           "AND p.twoFaCode = :twoFaCode " +
           "AND p.twoFaExpiry > :currentTime")
    boolean existsByEmailIdAndTwoFaCodeAndTwoFaExpiryAfter(
            @Param("emailId") String emailId,
            @Param("twoFaCode") String twoFaCode,
            @Param("currentTime") LocalDateTime currentTime
    );
}
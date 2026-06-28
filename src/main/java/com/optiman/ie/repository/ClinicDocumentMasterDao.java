package com.optiman.ie.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.util.List;

@Repository
public interface ClinicDocumentMasterDao extends JpaRepository<ClinicDocumentMaster, Long> {

    @Query("SELECT COUNT(p) FROM ClinicDocumentMaster p")
    long countAll();
    ClinicDocumentMaster findByDocumentId(String documentId);

    List<ClinicDocumentMaster> findTop5000ByOrderByCreateDateDesc();


    @Query(value = """
    SELECT * FROM clinic_document_master WHERE UPPER(xmlDocumentName) LIKE '%.XML' OR UPPER(documentname) LIKE 'EXE_REP_%' ORDER BY create_date DESC  LIMIT 5000
    """, nativeQuery = true)
    List<ClinicDocumentMaster> findTop5000XmlDocuments();


    // Custom JPQL query for more control
    @Query("SELECT p FROM ClinicDocumentMaster p WHERE " +
            "LOWER(p.firstName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) " +
            "OR LOWER(p.lastName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) " +
            "OR LOWER(p.testType) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    List<ClinicDocumentMaster> searchByFirstOrLastName(@Param("searchTerm") String searchTerm, Pageable pageable);


    // Search by birth date
    List<ClinicDocumentMaster> findByBirthDate(Date birthDate);



    @Query(value= "SELECT * FROM clinic_document_master WHERE userId = :userId ORDER BY create_date DESC", nativeQuery = true)
    List<ClinicDocumentMaster> findAllDocumentOfUser(@Param("userId") String userId);

    @Query(value = "SELECT * FROM clinic_document_master WHERE userid = :userId AND document_type = :documentType ORDER BY create_date DESC", nativeQuery = true)
    List<ClinicDocumentMaster> searchUserDocumentsByDocumentType(@Param("userId") String userId, @Param("documentType") String documentType);

    @Query(value = """
        SELECT * FROM clinic_document_master 
        WHERE userid = :userId AND create_date BETWEEN :startDate AND :endDate
        ORDER BY create_date DESC
        """, nativeQuery = true)
    List<ClinicDocumentMaster> searchUserDocumentByDates(
            @Param("userId") String userId,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate
    );

    @Query(value = """
        SELECT * FROM clinic_document_master 
        WHERE userid = :userId AND create_date BETWEEN :startDate AND :endDate AND document_type = :documentType
        ORDER BY create_date DESC
        """, nativeQuery = true)
    List<ClinicDocumentMaster> searchUserDocumentByDatesAndType(
            @Param("userId") String userId,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("documentType") String documentType
    );

    @Modifying
    @Transactional
    @Query("UPDATE ClinicDocumentMaster u SET u.documentViewDate = CURRENT_TIMESTAMP, u.documentViewCount = u.documentViewCount + 1 WHERE u.documentName = :documentName")
    int updateDocumentViewCount(@Param("documentName") String documentName);

    @Modifying
    @Transactional
    @Query("DELETE FROM ClinicDocumentMaster u WHERE u.documentId = :documentId")
    int deleteByDocumentId(@Param("documentId") String documentId);



    @Modifying
    @Transactional
    @Query("""
       update ClinicDocumentMaster p
       set p.srvbyUserid   = :userId,
           p.srvbyUserName = :userName,
           p.requestStatus = :status,
           p.servdDate     = :servdDate
       where p.documentId  = :documentId
       """)
    int updateDocumentServiceDetails(@Param("documentId") String documentId,
                                     @Param("userId") String userId,
                                     @Param("userName") String userName,
                                     @Param("servdDate") java.time.LocalDateTime servdDate,
                                     @Param("status") String status);





    @Modifying
    @Transactional
    @Query("UPDATE ClinicDocumentMaster u SET u.requestStatus = :processStatus WHERE u.documentId = :documentId")
    int updateDocumentStatus(@Param("processStatus") String processStatus,@Param("documentId") String documentId);

    @Modifying
    @Transactional
    @Query("UPDATE ClinicDocumentMaster u SET u.emailId = :emailId , u.userId = :userId WHERE u.documentId = :documentId")
    int updateEmailIdUserIdToDocument(@Param("emailId") String emailId, @Param("userId") String userId , @Param("documentId") String documentId);



    /**
     * Check if a record already exists with the same firstName, lastName, sex, birthDate, and testDate
     */
    @Query("""
    SELECT COUNT(c) FROM ClinicDocumentMaster c
    WHERE LOWER(c.firstName) = LOWER(:firstName)
      AND LOWER(c.lastName) = LOWER(:lastName)
      AND LOWER(c.sex) = LOWER(:sex)
      AND LOWER(c.documentType) = LOWER(:documentType)
      AND FUNCTION('DATE', c.birthDate) = :birthDateOnly
      AND FUNCTION('DATE', c.testDate) = :testDateOnly
""")
    long countDuplicateRecord(
            @Param("firstName") String firstName,
            @Param("lastName") String lastName,
            @Param("sex") String sex,
            @Param("documentType") String documentType,
            @Param("birthDateOnly") Date birthDateOnly,
            @Param("testDateOnly") Date testDateOnly
    );

}
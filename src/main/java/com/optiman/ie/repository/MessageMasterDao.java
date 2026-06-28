package com.optiman.ie.repository;

import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface MessageMasterDao extends JpaRepository<MessageMaster, String> {
    // Custom query to retrieve the latest entries
    @Query("SELECT n FROM MessageMaster n ORDER BY n.createDate DESC")
    List<MessageMaster> findLatestMessage(); // Fetch all entries sorted by createDate (latest first)

    // If you want to limit the number of entries (e.g., 15 latest entries):
    @Query("SELECT n FROM MessageMaster n ORDER BY n.createDate DESC")
    List<MessageMaster> findTop15ByOrderByCreateDateDesc();

    List<MessageMaster> findByViewStatusFalseOrderByCreateDateDesc();

    @Modifying
    @Query("UPDATE MessageMaster s SET s.viewStatus = true WHERE s.requestId = :requestId")
    @Transactional
    void markAsViewed(@Param("requestId") String requestId);

    @Async
    @Modifying
    @Transactional
    @Query("UPDATE MessageMaster s SET s.viewStatus = true, s.viewDateTime = CURRENT_TIMESTAMP WHERE s.messageId = :messageId")
    void markMessageAsViewed(@Param("messageId") String messageId);

    @Query("SELECT n FROM MessageMaster n " +
            "WHERE (n.messageToId = :userId ) AND n.viewStatus = false " +
            "ORDER BY n.createDate DESC")
    List<MessageMaster> getAllUnreadMessagesForUserId(@Param("userId") String userId);


    @Query("SELECT n FROM MessageMaster n " +
            "WHERE (n.messageToId = :userId ) ORDER BY n.createDate DESC")
    List<MessageMaster> getAllMessagesForUserId(@Param("userId") String userId);


    @Query("SELECT n FROM MessageMaster n WHERE n.requestId = :requestId ORDER BY n.createDate DESC")
    List<MessageMaster> getAllMessagesForRequestId(@Param("requestId") String requestId);



    @Modifying
    @Transactional
    @Query("""
    DELETE FROM MessageMaster m  WHERE m.viewStatus = true  OR m.createDate <= :cutoffDate
    """)
    void deleteOldMessagesORViewStatusTrue(
            @Param("cutoffDate") Date cutoffDate
    );




}

package com.optiman.ie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface  TaskMasterDao extends JpaRepository<TaskMaster, Long> {

    @Query("SELECT COUNT(p) FROM TaskMaster p")
    long countAll();

    List<TaskMaster> findByAssignToAndTaskHeadingAndTaskDetailAndTaskStatus(String assignTo, String taskHeading, String taskDetail, String taskStatus);

    List<TaskMaster> findByAssignTo(String assignTo);

    List<TaskMaster> findByAssignToOrderByCreateDateDesc(String assignTo);

    List<TaskMaster> findAllByOrderByCreateDateDesc();

    TaskMaster findByRefNumber(String refNumber);

}

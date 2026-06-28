package com.optiman.ie.repository;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Table(name = "task_master")
public class TaskMaster implements Serializable {

    @Id
    @Column(name = "ref_number", length = 20)
    private String refNumber;

    @Column(name = "document_id", length = 50)
    private String documentId;

    @Column(name = "patient_id" , length = 15)
    private String patientId;

    @Column(name = "assign_to", length = 50)
    private String assignTo;

    @Column(name = "assign_to_name", length = 100)
    private String assignToName;

    @Column(name = "task_heading", length = 150)
    private String taskHeading;

    @Column(name = "task_detail", columnDefinition = "TEXT")
    private String taskDetail;

    @Column(name = "task_status")
    private String taskStatus;

    @Column(name = "patient_note", columnDefinition = "TEXT")
    private String patientNote;

    @Column(name = "task_log", columnDefinition = "TEXT")
    private String taskLog;


    @Column(name = "create_by", length = 50)
    private String createBy;

    @Column(name = "create_by_name", length = 100)
    private String createByName;

    @Column(name = "create_date")
    private LocalDateTime createDate;

    private String longTimeAgo;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (createDate == null) createDate = now;
    }

    public String getFormatCreateDate() {
        if (this.createDate == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm a");
        return this.createDate.format(formatter);
    }


    public String getTimeAgo() {
        String dateStr = String.valueOf(this.createDate);
        LocalDateTime specifiedDateTime;
        try {
            specifiedDateTime = LocalDateTime.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        } catch (DateTimeParseException e) {
            DateTimeFormatter fallback = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
            specifiedDateTime = LocalDateTime.parse(dateStr, fallback);
        }
        LocalDateTime now = LocalDateTime.now();
        Duration duration = Duration.between(specifiedDateTime, now);
        this.longTimeAgo = duration.toHours() + " hrs. ago";
        return this.longTimeAgo;
    }

    //--- Inner class for log details

    /**
     * Adds a log entry to the taskLog JSON array.
     * If taskLog is empty, creates a new array; otherwise, appends to the existing array.
     * @param fromName   The name of the person/user who performed the action
     * @param actionNote The note or description of the action
     * @param actionDate The date/time of the action (string, e.g., formatted)
     */
    public void addTaskLogDetail(String fromName, String actionNote, String actionDate) {
        ObjectMapper mapper = new ObjectMapper();
        List<TaskLogDetail> logList = new ArrayList<>();

        try {
            // If there are existing logs, read them into the list
            if (this.taskLog != null && !this.taskLog.isEmpty()) {
                logList = mapper.readValue(this.taskLog, new TypeReference<List<TaskLogDetail>>() {});
            }

            // Add the new log entry
            logList.add(new TaskLogDetail(fromName, actionNote, actionDate));

            // Serialize the list back to the JSON string
            this.taskLog = mapper.writeValueAsString(logList);
        } catch (Exception e) {
            throw new RuntimeException("Failed to serialize TaskLogDetail list to JSON", e);
        }
    }

    /**
     * Utility method: Get the list of task log entries.
     */
    public List<TaskLogDetail> getTaskLogDetails() {
        ObjectMapper mapper = new ObjectMapper();
        if (this.taskLog == null || this.taskLog.isEmpty()) {
            return new ArrayList<>();
        }
        try {
            return mapper.readValue(this.taskLog, new TypeReference<List<TaskLogDetail>>() {});
        } catch (Exception e) {
            throw new RuntimeException("Failed to deserialize TaskLogDetail list from JSON", e);
        }
    }

    @Data
    public static class TaskLogDetail {
        private String fromName;
        private String actionNote;
        private String actionDate;

        @JsonCreator
        public TaskLogDetail(
                @JsonProperty("fromName") String fromName,
                @JsonProperty("actionNote") String actionNote,
                @JsonProperty("actionDate") String actionDate
        ) {
            this.fromName = fromName;
            this.actionNote = actionNote;
            this.actionDate = actionDate;
        }

    }
}
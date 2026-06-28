package com.optiman.ie.repository;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.UUID;

@Data
@Entity
@Table(name = "message_master", uniqueConstraints = {
        @UniqueConstraint(columnNames = "MESSAGEID")
})
public class MessageMaster implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "MESSAGEID")
    private String messageId;


    @Column(name = "REQUESTID", columnDefinition = "VARCHAR(25)")
    private String requestId;

    @Column(name = "REQUEST_TYPE", length = 50)
    private String requestType;  // sick note , presciption ,  GP Appointment


    @Column(name = "MESSAGEFROMID")  //  From Userid
    private String messageFromId;

    @Column(name = "MESSAGEFROM", columnDefinition = "VARCHAR(100)")  //  From User Name
    private String messageFrom;

    @Column(name = "MESSAGETOID")  //  To Userid
    private String messageToId;

    @Column(name = "MESSAGETO", columnDefinition = "VARCHAR(100)")  //  To User Name
    private String messageTo;


    @Column(name = "MESSAGEBODY", columnDefinition = "TEXT")
    private String messageBody;

    @Column(name = "ATTACHEDFILE", columnDefinition = "VARCHAR(225)")
    private String attachedFile;


    @Column(name = "VIEWSTATUS")
    private boolean viewStatus;

    @Column(name = "VIEWDATETIME")
    private LocalDateTime viewDateTime;


    private String longTimeAgo;

    @Column(name = "CREATEDATE")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createDate;

    @PrePersist
    protected void onCreate() {
        this.createDate = new Date();
        this.messageId = UUID.randomUUID().toString();
    }

    public String timeAgo(){
        // Parse the specified date-time
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        LocalDateTime specifiedDateTime = LocalDateTime.parse(String.valueOf(this.createDate), formatter);
        LocalDateTime now = LocalDateTime.now();
        Duration duration = Duration.between(specifiedDateTime, now);
        this.longTimeAgo = (duration.toHours()) + " hrs. ago";
        return (duration.toHours()) + " hrs. ago";
    }


    public String getMessageDate() throws ParseException {
        // Convert the original date string to a Date object
        SimpleDateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        Date date = originalFormat.parse(String.valueOf(this.createDate));
        // Format the Date object to the desired string format
        SimpleDateFormat desiredFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm a");
        return desiredFormat.format(date);
    }


}
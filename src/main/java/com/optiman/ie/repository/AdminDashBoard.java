package com.optiman.ie.repository;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "admin_dash_board")
@Data
public class AdminDashBoard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long Id;

    @Column(name = "patient_count")
    private int patientCount;

    @Column(name = "patient_consultation_count", nullable = false)
    @org.hibernate.annotations.ColumnDefault("0")
    private int patientConsultationCount = 0;

    @Column(name = "booking_count")
    private Integer bookingCount;

    @Column(name = "service_request_count")
    private int service_request_count;

    @Column(name = "patient_document_count")
    private int patient_document_count;

    @Column(name = "mytask_count")
    private int mytask_count;

    @Column(name = "patient_check_in_count")
    @org.hibernate.annotations.ColumnDefault("0")
    private int patientCheckInCount = 0;

    @Column(name = "updated_date")
    private LocalDate updated_date;

}
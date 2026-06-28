package com.optiman.ie.repository;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "clinic_service")
@Data
public class ClinicService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "service_code", unique = true, nullable = false)
    private String serviceCode;

    @Column(name = "service_name", nullable = false)
    private String serviceName;

    @Column(name = "duration_minutes", nullable = false)
    private int durationMinutes;

    @Column(name = "service_cost", nullable = false)
    private Float serviceCost = 0.00f;

    @Column(nullable = false)
    private boolean active = true;
}

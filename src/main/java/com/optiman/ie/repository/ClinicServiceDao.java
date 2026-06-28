package com.optiman.ie.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClinicServiceDao extends JpaRepository<ClinicService, Long> {

    ClinicService findByServiceName(String serviceName);

    ClinicService findByServiceCode(String serviceCode);

    List<ClinicService> findAllByOrderByServiceNameAsc();

}

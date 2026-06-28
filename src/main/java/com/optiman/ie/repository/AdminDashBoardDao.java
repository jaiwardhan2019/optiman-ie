package com.optiman.ie.repository;


import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AdminDashBoardDao extends JpaRepository<AdminDashBoard, Long> {
    List<AdminDashBoard> findAll();
}
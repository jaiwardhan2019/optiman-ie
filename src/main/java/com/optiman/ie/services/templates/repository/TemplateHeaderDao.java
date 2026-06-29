package com.optiman.ie.services.templates.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TemplateHeaderDao extends JpaRepository<TemplateHeader, Long> {

    List<TemplateHeader> findAllByOrderByHeadingNameAsc();

    List<TemplateHeader> findByHeadingNameContainingIgnoreCaseOrderByHeadingNameAsc(String headingName);

    List<TemplateHeader> findByOrderByHeadingNameAsc();

    List<TemplateHeader> findByOrderByCreateDateDesc();

    @Modifying
    @Query("UPDATE TemplateHeader t SET t.headingName = :newHeader WHERE t.tempHeaderId = :tempHeaderId")
    int updateHeaderById(@Param("tempHeaderId") Long tempHeaderId, @Param("newHeader") String newHeader);


}
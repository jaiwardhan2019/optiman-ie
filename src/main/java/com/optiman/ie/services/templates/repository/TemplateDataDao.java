package com.optiman.ie.services.templates.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface TemplateDataDao extends JpaRepository<TemplateData, Long> {

        // Order by category then heading
        List<TemplateData> findAllByOrderByDataCategoryAscHeadingNameAsc();

        // Latest first
        List<TemplateData> findByOrderByCreateDateDesc();


        List<TemplateData> findByDataCategoryOrderByHeadingNameAsc(String dataCategory);

        // Search within a category
        @Query("""
            SELECT d
            FROM TemplateData d
            WHERE
                (LOWER(d.headingName) LIKE LOWER(CONCAT('%', :headingName, '%'))
                 OR LOWER(d.contentDetail) LIKE LOWER(CONCAT('%', :headingName, '%')))
            AND LOWER(d.dataCategory) = LOWER(:dataCategory)
            ORDER BY d.createDate DESC
            """)
        List<TemplateData> findCaseSensitiveByHeadingNameContainingAndDataCategoryOrderByCreateDateDesc(
                @Param("headingName") String headingName,
                @Param("dataCategory") String dataCategory);

        // Global search
        @Query("""
            SELECT d
            FROM TemplateData d
            WHERE
                LOWER(d.headingName) LIKE LOWER(CONCAT('%', :keyword, '%'))
                OR LOWER(d.contentDetail) LIKE LOWER(CONCAT('%', :keyword, '%'))
            ORDER BY d.headingName ASC
            """)
        List<TemplateData> searchByHeadingNameOrContentDetail(
                @Param("keyword") String keyword);

        @Modifying
        @Transactional
        @Query("""
            UPDATE TemplateData d
            SET d.dataCategory = :newDataCategory
            WHERE LOWER(d.dataCategory) = LOWER(:dataCategoryToBeUpdated)
            """)
        int updateDataCategoryForWhereDataCategoryIsSame(
                @Param("dataCategoryToBeUpdated") String dataCategoryToBeUpdated,
                @Param("newDataCategory") String newDataCategory);

        // -------- FK RELATION QUERIES --------

        List<TemplateData> findByTemplateHeaderTempHeaderId(Long tempHeaderId);

        List<TemplateData> findByTemplateHeaderTempHeaderIdOrderByHeadingNameAsc(Long tempHeaderId);

        List<TemplateData> findByTemplateHeaderHeadingNameContainingIgnoreCase(String headingName);

}
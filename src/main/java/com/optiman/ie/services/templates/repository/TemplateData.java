package com.optiman.ie.services.templates.repository;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
@Entity
@Table(name = "template_data")
public class TemplateData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "data_category", length = 100)
    private String dataCategory;

   @Column(name = "content_detail", columnDefinition = "TEXT")
    private String contentDetail;

    @Column(name = "create_by", length = 50)
    private String createBy;

    @Column(name = "create_date")
    private LocalDate createDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "temp_header_id",referencedColumnName = "temp_header_id",nullable = false)
    private TemplateHeader templateHeader;

    @Column(name = "heading_name", length = 100)
    private String headingName;


    @Transient
    public String getCreatedDate() {
        return createDate != null
                ? createDate.format(DateTimeFormatter.ofPattern("dd-MMM-yyyy"))
                : null;
    }
}
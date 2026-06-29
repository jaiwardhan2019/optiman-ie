package com.optiman.ie.services.templates.repository;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "template_header")
public class TemplateHeader {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "temp_header_id")
    private Long tempHeaderId;

    @Column(name = "heading_name", length = 100)
    private String headingName;

    @Column(name = "create_by", length = 50)
    private String createBy;

    @Column(name = "create_date")
    private LocalDateTime createDate;

    @OneToMany(mappedBy = "templateHeader", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<TemplateData> templateDataTemplates = new ArrayList<>();

    @Transient
    public String getCreatedDate() {
        return createDate != null
                ? createDate.format(DateTimeFormatter.ofPattern("dd-MMM-yyyy"))
                : null;
    }
}
package com.optiman.ie.contant;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.optiman.ie.services.templates.repository.TemplateHeader;
import com.optiman.ie.services.templates.repository.TemplateHeaderDao;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DataTemplateCategory {

    private final TemplateHeaderDao templatesDao;

    public List<TemplateHeader> templatesList;

    public DataTemplateCategory(TemplateHeaderDao templatesDao) {
        this.templatesDao = templatesDao;
    }

    @PostConstruct
    public void init() throws JsonProcessingException {
        templatesList = templatesDao.findAll();
    }

    public synchronized void refreshTemplatesList() {
        this.templatesList = templatesDao.findAll();
    }
}



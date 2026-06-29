package com.optiman.ie.services.templates;

import ch.qos.logback.core.util.StringUtil;
import com.optiman.ie.contant.DataTemplateCategory;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.templates.repository.TemplateData;
import com.optiman.ie.services.templates.repository.TemplateDataDao;
import com.optiman.ie.services.templates.repository.TemplateHeader;
import com.optiman.ie.services.templates.repository.TemplateHeaderDao;
import com.optiman.ie.util.ModelViewUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.xml.bind.JAXBException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;


/*
 *  This controller will manage the Data Template Add . Remove and Update for all the modules
 *  of the entire application
 *
 * */


@Slf4j
@Controller
public class SetupDataTempletController extends ModelViewUtil {


    @Autowired
    TemplateHeaderDao templateHeaderDao;

    @Autowired
    TemplateDataDao templateDataDao;

    @Autowired
    DataTemplateCategory dataTemplateCategory;



    //-- This end point will manage the Data Template Category  Add . Remove and Update
    @RequestMapping(value = "manage_templates_header", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView ManageTemplates(HttpServletRequest request,
                                        @RequestParam(value = "updateTemplateId", required = false) String updateTemplateId,
                                        @RequestParam(value = "addTemplateId", required = false) String addTemplateId,
                                        @RequestParam(value = "delTemplateId", required = false) String delTemplateId) {

        if (request.getSession().getAttribute("ADMIN_SESSION") == null) {
            return renderViewPage("admin-login");
        }
        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");

        // For remove template
        if (!StringUtil.isNullOrEmpty(delTemplateId)) {
            templateHeaderDao.deleteById(Long.parseLong(delTemplateId));
            log.info("Template with ID: {} is removed by : {}", delTemplateId, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());
            ModelAndView modelView = new ModelAndView("template-header-list");
            modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
            modelView.addObject("templateList", templateHeaderDao.findByOrderByHeadingNameAsc());
            return modelView;
        }


        // For rendering Update template
        if (!StringUtil.isNullOrEmpty(updateTemplateId)) {
            //-- Render the update template page with the existing template data
            ModelAndView modelView = new ModelAndView("update-template-header");
            modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
            modelView.addObject("templateHeaderObj", templateHeaderDao.findById(Long.parseLong(updateTemplateId)).orElse(null));
            return modelView;
        }

        // For Add new template
        if (!StringUtil.isNullOrEmpty(addTemplateId)) {
            //-- Render the update template page with the existing template data
            TemplateHeader templateHeaderObj = new TemplateHeader();
            ModelAndView modelView = new ModelAndView("update-template-header");
            modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
            modelView.addObject("templateHeaderObj", templateHeaderObj);
            return modelView;
        }


        ModelAndView modelView = new ModelAndView("template-header-list");
        modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
        modelView.addObject("templateList", templateHeaderDao.findByOrderByCreateDateDesc());
        log.info("Template list viewed by : {}", adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());
        return modelView;
    }




    //--  WILL CREATE NEW AND UPDATE TEMPLATE HEADER
    @PostMapping("update-template-header")
    public ResponseEntity<String> updateTemplateCategory(HttpServletRequest reqObj,@RequestBody Map<String, String> requestData) throws IOException, JAXBException {

        // Get user detail from session
        ClinicUser adminUser = (ClinicUser) reqObj.getSession().getAttribute("ADMIN_SESSION");
        if (adminUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized access.");
        }

        String templateId = requestData.get("templateId");
        String templateHeader = requestData.get("templateHeader");

        String sending_status = "";

        if (templateId == null || templateId.isEmpty()) {
            // Create a new template
            log.info("Creating new template with header: {}", templateHeader);
            TemplateHeader templateHeaderObj = new TemplateHeader();
            templateHeaderObj.setHeadingName(templateHeader);
            templateHeaderObj.setCreateDate(LocalDateTime.now());
            templateHeaderObj.setCreateBy(adminUser.getFirstName() + " " + adminUser.getLastName());
            try {
                this.templateHeaderDao.save(templateHeaderObj);
            } catch (Exception e) {
                log.error("Error creating template: {}", e.getMessage());
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }

            sending_status = "Template is created successfully !!";
            log.info("New template with Header : {} is created  by : {}", templateHeader, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());

        } else {

            // Update existing template
            TemplateHeader dataTemplates = this.templateHeaderDao.getReferenceById(Long.parseLong(templateId));
            if (dataTemplates != null) {

                try {

                    dataTemplates.setHeadingName(templateHeader);
                    dataTemplates.setHeadingName(templateHeader);
                    dataTemplates.setCreateDate(LocalDateTime.now());
                    dataTemplates.setCreateBy(adminUser.getFirstName() + " " + adminUser.getLastName());
                    this.templateHeaderDao.save(dataTemplates);
                    sending_status = "Updated successfully !!";
                    log.info("Template with ID: {} is updated by : {}", templateId, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());

                } catch (Exception e) {
                    log.error("Error updating template: {}", e.getMessage());
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
                }

            } else {

                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Unable to find in the system !!");
            }
        }

        // Refresh the template list as it is stored in the global varriable dataTemplateCategory
        dataTemplateCategory.refreshTemplatesList();

        if (sending_status == null || sending_status.isEmpty()) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to update template.");
        }

        return ResponseEntity.ok(sending_status);
    }





    @RequestMapping(value = "manage_template_data", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView ManageDataTemplates(HttpServletRequest request,
                                            @RequestParam(value = "updateTemplateId", required = false) String updateTemplateId,
                                            @RequestParam(value = "addTemplateId", required = false) String addTemplateId,
                                            @RequestParam(value = "delTemplateId", required = false) String delTemplateId) {

        if (request.getSession().getAttribute("ADMIN_SESSION") == null) {
            return renderViewPage("admin-login");
        }
        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");

        // For remove template
        if (!StringUtil.isNullOrEmpty(delTemplateId)) {

            Optional<TemplateData> dataTemplates = templateDataDao.findById(Long.parseLong(delTemplateId));
            templateDataDao.deleteById(Long.parseLong(delTemplateId));
            log.info("Data template with ID: {} is removed by : {}", delTemplateId, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());

            ModelAndView modelView = new ModelAndView("template-data-list");
            modelView.addObject("templateType", dataTemplates.get().getDataCategory());
            modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
            modelView.addObject("templateList", templateDataDao.findByDataCategoryOrderByHeadingNameAsc(dataTemplates.get().getDataCategory()));
            return modelView;
        }


        // For rendering Update template
        if (!StringUtil.isNullOrEmpty(updateTemplateId)) {
            //-- Render the update template page with the existing template data
            ModelAndView modelView = new ModelAndView("update-data-template");
            modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
            modelView.addObject("dataTemplate", templateDataDao.findById(Long.parseLong(updateTemplateId)).orElse(null));
            return modelView;
        }

        // For Add new template
        if (!StringUtil.isNullOrEmpty(addTemplateId)) {
            //-- Render the update template page with the existing template data
            TemplateData dataTemplates = new TemplateData();
            dataTemplates.setDataCategory("");
            ModelAndView modelView = new ModelAndView("update-data-template");
            modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
            modelView.addObject("dataTemplate", dataTemplates);
            return modelView;
        }

        ModelAndView modelView = new ModelAndView("template-data-list");
        modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
        modelView.addObject("templateList", templateDataDao.findByOrderByCreateDateDesc());
        return modelView;
    }



    @PostMapping("update-data-template")
    public ResponseEntity<String> updateTemplate(HttpServletRequest reqObj,@RequestBody Map<String, String> requestData) throws IOException, JAXBException {
        // Get user detail from session
        ClinicUser adminUser = (ClinicUser) reqObj.getSession().getAttribute("ADMIN_SESSION");
        if (adminUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized access.");
        }

        String templateId = requestData.get("templateId");
        String dataCategory = requestData.get("dataCategory");
        String templateHeader = requestData.get("templateHeader");
        String templateContent = requestData.get("templateContent");
        String sending_status = "";


        //----- ADD NEW TEMPLATE DATA
        if (templateId == null || templateId.isEmpty()) {

            TemplateHeader header = templateHeaderDao.findById(Long.valueOf(dataCategory))
                    .orElseThrow(() -> new IllegalArgumentException("Invalid tempHeaderId: " + templateId));

            TemplateData entity = new TemplateData();
            entity.setTemplateHeader(header);                          // mandatory relation
            entity.setDataCategory(dataCategory);             // or header.getHeadingName()
            entity.setHeadingName(templateHeader);     // String field
            entity.setContentDetail(templateContent);
            entity.setCreateDate(LocalDate.now());
            entity.setCreateBy(adminUser.getFullName());
            TemplateData saved = templateDataDao.save(entity);
            sending_status = "Template is created successfully !!";

            log.info("New template with Header: {} created by: {} {} @ {}",saved.getHeadingName(),adminUser.getFirstName(),
            adminUser.getLastName(), new Date());

        } else {
            // UPDATE EXISTING DATA
            TemplateData dataTemplates = templateDataDao.getReferenceById(Long.parseLong(templateId));
            dataTemplates.setId(Long.parseLong(templateId));
            dataTemplates.setDataCategory(dataCategory);
            dataTemplates.setHeadingName(templateHeader);
            dataTemplates.setContentDetail(templateContent);
            templateDataDao.save(dataTemplates);
            sending_status = "Updated successfully !!";
            log.info("Template with ID: {} is updated by : {}", templateId, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());
        }

        if (sending_status == null || sending_status.isEmpty()) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to update template.");
        }

        return ResponseEntity.ok(sending_status);
    }






    //-- This end point will manage the Data Template Add . Remove and Update
    @RequestMapping(value = "search_data_template", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView searchDataTemplates(HttpServletRequest request,
                                            @RequestParam(value = "searchKey", required = false) String searchKey,
                                            @RequestParam(value = "templateType", required = false) String templateType) {

        if (request.getSession().getAttribute("ADMIN_SESSION") == null) {
            return renderViewPage("admin/admin-login");
        }
        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");


        List<TemplateData> templateDataList = new ArrayList<>();

        if (!StringUtil.isNullOrEmpty(searchKey) && !StringUtil.isNullOrEmpty(templateType)) { // by both field
            templateDataList = templateDataDao.findCaseSensitiveByHeadingNameContainingAndDataCategoryOrderByCreateDateDesc(searchKey, templateType);
            //log.info("Search performed with Key : {} and Type : {} by : {}", searchKey, templateType, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());
        } else if (!StringUtil.isNullOrEmpty(searchKey)) { // by search key
            templateDataList = templateDataDao.searchByHeadingNameOrContentDetail(searchKey);
            //log.info("Search performed with Key : {} by : {}", searchKey, adminUser.getFirstName() + " " + adminUser.getLastName());
        } else if (!StringUtil.isNullOrEmpty(templateType)) { // by template type
            templateDataList = templateDataDao.findByDataCategoryOrderByHeadingNameAsc(templateType);
            //log.info("Search performed with Type : {} by : {}", templateType, adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());
        } else {
            templateDataList = templateDataDao.findByOrderByCreateDateDesc();
            //log.info("All templates viewed by : {}", adminUser.getFirstName() + " " + adminUser.getLastName() + " @ " + new Date());
        }

        ModelAndView modelView = new ModelAndView("admin/data-template-list");
        modelView.addObject("templateType", templateType);
        modelView.addObject("templatesSnippet", dataTemplateCategory.templatesList);
        modelView.addObject("templateList", templateDataList);
        return modelView;
    }


}
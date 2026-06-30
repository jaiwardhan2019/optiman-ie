package com.optiman.ie.services.clinic_document;

import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.clinic_document.repository.ClinicDocumentMaster;
import com.optiman.ie.services.clinic_document.srv.ClinicDocumentsService;
import com.optiman.ie.util.ModelViewUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@RestController
public class ClinicDocumentsController extends ModelViewUtil {


    private ClinicDocumentsService clinicDocumentsService;

    public ClinicDocumentsController(ClinicDocumentsService clinicDocumentsService) {
        this.clinicDocumentsService = clinicDocumentsService;
    }

    //--- List all documents , Add Document , Remove document
    @RequestMapping(value = "manage-clinic-documents", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView managePatientDocuments(HttpServletRequest request,
                                               @RequestParam(value = "search", required = false) String searchString,
                                               @RequestParam(value = "cfile", required = false) MultipartFile[] files,
                                               @RequestParam(value = "delDocumentId", required = false) String delDocumentId) throws ParseException {

        ModelAndView mv = securityCheckforAdmin(request);
        if (mv != null) {
            return mv; // 🔥 STOP execution and go to login page
        }

        ClinicUser adminUser = (ClinicUser) request.getSession().getAttribute("ADMIN_SESSION");

        //-- ADD NEW LIST OF XML FILES
        if (files != null) {
            if (files.length > 0) {
                //clinicDocumentSrv.addPatientHl7XmlDocuments(files, adminUser);
            }
        }

        //-- REMOVE DOCUMENT FROM DB AND FILE SYSTEM
        if (delDocumentId != null && !Objects.equals(delDocumentId, "") && !Objects.equals(delDocumentId, "null")) {
            //clinicDocumentSrv.removeClinicDocument(delDocumentId);
        }


        List<ClinicDocumentMaster> documentList = new ArrayList<>();

        //--- IF THE SEARCH BUTTON CLICKED AND SEARCH STRING IS NOT EMPTY
        if (searchString != null && !searchString.isEmpty()) {
            //--- Search for documents by document name
            //documentList = clinicDocumentSrv.searchClinicDocuments(searchString);
        } else {
            //--- IF NO SEARCH STRING, GET ALL DOCUMENTS
           documentList = clinicDocumentsService.getListOfTop15000OrderByCreateDateDesc();
        }

        //-- List document
        ModelAndView modelView = new ModelAndView("clinic-documents-list");
        modelView.addObject("documentList", documentList);
        return modelView;
    }


}

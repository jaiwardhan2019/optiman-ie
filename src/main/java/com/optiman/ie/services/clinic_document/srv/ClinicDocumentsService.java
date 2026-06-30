package com.optiman.ie.services.clinic_document.srv;

import com.optiman.ie.services.clinic_document.repository.ClinicDocumentMaster;
import com.optiman.ie.services.clinic_document.repository.ClinicDocumentMasterDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class ClinicDocumentsService {


    @Autowired
    ClinicDocumentMasterDao clinicDocumentMasterDao;

    private static final String[] DATE_PATTERNS = {"dd/MM/yyyy", "MM/dd/yyyy", "yyyy-MM-dd"};

    public List<ClinicDocumentMaster> getListOfTop15000OrderByCreateDateDesc() {

        return clinicDocumentMasterDao.findTop15000ByOrderByCreateDateDesc();
    }



}

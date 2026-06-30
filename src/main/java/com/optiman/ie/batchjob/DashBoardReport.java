package com.optiman.ie.batchjob;

import com.fasterxml.jackson.databind.ObjectMapper;

import com.optiman.ie.repository.AdminDashBoard;
import com.optiman.ie.repository.AdminDashBoardDao;
import com.optiman.ie.repository.TaskMasterDao;
import com.optiman.ie.services.clinic_document.repository.ClinicDocumentMasterDao;
import com.optiman.ie.services.patientAccount.repository.PatientAccountDao;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
@Slf4j
public class DashBoardReport {


    private PatientAccountDao patientAccountDao;
    private ClinicDocumentMasterDao clinicDocumentMasterDao;
    private TaskMasterDao taskMasterDao;

    private AdminDashBoardDao adminDashBoardDao;

    public DashBoardReport(PatientAccountDao patientAccountDao, ClinicDocumentMasterDao clinicDocumentMasterDao, TaskMasterDao taskMasterDao, AdminDashBoardDao adminDashBoardDao) {
        this.patientAccountDao = patientAccountDao;
        this.clinicDocumentMasterDao = clinicDocumentMasterDao;
        this.taskMasterDao = taskMasterDao;
        this.adminDashBoardDao = adminDashBoardDao;
    }

    @Async
    @Transactional
    public void collectAndUpdateDashBoardReport() {

        log.info("Collecting dashboard report data...");
        long patientCount = patientAccountDao.countAll();
        //long serviceRequestCount = serviceRequestDao.countAll();
        long clinicDocumentCount = clinicDocumentMasterDao.countAll();
        long mytaskCount = taskMasterDao.countAll();
       // long totalBookings = appointmentBookingDao.countBookingsByDay(java.time.LocalDate.now());
        //long totalConsultations = patientConsultationDao.countAll();
        //long patientCheckinCount = patientCheckinQueueDAO.count();

        AdminDashBoard currentData = adminDashBoardDao.findAll().stream().findFirst().orElse(new AdminDashBoard());
        currentData.setPatientCount((int) patientCount);
        currentData.setBookingCount(0);
        currentData.setService_request_count(0);
        currentData.setPatient_document_count((int) clinicDocumentCount);
        currentData.setMytask_count((int) mytaskCount);
        currentData.setPatientConsultationCount(0);
        currentData.setPatientCheckInCount(0);
        currentData.setUpdated_date(java.time.LocalDate.now());
        adminDashBoardDao.save(currentData);

        log.info("Dashboard report data updated to database :  {}",new Date());

    }



    public AdminDashBoard getDashBoardReport() {
        ObjectMapper objectMapper = new ObjectMapper();
        Optional<AdminDashBoard> firstRow = adminDashBoardDao.findAll().stream().findFirst();
        if (firstRow.isPresent()) {
            return firstRow.get();}
        else {
            return null;
        }
    }


}

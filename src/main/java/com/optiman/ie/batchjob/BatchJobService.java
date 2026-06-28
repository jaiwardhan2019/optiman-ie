package com.optiman.ie.batchjob;

import com.optiman.ie.repository.MessageMasterDao;
import jakarta.transaction.Transactional;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Calendar;
import java.util.Date;


@Slf4j
@Component
public class BatchJobService {

    @Autowired
    DashBoardReport dashBoardReport;

    @Autowired
    MessageMasterDao messageMasterDao;


/*

    @Async
    @Scheduled(cron = "0 0 23 * * ?")
    // Runs every day at 11 PM remove png and temp-mc*.pdf files from medical cert folder
    public void RemovePngAndTempFile() {
        Path directory = Paths.get(MEDICAL_CERT_FOLDER_PATH); // Replace with your directory path
        try {
            Files.walkFileTree(directory, new SimpleFileVisitor<Path>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                    String fileName = file.getFileName().toString();
                    // Check if file starts with "temp" or ends with ".png"
                    if (fileName.startsWith("temp") || fileName.endsWith(".png")) {
                        Files.delete(file);
                    }
                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
                    log.error("Error accessing file: " + file + " - " + exc);
                    return FileVisitResult.CONTINUE;
                }
            });

            log.info(".png file and temp-mc*.pdf File cleanup completed successfully @ {}", new Date());

            // TEMP -- this is temporary for JAI TODO
            //patientAccountDao.updateSubscriptionTypeForActiveUsers();


        } catch (IOException e) {
            log.error("Error in method RemovePngAndTempFile method  during file cleanup: {}", e);
        }
    }*/


    /*//**==== TEST OR OTHER REMINDER SERVICE CREATE BY GP / ADMIN ======================================
    @SneakyThrows
    @Transactional
    @Scheduled(cron = "0 0 5 * * ?") // Runs every day at 5 am in the morning send reminder to the patients
    public void SendEmailReminder() {
        LocalDate today = LocalDate.now();
        List<Reminder> reminders = reminderRepo.findBySentStatusFalse();
        for (Reminder reminder : reminders) {
            LocalDateTime reminderDateTime = reminder.getReminderDate();
            if (reminderDateTime != null && reminderDateTime.toLocalDate().equals(today)) {
                try {
                    //-- Trigger email
                    String makeDbTextToHtml = emailService.convertDataBaseMessageToHtml(reminder.getReminderText());
                    makeDbTextToHtml = makeDbTextToHtml.replace("PATIENT", reminder.getForName());
                    makeDbTextToHtml = makeDbTextToHtml + gp4lessEmailSignature;
                    emailService.sendHtmlMessage(reminder.getForEmailId(), "GP4Less Ireland - Reminder alert", makeDbTextToHtml);
                    //-- Update the reminder after sending email
                    reminder.setSentStatus(true);
                    reminderRepo.save(reminder);
                    log.info("Reminder email sent to {} on {}", reminder.getForEmailId(), new Date());
                } catch (Exception e) {
                    log.error("Error in method SendEmailReminder sending reminder email to {}: {}", reminder.getForEmailId(), e.getMessage());
                }
            }
        }
    }
*/


    // -- This service method will collect data from different tables and update the dashboard report table every one hour
    @Scheduled(cron = "0 0 * * * ?")
    public void displayHiThereMessage() {
        dashBoardReport.collectAndUpdateDashBoardReport();
    }


    @SneakyThrows
    @Async
    @Transactional
    @Scheduled(cron = "0 0 3 * * ?")
    // Runs every day at 3 am in the morning remove all those service request which is not paid and older then 3 days
    public void removeSeenMessageAndNotification() {

        log.info("Batch job started to remove seen message over 30 Days old and notification at : " + new Date());
        //**** REMOVE ALL THOSE MESSAGE NOTIFICATION WHICH IS SEEN BY ADMIN
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DAY_OF_YEAR, -30);
        Date cutoffDate = cal.getTime();
        messageMasterDao.deleteOldMessagesORViewStatusTrue(cutoffDate);
        log.info("Batch job completed to remove seen message and notification at : " + new Date());
    }



}


package com.optiman.ie.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public class DateUtil {


    public static boolean isValidTSDate(String value) {
        // Regex: TS[ then 8 digits then ]
        return value != null && value.matches("TS\\[\\d{8}\\]");
    }

    public static String convertTSDate(String tsString) {
        // Extract the date part between the brackets
        String datePart = tsString.replaceAll("TS\\[(\\d{8})\\]", "$1");
        if (datePart.length() != 8) {
            throw new IllegalArgumentException("Invalid date format in input: " + tsString);
        }
        String year = datePart.substring(0, 4);
        String month = datePart.substring(4, 6);
        String day = datePart.substring(6, 8);
        return day + "/" + month + "/" + year;
    }

    public static java.sql.Date parseToSqlDate(String input) throws ParseException {
        if (input == null || input.trim().isEmpty()) return null;

        String[] patterns = {"yyyyMMdd", "dd/MM/yyyy","dd-MM-yyyy","yyyy-MM-dd","yyyy-MM-dd HH:mm:ss.S"};
        ParseException lastException = null;
        for (String pattern : patterns) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                sdf.setLenient(false);
                Date utilDate = sdf.parse(input);
                return new java.sql.Date(utilDate.getTime());
            } catch (ParseException e) {
                lastException = e;
            }
        }
        throw lastException != null ? lastException : new ParseException("Unrecognized date format: " + input, 0);
    }

    public static String convertToDateString(String dateStr){
        DateTimeFormatter FOMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate date = LocalDate.parse(dateStr, FOMATTER);
        DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        return outputFormat.format(date);
    }

    public LocalDate parseToLocalDate(String input) {
        if (input == null || input.trim().isEmpty()) return null;

        String[] patterns = {"yyyyMMdd", "dd/MM/yyyy", "dd-MM-yyyy", "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss.S"};
        DateTimeParseException lastException = null;

        for (String pattern : patterns) {
            try {
                // For patterns with time components, we need to parse as LocalDateTime first
                if (pattern.contains("HH") || pattern.contains("mm") || pattern.contains("ss")) {
                    LocalDateTime dateTime = LocalDateTime.parse(input, DateTimeFormatter.ofPattern(pattern));
                    return dateTime.toLocalDate();
                } else {
                    return LocalDate.parse(input, DateTimeFormatter.ofPattern(pattern));
                }
            } catch (DateTimeParseException e) {
                lastException = e;
            }
        }
        throw lastException != null ? lastException :
                new DateTimeParseException("Unrecognized date format: " + input, input, 0);
    }

    public String convertDateToRenderOnPdf(Date date){
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MM-yyyy");
        return outputFormat.format(date);
    }

    public String getDatePlusOne(Date date){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        Date tomorrow = calendar.getTime();
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MM-yyyy");
        return outputFormat.format(tomorrow);
    }

    public String getFormattedDate(Date date){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, 0);
        Date tomorrow = calendar.getTime();
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MM-yyyy");
        return outputFormat.format(tomorrow);
    }

    public String getCurrentDateAsString() {
        DateTimeFormatter FOMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        return FOMATTER.format(LocalDateTime.now());
    }

    public String getCurrentDateTimeAsString() {
        DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm a");
        return FORMATTER.format(LocalDateTime.now());
    }

    public String getCurrentDateAsStringddMMyyyy() {
        DateTimeFormatter FOMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return FOMATTER.format(LocalDateTime.now());
    }

        public Date getCurrentDateAsDate() throws ParseException {
        DateTimeFormatter FOMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy:HH:mm");
        String currentDate = FOMATTER.format(LocalDateTime.now());
        SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy:HH:mm", Locale.ENGLISH);
        return formatter.parse(currentDate);
    }

    public LocalDate convertDateOfBirthStringToDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }

        List<String> patterns = List.of(
                "yyyy-MM-dd",
                "dd/MM/yyyy",
                "MM/dd/yyyy",
                "yyyyMMdd",
                "yyyy/MM/dd",
                "dd-MM-yyyy"
        );

        for (String pattern : patterns) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
                return LocalDate.parse(dateStr, formatter);
            } catch (Exception ignored) {}
        }

        return null; // No format matched
    }

    public java.sql.Timestamp getCurrentDateTimeForSql() {
        return new java.sql.Timestamp(System.currentTimeMillis());
    }

    /*
        We have GMT but H1 is accepting CET to we need to adjust date time.
        April - Oct  +1
        Nov - March  +0
    */
    public String createUtcDate(int year , int month , int daysOfMonth , int hour ,int minute , int second) {

        // Create a LocalDateTime object representing the desired date and time
        LocalDateTime dateTime = LocalDateTime.of(year, month, daysOfMonth, hour,minute,second);

        // Create an OffsetDateTime object with the desired time zone offset (+02:00 in this case)
        ZoneId irelandZone = ZoneId.of("Europe/Dublin");
        LocalDate dateToCheck = LocalDate.of(year, month, daysOfMonth);
        ZonedDateTime dateTimeToCheck = dateToCheck.atStartOfDay(irelandZone);
        boolean isDSTAtDate = dateTimeToCheck.getZone().getRules().isDaylightSavings(dateTimeToCheck.toInstant());
        int offSetHr = 0;
        if(isDSTAtDate) {
            offSetHr = 1;
        }

        OffsetDateTime offsetDateTime = OffsetDateTime.of(dateTime, ZoneOffset.ofHours(offSetHr));
        // Convert OffsetDateTime to a string in the desired format
        String dateTimeString = offsetDateTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME);

        return dateTimeString;
    }

    /**
     * @param startTimeStr   "11:30:00"
     * @param endTimeStr     "11:40:00"
     * @return                10
     * @throws ParseException
     */
    public int getTimeDurationInMinutes(String startTimeStr , String endTimeStr){

        int timeDifference = 0;
        if(startTimeStr.length() == 8) { //-- This is for Pramod Agrawal   "start_time": "11:00:00", "end_time": "11:10:00",
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
            LocalTime startTime = LocalTime.parse(startTimeStr, timeFormatter);
            LocalTime endTime = LocalTime.parse(endTimeStr, timeFormatter);
            Duration duration = Duration.between(startTime, endTime);
            timeDifference = Math.toIntExact(duration.toMinutes());
        }

        if(startTimeStr.length() > 10){ //-- Dr Laurance    "start_time": "2024-08-19T08:00Z", "end_time": "2024-08-19T08:15Z",
            // Parse the date strings into ZonedDateTime objects
            ZonedDateTime startTime = ZonedDateTime.parse(startTimeStr, DateTimeFormatter.ISO_DATE_TIME);
            ZonedDateTime endTime = ZonedDateTime.parse(endTimeStr, DateTimeFormatter.ISO_DATE_TIME);
            // Calculate the duration between the two times
            Duration duration = Duration.between(startTime, endTime);
            // Get the difference in minutes
            timeDifference = (int)duration.toMinutes();
        }

            return timeDifference;
    }

    private long formatDuration(long duration) {
        long hours = TimeUnit.MILLISECONDS.toHours(duration);
        long minutes = TimeUnit.MILLISECONDS.toMinutes(duration) % 60;
        long seconds = TimeUnit.MILLISECONDS.toSeconds(duration) % 60;
        long milliseconds = duration % 1000;
        return minutes;
    }

    public String coverDateToMsAccess(String dateStr){

            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy");
            Date parsedDate;
            String formattedDate = "";
            try {
                parsedDate = inputFormat.parse(dateStr);
                formattedDate = outputFormat.format(parsedDate);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            return "#"+formattedDate+"#";
        }

    public String coverDateToReadbels(String dateStr){

        SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
        if(!dateStr.contains("/")){ //  example 19910406
            inputFormat = new SimpleDateFormat("yyyyMMdd");
        }

        SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MMM-yyyy");
        Date parsedDate;
        String formattedDate = "";
        try {
            parsedDate = inputFormat.parse(dateStr);
            formattedDate = outputFormat.format(parsedDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return formattedDate;
    }

    public String convertXmlDateStrToDate(String input) {
         String formattedDate = String.format("%02d/%02d/%d %02d:%02d", Integer.parseInt(input.substring(6, 8)),
                 Integer.parseInt(input.substring(4, 6)),
                 Integer.parseInt(input.substring(0, 4)),
                 Integer.parseInt(input.substring(8, 10)),
                 Integer.parseInt(input.substring(10, 12)));
         return formattedDate;
    }

    public String convertXmlDateStrToDateWithTime(String input) {
        String formattedDate = String.format("%02d/%02d/%d %02d:%02d:%02d", Integer.parseInt(input.substring(6, 8)),
                Integer.parseInt(input.substring(4, 6)),
                Integer.parseInt(input.substring(0, 4)),
                Integer.parseInt(input.substring(8, 10)),
                Integer.parseInt(input.substring(10, 12)),
                Integer.parseInt(input.substring(12, 14)));
        return formattedDate;
    }

    public String convertDateToString(String dateStr){
        DateTimeFormatter FOMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate date = LocalDate.parse(dateStr, FOMATTER);
        DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return outputFormat.format(date);
    }

    public String convertBackToBusinessDate(String dateStr){
        DateTimeFormatter FOMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate date = LocalDate.parse(dateStr, FOMATTER);
        DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        return outputFormat.format(date);
    }



}

package com.optiman.ie.services.patientEhr.srv;

import com.optiman.ie.services.patientEhr.model.HealthTrendRecord;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class HealthTrendDataMapper {

    // Optional: build JavaScript string exactly like: var healthTrendData = [...]
    public String toJavaScriptVarAll(List<HealthTrendRecord> records){

        List<Map<String, Object>> healthTrendData = toHealthTrendDataAll(records);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < healthTrendData.size(); i++) {
            Map<String, Object> m = healthTrendData.get(i);
            sb.append("{")
                    .append("\"trendRecordId\":\"").append(m.get("trendRecordId")).append("\",")
                    .append("\"bmi\":").append(m.get("bmi")).append(",")
                    .append("\"systolicBp\":").append(m.get("systolicBp")).append(",")
                    .append("\"diastolicBp\":").append(m.get("diastolicBp")).append(",")
                    .append("\"pulseRate\":").append(m.get("pulseRate")).append(",")
                    .append("\"recordedAt\":").append(m.get("recordedAt"))
                    .append("}");
            if (i < healthTrendData.size() - 1) sb.append(",");
            sb.append("\n");
        }
        sb.append("]");
        //log.info("Generated JavaScript variable for health trend data: {}", sb.toString());
        return sb.toString();
    }
    public String toJavaScriptVarBmi(List<HealthTrendRecord> records){

        List<Map<String, Object>> healthTrendData = toHealthTrendDataBmi(records);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < healthTrendData.size(); i++) {
            Map<String, Object> m = healthTrendData.get(i);
            sb.append("{")
                    .append("\"trendRecordId\":\"").append(m.get("trendRecordId")).append("\",")
                    .append("\"bmi\":").append(m.get("bmi")).append(",")
                    .append("\"recordedAt\":").append(m.get("recordedAt"))
                    .append("}");
            if (i < healthTrendData.size() - 1) sb.append(",");
            sb.append("\n");
        }
        sb.append("]");
        //log.info("Generated JavaScript variable for health trend data: {}", sb.toString());
        return sb.toString();
    }

    public String toJavaScriptVarBp(List<HealthTrendRecord> records){

        List<Map<String, Object>> healthTrendData = toHealthTrendDataBp(records);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < healthTrendData.size(); i++) {
            Map<String, Object> m = healthTrendData.get(i);
            sb.append("{")
                    .append("\"trendRecordId\":\"").append(m.get("trendRecordId")).append("\",")
                    .append("\"systolicBp\":").append(m.get("systolicBp")).append(",")
                    .append("\"diastolicBp\":").append(m.get("diastolicBp")).append(",")
                    .append("\"pulseRate\":").append(m.get("pulseRate")).append(",")
                    .append("\"recordedAt\":").append(m.get("recordedAt"))
                    .append("}");
            if (i < healthTrendData.size() - 1) sb.append(",");
            sb.append("\n");
        }
        sb.append("]");
        //log.info("Generated JavaScript variable for health trend data: {}", sb.toString());
        return sb.toString();
    }



    public  List<Map<String, Object>> toHealthTrendDataAll(List<HealthTrendRecord> records) {
        return records.stream().map(r -> {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("trendRecordId", r.getTrendRecordId());
            // keep 1 decimal like sample (22.1, 24.3, etc.)
            item.put("bmi", r.getBmi() == null ? null : Math.round(r.getBmi() * 10.0) / 10.0);
            item.put("systolicBp", r.getSystolicBp());
            item.put("diastolicBp", r.getDiastolicBp());
            item.put("pulseRate", r.getPulseRate());
            LocalDateTime dt = r.getRecordedAt();
            item.put("recordedAt", dt == null ? null : Arrays.asList(
                    dt.getYear(),
                    dt.getMonthValue(),
                    dt.getDayOfMonth()
            ));

            return item;
        }).collect(Collectors.toList());
    }

    public List<Map<String, Object>> toHealthTrendDataBmi(List<HealthTrendRecord> records) {
        return records.stream()
                .filter(r -> r.getBmi() != null) // Exclude records with null BMI
                .map(r -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("trendRecordId", r.getTrendRecordId());
                    item.put("bmi", Math.round(r.getBmi() * 10.0) / 10.0);
                    LocalDateTime dt = r.getRecordedAt();
                    item.put("recordedAt", dt == null ? null : Arrays.asList(
                            dt.getYear(),
                            dt.getMonthValue(),
                            dt.getDayOfMonth()
                    ));
                    return item;
                })
                .collect(Collectors.toList());
    }

    public List<Map<String, Object>> toHealthTrendDataBp(List<HealthTrendRecord> records) {
        return records.stream()
                .filter(r -> r.getSystolicBp() != null && r.getDiastolicBp() != null && r.getPulseRate() != null)
                .map(r -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("trendRecordId", r.getTrendRecordId());
                    item.put("systolicBp", r.getSystolicBp());
                    item.put("diastolicBp", r.getDiastolicBp());
                    item.put("pulseRate", r.getPulseRate());
                    LocalDateTime dt = r.getRecordedAt();
                    item.put("recordedAt", dt == null ? null : Arrays.asList(
                            dt.getYear(),
                            dt.getMonthValue(),
                            dt.getDayOfMonth()
                    ));
                    return item;
                })
                .collect(Collectors.toList());
        }
    }
package com.optiman.ie.constant;

import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.TreeMap;

@Service
public class TestTypeSnippet {

    private final String BLOOD_TEST = "Dear PATIENT\n\n" +
            "\nThis is a reminder from Optiman Medical Center, regarding your recent lab results.\n" +
            "\nDuring your last visit, we discussed that a follow-up blood test is necessary to monitor your [e.g., cholesterol levels, thyroid function, iron levels]. It is important that this test is completed by [Date] to ensure we have the most current information for your care.\n" +
            "\nPlease schedule your blood test at your earliest convenience. \n" +
            "\nIf you have already completed this test, please disregard this message.\n" +
            "\nThank you for your attention to this important matter.\n" +
            "\nPlese refer this link to book the appointment with us. https://www.optiman.ie/book-an-appointment\n";
    private final String COVID_TEST = "Covid Test";
    private final String URINE_TEST = "Urine Test";
    private final String SWAB_TEST = "Covid Test";
    private final String ALERGY_TEST = "Alergy Test";

    public final Map<String, String> getTestTypeList() {
        Map<String, String> testTypeList = new TreeMap<>();
        testTypeList.put("", " -- Select-- ");
        testTypeList.put(BLOOD_TEST, "Blood Test");
        testTypeList.put(COVID_TEST, "Covid Test");
        testTypeList.put(URINE_TEST, "Urine Test");
        testTypeList.put(SWAB_TEST, "Swab Test");
        testTypeList.put(ALERGY_TEST, "Allergy Test");
        return testTypeList;
    }

}
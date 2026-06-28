package com.optiman.ie.contant;

import java.util.Collections;
import java.util.Map;
import java.util.TreeMap;

public class DocumentCategoryStatus {

    public static final Map<String, String> DOC_TYPE_MAP;
    public static final Map<String, String> CLINIC_DOC_STATUS_MAP;

    static {
        Map<String, String> map = new TreeMap<>();
        for (GlobalConst.DocumentType type : GlobalConst.DocumentType.values()) {
            map.put(type.getDisplayName(), type.getDisplayName());
        }
        DOC_TYPE_MAP = Collections.unmodifiableMap(map);
    }

    static {
        Map<String, String> map = new TreeMap<>();
        for (GlobalConst.ClinicDocumentStatus type : GlobalConst.ClinicDocumentStatus.values()) {
            map.put(type.getDisplayName(), type.getDisplayName());
        }
        CLINIC_DOC_STATUS_MAP = Collections.unmodifiableMap(map);
    }

}
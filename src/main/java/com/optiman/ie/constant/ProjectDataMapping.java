package com.optiman.ie.constant;

import java.io.File;

public final class ProjectDataMapping {

        public static final String DATA_FOLDER;

        static {

            DATA_FOLDER = System.getProperty("user.dir") + File.separator + "appDataFolder";

            /*
                        String os = System.getProperty("os.name").toLowerCase();
                        if (os.contains("win")) {
                            DATA_FOLDER = "C:\\optiman_ie_app_data";
                        } else {
                            DATA_FOLDER = "/optiman_ie_app_data";
                        }
            */
        }

        private ProjectDataMapping() {}

}

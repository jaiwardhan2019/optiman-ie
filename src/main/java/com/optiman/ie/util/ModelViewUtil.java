package com.optiman.ie.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;



@Slf4j
public class ModelViewUtil {


    //--- Render View Page ----------
    public ModelAndView renderViewPage(String viewPageName) {
        ModelAndView modelView = new ModelAndView(viewPageName);
        return modelView;
    }



    public ModelAndView renderViewPage(String viewPageName, String stringStatus, String statusValue) {
        ModelAndView modelView = new ModelAndView(viewPageName);
        modelView.addObject(stringStatus, statusValue);
        return modelView;
    }




    public <T> ModelAndView renderViewPage(String viewPageName, String objectName, List<T> objectListObj) {
        ModelAndView modelView = new ModelAndView(viewPageName);
        modelView.addObject(objectName, objectListObj);
        return modelView;
    }

    public <T> ModelAndView renderViewPage(String viewPageName, String objectName, Object objectListObj) {
        ModelAndView modelView = new ModelAndView(viewPageName);
        modelView.addObject(objectName, objectListObj);
        return modelView;
    }



    public ModelAndView renderViewPage(String viewPageName, String objectName,  Map<String,String> objectValue) {
        ModelAndView modelView = new ModelAndView(viewPageName);
        modelView.addObject(objectName, objectValue);
        return modelView;
    }


    public void storePreviousEndPOintInSession(HttpServletRequest request,String endPoint) {
        // Get the session
        HttpSession session = request.getSession();
        // Store the URL in the session
        session.setAttribute("previousEndPoint", endPoint);
    }


}

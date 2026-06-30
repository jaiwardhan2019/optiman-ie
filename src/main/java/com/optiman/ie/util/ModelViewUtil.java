package com.optiman.ie.util;

import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

import static com.optiman.ie.constant.GlobalConst.ADMIN_SESSION;
import static com.optiman.ie.constant.GlobalConst.USER_VALIDATED;


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


    public ModelAndView securityCheckforAdmin(HttpServletRequest reqObj) {

        HttpSession session = reqObj.getSession(false);
        if (session == null) {return new ModelAndView("admin-login");}

        session.setAttribute("previousAdminEndPoint",reqObj.getRequestURL().toString());
        ClinicUser adminUser = (ClinicUser) session.getAttribute(ADMIN_SESSION);

        if (adminUser == null || !USER_VALIDATED.equalsIgnoreCase(adminUser.getLogonStatus())) {
            session.invalidate();
            return new ModelAndView("admin-login");
        }

        return null;
    }



}

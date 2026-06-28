package com.optiman.ie.services.clinicUserAccount;


import com.optiman.ie.batchjob.DashBoardReport;
import com.optiman.ie.services.clinicUserAccount.repository.ClinicUser;
import com.optiman.ie.services.clinicUserAccount.srv.ClinicUserSrv;
import com.optiman.ie.util.ModelViewUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.text.ParseException;

import static com.optiman.ie.contant.GlobalConst.*;


@Slf4j
@RestController
public class userAccountController extends ModelViewUtil {

    private ClinicUserSrv clinicUserSrv;

    private DashBoardReport dashBoardReport;


    public userAccountController(ClinicUserSrv clinicUserSrv, DashBoardReport dashBoardReport) {
        this.clinicUserSrv = clinicUserSrv;
        this.dashBoardReport = dashBoardReport;
    }



    //----- Validate Admin Login page
    @PostMapping("validate-admin")
    public ModelAndView validateAdmin(HttpServletRequest reqObj, HttpServletResponse response) throws ParseException, IOException {

        String viewPageName = "admin-login";

        //1-- This part wil execute when cal comes from admin-login.jsp with the user id & password
        if (reqObj.getParameter("username") != null) {
            ClinicUser aminUser = clinicUserSrv.validateUserLoginDetail(reqObj.getParameter("username").trim(), reqObj.getParameter("password").trim());
            if (aminUser != null) {

                if (aminUser.getLogonStatus().equalsIgnoreCase(USER_LOGIN_PASSWORD_VALIDATED)) {
                    //-- All good then update session

                    aminUser.setLogonStatus(USER_VALIDATED);
                    reqObj.getSession().setAttribute(ADMIN_SESSION, aminUser);

                    if (reqObj.getSession().getAttribute("previousAdminEndPoint") != null) {
                        viewPageName = reqObj.getSession().getAttribute("previousAdminEndPoint").toString();
                        response.sendRedirect(viewPageName);
                    }

                    viewPageName = "admin-home";
                    ModelAndView modelAndView = new ModelAndView(viewPageName);
                    modelAndView.addObject("AdminDashBoard",dashBoardReport.getDashBoardReport());
                    return modelAndView;

                } else {
                    return renderViewPage(viewPageName, "loginStatus", "Login | Passowrd seems not correct !!");
                }
            } else {
                return renderViewPage(viewPageName, "loginStatus", "Login | Passowrd seems not correct !!");
            }

        }// End of if

        return renderViewPage(viewPageName);
    }




}

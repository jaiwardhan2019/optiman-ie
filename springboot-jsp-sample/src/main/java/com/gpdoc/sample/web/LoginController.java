package com.gpdoc.sample.web;

import com.gpdoc.sample.user.UserValidationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    private final UserValidationService userValidationService;

    public LoginController(UserValidationService userValidationService) {
        this.userValidationService = userValidationService;
    }

    @GetMapping({"/", "/login"})
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model) {
        boolean valid = userValidationService.validateUser(username, password);
        model.addAttribute("username", username);
        model.addAttribute("isValid", valid);
        return "login-result";
    }
}

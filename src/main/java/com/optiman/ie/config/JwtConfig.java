package com.optiman.ie.config;

import io.jsonwebtoken.security.Keys;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.security.Key;

@Configuration
public class JwtConfig {

    @Bean
    public Key secretKey() {
        String secret = "optiman-secret-key-123456789012345";
        return Keys.hmacShaKeyFor(secret.getBytes());
    }
}
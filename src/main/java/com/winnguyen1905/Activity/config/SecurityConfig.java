package com.winnguyen1905.activity.config;

import java.util.Arrays;

import org.springframework.boot.autoconfigure.web.ErrorProperties;
import org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import jakarta.servlet.Filter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

  public static final String[] whiteList = {
      "/auth/register", "/auth/login", "/v1/auth/login", "/v1/auth/refresh", // Auth
      "/storage/**", // Source
      "/v1/products/**" // Product
  };

  // @Override
  // public void addCorsMappings(CorsRegistry registry) {
  // registry.addMapping("/**")
  // .allowedOrigins("*") // Allow all origins for testing
  // .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
  // .allowedHeaders("Authorization", "Content-Type")
  // .allowCredentials(false) // Must be false with "*"
  // .maxAge(3600);
  // }

  @Bean
  PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http, AuthenticationManager authenticationManager)
      throws Exception {
    return http
        .cors(AbstractHttpConfigurer::disable)
        .csrf(AbstractHttpConfigurer::disable)
        .formLogin(form -> form.disable())
        .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(auth -> auth.requestMatchers(whiteList).permitAll()
            .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll() // Allow preflight requests
            // .requestMatchers(HttpMethod.GET, "/chima/**").hasRole("STUDENT")
            // .requestMatchers(HttpMethod.POST, "/auth/register/**").permitAll()
            // .requestMatchers(HttpMethod.POST, "/auth/login/**").permitAll()
            // .requestMatchers(HttpMethod.GET, "/authentication-docs/**").permitAll()
            .anyRequest().authenticated())
        .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
        // .authenticationManager(authenticationManager)
        .build();
  }

  // @Bean
  // public FilterRegistrationBean<Filter> corsFilter() {
  //   CorsConfiguration configuration = new CorsConfiguration();
  //   configuration.setAllowedOrigins(Arrays.asList("https://localhost:3000",
  //       "https://localhost:4173", "*"));
  //   configuration.setAllowedMethods(Arrays.asList("GET", "POST", "DELETE", "PUT",
  //       "PATCH", "OPTIONS"));
  //   configuration.setAllowCredentials(true);
  //   configuration.addAllowedHeader("*");
  //   configuration
  //       .setAllowedHeaders(Arrays.asList("Content-Type", "Authorization", "Accept",
  //           "x-no-retry", "x-api-key"));
  //   configuration.setMaxAge(3600L);

  //   UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
  //   source.registerCorsConfiguration("/**", configuration);

  //   FilterRegistrationBean<Filter> bean = new FilterRegistrationBean<>();
  //   bean.setFilter(new CorsFilter(source));
  //   bean.setOrder(Ordered.HIGHEST_PRECEDENCE);
  //   return bean;
  // }
}

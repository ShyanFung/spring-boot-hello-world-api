package com.metronaviation.harmony;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.authentication.www.BasicAuthenticationEntryPoint;
import org.springframework.stereotype.Component;

@Configuration
@EnableWebSecurity
public class SpringSecurityConfig extends WebSecurityConfigurerAdapter {

	/* IMPORTANT: Demo only, setup basic auth from users.properties file in-memory. */
	@Value("${app.basic.auth.user.properites:classpath:users.properties}")
	private Resource userDetailsPropertiesResource = null;

	@Autowired
	private BasicAuthenticationPoint basicAuthenticationPoint; 

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		
		///////////////////////////////////////////////////////////////////////
		// Basic Authentication.
		// http://www.resilientdatasystems.co.uk/spring/fast-stateless-api-authentication-spring-security/
		///////////////////////////////////////////////////////////////////////
		http.sessionManagement()
			.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
		
		///////////////////////////////////////////////////////////////////////
		// https://blog.napagoda.com/2017/10/secure-spring-boot-rest-api-using-basic.html
		///////////////////////////////////////////////////////////////////////
		http.authorizeRequests()
			//TODO add basic auth for API role to /callback/from/** path. 
			.antMatchers("/", "/actuator/health").permitAll()
	        .anyRequest().authenticated()
	        .and().httpBasic()
			.authenticationEntryPoint(basicAuthenticationPoint);
		
		///////////////////////////////////////////////////////////////////////
		// Filter chains.
		// http://www.baeldung.com/spring-security-custom-filter
		///////////////////////////////////////////////////////////////////////
		// TODO add rate limit filter, etc.
		
		///////////////////////////////////////////////////////////////////////
		// Disable CSRF so requests can POST.
		// https://stackoverflow.com/questions/38004035/could-not-verify-the-provided-csrf-token-because-your-session-was-not-found-in-s
		///////////////////////////////////////////////////////////////////////
		http.csrf().disable();
	}

	/* NOTE: Testing and demo user details only. */
	@Bean
	public UserDetailsService userDetailsService() {
		UserDetailsService rtn = new InMemoryUserDetailsManager();
		if (userDetailsPropertiesResource != null) {
			Properties users = new Properties();
			try {
				users.load(userDetailsPropertiesResource.getInputStream());
			} catch (IOException e) {
				throw new IllegalArgumentException(e);
			}
			rtn = new InMemoryUserDetailsManager(users);
		}
		return rtn;
	}

	// Once a user agent is authenticated using BASIC authentication, logout requires that the
	// browser be closed or an unauthorized (401) header be sent.
	@Component
	public static class BasicAuthenticationPoint extends BasicAuthenticationEntryPoint {
		@Override
		public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authEx)
				throws IOException, ServletException {
			response.addHeader("WWW-Authenticate", "Basic realm=" + getRealmName());
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			PrintWriter writer = response.getWriter();
			writer.println("HTTP Status 401 - " + authEx.getMessage());
		}
		@Override
		public void afterPropertiesSet() throws Exception {
			setRealmName("DEMOAPI");
			super.afterPropertiesSet();
		}
	}

}

package com.metronaviation.harmony;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {

	@Bean
	public Docket api() {
		return new Docket(DocumentationType.SWAGGER_2)
				.groupName("Metron Harmony API")
				.select()
				.apis(RequestHandlerSelectors.basePackage("com.metronaviation.harmony"))
				.paths(PathSelectors.any())
				.build();
	}

	/** Configure swagger2 via SpringFox. */
	@Bean
	public Docket swaggerSettingsForSpringActuator() {
		return new Docket(DocumentationType.SWAGGER_2)
				.groupName("Spring Actuator")
				.select()
				.apis(RequestHandlerSelectors.basePackage("org.springframework.boot.actuate"))
				.paths(PathSelectors.any())
				.build();
	}

}

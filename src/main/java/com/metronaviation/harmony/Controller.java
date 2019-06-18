package com.metronaviation.harmony;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.annotations.ApiOperation;

@RestController
public class Controller {

	private static final Logger logger = LoggerFactory.getLogger(Controller.class);

	@ApiOperation(value = "Echo an XML message.", response = String.class)
	@RequestMapping(value = "/echo", method = RequestMethod.POST)
	public String echo(@RequestBody String msg) {
		
		logger.info("API hello world service: {}", msg);
		
		return "Echo: " + msg;
	}

}

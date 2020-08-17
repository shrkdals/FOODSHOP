package com.ensys.sample.controllers;

import java.util.HashMap;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.OrderEndding.OrderEnddingService;

@Controller
@RequestMapping(value = "/api/OrderEndding")
public class OrderEnddingController extends BaseController {

	@Inject
	private OrderEnddingService service;

	@RequestMapping(value = "search", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse search(@RequestBody HashMap<String, Object> param) {
		return Responses.ListResponse.of(service.search(param));
	}

	@RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public ApiResponse save(@RequestBody HashMap<String, Object> param) {
		service.save(param);
		return ok();
	}

}

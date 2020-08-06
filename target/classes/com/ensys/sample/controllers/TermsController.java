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
import com.ensys.sample.domain.Terms.TermsService;

@Controller
@RequestMapping(value = "/api/Terms")
public class TermsController extends BaseController {

	@Inject
	private TermsService service;

	@RequestMapping(value = "select", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse selectH(@RequestBody HashMap<String, Object> param) {
		return Responses.ListResponse.of(service.select(param));
	}

	@RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public ApiResponse pdf(@RequestBody HashMap<String, Object> param) {
		service.save(param);
		return ok();
	}

}

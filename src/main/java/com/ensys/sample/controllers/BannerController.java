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
import com.ensys.sample.domain.Banner.BannerService;

@Controller
@RequestMapping(value = "/api/banner")
public class BannerController extends BaseController {

	@Inject
	private BannerService service;

	@RequestMapping(value = "search", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse search(@RequestBody HashMap<String, Object> param) {
		return Responses.ListResponse.of(service.search(param));
	}

	@RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public ApiResponse save(@RequestBody HashMap<String, Object> param) {
		try {
			service.save(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ok();
	}

}

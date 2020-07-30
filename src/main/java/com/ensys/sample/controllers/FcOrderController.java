package com.ensys.sample.controllers;

import java.util.HashMap;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.FcOrder.FcOrderService;

@Controller
@RequestMapping(value = "/api/FcOrder")
public class FcOrderController extends BaseController { // 프렌차이즈(가맹점) 주문현황

	@Inject
	private FcOrderService service;

	@RequestMapping(value = "selectH", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse selectH(@RequestBody HashMap<String, Object> param) {
		return Responses.ListResponse.of(service.selectH(param));
	}

	@RequestMapping(value = "selectD", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse selectD(@RequestBody HashMap<String, Object> param) {
		return Responses.ListResponse.of(service.selectD(param));
	}
}

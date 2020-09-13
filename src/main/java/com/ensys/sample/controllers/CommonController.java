package com.ensys.sample.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.common.common;
import com.ensys.sample.domain.common.commonService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Controller
@RequestMapping(value = "/api/v1/common")
public class CommonController extends BaseController {

	@Inject
	private commonService commonService;

	@RequestMapping(value = "getCodeList", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse getCodeList(common requestParams) {
		List<Map<String, String>> list = commonService.getCodeList(requestParams);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "getAuthSeq", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse getAuthSeq() {
		List<Map<String, String>> list = commonService.getAuthSeq();
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "getMenuList", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse getMenuList() {

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list.add(commonService.selectMenu());
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_CHECK_SEARCH", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_CHECK_SEARCH(@RequestBody HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("CD_COMPANY", user.getCdCompany());
		List<HashMap<String, Object>> list = commonService.HELP_CHECK_SEARCH(param);
		return Responses.ListResponse.of(list);
	}

}

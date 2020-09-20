package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.CommonHelp.CommonHelpService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.*;

@Controller
@RequestMapping(value = "/api/commonHelp")
public class CommonHelpController extends BaseController {

	/*********************************************************************/
	/*
	 * /* 공통도움창 Controller 규칙 /* 대문자만을 사용합니다. /* 만약 이름이 2가지 단어와 혼합되어 있다면, 언더바를
	 * 넣어줍니다. /* /* /
	 *********************************************************************/

	@Inject
	private CommonHelpService service;

	@RequestMapping(value = "HELP_GROUP_USER", method = RequestMethod.POST, produces = APPLICATION_JSON) // 상품도움창
	public Responses.ListResponse HELP_GROUP_USER(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_GROUP_USER(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_USER_NOTICE", method = RequestMethod.POST, produces = APPLICATION_JSON) // 상품도움창
	public Responses.ListResponse HELP_USER_NOTICE(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("PT_SP", param.get("PT_SP"));
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_USER_NOTICE(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BRAND_ITEM", method = RequestMethod.POST, produces = APPLICATION_JSON) // 상품도움창
	public Responses.ListResponse HELP_BRAND_ITEM(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("PT_CD", param.get("PT_CD"));
		param.put("ITEM_SP", param.get("ITEM_SP"));
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_BRAND_ITEM(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BRAND_PARTNER", method = RequestMethod.POST, produces = APPLICATION_JSON) // 브랜드거래처도움창
	public Responses.ListResponse HELP_BRAND_PARTNER(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("PT_SP", param.get("PT_SP"));
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_BRAND_PARTNER(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_DISTRIP_PARTNER", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_DISTRIP_PARTNER(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		param.put("LOGIN_ID", sessionUser.getIdUser());
		List<HashMap<String, Object>> list = service.HELP_DISTRIP_PARTNER(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PARTNER", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_PARTNER(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_PARTNER(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PARTNER3", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_PARTNER3(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_PARTNER3(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PARTNER_CONTRACT", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_PARTNER_CONTRACT(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_PARTNER_CONTRACT(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_AREA", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_AREA(@RequestBody Map<String, Object> param) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_AREA(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_AREA2", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_AREA2(@RequestBody Map<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_AREA2(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ITEM", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_ITEM(@RequestBody Map<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_ITEM(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ITEM_CATEGORY", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_ITEM_CATEGORY(@RequestBody Map<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_ITEM_CATEGORY(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ACCT", method = RequestMethod.POST, produces = APPLICATION_JSON) // 계정도움창
	public Responses.ListResponse HELP_ACCT(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		parameterMap.put("TP_DRCR", requestParams.get("TP_DRCR"));
		parameterMap.put("BAN", requestParams.get("BAN"));
		List<HashMap<String, Object>> list = service.HELP_ACCT(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_CARD", method = RequestMethod.POST, produces = APPLICATION_JSON) // 신용카드도움창
	public Responses.ListResponse HELP_CARD(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_CARD(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BIZAREA", method = RequestMethod.POST, produces = APPLICATION_JSON) // 사업장도움창
	public Responses.ListResponse HELP_BIZAREA(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_BIZAREA(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ETAX_EMP", method = RequestMethod.POST, produces = APPLICATION_JSON) // 발행자도움창
	public Responses.ListResponse HELP_ETAX_EMP(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_ETAX_EMP(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BANK", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse bankHelp(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_BANK(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_DISBDOC", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse disbDocList(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_DISBDOC(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BUDGET", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse budgetHelp(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		parameterMap.put("CD_DEPT", requestParams.get("CD_DEPT"));
		List<HashMap<String, Object>> list = service.HELP_BUDGET(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_CC", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse ccHelp(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_CC(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_DEPT", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_DEPT(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("ID_USER", sessionUser.getIdUser());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		parameterMap.put("ALL", requestParams.get("P_ALL"));
		List<HashMap<String, Object>> list = service.HELP_DEPT(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ALL_DEPT", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_ALL_DEPT(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_ALL_DEPT(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_APPROVEBU", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_APPROVEBU(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_APPROVEBU(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_APPROVEFI", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_APPROVEFI(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_APPROVEFI(parameterMap);
		return Responses.ListResponse.of(list);
	}

	// 사원사번
	@RequestMapping(value = "HELP_EMP", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_EMP(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));

		if (requestParams.get("P_CD_DEPT") != null) {
			parameterMap.put("CD_DEPT", requestParams.get("P_CD_DEPT"));
			list = service.HELP_MULTI_EMP(parameterMap);
		} else if (requestParams.get("CD_DEPT") != null) {
			parameterMap.put("CD_DEPT", requestParams.get("CD_DEPT"));
			list = service.HELP_MULTI_EMP(parameterMap);
		} else {
			list = service.HELP_EMP(parameterMap);
		}

		return Responses.ListResponse.of(list);
	}

	// 사원사번 멀티
	@RequestMapping(value = "HELP_MULTI_EMP", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_MULTI_USER(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		if (requestParams.get("CD_DEPT") == null) {
			parameterMap.put("CD_DEPT", requestParams.get("P_CD_DEPT"));
		} else {
			parameterMap.put("CD_DEPT", requestParams.get("CD_DEPT"));
		}
		List<HashMap<String, Object>> list = service.HELP_MULTI_EMP(parameterMap);
		return Responses.ListResponse.of(list);
	}

	// 사원아이디
	@RequestMapping(value = "HELP_USER", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_USER(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_USER(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_USER2", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_USER2(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_GROUP", sessionUser.getCdGroup());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		parameterMap.put("LOGIN_ID", sessionUser.getIdUser());
		List<HashMap<String, Object>> list = service.HELP_USER2(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PROG", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse progList(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_PROG(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_AUTHGROUP", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_AUTHGROUP(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		parameterMap.put("GROUP_GB", requestParams.get("P_GROUP_GB"));
		List<HashMap<String, Object>> list = service.HELP_AUTHGROUP(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_DEPOSIT", method = RequestMethod.POST, produces = APPLICATION_JSON) // 예적금계좌 도움창
	public Responses.ListResponse HELP_DEPOSIT(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_PC", sessionUser.getCdPc());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_DEPOSIT(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PC", method = RequestMethod.POST, produces = APPLICATION_JSON) // 예적금계좌 도움창
	public Responses.ListResponse HELP_PC(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_PC(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_CODEDTL", method = RequestMethod.POST, produces = APPLICATION_JSON) // 예적금계좌 도움창
	public Responses.ListResponse HELP_CODEDTL(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_FIELD", requestParams.get("P_CD_FIELD"));
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_CODEDTL(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ANTICIPATION", method = RequestMethod.POST, produces = APPLICATION_JSON) // 환종 도움창
	public Responses.ListResponse HELP_ANTICIPATION(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_FIELD", "MA_B000005");
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_CODEDTL(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_VAT_SALES", method = RequestMethod.POST, produces = APPLICATION_JSON)
	// MA_B000040 : 세무구분 부가세 매출
	public Responses.ListResponse HELP_VAT_SALES(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_FIELD", "MA_B000040");
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_CODEDTL(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_VAT_PURCHASE", method = RequestMethod.POST, produces = APPLICATION_JSON)
	// MA_B000040 : 부가세 매입
	public Responses.ListResponse HELP_VAT_PURCHASE(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_FIELD", "MA_B000046");
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_CODEDTL(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BIZCAR", method = RequestMethod.POST, produces = APPLICATION_JSON) // 도움창
	public Responses.ListResponse HELP_BIZCAR(@RequestBody Map<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("CD_COMPANY", sessionUser.getCdCompany());
		param.put("CD_PC", sessionUser.getCdPc());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_BIZCAR(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_ASSET_PROCGB", method = RequestMethod.POST, produces = APPLICATION_JSON)
	// 자산처리구분 도움창
	public Responses.ListResponse HELP_ASSET_PROCGB(@RequestBody Map<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("CD_COMPANY", sessionUser.getCdCompany());
		param.put("KEYWORD", param.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_ASSET_PROCGB(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PARTNER_DEPOSIT", method = RequestMethod.POST, produces = APPLICATION_JSON) // 거래처도움창
	public Responses.ListResponse HELP_PARTNER_DEPOSIT(@RequestBody Map<String, Object> requestParams) {
		HashMap<String, Object> parameterMap = new HashMap<String, Object>();

		SessionUser sessionUser = SessionUtils.getCurrentUser();

		parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
		parameterMap.put("CD_PARTNER", requestParams.get("CD_PARTNER"));
		parameterMap.put("KEYWORD", requestParams.get("P_KEYWORD"));
		List<HashMap<String, Object>> list = service.HELP_PARTNER_DEPOSIT(parameterMap);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_BUDGET_REPORT", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_BUDGET_REPORT(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("CD_COMPANY", sessionUser.getCdCompany());
		List<HashMap<String, Object>> list = service.HELP_BUDGET_REPORT(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "COMMON_PRC", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse COMMON_PRC(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("LOGIN_ID", sessionUser.getIdUser());
		param.put("LOGIN_GROUP", sessionUser.getCdGroup());
		List<HashMap<String, Object>> list = service.COMMON_PRC(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_CATE_COMMITION", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_CATE_COMMITION(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", sessionUser.getCdCompany());
		param.put("LOGIN_ID", sessionUser.getIdUser());
		param.put("LOGIN_GROUP", sessionUser.getCdGroup());
		List<HashMap<String, Object>> list = service.HELP_CATE_COMMITION(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_CATEGORY", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_CATEGORY(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", sessionUser.getCdCompany());
		List<HashMap<String, Object>> list = service.HELP_CATEGORY(param);
		return Responses.ListResponse.of(list);
	}

	@RequestMapping(value = "HELP_PARTNER_CATEGORY", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_PARTNER_CATEGORY(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", sessionUser.getCdCompany());
		List<HashMap<String, Object>> list = service.HELP_PARTNER_CATEGORY(param);
		return Responses.ListResponse.of(list);
	}
	
	@RequestMapping(value = "HELP_PARTNER_AREA", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public Responses.ListResponse HELP_PARTNER_AREA(@RequestBody HashMap<String, Object> param) {
		SessionUser sessionUser = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", sessionUser.getCdCompany());
		List<HashMap<String, Object>> list = service.HELP_PARTNER_AREA(param);
		return Responses.ListResponse.of(list);
	}
	

}

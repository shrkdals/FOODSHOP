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
import com.ensys.sample.utils.SMSComponent;
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
	
	@RequestMapping(value = "SendMessage", method = RequestMethod.POST, produces = APPLICATION_JSON)
		public Responses.MapResponse SendMessage(@RequestBody HashMap<String, Object> param) {
			HashMap<String, Object> result = new HashMap<String, Object>();
			List<String> strTelList = (List<String>) param.get("strTelList");
			String[] strDestList = null;
			if (strTelList != null && strTelList.size() > 0) {
				strDestList = strTelList.toArray(new String[strTelList.size()]);
			}
			
			String strCallBack = "15220896";							//	보낸번호
			String strSubject = (String) param.get("SUBJECT");			//	제목
			String strDate = (String) param.get("DATE");				//	
			String strData = (String) param.get("CONTENT");				//	내용
			int nCount = strDestList.length;
			
			String strMsg = "";
			SMSComponent smsc = null;
			try {
				smsc = new SMSComponent();
	
				try {
					smsc.connect();
				} catch (Exception e) {
					strMsg = "SMS Server 연결에 실패했습니다.";
				} // catch
	
				try {
					strMsg = smsc.SendMsg(strDestList, strCallBack, strSubject, strDate, strData, nCount);
					strMsg = "문자 발송을 완료했습니다.\n" + strMsg;
					strMsg = strMsg.replaceAll("\n", "<br>");
				} catch (IOException e) {
					strMsg = "발송할 수 없습니다." + e;
				}
				smsc.disconnect();
			} catch (Exception e) {
				e.printStackTrace();
			}
			result.put("MSG", strMsg);
			return Responses.MapResponse.of(result);
		}

}

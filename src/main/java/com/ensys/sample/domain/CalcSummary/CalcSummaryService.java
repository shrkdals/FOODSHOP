package com.ensys.sample.domain.CalcSummary;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class CalcSummaryService {

	@Inject
	private CalcSummaryMapper mapper;

	public List<HashMap<String, Object>> selectH(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		param.put("GROUP_CD", user.getCdGroup());
		return mapper.selectH(param);
	}

	public List<HashMap<String, Object>> selectPop(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		return mapper.selectPop(param);
	}

	@Transactional
	public void approve(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("list");
		for (HashMap<String, Object> item: items) {
			item.put("COMPANY_CD", user.getCdCompany());
			item.put("LOGIN_ID", user.getIdUser());
			mapper.approve(item);
		}
		
		
		
	}
	
	@Transactional
	public void FundTransfer(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("list");
		for (HashMap<String, Object> item: items) {
			item.put("COMPANY_CD", user.getCdCompany());
			item.put("LOGIN_ID", user.getIdUser());
			mapper.FundTransfer(item);
		}
	}
	
	

}

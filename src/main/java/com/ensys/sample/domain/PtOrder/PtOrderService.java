package com.ensys.sample.domain.PtOrder;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class PtOrderService extends BaseService {

	@Inject
	private PtOrderMapper mapper;

	public List<HashMap<String, Object>> selectH(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		return mapper.selectH(param);
	}

	public List<HashMap<String, Object>> selectD(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		return mapper.selectD(param);
	}

}
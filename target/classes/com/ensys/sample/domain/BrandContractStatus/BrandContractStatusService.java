package com.ensys.sample.domain.BrandContractStatus;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class BrandContractStatusService extends BaseService {

	@Inject
	private BrandContractStatusMapper mapper;

	public List<HashMap<String, Object>> select(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		return mapper.select(param);
	}

	public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		return mapper.selectDtl(param);
	}

}

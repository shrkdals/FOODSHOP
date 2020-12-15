package com.ensys.sample.domain.BrdHeadPayStatus;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class BrdHeadPayStatusService extends BaseService {

	@Inject
	private BrdHeadPayStatusMapper mapper;

	public List<HashMap<String, Object>> select(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", user.getCdCompany());

		return mapper.select(param);
	}

	public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();

		param.put("COMPANY_CD", user.getCdCompany());

		return mapper.selectDtl(param);
	}

}

package com.ensys.sample.domain.Terms;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class TermsService extends BaseService {

	@Inject
	private TermsMapper TermsMapper;

	public List<HashMap<String, Object>> select(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());

		return TermsMapper.select(param);
	}

	@Transactional
	public void save(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		TermsMapper.save(param);
	}

}

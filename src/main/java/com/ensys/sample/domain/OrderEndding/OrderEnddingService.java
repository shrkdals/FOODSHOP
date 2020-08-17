package com.ensys.sample.domain.OrderEndding;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class OrderEnddingService extends BaseService {

	@Inject
	private OrderEnddingMapper mapper;

	public List<HashMap<String, Object>> search(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());

		return mapper.search(param);
	}

	@Transactional
	public void save(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		ArrayList<HashMap<String, Object>> items = (ArrayList<HashMap<String, Object>>) param.get("saveData");
		for (HashMap<String, Object> item : items) {
			item.put("COMPANY_CD", user.getCdCompany());
			item.put("USER_ID", user.getIdUser());
			mapper.save(item);
		}
	}

}

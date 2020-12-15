package com.ensys.sample.domain.Order;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class OrderService extends BaseService {

	@Inject
	private OrderMapper mapper;

	public List<HashMap<String, Object>> selectH(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		param.put("GROUP_CD", user.getCdGroup());
		return mapper.selectH(param);
	}

	public List<HashMap<String, Object>> selectD(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		param.put("LOGIN_ID", user.getIdUser());
		return mapper.selectD(param);
	}

	@Transactional
	public void success(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		ArrayList<HashMap<String, Object>> items = (ArrayList<HashMap<String, Object>>) param.get("list");
		for (HashMap<String, Object> item : items) {
			item.put("COMPANY_CD", user.getCdCompany());
			item.put("LOGIN_ID", user.getIdUser());
			if (param.get("TYPE").toString().equals("1")) {
				mapper.success(item);
			} else {
				mapper.success2(item);
			}
		}
		if (items != null && items.size() > 0) {
			items.get(0).put("COMPANY_CD", user.getCdCompany());
			items.get(0).put("ORDER_SEQ", param.get("ORDER_SEQ_ARR"));
			if(param.get("PAGE_NAME") != null && param.get("PAGE_NAME").toString().equals("FS_PT_ORDER_M")){
				mapper.adjust2(items.get(0));
			}else{
				mapper.adjust(items.get(0));
			}

		}

	}

	@Transactional
	public void success3(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		ArrayList<HashMap<String, Object>> items = (ArrayList<HashMap<String, Object>>) param.get("list");
		for (HashMap<String, Object> item : items) {
			item.put("COMPANY_CD", user.getCdCompany());
			item.put("LOGIN_ID", user.getIdUser());

			String ORDER_SEQ_ARR = "";
			List<HashMap<String, Object>> adjustData = mapper.success3(item);
			
			if (adjustData != null && adjustData.size() > 0) {
				
				for (int i = 0; i < adjustData.size(); i++) {
					ORDER_SEQ_ARR += adjustData.get(i).get("ORDER_SEQ");
					if (i != adjustData.size() - 1) {
						ORDER_SEQ_ARR += "|";
					}
				}
				System.out.println("ORDER_SEQ_ARR : "+ ORDER_SEQ_ARR);
				HashMap<String, Object> adjustDataMap = new HashMap<String, Object>();
				adjustDataMap.put("ORDER_SEQ", ORDER_SEQ_ARR);
				adjustDataMap.put("JOIN_PT_CD", item.get("JOIN_PT_CD"));
				adjustDataMap.put("ORDER_CD", item.get("ORDER_CD"));
				adjustDataMap.put("COMPANY_CD", user.getCdCompany());
				mapper.adjust(adjustDataMap);
			}
		}
	}

	public List<HashMap<String, Object>> excel(HashMap<String, Object> param) {
		if (param.get("TYPE").equals("01")) {
			return mapper.excel1(param);
		} else {
			return mapper.excel2(param);
		}
	}

	public List<HashMap<String, Object>> pdf(HashMap<String, Object> param) {
		if (param.get("TYPE").equals("01")) {
			return mapper.pdf1(param);
		} else {
			return mapper.pdf2(param);
		}
	}

	@Transactional
	public void orderCancel(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		ArrayList<HashMap<String, Object>> items = (ArrayList<HashMap<String, Object>>) param.get("list");
		for (HashMap<String, Object> item : items) {
			item.put("COMPANY_CD", user.getCdCompany());
			mapper.orderCancel(item);
		}
	}

    public void DEL_DT_SAVE(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		ArrayList<HashMap<String, Object>> items = (ArrayList<HashMap<String, Object>>) param.get("list");
		for (HashMap<String, Object> item : items) {
			item.put("COMPANY_CD", user.getCdCompany());
			mapper.DEL_DT_SAVE(item);
		}
    }

	public void REMARK_SAVE(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		mapper.REMARK_SAVE(param);
	}
}

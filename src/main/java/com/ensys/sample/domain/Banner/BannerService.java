package com.ensys.sample.domain.Banner;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;

@Service
public class BannerService extends BaseService {

	@Inject
	private BannerMapper mapper;

	@Inject
	private fileService fileservice;

	public List<HashMap<String, Object>> search(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		return mapper.search(param);
	}
	
	public List<HashMap<String, Object>> searchDtl(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		return mapper.searchDtl(param);
	}

	@Transactional
	public void save(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();

		List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("saveData");
		List<HashMap<String, Object>> saveDataD = (List<HashMap<String, Object>>) param.get("saveDataD");
		
		if (items != null && items.size() > 0) { // 마스터
			for (HashMap<String, Object> item : items) {
				item.put("COMPANY_CD", user.getCdCompany());
				item.put("USER_ID", user.getIdUser());
				if (item.get("__deleted__") != null) {
					if ((boolean) item.get("__deleted__")) {
						mapper.delete(item);
					}
				} else if (item.get("__created__") != null) {
					if ((boolean) item.get("__created__")) {
						mapper.insert(item);

						if (item.get("FILE") != null) {
							HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
							fileservice.insertFsFile(file);
						}
					}
				} else if (item.get("__modified__") != null && item.get("__created__") == null) {
					if ((boolean) item.get("__modified__")) {
						mapper.update(item);

						if (item.get("FILE") != null) {
							HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
							fileservice.insertFsFile(file);
						}
					}
				}
			}
		}
		
		if (saveDataD != null && saveDataD.size() > 0) { // 마스터
			for (HashMap<String, Object> item : saveDataD) {
				item.put("COMPANY_CD", user.getCdCompany());
				item.put("USER_ID", user.getIdUser());
				if (item.get("__deleted__") != null) {
					if ((boolean) item.get("__deleted__")) {
						mapper.deleteDtl(item);
					}
				} else if (item.get("__created__") != null) {
					if ((boolean) item.get("__created__")) {
						mapper.insertDtl(item);

						if (item.get("FILE") != null) {
							HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
							fileservice.insertFsFile(file);
						}
					}
				} else if (item.get("__modified__") != null && item.get("__created__") == null) {
					if ((boolean) item.get("__modified__")) {
						mapper.updateDtl(item);

						if (item.get("FILE") != null) {
							HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
							fileservice.insertFsFile(file);
						}
					}
				}
			}
		}
	}

}

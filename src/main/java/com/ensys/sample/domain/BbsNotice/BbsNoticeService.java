package com.ensys.sample.domain.BbsNotice;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class BbsNoticeService extends BaseService {

	@Inject
	private BbsNoticeMapper BbsNoticeMapper;

	
	@Inject
    private fileService fileservice;

	public List<HashMap<String, Object>> select(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		return BbsNoticeMapper.select(param);
	}
	public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("COMPANY_CD", user.getCdCompany());
		return BbsNoticeMapper.selectDtl(param);
	}
	

	@Transactional
	public void save(HashMap<String, Object> param) throws Exception {
		SessionUser user = SessionUtils.getCurrentUser();

		List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("saveData");

		if (items != null && items.size() > 0) { 
			for (HashMap<String, Object> item : items) {
				item.put("COMPANY_CD", user.getCdCompany());
				item.put("ID_USER", user.getIdUser());
				if (item.get("__deleted__") != null) {
					if ((boolean) item.get("__deleted__")) {
						BbsNoticeMapper.deleteWrite(item);
					}
				} else if (item.get("__created__") != null) {
					if ((boolean) item.get("__created__")) {
						BbsNoticeMapper.write(item);
						
						if (item.get("FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
                            fileservice.insertFsFile(file);
                        }
					}
				} else if (item.get("__modified__") != null && item.get("__created__") == null) {
					if ((boolean) item.get("__modified__")) {
						BbsNoticeMapper.updateWrite(item);
						
						if (item.get("FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
                            fileservice.insertFsFile(file);
                        }
					}
				}
			}
		}
	}
	
	@Transactional
	public void saveNotice(HashMap<String, Object> param) throws Exception {
		SessionUser user = SessionUtils.getCurrentUser();
		List<HashMap<String, Object>> users = (List<HashMap<String, Object>>) param.get("USER_ID");
		
		if (users != null && users.size() > 0) {
			for (HashMap<String, Object> item : users) {
				
				item.put("COMPANY_CD", user.getCdCompany());
				item.put("LOGIN_ID", user.getIdUser());
				item.put("BOARD_TYPE", param.get("BOARD_TYPE"));
				item.put("BOARD_SP", param.get("BOARD_SP"));
				item.put("SEQ", param.get("SEQ"));
				
				
				BbsNoticeMapper.saveNotice(item);
			}
			
		}
		
	}
	
	

	/*
	 * public List<HashMap<String, Object>> selectList(HashMap<String, Object>
	 * param) { return BbsNoticeMapper.selectList(param); }
	 * 
	 * public List<HashMap<String, Object>> selectDetail(HashMap<String, Object>
	 * param) { return BbsNoticeMapper.selectDetail(param); }
	 * 
	 * 
	 * @Transactional public HashMap<String, Object> write(HashMap<String, Object>
	 * request) { HashMap<String, Object> bbsData = (HashMap<String, Object>)
	 * request.get("bbsData"); HashMap<String, Object> fileData = (HashMap<String,
	 * Object>) request.get("fileData");
	 * 
	 * String SEQ = ""; SessionUser user = SessionUtils.getCurrentUser();
	 * HashMap<String, Object> result = new HashMap<String, Object>();
	 * 
	 * HashMap<String, Object> parameterMap = new HashMap<String, Object>();
	 * parameterMap.put("CD_COMPANY", user.getCdCompany()); parameterMap.put("SEQ",
	 * bbsData.get("P_SEQ")); parameterMap.put("BOARD_TYPE",
	 * bbsData.get("P_BOARD_TYPE")); parameterMap.put("TITLE",
	 * bbsData.get("P_TITLE")); parameterMap.put("CONTENTS",
	 * bbsData.get("P_CONTENTS")); parameterMap.put("ID_INSERT", user.getIdUser());
	 * parameterMap.put("ID_UPDATE", user.getIdUser());
	 * 
	 * if (parameterMap.get("SEQ") != null && !"".equals(parameterMap.get("SEQ"))) {
	 * result = BbsNoticeMapper.updateWrite(parameterMap); result.put("chkVal",
	 * "N");
	 * 
	 * if (result.get("SEQ") instanceof Integer) { int seq = (int)
	 * result.get("SEQ"); SEQ = String.valueOf(seq); } else { SEQ = (String)
	 * result.get("SEQ"); } } else { result = BbsNoticeMapper.write(parameterMap);
	 * result.put("chkVal", "N");
	 * 
	 * if (result.get("SEQ") instanceof Integer) { int seq = (int)
	 * result.get("SEQ"); SEQ = String.valueOf(seq); } else { SEQ = (String)
	 * result.get("SEQ"); } } if (fileData != null) {
	 * fileService.BbsFileModify((String) bbsData.get("P_BOARD_TYPE"), SEQ,
	 * fileData); } return result; }
	 * 
	 * @Transactional public HashMap<String, Object> deleteWrite(HashMap<String,
	 * Object> request) { SessionUser user = SessionUtils.getCurrentUser();
	 * 
	 * List<String> deleteFile = new ArrayList<String>(); HashMap<String, Object>
	 * result = new HashMap<String, Object>();
	 * 
	 * HashMap<String, Object> parameterMap = new HashMap<String, Object>();
	 * 
	 * parameterMap.put("CD_COMPANY", user.getCdCompany()); parameterMap.put("SEQ",
	 * request.get("P_SEQ")); parameterMap.put("BOARD_TYPE",
	 * request.get("P_BOARD_TYPE"));
	 * 
	 * List<HashMap<String, Object>> deleteList =
	 * BbsNoticeMapper.deleteWrite(parameterMap);
	 * 
	 * 
	 * fileService.deleteFile((String) request.get("P_BOARD_TYPE"), deleteList);
	 * 
	 * result.put("chkVal", "N"); return result; }
	 */
}
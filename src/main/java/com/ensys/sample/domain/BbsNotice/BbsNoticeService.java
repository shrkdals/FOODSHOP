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
    private fileService fileService;


    public List<HashMap<String, Object>> selectList(HashMap<String, Object> param) {
        return BbsNoticeMapper.selectList(param);
    }

    public List<HashMap<String, Object>> selectDetail(HashMap<String, Object> param) {
        return BbsNoticeMapper.selectDetail(param);
    }


    @Transactional
    public HashMap<String, Object> write(HashMap<String, Object> request) {
        HashMap<String, Object> bbsData = (HashMap<String, Object>) request.get("bbsData");
        HashMap<String, Object> fileData = (HashMap<String, Object>) request.get("fileData");

        String SEQ = "";
        SessionUser user = SessionUtils.getCurrentUser();
        HashMap<String, Object> result = new HashMap<String, Object>();

        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("SEQ", bbsData.get("P_SEQ"));
        parameterMap.put("BOARD_TYPE", bbsData.get("P_BOARD_TYPE"));
        parameterMap.put("TITLE", bbsData.get("P_TITLE"));
        parameterMap.put("CONTENTS", bbsData.get("P_CONTENTS"));
        parameterMap.put("ID_INSERT", user.getIdUser());
        parameterMap.put("ID_UPDATE", user.getIdUser());

        if (parameterMap.get("SEQ") != null && !"".equals(parameterMap.get("SEQ"))) {
            result = BbsNoticeMapper.updateWrite(parameterMap);
            result.put("chkVal", "N");

            if (result.get("SEQ") instanceof Integer) {
                int seq = (int) result.get("SEQ");
                SEQ = String.valueOf(seq);
            } else {
                SEQ = (String) result.get("SEQ");
            }
        } else {
            result = BbsNoticeMapper.write(parameterMap);
            result.put("chkVal", "N");

            if (result.get("SEQ") instanceof Integer) {
                int seq = (int) result.get("SEQ");
                SEQ = String.valueOf(seq);
            } else {
                SEQ = (String) result.get("SEQ");
            }
        }
        if (fileData != null) {
            fileService.BbsFileModify((String) bbsData.get("P_BOARD_TYPE"), SEQ, fileData);
        }
        return result;
    }

    @Transactional
    public HashMap<String, Object> deleteWrite(HashMap<String, Object> request) {
        SessionUser user = SessionUtils.getCurrentUser();

        List<String> deleteFile = new ArrayList<String>();
        HashMap<String, Object> result = new HashMap<String, Object>();

        HashMap<String, Object> parameterMap = new HashMap<String, Object>();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("SEQ", request.get("P_SEQ"));
        parameterMap.put("BOARD_TYPE", request.get("P_BOARD_TYPE"));

        List<HashMap<String, Object>> deleteList = BbsNoticeMapper.deleteWrite(parameterMap);


        fileService.deleteFile((String) request.get("P_BOARD_TYPE"), deleteList);

        result.put("chkVal", "N");
        return result;
    }
}
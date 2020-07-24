package com.ensys.sample.domain.schedule;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.CommonUtility.CommonUtilityService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Service
public class scheduleService extends BaseService {

    @Inject
    private scheduleMapper scheduleMapper;

    @Inject
    private fileService fileService;

    public List<HashMap<String, Object>> selectList(HashMap<String, Object> param) {
        return scheduleMapper.selectList(param);
    }

    public List<HashMap<String, Object>> selectDetail(HashMap<String, Object> param) {
        return scheduleMapper.selectDetail(param);
    }


    @Transactional
    public HashMap<String, Object> write(HashMap<String, Object> request) {

        HashMap<String, Object> scheduleData = (HashMap<String, Object>) request.get("scheduleData");
        HashMap<String, Object> fileData = (HashMap<String, Object>) request.get("fileData");

        SessionUser user = SessionUtils.getCurrentUser();
        String SEQ = "";
        String BOARD_TYPE = "schedule";
        HashMap<String, Object> result = new HashMap<String, Object>();

        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("BOARD_TYPE", BOARD_TYPE);
        parameterMap.put("SEQ", scheduleData.get("P_SEQ"));
        parameterMap.put("TYPE", scheduleData.get("P_TYPE"));    //  1:전체공개, 2:부서공개, 3:비공개(나만공개)
        parameterMap.put("TITLE", scheduleData.get("P_TITLE"));
        parameterMap.put("CONTENTS", scheduleData.get("P_CONTENTS"));
        parameterMap.put("ID_INSERT", user.getIdUser());
        parameterMap.put("ID_UPDATE", user.getIdUser());
        parameterMap.put("SCHEDULE", scheduleData.get("P_SCHEDULE"));

        if (parameterMap.get("SEQ") != null && !"".equals(parameterMap.get("SEQ"))) {
            result = scheduleMapper.updateWrite(parameterMap);
            result.put("chkVal", "N");
            if (result.get("SEQ") instanceof Integer) {
                int seq = (int) result.get("SEQ");
                SEQ = String.valueOf(seq);
            } else {
                SEQ = (String) result.get("SEQ");
            }
        } else {
            result = scheduleMapper.write(parameterMap);
            result.put("chkVal", "N");
            if (result.get("SEQ") instanceof Integer) {
                int seq = (int) result.get("SEQ");
                SEQ = String.valueOf(seq);
            } else {
                SEQ = (String) result.get("SEQ");
            }
        }
        if (fileData != null) {
            fileService.BbsFileModify(BOARD_TYPE, SEQ, fileData);
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
        parameterMap.put("ID", user.getIdUser());
        parameterMap.put("BOARD_TYPE", request.get("P_BOARD_TYPE"));

        List<HashMap<String, Object>> deleteList = scheduleMapper.deleteWrite(parameterMap);

        fileService.deleteFile("schedule", deleteList);

        result.put("chkVal", "N");
        return result;
    }

}

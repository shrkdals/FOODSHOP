package com.ensys.sample.domain.Mapartnerm;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Service
public class MapartnermService extends BaseService {

    @Inject
    private MapartnermMapper mapper;

    public List<HashMap<String, Object>> select(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        return mapper.select(param);
    }
    public List<HashMap<String, Object>> select2(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        return mapper.select2(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) throws Exception {
        SessionUser user = SessionUtils.getCurrentUser();
        // #### 거래처 마스터 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.delete(item);
            mapper.deleteCONT(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert(item);
            mapper.insertCONT(item);
        }
        // #### 거래처 마스터 ####

        // #### 거래처 연결 수수료 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete2")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.delete2(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert2")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert2(item);
        }
        // #### 거래처 연결 수수료 ####




    }

    public List<HashMap<String, Object>> getPartnerCommitionList(HashMap<String, Object> param) {
       return mapper.getPartnerCommitionList(param);
    }

    @Transactional
    public void SAVE_USERMAPPING(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        // #### 사용자별 거래처 마스터 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.SAVE_USERMAPPING_D(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.SAVE_USERMAPPING_I(item);
        }
        // #### 사용자별 거래처 마스터 ####
    }

    public List<HashMap<String, Object>> SAVE_USERMAPPING_S(HashMap<String, Object> param) {
        return mapper.SAVE_USERMAPPING_S(param);
    }

    public List<HashMap<String, Object>> SAVE_USERMAPPING_H_S(HashMap<String, Object> param) {
        return mapper.SAVE_USERMAPPING_H_S(param);
    }

    @Transactional
    public void saveAll2(HashMap<String, Object> param) {


        SessionUser user = SessionUtils.getCurrentUser();
        // #### 거래처 마스터 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.delete(item);
            mapper.deleteCONT(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert(item);
            mapper.insertCONT(item);
        }
        // #### 거래처 마스터 ####

        // #### 거래처 연결 수수료 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete2")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.delete2(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert2")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert2(item);
        }
        // #### 거래처 연결 수수료 ####

        // #### 거래처 등록하면에서 거래처사용자 매핑 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete3")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.MEMBER_JOIN_D(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert3")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.MEMBER_JOIN_I(item);
        }
        // #### 거래처 등록하면에서 거래처사용자 매핑 ####
    }
}



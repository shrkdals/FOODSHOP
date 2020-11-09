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
    
    @Inject
    private fileService fileservice;

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
    public List<HashMap<String, Object>> select4(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        return mapper.select4(param);
    }

    public List<HashMap<String, Object>> selectGrid2(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        return mapper.selectGrid2(param);
    }
    

    //거래처 계약관리
    @Transactional
    public void saveAll(HashMap<String, Object> param) throws Exception {
        SessionUser user = SessionUtils.getCurrentUser();
        // #### 거래처 마스터 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
//            mapper.delete(item);
            mapper.deleteCONT(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert(item);
            mapper.insertCONT(item);
        }
        // #### 거래처 마스터 ####

        /*
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

        */
        // #### 거래처 브랜드 계약 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            if(item.get("TAB_GRID2_OBJ") != null){
                mapper.grid2Obj_delete(item);
                for(HashMap<String, Object> obj : (List<HashMap<String, Object>>)item.get("TAB_GRID2_OBJ")){
                    obj.put("COMPANY_CD",user.getCdCompany());
                    obj.put("USER_ID",user.getIdUser());
                    /*List<HashMap<String, Object>> chk = mapper.selectGrid2(param);
                    if(chk.size() > 1){
                        new RuntimeException("중복된 계약이 존재합니다.");
                    }*/
                    mapper.grid2Obj_insert(obj);
                }
            }
        }


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

    //거래처 등록관리
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
            if (item.get("FILE") != null){
                HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
                fileservice.insertFsFile(file);
            }
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
            if(item.get("__created__") != null){
                mapper.MEMBER_JOIN_I(item);
            }else{
                mapper.MEMBER_JOIN_U(item);
            }

        }
        // #### 거래처 등록하면에서 거래처사용자 매핑 ####
        
        // #### 거래처 등록화면에서 카테고리 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete4")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.delete4(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert4")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert4(item);
        }
        // #### 거래처 등록화면에서 카테고리 ####

        // #### 거래처 브랜드 계약 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            if(item.get("TAB_GRID2_OBJ") != null){
                mapper.grid2Obj_delete(item);
                for(HashMap<String, Object> obj : (List<HashMap<String, Object>>)item.get("TAB_GRID2_OBJ")){
                    obj.put("COMPANY_CD",user.getCdCompany());
                    obj.put("USER_ID",user.getIdUser());
                    /*List<HashMap<String, Object>> chk = mapper.selectGrid2(param);
                    if(chk.size() > 1){
                        new RuntimeException("중복된 계약이 존재합니다.");
                    }*/
                    mapper.grid2Obj_insert(obj);
                }
            }
        }
        // ### 거래처 브랜드 계약 ####


    }

    public List<HashMap<String, Object>> checkBlock(HashMap<String, Object> param) {
        return mapper.checkBlock(param);
    }
}



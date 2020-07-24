package com.ensys.sample.domain.Area;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class AreaService extends BaseService {

    @Inject
    private AreaMapper mapper;

    public List<HashMap<String, Object>> select1(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.select1(param);
    }

    public List<HashMap<String, Object>> select2(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.select2(param);
    }

    public List<HashMap<String, Object>> select3(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.select3(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) throws Exception {
        SessionUser user = SessionUtils.getCurrentUser();

        // #### 관할구역 마스터 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete1")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            item.put("CRUD_TYPE",'D');
            mapper.FS_AREA_M_CRUD(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert1")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            item.put("CRUD_TYPE",'I');
            mapper.FS_AREA_M_CRUD(item);
        }
        // #### 관할구역 마스터 ####

        // #### 관할구역 상세 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete2")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            item.put("CRUD_TYPE",'D');
            mapper.FS_AREA_D_CRUD(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert2")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            item.put("CRUD_TYPE",'I');
            mapper.FS_AREA_D_CRUD(item);
        }
        // #### 관할구역 상세 ####

        // #### 관할구역 영업담당 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete3")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            item.put("CRUD_TYPE",'D');
            mapper.FS_AREA_SALES_PERSON_CRUD(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert3")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            item.put("CRUD_TYPE",'I');
            mapper.FS_AREA_SALES_PERSON_CRUD(item);
        }
        // #### 관할구역 영업담당 ####


    }

}



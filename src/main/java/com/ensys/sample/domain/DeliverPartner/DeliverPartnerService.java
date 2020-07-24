package com.ensys.sample.domain.DeliverPartner;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class DeliverPartnerService extends BaseService {

    @Inject
    private DeliverPartnerMapper mapper;

    public List<HashMap<String, Object>> selectH(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.selectH(param);
    }

    public List<HashMap<String, Object>> selectD(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.selectD(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        // #### 마스터 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("deleteM")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.deleteM(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insertM")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.insertM(item);
        }
        // #### 마스터 ####

        // #### 디테일 ####
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("deleteD")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.deleteD(item);
        }
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insertD")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.insertD(item);
        }
        // #### 디테일 ####
    }
}



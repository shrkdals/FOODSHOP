package com.ensys.sample.domain.BrandContract;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class BrandContractService extends BaseService {

    @Inject
    private BrandContractMapper mapper;

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
    
    public List<HashMap<String, Object>> selectD2(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.selectD2(param);
    }

    public List<HashMap<String, Object>> S_1(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        param.put("GROUP_CD",user.getCdGroup());
        return mapper.S_1(param);
    }

    public List<HashMap<String, Object>> S_2(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        param.put("GROUP_CD",user.getCdGroup());
        return mapper.S_2(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();

        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("list")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.save(item);
        }
    }

    public List<HashMap<String, Object>> S_3(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        param.put("GROUP_CD",user.getCdGroup());
        return mapper.S_3(param);
    }

    @Transactional
    public void contract_cancel(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("list")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.contract_cancel(item);
        }
    }
}



package com.ensys.sample.domain.Commition;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class CommitionService extends BaseService {

    @Inject
    private CommitionMapper mapper;

    public List<HashMap<String, Object>> getCommitionHList(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD", sessionUser.getCdCompany());
        return mapper.getCommitionHList(param);
    }
    public List<HashMap<String, Object>> getCommitionDList(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD", sessionUser.getCdCompany());
        return mapper.getCommitionDList(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();

        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("listH")){
            item.put("COMPANY_CD", sessionUser.getCdCompany());
            item.put("USER_ID", sessionUser.getIdUser());
            if(item.get("__deleted__") != null){
                if(item.get("__deleted__").toString() == "true"){
                    mapper.deleteH(item);
                }
            }else if(item.get("__created__") != null) {
                if(item.get("__created__").toString() == "true"){
                    mapper.insertH(item);
                }
            }else if(item.get("__modified__") != null) {
                if(item.get("__modified__").toString() == "true" ){
                    mapper.insertH(item);
                }
            }
        }

        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("listD")){
            item.put("COMPANY_CD", sessionUser.getCdCompany());
            item.put("USER_ID", sessionUser.getIdUser());
            if(item.get("__deleted__") != null){
                if(item.get("__deleted__").toString() == "true"){
                    mapper.deleteD(item);
                }
            }else if(item.get("__created__") != null) {
                if(item.get("__created__").toString() == "true"){
                    mapper.insertD(item);
                }
            }else if(item.get("__modified__") != null) {
                if(item.get("__modified__").toString() == "true" ){
                    mapper.insertD(item);
                }
            }
        }

    }
}
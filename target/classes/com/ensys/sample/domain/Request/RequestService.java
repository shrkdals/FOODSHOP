package com.ensys.sample.domain.Request;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class RequestService extends BaseService {

    @Inject
    private RequestMapper mapper;

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

    public void update(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();

        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("update")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            mapper.update(item);
        }

    }

}



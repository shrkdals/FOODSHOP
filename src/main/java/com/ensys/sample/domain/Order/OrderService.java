package com.ensys.sample.domain.Order;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Service
public class OrderService extends BaseService {

    @Inject
    private OrderMapper mapper;

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


    public void success(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(HashMap<String, Object> item : (ArrayList<HashMap<String, Object>>)param.get("list") ){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("LOGIN_ID",user.getIdUser());
            if(param.get("TYPE").toString().equals("1")){
                mapper.success(item);
            }else{
                mapper.success2(item);
            }

        }
    }

    public List<HashMap<String, Object>> excel(HashMap<String, Object> param) {
        if(param.get("TYPE").equals("01")){
            return mapper.excel1(param);
        }else{
            return mapper.excel2(param);
        }
    }
}



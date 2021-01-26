package com.ensys.sample.domain.KakaoCert;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

@Service
public class KakaoFsService extends BaseService {

    @Autowired
    private KakaoFsMapper mapper;


    public void saveReceiptID(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String toDay = sdf.format(date);

        param.put("COMPANY_CD", user.getCdCompany());
        param.put("INSERT_DTS", toDay);

        mapper.saveReceiptID(param);
        mapper.contractUpdate(param);

    }

    public void stateUpdate(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String toDay = sdf.format(date);

        param.put("COMPANY_CD", user.getCdCompany());
        param.put("INSERT_DTS", toDay);
        mapper.stateUpdate(param);
    }

    public void signDataUpdate(HashMap<String, Object> item) {
        SessionUser user = SessionUtils.getCurrentUser();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String toDay = sdf.format(date);

        item.put("COMPANY_CD", user.getCdCompany());
        item.put("INSERT_DTS", toDay);
        mapper.signDataUpdate(item);
    }
}

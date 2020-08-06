package com.ensys.sample.domain.Sysusermenu;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.h2.engine.Session;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class SysusermenuService extends BaseService {

    @Inject
    private SysusermenuMapper authMapper;


    public List<HashMap<String, Object>> selectMst() {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();
        parameterMap.put("CD_COMPANY", user.getCdCompany());
        return authMapper.selectMst(parameterMap);
    }

    public List<HashMap<String, Object>> select(HashMap<String, Object> auth) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();

        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("CD_GROUP", auth.get("P_CD_GROUP"));

        return authMapper.select(parameterMap);
    }

    public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> auth) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("CD_GROUP", auth.get("P_CD_GROUP"));
        parameterMap.put("ID_USER", auth.get("P_ID_USER"));

        return authMapper.selectDtl(parameterMap);
    }


    @Transactional
    public void saveAuth(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("gridData");


        if (items != null && items.size() > 0) {

            items.get(0).put("CD_COMPANY", user.getCdCompany());
            authMapper.authDdelete(items.get(0));

            for (HashMap<String, Object> item : items) {

                item.put("CD_COMPANY", user.getCdCompany());
                authMapper.authDinsert(item);
            }
        }


    }


}
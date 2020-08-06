package com.ensys.sample.domain.Sysmenu;

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
public class SysmenuService extends BaseService {

    @Inject
    private SysmenuMapper newMemuMapper;


    public List<HashMap<String, Object>> menuSelect(HashMap<String, Object> menu) {
        return newMemuMapper.menuSelect(menu);
    }


    @Transactional
    public void saveMenu(HashMap<String, Object> menu) {
        SessionUser user = SessionUtils.getCurrentUser();

        List<HashMap<String, Object>> menuH = (List<HashMap<String, Object>>) menu.get("listM");
        List<HashMap<String, Object>> menuD = (List<HashMap<String, Object>>) menu.get("listD");

        for (HashMap<String, Object> data : menuH) {
            if (data != null && data.size() > 0) {
                if (data.get("__deleted__") != null) {
                    if ((boolean) data.get("__deleted__")) {
                        data.put("CD_COMPANY", user.getCdCompany());
                        newMemuMapper.menuDelete(data);
                    }
                } else if (data.get("__created__") != null) {
                    if ((boolean) data.get("__created__")) {
                        data.put("CD_COMPANY", user.getCdCompany());
                        newMemuMapper.menuInsert(data);
                    }
                } else if (data.get("__modified__") != null && data.get("__created__") == null) {
                    if ((boolean) data.get("__modified__")) {
                        data.put("CD_COMPANY", user.getCdCompany());
                        newMemuMapper.menuUpdate(data);
                    }
                }
            }
        }

        for (HashMap<String, Object> data : menuD) {

            if (data != null && data.size() > 0) {
                if (data.get("__deleted__") != null) {
                    if ((boolean) data.get("__deleted__")) {
                        data.put("CD_COMPANY", user.getCdCompany());
                        newMemuMapper.menuDelete(data);
                    }
                } else if (data.get("__created__") != null) {
                    if ((boolean) data.get("__created__")) {
                        data.put("CD_COMPANY", user.getCdCompany());
                        newMemuMapper.menuInsert(data);
                    }
                } else if (data.get("__modified__") != null && data.get("__created__") == null) {
                    if ((boolean) data.get("__modified__")) {
                        data.put("CD_COMPANY", user.getCdCompany());
                        newMemuMapper.menuUpdate(data);
                    }
                }
            }
        }
    }

    public HashMap<String, Object> chkMenuId(HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("cdCompany", user.getCdCompany());
        result = newMemuMapper.chkMenuId(param);
        return result;
    }

}
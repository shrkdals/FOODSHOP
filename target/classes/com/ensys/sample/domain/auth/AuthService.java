package com.ensys.sample.domain.auth;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class AuthService extends BaseService {

    @Inject
    private com.ensys.sample.domain.auth.authMapper authMapper;


    public List<HashMap<String, Object>> authMselect(HashMap<String, Object> auth) {
        SessionUser user = SessionUtils.getCurrentUser();
        auth.put("CD_COMPANY", user.getCdCompany());
        return authMapper.authMselect(auth);
    }

    public List<HashMap<String, Object>> authDselect(HashMap<String, Object> auth) {
        SessionUser user = SessionUtils.getCurrentUser();
        auth.put("CD_COMPANY", user.getCdCompany());
        return authMapper.authDselect(auth);
    }


    @Transactional
    public void saveAuth(HashMap<String, Object> param) {

        List<HashMap<String, Object>> M_items = (List<HashMap<String, Object>>) param.get("listM");
        List<HashMap<String, Object>> D_items = (List<HashMap<String, Object>>) param.get("listD");
        SessionUser user = SessionUtils.getCurrentUser();

        if (D_items != null && D_items.size() > 0) {

            D_items.get(0).put("CD_COMPANY", user.getCdCompany());
            authMapper.authDdelete(D_items.get(0));

            for (HashMap<String, Object> item : D_items) {
                item.put("CD_COMPANY", user.getCdCompany());
                authMapper.authDinsert(item);
            }

            authMapper.AUTHD_UPDATE(D_items.get(0));
        }



        if (M_items != null && M_items.size() > 0) {
            for (HashMap<String, Object> item : M_items) {
                item.put("CD_COMPANY", user.getCdCompany());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        authMapper.authMdelete(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        authMapper.authMinsert(item);
                    }
                }

            }

        }
    }
}
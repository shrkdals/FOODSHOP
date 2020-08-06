package com.ensys.sample.domain.Sysuserauth;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class SysuserauthService extends BaseService {

    @Inject
    private SysuserauthMapper SysuserauthMapper;

    public List<HashMap<String, Object>> select(HashMap<String, Object> auth) {

        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();
        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("ID_USER", auth.get("P_ID_USER"));
        parameterMap.put("CD_DEPT", auth.get("P_CD_DEPT"));

        return SysuserauthMapper.select(parameterMap);
    }

    public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> auth) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();

        SessionUser user = SessionUtils.getCurrentUser();
        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("ID_USER", auth.get("P_ID_USER"));

        return SysuserauthMapper.selectDtl(parameterMap);
    }


    @Transactional
    public void saveAll(HashMap<String, Object> param) {

        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("gridData");
        List<HashMap<String, Object>> gridDataDelete = (List<HashMap<String, Object>>) param.get("gridDataDelete");
        SessionUser user = SessionUtils.getCurrentUser();


        if (items != null && items.size() > 0) {        //  디테일 추가된 것
            for (HashMap<String, Object> item : items) {
                item.put("CD_COMPANY", user.getCdCompany());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        SysuserauthMapper.delete(item);
                    }
                } else if (item.get("__modified__") != null) {
                    if ((boolean) item.get("__created__")) {
                        SysuserauthMapper.insert(item);

                    }
                }
            }
        }

        if (gridDataDelete != null && gridDataDelete.size() > 0) {      //  HEADER 삭제
            for (HashMap<String, Object> delete : gridDataDelete) {
                delete.put("CD_COMPANY", user.getCdCompany());
                SysuserauthMapper.deleteUser(delete);
            }
        }
    }

}
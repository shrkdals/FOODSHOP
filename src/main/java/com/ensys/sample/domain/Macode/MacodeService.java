package com.ensys.sample.domain.Macode;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class MacodeService extends BaseService {

    @Inject
    private MacodeMapper macodeMapper;

    public List<HashMap<String, Object>> select(HashMap<String, Object> macode) {
        SessionUser user = SessionUtils.getCurrentUser();
        macode.put("ID", user.getIdUser());
        return macodeMapper.select(macode);
    }

    public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> macode) {
        return macodeMapper.selectDtl(macode);
    }


    @Transactional
    public void save(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();

        List<HashMap<String, Object>> gridH = (List<HashMap<String, Object>>) param.get("gridH");
        List<HashMap<String, Object>> gridD = (List<HashMap<String, Object>>) param.get("gridD");

        String CD_FIELD = "";
        if (gridH != null && gridH.size() > 0) {
            for (HashMap<String, Object> item : gridH) {
                if (item != null && item.size() > 0) {
                    if (item.get("__deleted__") != null) {
                        if ((boolean) item.get("__deleted__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            macodeMapper.delete(item);
                        }
                    } else if (item.get("__created__") != null) {
                        if ((boolean) item.get("__created__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            HashMap<String, Object> result = macodeMapper.insert(item);
                            CD_FIELD = (String) result.get("CD_FIELD");
                        }
                    } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                        if ((boolean) item.get("__modified__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            macodeMapper.update(item);
                        }
                    }
                }
            }
        }
        if (gridD != null && gridD.size() > 0) {
            for (HashMap<String, Object> item : gridD) {
                if (item != null && item.size() > 0) {
                    String _cd_field = "";
                    if (item.get("CD_FIELD") != null && !item.get("CD_FIELD").equals("")) {
                        _cd_field = (String) item.get("CD_FIELD");
                    } else {
                        _cd_field = CD_FIELD;
                    }
                    if (item.get("__deleted__") != null) {
                        if ((boolean) item.get("__deleted__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            macodeMapper.deleteDtl(item);
                        }
                    } else if (item.get("__created__") != null) {
                        if ((boolean) item.get("__created__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            item.put("CD_FIELD", _cd_field);
                            macodeMapper.insertDtl(item);
                        }
                    } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                        if ((boolean) item.get("__modified__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            macodeMapper.updateDtl(item);
                        }
                    }
                }
            }
        }
    }

}
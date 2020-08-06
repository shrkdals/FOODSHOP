package com.ensys.sample.domain.Maacctmapping;


import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class MaacctmappingService extends BaseService {


    @Inject
    private MaacctmappingMapper acctMapper;

    public List<HashMap<String, Object>> select(HashMap<String, Object> up) {

        return acctMapper.select(up);

    }

    public List<HashMap<String, Object>> selectDtl(HashMap<String, Object> up) {

        return acctMapper.selectDtl(up);

    }

    public List<HashMap<String, Object>> selectDept(HashMap<String, Object> up) {

        return acctMapper.selectDept(up);

    }


    public List<HashMap<String, Object>> acctListHelp(HashMap<String, Object> up) {

        return acctMapper.acctListHelp(up);

    }

    @Transactional
    public void save(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();

        List<HashMap<String, Object>> saveList = (List<HashMap<String, Object>>) param.get("saveList");
        List<HashMap<String, Object>> gridDept = (List<HashMap<String, Object>>) param.get("gridDept");
        List<HashMap<String, Object>> gridAcct = (List<HashMap<String, Object>>) param.get("gridAcct");

        String CD_TPDOCU = "";

        if (saveList != null && saveList.size() > 0) {
            for (HashMap<String, Object> item : saveList) {
                if (item != null && item.size() > 0) {
                    if (item.get("__deleted__") != null) {
                        if ((boolean) item.get("__deleted__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            acctMapper.delete(item);
                        }
                    } else if (item.get("__created__") != null) {
                        if ((boolean) item.get("__created__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            HashMap<String, Object> result = acctMapper.insert(item);
                            CD_TPDOCU = (String) result.get("CD_TPDOCU");
                        }
                    } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                        if ((boolean) item.get("__modified__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            acctMapper.update(item);
                        }
                    }
                }
            }
        }

        if (gridDept != null && gridDept.size() > 0) {
            for (HashMap<String, Object> item : gridDept) {
                if (item != null && item.size() > 0) {
                    String _cd_tpdocu = "";
                    if (item.get("CD_TPDOCU") != null && !item.get("CD_TPDOCU").equals("")) {
                        _cd_tpdocu = (String) item.get("CD_TPDOCU");
                    } else {
                        _cd_tpdocu = CD_TPDOCU;
                    }
                    if (item.get("__deleted__") != null) {
                        if ((boolean) item.get("__deleted__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            acctMapper.deleteDept(item);
                        }
                    } else if (item.get("__created__") != null) {
                        if ((boolean) item.get("__created__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            item.put("CD_TPDOCU", _cd_tpdocu);
                            acctMapper.insertDept(item);
                        }
                    } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                        if ((boolean) item.get("__modified__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            acctMapper.updateDept(item);
                        }
                    }
                }
            }
        }

        if (gridAcct != null && gridAcct.size() > 0) {
            for (HashMap<String, Object> item : gridAcct) {
                if (item != null && item.size() > 0) {
                    String _cd_tpdocu = "";
                    if (item.get("CD_TPDOCU") != null && !item.get("CD_TPDOCU").equals("")) {
                        _cd_tpdocu = (String) item.get("CD_TPDOCU");
                    } else {
                        _cd_tpdocu = CD_TPDOCU;
                    }
                    if (item.get("__deleted__") != null) {
                        if ((boolean) item.get("__deleted__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            acctMapper.deleteDtl(item);
                        }
                    } else if (item.get("__created__") != null) {
                        if ((boolean) item.get("__created__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            item.put("CD_TPDOCU", _cd_tpdocu);
                            acctMapper.insertDtl(item);

                        }
                    } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                        if ((boolean) item.get("__modified__")) {
                            item.put("CD_COMPANY", user.getCdCompany());
                            item.put("ID_INSERT", user.getIdUser());
                            acctMapper.updateDtl(item);
                        }
                    }
                }
            }
        }
    }
}

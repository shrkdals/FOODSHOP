package com.ensys.sample.domain.ItemM;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

@Service
public class ItemMService  extends BaseService {

    @Inject
    public ItemMMapper Mapper;

    public List<HashMap<String, Object>> search(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        return Mapper.search(param);
    }

    @Inject
    private fileService fileservice;

    @Transactional
    public void save(HashMap<String, Object> param){
        SessionUser user = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("saveData");

        if (items != null && items.size() > 0){
            for (HashMap<String, Object> item : items){
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        item.put("COMPANY_CD", user.getCdCompany());
                        Mapper.delete(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        item.put("COMPANY_CD", user.getCdCompany());
                        item.put("INSERT_ID", user.getIdUser());
                        Mapper.insert(item);

                        if (item.get("FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
                            fileservice.insertFsFile(file);
                        }
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        item.put("COMPANY_CD", user.getCdCompany());
                        item.put("UPDATE_ID", user.getIdUser());
                        Mapper.update(item);

                        if (item.get("FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
                            fileservice.insertFsFile(file);
                        }
                    }
                }
            }
        }
    }


}

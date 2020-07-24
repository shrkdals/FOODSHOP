package com.ensys.sample.domain.Event;

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
public class EventService extends BaseService {

    @Inject
    public EventMapper mapper;

    @Inject
    private fileService fileservice;

    public List<HashMap<String, Object>> search(HashMap<String, Object> param) {
        return mapper.search(param);
    }

    @Transactional
    public void save(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("saveData");

        if (items != null && items.size() > 0) {
            for (HashMap<String, Object> item : items) {
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());

                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        mapper.delete(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insert(item);

                        if (item.get("FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("FILE");
                            fileservice.insertFsFile(file);
                        }
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.update(item);

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

package com.ensys.sample.domain.Categorym;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class CategorymService extends BaseService {

    @Inject
    private CategorymMapper mapper;

    public List<HashMap<String,Object>> getBrcode(HashMap<String, Object> param) {
        return mapper.getBrcode(param);
    }

    public List<HashMap<String,Object>> getParentBrcode(HashMap<String, Object> param) {
        return mapper.getParentBrcode(param);
    }

    public List<HashMap<String,Object>> categorymSearchMain(HashMap<String, Object> param) {
        return mapper.categorymSearchMain(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) throws Exception {
        SessionUser user = SessionUtils.getCurrentUser();
        // 카테고리
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("insert")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.insert(item);
        }

        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("delete")){
            item.put("COMPANY_CD",user.getCdCompany());
            item.put("USER_ID",user.getIdUser());
            mapper.delete(item);
        }

    }

}



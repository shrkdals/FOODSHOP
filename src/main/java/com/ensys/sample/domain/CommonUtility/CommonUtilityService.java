package com.ensys.sample.domain.CommonUtility;

import com.chequer.axboot.core.api.response.Responses;
import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class CommonUtilityService extends BaseService {

    @Inject
    public CommonUtilityMapper CommonUtilityMapper;

    public List<HashMap<String, Object>> CommonCodeList(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CommonUtilityMapper.selectList(param);
    }

    public Map<String, Object> checkMagam(HashMap<String, Object> param) {
        return CommonUtilityMapper.checkMagam(param);
    }

    public Map<String, Object> GETNO(HashMap<String, Object> param) {
        return CommonUtilityMapper.GETNO(param);
    }

    public List<HashMap<String, Object>> tempMethod(HashMap<String, Object> param) {
        return CommonUtilityMapper.selectList(param);
    }
    
    public List<HashMap<String, Object>> getLoginPartner(HashMap<String, Object> param){
    	SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        param.put("USER_ID", sessionUser.getIdUser());
    	return CommonUtilityMapper.getLoginPartner(param);
    }
}
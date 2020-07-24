package com.ensys.sample.domain.CustomHelp;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomHelpService extends BaseService {

    @Inject
    public CustomHelpMapper CustomHelpMapper;

    public List<Map<String, Object>> getCardList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.getCardList(param);
    }

    public List<Map<String, Object>> getAcctList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.getAcctList(param);
    }

    public List<Map<String, Object>> getPcList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.getPcList(param);
    }

    public List<Map<String, Object>> tpdocuListHelp(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.tpdocuListHelp(param);
    }

    public List<Map<String, Object>> getPartnerTemp(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.getPartnerTemp(param);
    }

    public List<Map<String, Object>> getBuAcctList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.getBuAcctList(param);
    }

    public List<Map<String, Object>> CUSTOM_HELP_USER_DEPT(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.CUSTOM_HELP_USER_DEPT(param);
    }

    public List<Map<String, Object>> CUSTOM_HELP_BIZTRIP_APPLY(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.CUSTOM_HELP_BIZTRIP_APPLY(param);
    }

    public List<Map<String, Object>> CUSTOM_HELP_BIZTRIP_BUCARD(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return CustomHelpMapper.CUSTOM_HELP_BIZTRIP_BUCARD(param);
    }


}
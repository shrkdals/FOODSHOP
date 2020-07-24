package com.ensys.sample.domain.CommonHelp;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CommonHelpService extends BaseService {

    @Inject
    public CommonHelpMapper mapper;

    public List<HashMap<String, Object>> HELP_BRAND_ITEM(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_BRAND_ITEM(param);
    }
    public List<HashMap<String, Object>> HELP_BRAND_PARTNER(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_BRAND_PARTNER(param);
    }

    public List<HashMap<String, Object>> HELP_ACCT(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        param.put("LOGIN_ID", sessionUser.getIdUser());
        return mapper.HELP_ACCT(param);
    }

    public List<HashMap<String, Object>> HELP_PARTNER(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_PARTNER(param);
    }

    public List<HashMap<String, Object>> HELP_PARTNER3(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD", sessionUser.getCdCompany());
        param.put("LOGIN_ID", sessionUser.getIdUser());
        return mapper.HELP_PARTNER3(param);
    }

    public List<HashMap<String, Object>> HELP_CARD(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_CARD(param);
    }

    public List<HashMap<String, Object>> HELP_BIZAREA(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_BIZAREA(param);
    }

    public List<HashMap<String, Object>> HELP_ETAX_EMP(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_ETAX_EMP(param);
    }

    public List<HashMap<String, Object>> HELP_BANK(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_BANK(param);
    }

    public List<HashMap<String, Object>> HELP_DISBDOC(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_DISBDOC(param);
    }

    public List<HashMap<String, Object>> HELP_BUDGET(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_BUDGET(param);
    }

    public List<HashMap<String, Object>> HELP_CC(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_CC(param);
    }

    public List<HashMap<String, Object>> HELP_DEPT(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_DEPT(param);
    }

    public List<HashMap<String, Object>> HELP_ALL_DEPT(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_ALL_DEPT(param);
    }


    public List<HashMap<String, Object>> HELP_APPROVEBU(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_APPROVEBU(param);
    }

    public List<HashMap<String, Object>> HELP_APPROVEFI(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_APPROVEFI(param);
    }

    public List<HashMap<String, Object>> HELP_EMP(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_EMP(param);
    }

    public List<HashMap<String, Object>> HELP_USER(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        param.put("LOGIN_ID", sessionUser.getIdUser());
        return mapper.HELP_USER(param);
    }

    public List<HashMap<String, Object>> HELP_MULTI_EMP(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_MULTI_EMP(param);
    }

    public List<HashMap<String, Object>> HELP_PROG(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_PROG(param);
    }

    public List<HashMap<String, Object>> HELP_AUTHGROUP(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_AUTHGROUP(param);
    }


    public List<HashMap<String, Object>> HELP_DEPOSIT(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_DEPOSIT(param);
    }

    public List<HashMap<String, Object>> HELP_PC(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_PC(param);
    }

    public List<HashMap<String, Object>> HELP_CODEDTL(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_CODEDTL(param);
    }



    public List<HashMap<String, Object>> HELP_BIZCAR(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_BIZCAR(param);
    }

    public List<HashMap<String, Object>> HELP_ASSET_PROCGB(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_ASSET_PROCGB(param);
    }


    public List<HashMap<String, Object>> HELP_PARTNER_DEPOSIT(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return mapper.HELP_PARTNER_DEPOSIT(param);
    }


    public List<HashMap<String, Object>> HELP_BUDGET_REPORT(HashMap<String, Object> param) {
        return mapper.HELP_BUDGET_REPORT(param);
    }

    public List<HashMap<String, Object>> HELP_AREA(Map<String, Object> param) {
        return mapper.HELP_AREA(param);
    }
    public List<HashMap<String, Object>> HELP_AREA2(Map<String, Object> param) {
        return mapper.HELP_AREA2(param);
    }
    public List<HashMap<String, Object>> HELP_ITEM(Map<String, Object> param) {
        return mapper.HELP_ITEM(param);
    }

    public List<HashMap<String, Object>> HELP_ITEM_CATEGORY(Map<String, Object> param) {
        return mapper.HELP_ITEM_CATEGORY(param);
    }

    public List<HashMap<String, Object>> HELP_PARTNER_CONTRACT(HashMap<String, Object> param) {
        return mapper.HELP_PARTNER_CONTRACT(param);
    }
}
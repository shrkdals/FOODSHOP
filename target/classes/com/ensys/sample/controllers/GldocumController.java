package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.Gldocum.GldocumService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

@Controller
@RequestMapping(value = "/api/v1/Gldocum")
public class GldocumController extends BaseController {

    @Inject
    private GldocumService disbDocsService;

    @RequestMapping(value = "tpdocuAcct", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse list2(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("CD_TPDOCU", requestParams.getString("P_CD_TPDOCU", ""));
        parameterMap.put("CD_DOCU", requestParams.getString("P_CD_DOCU", ""));

        List<HashMap<String, Object>> list = disbDocsService.tpdocuAcct(parameterMap);

        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "ccAddRow", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse ccAddRow(@RequestBody Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        List<Map<String, Object>> result = new ArrayList<>();
        result.addAll(disbDocsService.ccAddRow(param));
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "getTpDocu", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.MapResponse getTpDocu() {
        Map<String, Object> map = disbDocsService.getTpDocu();
        return Responses.MapResponse.of(map);
    }


    @RequestMapping(value = "insert", method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public Responses.MapResponse insert(@RequestBody Map<String, Object> param) {
        String groupnumber = disbDocsService.dataProcess(param);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("GROUP_NUMBER", groupnumber);
        return Responses.MapResponse.of(result);

    }

    @RequestMapping(value = "insertBan", method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public Responses.MapResponse insertBan(@RequestBody Map<String, Object> param) {
        String groupnumber = disbDocsService.dataProcessBan(param);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("GROUP_NUMBER", groupnumber);
        return Responses.MapResponse.of(result);

    }

    @RequestMapping(value = "getMngd", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.MapResponse getMngd(@RequestBody Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());

        return Responses.MapResponse.of(disbDocsService.getMngd(param));

    }

    @RequestMapping(value = "getAutoMngd", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.MapResponse getAutoMngd(@RequestBody Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("NO_EMP", param.get("NO_EMP"));
        param.put("CD_PARTNER", param.get("CD_PARTNER"));
        param.put("DATE", param.get("DATE"));
        param.put("AMT", param.get("AMT"));

        return Responses.MapResponse.of(disbDocsService.getAutoMngd(param));

    }

    @RequestMapping(value = "getAcctcode", method = {RequestMethod.GET}, produces = APPLICATION_JSON)
    public Responses.MapResponse getAcctcode(RequestParams requestParams) {
        SessionUser user = SessionUtils.getCurrentUser();
        Map<String, Object> param = new HashMap<>();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("CD_RELATION", requestParams.getString("CD_RELATION"));


        return Responses.MapResponse.of(disbDocsService.getAcctcode(param));

    }

    @RequestMapping(value = "receptInsert", method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public Responses.MapResponse receptInsert(@RequestBody Map<String, String> param) {

        Map<String, Object> rtn = new HashMap<>();
        rtn.put("NO_RECEPT", disbDocsService.receptInsert(param));

        return Responses.MapResponse.of(rtn);
    }


    @RequestMapping(value = "getRecept", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public Responses.MapResponse getRecept(@RequestBody Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());


        return Responses.MapResponse.of(disbDocsService.getRecept(param));

    }

    @RequestMapping(value = "getTaxBillList", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getTaxBillList(@RequestBody Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("NO_TAX", param.get("NO_TAX"));

        List<Map<String, Object>> list = disbDocsService.getTaxBillList(param);

        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getBnftAmt", method = POST, produces = APPLICATION_JSON)   //  편익누적금액 가져오기
    public Responses.MapResponse getBnftAmt(@RequestBody HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return Responses.MapResponse.of(disbDocsService.getBnftAmt(param));
    }


    @RequestMapping(value = "getDocuCopy", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse getDocuCopy(RequestParams param) {
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
        SessionUser user = SessionUtils.getCurrentUser();
        try {
            HashMap<String, Object> parameterMap = new HashMap<String, Object>();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("CD_PC", user.getCdPc());
            parameterMap.put("DT_ACCT_F", param.getString("P_DT_ACCT_F", ""));
            parameterMap.put("DT_ACCT_T", param.getString("P_DT_ACCT_T", ""));
            parameterMap.put("ID_WRITE", param.getString("P_ID_WRITE", ""));
            parameterMap.put("CD_DOCU", param.getString("P_CD_DOCU", ""));
            parameterMap.put("TP_GB", param.getString("P_TP_GB", ""));

            list = disbDocsService.getDocuCopy(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getDocuPusaivCopy", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getDocuPusaivCopy(@RequestBody HashMap<String, Object> param) {
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
        SessionUser user = SessionUtils.getCurrentUser();
        try {
            HashMap<String, Object> parameterMap = new HashMap<String, Object>();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("GROUP_NUMBER", param.get("P_GROUP_NUMBER"));

            list = disbDocsService.getDocuPusaivCopy(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getDocuAcctentCopy", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getDocuAcctentCopy(@RequestBody HashMap<String, Object> param) {
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
        SessionUser user = SessionUtils.getCurrentUser();
        try {
            list = disbDocsService.getDocuAcctentCopy(param);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getRtExch", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.MapResponse getRtExch(@RequestBody Map<String, Object> param) {
        return Responses.MapResponse.of(disbDocsService.getRtExch(param));

    }


    @RequestMapping(value = "getchkValidate", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.MapResponse chk_noTpdocu(@RequestBody HashMap<String, Object> param) {
        return Responses.MapResponse.of(disbDocsService.getchkValidate(param));

    }

    @RequestMapping(value = "acctBanCheck", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.MapResponse acctBanCheck(@RequestBody HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("TP_DRCR", param.get("TP_DRCR"));
        param.put("CD_ACCT", param.get("CD_ACCT"));

        return Responses.MapResponse.of(disbDocsService.acctBanCheck(param));

    }

    @RequestMapping(value = "getBanjanList", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.ListResponse getBanjanList(@RequestBody HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("CD_PC", param.get("CD_PC"));
        param.put("ID_BAN1", param.get("ID_BAN1"));
        param.put("ID_BAN2", param.get("ID_BAN2"));
        return Responses.ListResponse.of(disbDocsService.getBanjanList(param));
    }

    @RequestMapping(value = "getBanList", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    public Responses.ListResponse getBanList(@RequestBody HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("CD_PC", param.get("CD_PC"));
        param.put("CD_ACCT", param.get("CD_ACCT"));
        param.put("DT_ACCT_F", param.get("DT_ACCT_F"));
        param.put("DT_ACCT_T", param.get("DT_ACCT_T"));
        param.put("ST_BAN", param.get("ST_BAN"));
        param.put("CD_MNG", param.get("CD_MNG"));
        param.put("DT_EMD_F", param.get("DT_EMD_F"));
        param.put("DT_EMD_T", param.get("DT_EMD_T"));
        param.put("NM_ACCT", param.get("NM_ACCT"));
        param.put("CD_MNG2", param.get("CD_MNG2"));
        param.put("KEY", param.get("KEY"));
        param.put("GRID_TYPE", param.get("GRID_TYPE"));

        return Responses.ListResponse.of(disbDocsService.getBanList(param));

    }


}
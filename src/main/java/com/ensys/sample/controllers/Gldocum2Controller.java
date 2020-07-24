package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.Gldocum2.Gldocum2Service;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/v1/Gldocum2")
public class Gldocum2Controller extends BaseController {

    @Inject
    private Gldocum2Service disbDocsService;



    @RequestMapping(value = "getHeaderList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse getHeaderList(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("CD_EMP", requestParams.getString("CD_EMP", ""));
        parameterMap.put("CD_DEPT", requestParams.getString("CD_DEPT", ""));
        parameterMap.put("CD_DOCU", requestParams.getString("CD_DOCU", ""));

        List<HashMap<String, Object>> list = disbDocsService.getHeaderList(parameterMap);

        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getDetailList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.MapResponse getDetailList(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("NO_TPDOCU", requestParams.getString("NO_TPDOCU", ""));
        parameterMap.put("CD_EMP", requestParams.getString("CD_EMP", ""));
        parameterMap.put("CD_DEPT", requestParams.getString("CD_DEPT", ""));
        parameterMap.put("CD_DOCU", requestParams.getString("CD_DOCU", ""));

        HashMap<String, Object> list = disbDocsService.getDetailList(parameterMap);

        return Responses.MapResponse.of(list);
    }

    @RequestMapping(value = "saveimsi", method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public Responses.MapResponse saveimsi(@RequestBody HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            result = disbDocsService.saveimsi(param);

        }catch (Exception e){
            result.put("MSG", e);
            e.printStackTrace();
        }
        return Responses.MapResponse.of(result);
    }

    @RequestMapping(value = "insert", method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public Responses.MapResponse insert(@RequestBody HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            String groupnumber = disbDocsService.dataProcess(param);
            result.put("GROUP_NUMBER", groupnumber);
        }catch (Exception e){
            result.put("MSG", e);
            e.printStackTrace();
        }

        return Responses.MapResponse.of(result);
    }

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

    @RequestMapping(value = "getGroupNumber", method = RequestMethod.GET, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse getGroupNumber() {
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            result = disbDocsService.getGroupNumber();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.MapResponse.of(result);
    }

    @RequestMapping(value = "getTpDocu", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.MapResponse getTpDocu() {
        Map<String, Object> map = disbDocsService.getTpDocu();
        return Responses.MapResponse.of(map);
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


    @RequestMapping(value = "getBenefit", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse getBenefit(RequestParams param) {
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
        SessionUser user = SessionUtils.getCurrentUser();
        try {
            HashMap<String, Object> parameterMap = new HashMap<String, Object>();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("GROUP_NUMBER", param.getString("GROUP_NUMBER", ""));

            list = disbDocsService.getBenefit(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
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

}
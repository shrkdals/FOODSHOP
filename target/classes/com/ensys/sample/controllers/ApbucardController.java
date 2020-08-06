package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Apbucard.ApbucardService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.*;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

@Controller
@RequestMapping(value = "/api/Apbucard")
public class ApbucardController extends BaseController {

    @Inject
    private ApbucardService bucardService;

    @RequestMapping(value = "getBucardList", method = POST, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse list(@RequestBody HashMap<String, Object> requestParams) {
        List<HashMap<String, Object>> list = bucardService.select(requestParams);
        for(HashMap<String, Object> item : list){
            item.put("uid", UUID.randomUUID().toString());
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "acctAddRow", method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.ListResponse acctAddRow(@RequestBody Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println(" [ *** 로우 추가시 기본값 조회 *** ]");
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        List<Map<String, Object>> result = new ArrayList<>();
        result.add(bucardService.acctAddRow(param));
        result.add(bucardService.ccAddRow(param));
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "bgacctSetting", method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.ListResponse bgacctSetting(@RequestBody Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println(" [ *** 예산계정 조회 *** ]");
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        List<Map<String, Object>> result = bucardService.bgacctSetting(param);
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "acctBudgetAmt", method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.ListResponse acctBudgetAmt(@RequestBody Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println(" [ *** 계정별 예산액 조회 *** ]");
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        List<Map<String, Object>> result = bucardService.acctBudgetAmt(param);
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "getBucardDetailList", method = POST, produces = APPLICATION_JSON)
    public Responses.ListResponse dList(@RequestBody HashMap<String, Object> requestParams) {

        List<HashMap<String, Object>>  list = bucardService.selectD(requestParams);
        for(HashMap<String, Object> item : list){
            item.put("uid", UUID.randomUUID().toString());
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getBucardCustList", method = POST, produces = APPLICATION_JSON)
    public Responses.ListResponse custList(@RequestBody HashMap<String, Object> requestParams) {

        List<HashMap<String, Object>>  list = bucardService.selectCust(requestParams);
        for(HashMap<String, Object> item : list){
            item.put("uid", UUID.randomUUID().toString());
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "allsave", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse allsave(@RequestBody HashMap<String, Object> requestParams) throws Exception {

        SessionUser sessionUser = SessionUtils.getCurrentUser();
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap = requestParams;
        parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
        bucardService.save(parameterMap);
        return ok();
    }

    @RequestMapping(value = "statement", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public Responses.MapResponse statement(@RequestBody HashMap<String, Object> requestParams) throws Exception{
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        Map<String, Object> param = new HashMap<String, Object>();
        parameterMap = requestParams;
        parameterMap.put("CD_COMPANY" , sessionUser.getCdCompany());
        parameterMap.put("ID_USER" , sessionUser.getIdUser());
        param.put("GROUP_NUMBER",bucardService.statement(parameterMap));
        return Responses.MapResponse.of(param);
    }

    @RequestMapping(value = "statementMulti", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public Responses.MapResponse statementMulti(@RequestBody HashMap<String, Object> requestParams) throws Exception {
        HashMap<String, Object> param = new HashMap<String, Object>();
        param = bucardService.statementMulti(requestParams);
        return Responses.MapResponse.of(param);
    }

    @RequestMapping(value = "docuCancel", method = POST, produces = APPLICATION_JSON)
    public ApiResponse docuCancel(@RequestBody HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY",sessionUser.getCdCompany());
        bucardService.docuCancel(param);
//        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("itemC")){
//            item.put("CD_COMPANY",sessionUser.getCdCompany());
//            bucardService.docuBnftCancel(item);
//        }
        return ok();
    }

    @RequestMapping(value = "getBnftAmt", method = POST, produces = APPLICATION_JSON)
    public Responses.MapResponse getBnftAmt(@RequestBody HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY",sessionUser.getCdCompany());
        return Responses.MapResponse.of(bucardService.getBnftAmt(param));
    }

}
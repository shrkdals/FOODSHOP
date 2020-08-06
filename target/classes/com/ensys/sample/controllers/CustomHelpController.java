package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.CustomHelp.CustomHelpService;
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

@Controller
@RequestMapping(value = "/api/customHelp")
public class CustomHelpController extends BaseController {

    @Inject
    private CustomHelpService service;

    /**
     * 커스텀 카드 도옴창 API
     *
     * @PARAM : P_CD_COMPANY
     * @PARAM : P_KEYWORD
     * @PARAM : P_YN_USE
     * @PARAM : P_CARD_TYPE
     * @PARAM : P_CD_ST_CARD
     */
    @RequestMapping(value = "CUSTOM_HELP_CARD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getCardList(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** CustomHelpController : 공통코드 API *** ]");
        System.out.println("[ ***  CUSTOM_HELP_CARD PARAM INFO   *** ]");
        System.out.println("[ "
                + " P_CD_COMPANY : " + param.get("P_CD_COMPANY")
                + " P_KEYWORD : " + param.get("P_KEYWORD")
                + " P_YN_USE : " + param.get("P_YN_USE")
                + " P_CARD_TYPE : " + param.get("P_CARD_TYPE")
                + " P_CD_ST_CARD : " + param.get("P_CD_ST_CARD")
                + " ]");
        return Responses.ListResponse.of(service.getCardList(param));
    }

    /**
     * 계정도움창 API
     *
     * @PARAM : NM_ACCT
     * @PARAM : TP_DRCR
     */
    @RequestMapping(value = "CUSTOM_HELP_ACCT", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getAcctList(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** CustomHelpController : 계정도움창 API *** ]");
        System.out.println("[ ***  CUSTOM_HELP_ACCT PARAM INFO   *** ]");
        System.out.println("[ TP_DRCR : " + param.get("TP_DRCR") + " P_KEYWORD : " + param.get("P_KEYWORD") + " ]");
        return Responses.ListResponse.of(service.getAcctList(param));
    }

    /**
     * 법인카드계정도움창 API
     *
     * @PARAM : P_KEYWORD
     * @PARAM : TP_DRCR
     * @PARAM : JOB_TP
     */
    @RequestMapping(value = "CUSTOM_HELP_BUACCT", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getBuAcctList(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** CustomHelpController : 법인카드계정도움창 API *** ]");
        System.out.println("[ ***  CUSTOM_HELP_BUACCT PARAM INFO   *** ]");
        System.out.println("[ TP_DRCR : " + param.get("TP_DRCR") + " P_KEYWORD : " + param.get("P_KEYWORD") + " JOB_TP : " + param.get("JOB_TP") + " ]");
        return Responses.ListResponse.of(service.getBuAcctList(param));
    }

    /**
     * 회계단위도움창 API
     *
     * @PARAM : KEYWORD
     */
    @RequestMapping(value = "CUSTOM_HELP_PC", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getPcHelp(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** CustomHelpController : 회계단위도움창 API *** ]");
        System.out.println("[ ***  CUSTOM_HELP_PC PARAM INFO   *** ]");
        System.out.println("[ P_KEYWORD : " + param.get("P_KEYWORD") + " ]");
        return Responses.ListResponse.of(service.getPcList(param));
    }

    @RequestMapping(value = "CUSTOM_HELP_TPDOCU", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse tpdocuListHelp(@RequestBody Map<String, Object> param) {
        return Responses.ListResponse.of(service.tpdocuListHelp(param));
    }

    @RequestMapping(value = "CUSTOM_HELP_PARTNER_TEMP", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse CUSTOM_HELP_PARTNER_TEMP(@RequestBody Map<String, Object> param) {
        Map<String, Object> parameterMap = null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            parameterMap = new HashMap<String, Object>();

            System.out.println("[ *** CustomHelpController : 거래처 임시테이블 조회도움창 API *** ]");
            System.out.println("[ ***  CUSTOM_HELP_PARTNER_TEMP PARAM INFO   *** ]");
            System.out.println("[ P_KEYWORD : " + param.get("P_KEYWORD") + " ]");

            SessionUser user = SessionUtils.getCurrentUser();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("DT_ACCT_F", param.get("P_DT_ACCT_F"));
            parameterMap.put("DT_ACCT_T", param.get("P_DT_ACCT_T"));
            parameterMap.put("CD_EMP", param.get("P_CD_EMP"));
            parameterMap.put("KEYWORD", param.get("P_KEYWORD"));
            list = service.getPartnerTemp(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "CUSTOM_HELP_USER_DEPT", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse CUSTOM_USER_DEPT(@RequestBody Map<String, Object> param) {
        Map<String, Object> parameterMap = null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            parameterMap = new HashMap<String, Object>();

            System.out.println("[ *** CustomHelpController : 사용자권한부서에 따른 사원 조회도움창 API *** ]");
            System.out.println("[ ***  CUSTOM_USER_DEPT PARAM INFO   *** ]");
            System.out.println("[ P_KEYWORD : " + param.get("P_KEYWORD") + " ]");

            SessionUser user = SessionUtils.getCurrentUser();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("CD_DEPT", param.get("P_CD_DEPT"));
            parameterMap.put("KEYWORD", param.get("P_KEYWORD"));
            list = service.CUSTOM_HELP_USER_DEPT(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "CUSTOM_HELP_BIZTRIP_APPLY", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse CUSTOM_HELP_BIZTRIP_APPLY(@RequestBody Map<String, Object> param) {
        Map<String, Object> parameterMap = null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            parameterMap = new HashMap<String, Object>();

            System.out.println("[ *** CustomHelpController : 출장신청자에 따른 출장신청테이블 조회도움창 API *** ]");
            System.out.println("[ ***  CUSTOM_HELP_BIZTRIP_APPLY PARAM INFO   *** ]");
            System.out.println("[ P_KEYWORD : " + param.get("P_KEYWORD") + " ]");

            SessionUser user = SessionUtils.getCurrentUser();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("CD_DEPT", param.get("P_CD_DEPT"));
            parameterMap.put("CD_EMP", param.get("P_CD_EMP"));
            parameterMap.put("DT_WRITE_F", param.get("P_DT_WRITE_F").toString().replace("-", ""));
            parameterMap.put("DT_WRITE_T", param.get("P_DT_WRITE_T").toString().replace("-", ""));
            list = service.CUSTOM_HELP_BIZTRIP_APPLY(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "CUSTOM_HELP_BIZTRIP_BUCARD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse CUSTOM_HELP_BIZTRIP_BUCARD(@RequestBody Map<String, Object> param) {
        Map<String, Object> parameterMap = null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            parameterMap = new HashMap<String, Object>();

            System.out.println("[ *** CustomHelpController : 출장정산 시 사용자의 법인카드사용내역[CARD_TEMP] 조회도움창 API *** ]");
            System.out.println("[ ***  CUSTOM_HELP_BIZTRIP_BUCARD PARAM INFO   *** ]");

            SessionUser user = SessionUtils.getCurrentUser();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("CD_DEPT", param.get("P_CD_DEPT"));
            parameterMap.put("CD_EMP", param.get("P_CD_EMP"));
            parameterMap.put("TRADE_DATE_F", param.get("P_TRADE_DATE_F").toString().replace("-", ""));
            parameterMap.put("TRADE_DATE_T", param.get("P_TRADE_DATE_T").toString().replace("-", ""));
            parameterMap.put("ST_DRAFT", param.get("P_ST_DRAFT"));
            parameterMap.put("JOB_TP", param.get("P_JOB_TP"));
            parameterMap.put("DOCU_TP", param.get("P_DOCU_TP"));
            list = service.CUSTOM_HELP_BIZTRIP_BUCARD(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }
}

package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.ApbucardLv2.ApbucardLv2Service;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/ApbucardLv2")
public class ApbucardLv2Controller extends BaseController {

    @Inject
    private ApbucardLv2Service bucardService;

    @RequestMapping(value = "allsave", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse allsave(@RequestBody HashMap<String, Object> param) throws Exception {
        bucardService.save(param);
        return ok();
    }

    @RequestMapping(value = "allsaveCMS", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse allsaveCMS(@RequestBody HashMap<String, Object> param) throws Exception {
        bucardService.saveCMS(param);
        return ok();
    }
    //계정일괄적용
    @RequestMapping(value = "acctTemp", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse acctTemp(@RequestBody HashMap<String, Object> param) throws Exception {
        bucardService.acctTemp(param);
        return ok();
    }

    @RequestMapping(value = "applyInsert" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.MapResponse applyInsert(@RequestBody HashMap<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 결의서 결재요청 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        String no_draft = bucardService.getNoDraft().get("NO_DRAFT").toString();
        param.put("NO_DRAFT",no_draft);
        bucardService.applyInsert(param);
        return Responses.MapResponse.of(param);
    }

    @RequestMapping(value = "applyUpdate" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse applyUpdate(@RequestBody HashMap<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 결의서 결재요청 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        bucardService.applyUpdate(param);
        return ok();
    }

    @RequestMapping(value = "acctLink" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.MapResponse acctLink(@RequestBody HashMap<String, Object> param) {
        Map<String, Object> re = new HashMap<>();
        Map<String, Object> item = bucardService.acctLink(param);
        if(item != null){
            re.putAll(item);
        }else{
            re.put("NULL"," ");
        }

        return Responses.MapResponse.of(re);
    }

    @RequestMapping(value = "apbuPartner" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.MapResponse apbuPartner(@RequestBody HashMap<String, Object> param) {
        Map<String, Object> re = new HashMap<>();
        Map<String, Object> item = bucardService.apbuPartner(param);
        if(item != null){
            re.putAll(item);
        }else{
            re.put("NULL"," ");
        }

        return Responses.MapResponse.of(re);
    }

    @RequestMapping(value = "budgetCheck" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse budgetCheck(@RequestBody HashMap<String, Object> param) {
        bucardService.budgetCheck(param);
        return ok();
    }
    // CMS 전용
    @RequestMapping(value = "deptJobList", method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.ListResponse deptJobList(@RequestBody HashMap<String, Object> param) {
        List<HashMap<String, Object>> result = bucardService.deptJobList(param);
        return Responses.ListResponse.of(result);
    }
}
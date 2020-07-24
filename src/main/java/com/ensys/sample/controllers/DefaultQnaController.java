package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.DefaultQna.DefaultQnaService;
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

@Controller
@RequestMapping(value = "/api/defaultQna")
public class DefaultQnaController extends BaseController {

    @Inject
    DefaultQnaService service;

    @RequestMapping(value = "search", method = RequestMethod.POST, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse search(@RequestBody HashMap<String, Object> param) {
        HashMap<String, Object> ParameterMap = null;
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        try {

            SessionUser user = SessionUtils.getCurrentUser();
            ParameterMap = new HashMap<String, Object>();

            ParameterMap.put("COMPANY_CD", user.getCdCompany());
            ParameterMap.put("QNA_TYPE", param.get("QNA_TYPE"));
            ParameterMap.put("KEYWORD", param.get("KEYWORD"));
            ParameterMap.put("CONDITION", param.get("CONDITION"));

            result = service.search(ParameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
    @ResponseBody
    public void save(@RequestBody HashMap<String, Object> param) {
        try {
            service.save(param);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
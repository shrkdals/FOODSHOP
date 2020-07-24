package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Event.EventService;
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
@RequestMapping(value = "/api/event")
public class EventController extends BaseController {

    @Inject
    private EventService eventservice;

    @RequestMapping(value = "search", method = RequestMethod.POST, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse search(@RequestBody HashMap<String, Object> param) {
        HashMap<String, Object> ParameterMap = null;
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        try {

            SessionUser user = SessionUtils.getCurrentUser();
            ParameterMap = new HashMap<String, Object>();

            ParameterMap.put("COMPANY_CD", user.getCdCompany());
            ParameterMap.put("EVENT_ST_DTE", param.get("EVENT_ST_DTE"));
            ParameterMap.put("EVENT_ED_DTE", param.get("EVENT_ED_DTE"));
            ParameterMap.put("EVENT_NM", param.get("EVENT_NM"));

            result = eventservice.search(ParameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
    @ResponseBody
    public void save(@RequestBody HashMap<String, Object> param) {
        try {
            eventservice.save(param);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

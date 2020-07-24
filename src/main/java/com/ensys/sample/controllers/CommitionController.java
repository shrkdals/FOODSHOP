package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Commition.CommitionService;
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
@RequestMapping(value = "/api/commition")
public class CommitionController extends BaseController {

    @Inject
    private CommitionService service;

    @RequestMapping(value = "getCommitionHList", method = POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getCommitionHList(@RequestBody HashMap<String, Object> param) {
        List<HashMap<String, Object>> list = service.getCommitionHList(param);
        for(HashMap<String, Object> item : list){
            item.put("uid", UUID.randomUUID().toString());
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "getCommitionDList", method = POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getCommitionDList(@RequestBody HashMap<String, Object> param) {
        List<HashMap<String, Object>> list = service.getCommitionDList(param);
        for(HashMap<String, Object> item : list){
            item.put("uid", UUID.randomUUID().toString());
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "allsave", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse allsave(@RequestBody HashMap<String, Object> param) throws Exception {

        service.saveAll(param);
        return ok();
    }


}

package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.ApbucardLv1.ApbucardLv1Service;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

@Controller
@RequestMapping(value = "/api/ApbucardLv1")
public class ApbucardLv1Controller extends BaseController {

    @Inject
    private ApbucardLv1Service service;

    @RequestMapping(value = "getBucardLv1List", method = POST, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse list(@RequestBody HashMap<String, Object> requestParams) {
        List<HashMap<String, Object>> list = service.select(requestParams);
        for(HashMap<String, Object> item : list){
            item.put("uid", UUID.randomUUID().toString());
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "allsave", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse allsave(@RequestBody HashMap<String, Object> param) {
        service.save(param);
        return ok();
    }

    @RequestMapping(value = "statement", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public Responses.MapResponse statement(@RequestBody HashMap<String, Object> param) throws Exception{
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY" , sessionUser.getCdCompany());
        param.put("ID_USER" , sessionUser.getIdUser());
        param.put("GROUP_NUMBER",service.statement(param));
        return Responses.MapResponse.of(param);
    }

    @RequestMapping(value = "statementMulti", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public Responses.MapResponse statementMulti(@RequestBody HashMap<String, Object> requestParams) throws Exception {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("GROUP_NUMBER",service.statementMulti(requestParams));
        return Responses.MapResponse.of(param);
    }

}
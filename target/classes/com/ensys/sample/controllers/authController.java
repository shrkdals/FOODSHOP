package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.auth.auth;
import com.ensys.sample.domain.auth.AuthService;
import com.ensys.sample.domain.auth.authVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/api/auth")
public class authController extends BaseController {

    @Inject
    private AuthService authService;

    @RequestMapping(value = "authMselect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse menuList(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("AUTH_TYPE", requestParams.getString("AUTH_TYPE", ""));
        List<HashMap<String, Object>> list = authService.authMselect(parameterMap);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "authDselect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse authDselect(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("AUTH_TYPE", requestParams.getString("AUTH_TYPE", ""));
        parameterMap.put("AUTH_CODE", requestParams.getString("AUTH_CODE", ""));
        List<HashMap<String, Object>> list = authService.authDselect(parameterMap);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "seveAuth", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    @ResponseBody
    public ApiResponse PredocuItemModify(@RequestBody HashMap<String, Object> request) {
        try {
            authService.saveAuth(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ok();
    }


}
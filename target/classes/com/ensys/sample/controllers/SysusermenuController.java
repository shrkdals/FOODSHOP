package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Sysusermenu.Sysusermenu;
import com.ensys.sample.domain.Sysusermenu.SysusermenuService;
import com.ensys.sample.domain.Sysusermenu.SysusermenuVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/api/v1/Sysusermenu")
public class SysusermenuController extends BaseController {

    @Inject
    private SysusermenuService authService;



    @RequestMapping(value = "selectMst", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectMst() {
        List<HashMap<String, Object>> list = authService.selectMst();
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "select", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse select(@RequestBody HashMap<String, Object> requestParams) {
        List<HashMap<String, Object>> list = authService.select(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "selectDtl", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectDtl(@RequestBody HashMap<String, Object> requestParams) {
        List<HashMap<String, Object>> list = authService.selectDtl(requestParams);
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
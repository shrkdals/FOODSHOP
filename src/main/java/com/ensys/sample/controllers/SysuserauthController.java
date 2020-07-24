package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Sysuserauth.Sysuserauth;
import com.ensys.sample.domain.Sysuserauth.SysuserauthService;
import com.ensys.sample.domain.Sysuserauth.SysuserauthVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/api/v1/Sysuserauth")
public class SysuserauthController extends BaseController {

    @Inject
    private SysuserauthService SysuserauthService;


    @RequestMapping(value = "select", method = RequestMethod.POST, produces = APPLICATION_JSON)

    public Responses.ListResponse select(@RequestBody HashMap<String, Object> requestParams) {
        List<HashMap<String, Object>> list = SysuserauthService.select(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "selectDtl", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectDtl(@RequestBody HashMap<String, Object> requestParams) {
        List<HashMap<String, Object>> list = SysuserauthService.selectDtl(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "saveAll", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    @ResponseBody
    public ApiResponse saveAll(@RequestBody HashMap<String, Object> request) {
        try {
            SysuserauthService.saveAll(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ok();
    }


}
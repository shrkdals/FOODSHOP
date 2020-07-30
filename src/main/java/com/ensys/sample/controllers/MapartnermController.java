package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Mapartnerm.MapartnermService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/v1/Mapartnerm")
public class MapartnermController extends BaseController {

    @Inject
    private MapartnermService service;

    // 계약관리용
    @RequestMapping(value = "getPartnerList", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getPartnerList(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.select(param));
    }

    // 거래처 등록용
    @RequestMapping(value = "getPartnerList2", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getPartnerList2(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.select2(param));
    }

    @RequestMapping(value = "getPartnerCommitionList", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getPartnerCommitionList(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.getPartnerCommitionList(param));
    }

    @RequestMapping(value = "save", method =  {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse save(@RequestBody HashMap<String, Object> param) throws Exception {
        service.saveAll(param);
        return ok();
    }

    @RequestMapping(value = "save2", method =  {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse save2(@RequestBody HashMap<String, Object> param) throws Exception {
        service.saveAll2(param);
        return ok();
    }

    @RequestMapping(value = "SAVE_USERMAPPING_H_S", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse SAVE_USERMAPPING_H_S(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.SAVE_USERMAPPING_H_S(param));
    }

    @RequestMapping(value = "SAVE_USERMAPPING_S", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse SAVE_USERMAPPING_S(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.SAVE_USERMAPPING_S(param));
    }

    @RequestMapping(value = "SAVE_USERMAPPING", method =  RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse SAVE_USERMAPPING(@RequestBody HashMap<String, Object> param) throws Exception {
        service.SAVE_USERMAPPING(param);
        return ok();
    }


}
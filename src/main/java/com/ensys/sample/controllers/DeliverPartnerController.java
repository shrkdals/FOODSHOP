package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.DeliverPartner.DeliverPartnerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/DeliverPartner")
public class DeliverPartnerController extends BaseController {

    @Inject
    private DeliverPartnerService service;

    // ## 입출고관리 물류사용 ##
    @RequestMapping(value = "selectH", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectH(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectH(param));
    }

    @RequestMapping(value = "selectD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectD(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectD(param));
    }

    @RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse save(@RequestBody HashMap<String, Object> param) {
        service.saveAll(param);
        return ok();
    }

    @RequestMapping(value = "APPLY_INOUT", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse APPLY_INOUT(@RequestBody HashMap<String, Object> param) {
        service.APPLY_INOUT(param);
        return ok();
    }


    // ## 제조사관리 제조사용 ##
    @RequestMapping(value = "MkSelectH", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse MkselectH(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.MkselectH(param));
    }

    @RequestMapping(value = "MkselectD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse MkselectD(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.MkselectD(param));
    }


}

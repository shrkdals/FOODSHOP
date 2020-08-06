package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Order.OrderService;
import com.ensys.sample.domain.Request.RequestService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/Reuqest")
public class RequestController extends BaseController {

    @Inject
    private RequestService service;

    @RequestMapping(value = "selectH", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectH(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectH(param));
    }

    @RequestMapping(value = "selectD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectD(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectD(param));
    }

    @RequestMapping(value = "update", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse update(@RequestBody HashMap<String, Object> param) {
        service.update(param);
        return ok();
    }
}

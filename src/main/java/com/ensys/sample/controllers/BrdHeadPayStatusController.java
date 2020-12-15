package com.ensys.sample.controllers;

import java.util.HashMap;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.BrdHeadPayStatus.BrdHeadPayStatusService;

@Controller
@RequestMapping(value = "/api/BrdHeadPayStatus")
public class BrdHeadPayStatusController extends BaseController {

    @Inject
    private BrdHeadPayStatusService service;

    @RequestMapping(value = "select", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse select(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.select(param));
    }

    @RequestMapping(value = "selectDtl", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectDtl(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectDtl(param));
    }
}

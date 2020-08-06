package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Categorym.CategorymService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/Categorym")
public class CategorymController extends BaseController {

    @Inject
    private CategorymService service;

    @RequestMapping(value = "getBrcode", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getCategory(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.getBrcode(param));
    }

    @RequestMapping(value = "getParentBrcode", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getParentBrcode(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.getParentBrcode(param));
    }


    @RequestMapping(value = "categorymSearchMain", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse categorymSearchMain(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.categorymSearchMain(param));
    }

    @RequestMapping(value = "save", method =  {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse save(@RequestBody HashMap<String, Object> param) throws Exception {
        service.saveAll(param);
        return ok();
    }


}
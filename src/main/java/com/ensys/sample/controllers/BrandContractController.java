package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.BrandContract.BrandContractService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/BrandContract")
public class BrandContractController extends BaseController {

    @Inject
    private BrandContractService service;

    @RequestMapping(value = "selectH", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectH(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectH(param));
    }

    @RequestMapping(value = "selectD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectD(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectD(param));
    }
    
    @RequestMapping(value = "selectD2", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectD2(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectD2(param));
    }

    @RequestMapping(value = "S_1", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse S_1(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.S_1(param));
    }

    @RequestMapping(value = "S_2", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse S_2(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.S_2(param));
    }

    @RequestMapping(value = "S_3", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse S_3(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.S_3(param));
    }

    @RequestMapping(value = "save", method =  {RequestMethod.POST}, produces = APPLICATION_JSON)
    public ApiResponse save(@RequestBody HashMap<String, Object> param) throws Exception {
        service.saveAll(param);
        return ok();
    }

    @RequestMapping(value = "contract_cancel", method =  {RequestMethod.POST}, produces = APPLICATION_JSON)
    public ApiResponse contract_cancel(@RequestBody HashMap<String, Object> param) throws Exception {
        service.contract_cancel(param);
        return ok();
    }
    
    
    ////////////////////////////////////////////
    
    @RequestMapping(value = "selectH_B", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectH_B(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectH_B(param));
    }
    
    @RequestMapping(value = "selectD_B", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectD_B(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectD_B(param));
    }

}
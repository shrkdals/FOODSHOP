package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Brandm.BrandmService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/Brandm")
public class BrandmController extends BaseController {

    @Inject
    private BrandmService service;

    @RequestMapping(value = "getBrCode", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getbrCode(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.getBrCode_service(param));
    }

    @RequestMapping(value = "selectBrandM", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectBrandM(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectBrandM(param));
    }

    @RequestMapping(value = "selectBrandMenu", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectBrandMenu(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectBrandMenu(param));
    }

    @RequestMapping(value = "selectBrandPredicSaleM", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectBrandPredicSaleM(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectBrandPredicSaleM(param));
    }

    @RequestMapping(value = "selectBrandPredicSaleD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectBrandPredicSaleD(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectBrandPredicSaleD(param));
    }

    @RequestMapping(value = "selectBrandBeginItem", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectBrandBeginItem(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectBrandBeginItem(param));
    }

    @RequestMapping(value = "selectBrandItemCategory", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectBrandItemCategory(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectBrandItemCategory(param));
    }
    
    @RequestMapping(value = "save", method =  {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse save(@RequestBody HashMap<String, Object> param) throws Exception {
        service.saveAll(param);
        return ok();
    }


}
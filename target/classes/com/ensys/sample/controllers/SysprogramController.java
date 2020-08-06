package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Sysprogram.Sysprogram;
import com.ensys.sample.domain.Sysprogram.SysprogramVO;
import com.ensys.sample.domain.Sysprogram.SysprogramService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.List;

@Controller
@RequestMapping(value = "/api/v1/Sysprogram")
public class SysprogramController extends BaseController {

    @Inject
    private SysprogramService menuService;



    @RequestMapping(value = "progList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse progList(Sysprogram requestParams) {
        List<Sysprogram> list = menuService.progSelect(requestParams);
        return Responses.ListResponse.of(list);
    }


    @RequestMapping(value = "seveProg", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse saveProg(@RequestBody List<Sysprogram> request) {
        menuService.saveProg(request);
        return ok();
    }









}
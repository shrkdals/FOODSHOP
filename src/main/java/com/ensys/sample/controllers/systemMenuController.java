package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.newMenu.newMenu;
import com.ensys.sample.domain.newMenu.newMenuVO;
import com.ensys.sample.domain.newMenu.newMenuService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.List;

@Controller
@RequestMapping(value = "/api/newMenu")
public class systemMenuController extends BaseController {

    @Inject
    private newMenuService menuService;

    @RequestMapping(value = "menuList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse menuList(newMenu requestParams) {
        List<newMenu> list = menuService.menuSelect(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "progList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse progList(newMenu requestParams) {
        List<newMenu> list = menuService.progSelect(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "seveMenu", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse saveMenu(@RequestBody newMenuVO request) {
        menuService.saveMenu(request.getListM(),request.getListD());
        return ok();
    }


    @RequestMapping(value = "seveProg", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse saveProg(@RequestBody List<newMenu> request) {
        menuService.saveProg(request);
        return ok();
    }









}
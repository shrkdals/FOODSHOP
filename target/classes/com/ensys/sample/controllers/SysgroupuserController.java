package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Sysgroupuser.Sysgroupuser;
import com.ensys.sample.domain.Sysgroupuser.SysgroupuserService;
import com.ensys.sample.domain.Sysgroupuser.SysgroupuserVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.List;

@Controller
@RequestMapping(value = "/api/v1/Sysgroupuser")
public class SysgroupuserController extends BaseController {

    @Inject
    private SysgroupuserService authGroupService;

    @RequestMapping(value = "groupMselect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse menuList(Sysgroupuser requestParams) {
        List<Sysgroupuser> list = authGroupService.groupMselect(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "groupDselect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse groupDselect(Sysgroupuser requestParams) {
        List<Sysgroupuser> list = authGroupService.groupDselect(requestParams);
        return Responses.ListResponse.of(list);
    }


    @RequestMapping(value = "seveAuthGroup", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse seveAuthGroup(@RequestBody SysgroupuserVO request) {
        authGroupService.saveAuthGroup(request.getListM(), request.getListD());
        return ok();
    }
}
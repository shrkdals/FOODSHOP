package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.authGroup.authGroup;
import com.ensys.sample.domain.authGroup.authGroupService;
import com.ensys.sample.domain.authGroup.authGroupVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.List;

@Controller
@RequestMapping(value = "/api/authGroup")
public class authGroupController extends BaseController {

    @Inject
    private authGroupService authGroupService;

    @RequestMapping(value = "groupMselect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse menuList(authGroup requestParams) {
        List<authGroup> list = authGroupService.groupMselect(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "groupDselect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse groupDselect(authGroup requestParams) {
        List<authGroup> list = authGroupService.groupDselect(requestParams);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "deptUserSelect", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse deptUserSelect(authGroup requestParams) {
        List<authGroup> list = authGroupService.deptUserSelect(requestParams);
        return Responses.ListResponse.of(list);
    }


    @RequestMapping(value = "seveAuthGroup", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse seveAuthGroup(@RequestBody authGroupVO request) {
        authGroupService.saveAuthGroup(request.getListM(),request.getListD());
        return ok();
    }


    @RequestMapping(value = "saveGroupD", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse saveGroupD(@RequestBody List<authGroup> request) {
        authGroupService.saveGroupD(request);
        return ok();
    }


    @RequestMapping(value = "saveDeptUser", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse saveDeptUser(@RequestBody List<authGroup> request) {
        authGroupService.saveDeptUser(request);
        return ok();
    }









}
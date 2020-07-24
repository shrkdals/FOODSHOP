package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.Sysmenu.Sysmenu;
import com.ensys.sample.domain.Sysmenu.SysmenuVO;
import com.ensys.sample.domain.Sysmenu.SysmenuService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/api/v1/Sysmenu")
public class SysmenuController extends BaseController {

    @Inject
    private SysmenuService menuService;

    @RequestMapping(value = "menuList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse menuList(RequestParams requestParams) {
        SessionUser user = SessionUtils.getCurrentUser();

        HashMap<String, Object> param = new HashMap<>();

        param.put("CD_COMPANY", user.getCdCompany());
        param.put("LEVEL", requestParams.getString("LEVEL", ""));
        param.put("PARENT_ID", requestParams.getString("PARENT_ID", ""));

        List<HashMap<String, Object>> list = menuService.menuSelect(param);

        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "seveMenu", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse saveMenu(@RequestBody HashMap<String, Object> request) {
        menuService.saveMenu(request);
        return ok();
    }

    @RequestMapping(value = "chkMenuId", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.MapResponse chkMenuId(@RequestBody HashMap<String, Object> param) {
        HashMap<String, Object> result = menuService.chkMenuId(param);
        return Responses.MapResponse.of(result);
    }


}
package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.Macode.Macode;
import com.ensys.sample.domain.Macode.MacodeDtl;
import com.ensys.sample.domain.Macode.MacodeVO;
import com.ensys.sample.domain.Macode.MacodeService;
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
@RequestMapping(value = "/api/v1/Macode")
public class MacodeController extends BaseController {

    @Inject
    private MacodeService MacodeService;

    @RequestMapping(value = "select", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse list(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("NM_FIELD", requestParams.getString("P_NM_FIELD", ""));

        List<HashMap<String, Object>> list = MacodeService.select(parameterMap);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "selectDtl", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse applist(RequestParams requestParams) {
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("CD_FIELD", requestParams.getString("P_CD_FIELD", ""));

        List<HashMap<String, Object>> list = MacodeService.selectDtl(parameterMap);
        return Responses.ListResponse.of(list);
    }


    @RequestMapping(value = "allsave", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse allsave(@RequestBody HashMap<String, Object> request) {
        MacodeService.save(request);
        return ok();
    }


}
package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.BbsNotice.BbsNoticeService;
import com.ensys.sample.domain.CommonUtility.CommonUtilityService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Controller
@RequestMapping(value = "/api/Bbs")
public class BbsController extends BaseController {
    @Inject
    private BbsNoticeService service;

    @Inject
    private fileService fileService;


    @RequestMapping(value = "selectList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse selectM(RequestParams request) {
        HashMap<String, Object> ParameterMap = null;
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        try {

            SessionUser user = SessionUtils.getCurrentUser();
            ParameterMap = new HashMap<String, Object>();

            ParameterMap.put("CD_COMPANY", user.getCdCompany());
            ParameterMap.put("BOARD_TYPE", request.getString("P_BOARD_TYPE", ""));
            ParameterMap.put("KEYWORD", request.getString("P_KEYWORD", ""));
            ParameterMap.put("CONDITION", request.getString("P_CONDITION", ""));
            ParameterMap.put("NOWPAGE", request.getString("P_NOWPAGE", ""));
            ParameterMap.put("PAGING_SIZE", request.getString("P_PAGING_SIZE", ""));
            ParameterMap.put("OPT", request.getString("P_OPT", ""));
            ParameterMap.put("SEQ", request.getString("P_SEQ", ""));

            result = service.selectList(ParameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "selectDetail", method = RequestMethod.GET, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse selectDetail(RequestParams request) {
        HashMap<String, Object> ParameterMap = null;
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        try {

            SessionUser user = SessionUtils.getCurrentUser();
            ParameterMap = new HashMap<String, Object>();

            ParameterMap.put("CD_COMPANY", user.getCdCompany());
            ParameterMap.put("BOARD_TYPE", request.getString("P_BOARD_TYPE", ""));
            ParameterMap.put("SEQ", request.getString("P_SEQ", ""));
            ParameterMap.put("OPT", request.getString("P_OPT", ""));

            result = service.selectDetail(ParameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "write", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse write(@RequestBody HashMap<String, Object> param) {

        HashMap<String, Object> result = new HashMap<String, Object>();
        try {

            result = service.write(param);
        } catch (Exception e) {
            result.put("chkVal", "Y");
            result.put("MSG", e);
            e.printStackTrace();
            return Responses.MapResponse.of(result);
        }
        return Responses.MapResponse.of(result);
    }

    @RequestMapping(value = "deleteWrite", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse deleteWrite(@RequestBody HashMap<String, Object> param) {
        HashMap<String, Object> returnMap = new HashMap<String, Object>();

        try {
            returnMap = service.deleteWrite(param);
        } catch (Exception e) {
            returnMap.put("MSG", "삭제 중 오류가 발생하였습니다.. \n " + e);
            returnMap.put("chkVal", "Y");
            e.printStackTrace();
        }
        return Responses.MapResponse.of(returnMap);
    }
}

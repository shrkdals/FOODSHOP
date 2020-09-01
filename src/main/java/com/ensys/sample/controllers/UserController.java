package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.Api;
import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.domain.user.User;
import com.ensys.sample.domain.user.UserService;
import com.ensys.sample.security.PasswordEncrypter;
import com.ensys.sample.utils.SessionUtils;
import net.sf.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

@Controller
@RequestMapping(value = "/api/v1/users")
public class UserController extends BaseController {

    @Inject
    private UserService userService;


    private PasswordEncrypter encrypter;

//    @RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON)
//    public Responses.ListResponse list(RequestParams<User> requestParams) {
//        List<User> users = userService.get(requestParams);
//        return Responses.ListResponse.of(users);
//    }

//    @RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON, params = "userCd")
//    public User get(RequestParams requestParams) {
//        return userService.getUser(requestParams);
//    }

    @RequestMapping(method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public ApiResponse save(@Valid @RequestBody List<User> users) throws Exception {
        userService.saveUser(users);
        return ok();
    }


    @RequestMapping(value = "chkPw", method = {RequestMethod.GET}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse chkPw(RequestParams param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        HashMap<String, Object> responseMap = new HashMap<String, Object>();

        HashMap<String, Object> parameterMap = null;
        String passWord = param.getString("passWord", "");

        try {
            parameterMap = new HashMap<String, Object>();
            parameterMap.put("CD_COMPANY", param.getString("cdCompany", ""));
            parameterMap.put("ID_USER", param.getString("idUser", ""));
            parameterMap.put("GROUP_CD", param.getString("groupCode", ""));

            result = userService.chkPw(parameterMap);


            if (result.get("PASS_WORD") != null && !"".equals(result.get("PASS_WORD"))) {

                if (passWord.equals(result.get("PASS_WORD"))) {
                    responseMap.put("PASS_WORD", passWord);
                } else if (PasswordEncrypter.VerifyHash(passWord, (String) result.get("PASS_WORD"))) {
                    responseMap.put("PASS_WORD", result.get("PASS_WORD"));
                } else {
                    responseMap.put("PASS_WORD", passWord);
                }
            } else {
                responseMap.put("PASS_WORD", "");
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("PASS_WORD", "");
            return Responses.MapResponse.of(responseMap);
        }
        return Responses.MapResponse.of(responseMap);
    }

    @RequestMapping(value = "findId", method = {RequestMethod.GET}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.ListResponse findId(RequestParams param) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();

        HashMap<String, Object> parameterMap = null;
        try {
            parameterMap = new HashMap<String, Object>();


            parameterMap.put("NAME", param.getString("P_NAME", ""));
            parameterMap.put("BIRTH", param.getString("P_BIRTH", ""));
            parameterMap.put("EMAIL", param.getString("P_EMAIL", ""));

            result = userService.findId(parameterMap);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(result);
    }

    @RequestMapping(value = "findPw", method = {RequestMethod.GET}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse findPw(RequestParams param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        HashMap<String, Object> parameterMap = null;
        String uuid = UUID.randomUUID().toString();
        uuid = uuid.substring(0, 5);
        String password = "";
        try {
            password = PasswordEncrypter.ComputeHash(uuid);
        } catch (Exception e) {
            result.put("CHKVAL", 'N');
            result.put("MSG", "비밀번호 암호화 중 에러가 발생하였습니다.\n" + e);
            e.printStackTrace();
            return Responses.MapResponse.of(result);
        }
        try {
            parameterMap = new HashMap<String, Object>();

            parameterMap.put("ID_USER", param.getString("P_ID_USER", ""));
            parameterMap.put("NAME", param.getString("P_NAME", ""));
            parameterMap.put("BIRTH", param.getString("P_BIRTH", ""));
            parameterMap.put("EMAIL", param.getString("P_EMAIL", ""));
            parameterMap.put("UUID", password);
            parameterMap.put("PASSWORD", uuid);

            result = userService.findPw(parameterMap);

        } catch (Exception e) {
            result.put("CHKVAL", 'N');
            result.put("MSG", "에러가 났습니다. \n" + e);
            e.printStackTrace();
            return Responses.MapResponse.of(result);
        }
        return Responses.MapResponse.of(result);
    }


    @RequestMapping(value = "USER_SEARCH", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse USER_SEARCH(@RequestBody HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD", user.getCdCompany());
        param.put("GROUP_CD", user.getCdGroup());
        param.put("USER_ID", user.getIdUser());
        List<HashMap<String, Object>> list = userService.USER_SEARCH(param);
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "USER_SAVE", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse USER_SAVE(@RequestBody HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD", user.getCdCompany());
        param.put("GROUP_CD", user.getCdGroup());
        param.put("USER_ID", user.getIdUser());
        userService.USER_SAVE(param);
        return ok();
    }

    @RequestMapping(value = "getYnPwClear", method = {RequestMethod.GET}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse getYnPwClear() {
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            result = userService.getYnPwClear();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.MapResponse.of(result);
    }

    @RequestMapping(value = "join", method = {RequestMethod.GET}, produces = APPLICATION_JSON)
    @ResponseBody
    public ApiResponse join(RequestParams param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("CD_COMPANY",param.getString("CD_COMPANY",null));
        result.put("P_ID_USER",param.getString("P_ID_USER",null));
        result.put("P_NAME",param.getString("P_NAME",null));
        result.put("P_PWD",param.getString("P_PWD",null));
        result.put("P_TEL",param.getString("P_TEL",null));
        result.put("P_EMAIL",param.getString("P_EMAIL",null));
        result.put("P_USER_TP",param.getString("P_USER_TP",null));

        userService.join(result);

        return ok();
    }

    @RequestMapping(value = "passwordModify", method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse passwordModify(@RequestBody HashMap<String, Object> request) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        String password = "";
        try {
            password = PasswordEncrypter.ComputeHash((String) request.get("PASS_WORD1"));
        } catch (Exception e) {
            result.put("CHKVAL", 'N');
            result.put("MSG", "비밀번호 암호화 중 에러가 발생하였습니다.\n" + e);
            e.printStackTrace();
            return Responses.MapResponse.of(result);
        }

        try {
            SessionUser user = SessionUtils.getCurrentUser();
            HashMap<String, Object> parameterMap = new HashMap<String, Object>();

            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("ID_USER", user.getIdUser());
            parameterMap.put("PASS_WORD1", password);
            parameterMap.put("PASS_WORD2", password);

            result = userService.passwordModify(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.MapResponse.of(result);
    }

    @RequestMapping(value = "ensysLoginChk", method = {RequestMethod.POST})
    public ModelAndView ensysLoginChk(HttpServletRequest req) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        ModelAndView mav = new ModelAndView();

        String uid = UUID.randomUUID().toString();

        mav.setViewName("/loginTest2");
        try {
            result = userService.ensysLoginChk(req.getParameter("NO_EMP"));
            if (result != null && result.size() > 0) {
                if (result.size() == 1) {
                    mav.addObject("cdCompany", result.get(0).get("CD_COMPANY"));
                    mav.addObject("cdGroup", result.get(0).get("CD_GROUP"));
                    mav.addObject("idUser", result.get(0).get("ID_USER"));
                    mav.addObject("passWord", result.get(0).get("PASS_WORD"));
                } else {
                    List<HashMap<String, Object>> data = new ArrayList<HashMap<String, Object>>();
//
                    for (HashMap<String, Object> item : result) {
                        HashMap<String, Object> dataItem = new HashMap<>();
                        dataItem.put("CD_COMPANY", item.get("CD_COMPANY"));
                        dataItem.put("NM_COMPANY", item.get("NM_COMPANY"));
                        dataItem.put("CD_GROUP", item.get("CD_GROUP"));
                        dataItem.put("NM_GROUP", item.get("NM_GROUP"));
                        dataItem.put("ID_USER", item.get("ID_USER"));
                        dataItem.put("NM_USER", item.get("NM_USER"));

                        data.add(dataItem);
                    }

                    HttpSession newSession = req.getSession();

                    JSONArray json = new JSONArray();
                    mav.addObject("resultList", JSONArray.fromObject(data));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mav;
    }

}

package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Gldocus.GldocusService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value = "/api/glDocuS")
public class GldocusController extends BaseController {

    @Inject
    private GldocusService Service;

    @RequestMapping(value = "getMasterList" , method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse MasterList(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** getMasterList : 전표조회상신관리 - 마스터 조회 API *** ]");
        System.out.println("[ ***  getMasterList PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }

        param.put("DT_START",param.get("DT_START").toString().replace("-",""));
        param.put("DT_END",param.get("DT_END").toString().replace("-",""));
        return Responses.ListResponse.of(Service.MasterList(param));
    }

    @RequestMapping(value = "getSelectList" , method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getSelectList(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** getMasterList : 전표조회상신관리 - 마스터 조회 API *** ]");
        System.out.println("[ ***  getMasterList PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        return Responses.ListResponse.of(Service.getSelectList(param));
    }

    @RequestMapping(value = "getDetailList" , method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getDetailList(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** getDetailList : 전표조회상신관리 - 디테일 조회 API *** ]");
        System.out.println("[ ***  getDetailList PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        return Responses.ListResponse.of(Service.DetailList(param));
    }

    @RequestMapping(value = "applyDocu" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse applyDocu(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 결의서 결재요청 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        Service.applyDocu(param);

        return ok();
    }

    @RequestMapping(value = "getNoDraft" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public Responses.MapResponse getNoDraft() {
        return Responses.MapResponse.of(Service.getNoDraft());
    }

    @RequestMapping(value = "applyInsert" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse applyInsert(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 결의서 결재요청 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        Service.applyInsert(param);
        return ok();
    }

    @RequestMapping(value = "TEST" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse TEST(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 결의서 결재요청 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        Service.TEST(param);
        return ok();
    }

    @RequestMapping(value = "docu_crud" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse docu_crud(@RequestBody Map<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 전표취소 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        Service.docu_crud(param);
        return ok();
    }
    //상신취소
    @RequestMapping(value = "applyCancel" , method = RequestMethod.POST , produces = APPLICATION_JSON)
    public ApiResponse applyCancel(@RequestBody HashMap<String, Object> param) {
        System.out.println("[ *** applyDocu : 전표조회상신관리 - 상신취소 API *** ]");
        System.out.println("[ ***  applyDocu PARAM INFO   *** ]");
        for (String mapkey : param.keySet()){
            System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+param.get(mapkey)+" *** ]");
        }
        Service.applyCancel(param);
        return ok();
    }

    @ResponseBody
    @RequestMapping(value = "/fileUpload", method = RequestMethod.POST)
    public List<HashMap<String, Object>> multiImageUpload(@RequestParam("fileInfo") List<MultipartFile> files) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String writeDate = sdf.format(date);

        String path = "C:\\image\\";
        for (MultipartFile file : files) {
            String rename = UUID.randomUUID().toString().replace("-","");
            String safeFile = path + rename;
            int pos = file.getOriginalFilename().lastIndexOf(".");

            System.out.println(file.getOriginalFilename());
            try {
                resultMap.put("FILE_NAME"   , file.getOriginalFilename().substring(0,pos));
                resultMap.put("FILE_RENAME" , rename);
                resultMap.put("FILE_BYTE"   , Long.valueOf(file.getBytes()[0]));
                resultMap.put("FILE_SIZE"   , file.getSize());
                resultMap.put("FILE_DATE"   , writeDate);
                resultMap.put("FILE_EXTSN"  , file.getOriginalFilename().substring(pos+1));
                result.add(resultMap);

                file.transferTo(new File(safeFile));
            } catch (IllegalStateException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        //실제로는 저장 후 이미지를 불러올 위치를 콜백반환하거나,
        //특정 행위를 유도하는 값을 주는 것이 옳은 것 같다.
        return result;

    }


}
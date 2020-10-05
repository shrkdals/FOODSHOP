package com.ensys.sample.controllers;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
@Controller
@RequestMapping(value = "/api/file")
public class fileController extends BaseController {

    @Inject
    private fileService service;

    @RequestMapping(value = "getFileData", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getFileData(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.getFileData(param));
    }
    
    @RequestMapping(value = "fileClear", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse fileClear(@RequestBody HashMap<String, Object> param) {
        service.fileClear(param);
        return ok();
    }

    @RequestMapping(value = "FileRead", method = RequestMethod.POST, produces = APPLICATION_JSON)       //  계정도움창
    public void FileRead(HttpServletRequest request, @RequestBody HashMap<String, Object> requestParams) {
        String FILE_PATH = request.getSession().getServletContext().getRealPath("/file");
        try {
            HashMap<String, Object> file = (HashMap<String, Object>) requestParams.get("file");

            File CHKf = new File(FILE_PATH + "/" + file.get("FILE_PATH") + "/" + file.get("FILE_NAME"));

            if (CHKf.isFile()) {
                System.out.println("OK 파일 있습니다.");
            } else {
                System.out.println("NO 파일 없습니다.");

                File oriFile = new File("/rahan2000/" + file.get("FILE_PATH") + "/" + file.get("FILE_NAME"));
                if (oriFile.isFile()) {
                    System.out.println("잇엉");
                    File copyFolder = new File(FILE_PATH);    //  복사될 폴더
                    //* 폴더가 없을 경우 생성*//*
                    if (!copyFolder.isDirectory()) {
                        copyFolder.mkdir();
                    }
                    String splitFilePath = (String) file.get("FILE_PATH");
                    String path = "";
                    for (int i = 0 ; i < splitFilePath.split("/").length; i ++){
                        if (i != 0){
                            path += "/";
                        }
                        path += splitFilePath.split("/")[i];
                        File files = new File(FILE_PATH + "/" + path);

                        if (!files.isDirectory()) {
                            files.mkdir();
                        }
                    }

                    File files = new File(FILE_PATH + "/" + path + "/original");
                    if (!files.isDirectory()) {
                        files.mkdir();
                    }

                    FileInputStream fis = new FileInputStream(oriFile); //읽을파일
                    FileOutputStream fos = new FileOutputStream(FILE_PATH + "/" + file.get("FILE_PATH") + "/" + file.get("FILE_NAME")); //복사할파일

                    FileChannel fic = fis.getChannel(); 
                    FileChannel foc = fos.getChannel();
                    foc.transferFrom(fic, 0, fic.size());

					/*
					 * ScatteringByteChannel sbc = fis.getChannel(); GatheringByteChannel gbc =
					 * fos.getChannel();
					 * 
					 * ByteBuffer bb = ByteBuffer.allocateDirect(1024);
					 * 
					 * while(sbc.read(bb) != -1){ bb.flip(); gbc.write(bb); bb.clear(); }
					 */
                    
                    //자원사용종료
                    fis.close();
                    fos.close();
                    
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "cropUpload", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    @ResponseBody
    public void cropUpload(@RequestPart("orgnFile") List<MultipartFile> orgnFile,
                           @RequestPart("cropFile") List<MultipartFile> cropFile,
                           @RequestPart("fileName") HashMap<String, Object> fileName) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            service.cropUpload(orgnFile, cropFile, fileName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "getFiDocuFile", method = RequestMethod.POST, produces = APPLICATION_JSON)       //  계정도움창
    public Responses.ListResponse getFiDocuFile(HttpServletRequest request, @RequestBody HashMap<String, Object> requestParams) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();


        try {

            parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
            parameterMap.put("NO_DOCU", requestParams.get("SEQ"));

            list = service.getFiDocuFile(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "BbsFileSearch", method = RequestMethod.POST, produces = APPLICATION_JSON)       //  계정도움창
    public Responses.ListResponse BbsFileSearch(HttpServletRequest request, @RequestBody HashMap<String, Object> requestParams) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
        HashMap<String, Object> parameterMap = new HashMap<String, Object>();


        try {

            parameterMap.put("CD_COMPANY", sessionUser.getCdCompany());
            parameterMap.put("BOARD_TYPE", requestParams.get("BOARD_TYPE"));
            parameterMap.put("SEQ", requestParams.get("SEQ"));

            list = service.BbsFileSearch(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(list);
    }

    @RequestMapping(value = "save", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    @ResponseBody
    public Responses.MapResponse save(@RequestPart("files") List<MultipartFile> images,
                                      @RequestPart("fileName") List<HashMap<String, Object>> fileName
    ) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            result = service.fileUpload(images, fileName);
        } catch (Exception e) {
            result.put("chkVal", "Y");
            result.put("MSG", "저장 중 오류가 발생하였습니다. \n" + e);

            e.printStackTrace();
            return Responses.MapResponse.of(result);
        }
        return Responses.MapResponse.of(result);
    }


    @RequestMapping(value = "downloadFile", method = {RequestMethod.POST}, produces = APPLICATION_JSON)
    @ResponseBody
    public void downloadFile(@RequestBody HashMap<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {


        try {

            //저장경로, 파일이름
        	System.out.println("/rahan2000/" + param.get("FILE_PATH") + "/" + param.get("FILE_NAME"));
        	
            File f = new File("/rahan2000/" + param.get("FILE_PATH") + "/" + param.get("FILE_NAME"));

            BufferedInputStream bis = null;

            BufferedOutputStream bos = null;

            byte[] b = new byte[4096];

            int read = 0;


            String fileExtention = (String) param.get("FILE_EXT");


            if (f.isFile()) {
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Accept-Ranges", "bytes");
                response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode((String) param.get("FILE_NAME"), "UTF-8") + ";");
                response.setHeader("Content-Transfer-Encoding", "binary;");
                response.setCharacterEncoding("UTF-8");


                switch (fileExtention) {

                    case "ppt":
                        response.setContentType("application/vnd.ms-powerpoint; charset=utf-8");
                        break;

                    case "pptx":
                        response.setContentType("application/vnd.openxmlformats-officedocument.presentationml.presentation; charset=utf-8");
                        break;

                    case "xls":
                        response.setContentType("application/vnd.ms-excel; charset=utf-8");
                        break;

                    case "xlsx":
                        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; charset=utf-8");
                        break;

                    case "doc":
                        response.setContentType("application/msword; charset=utf-8");
                        break;

                    case "docx":
                        response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document; charset=utf-8");
                        break;

                    case "pdf":
                        response.setContentType("application/pdf; charset=utf-8");
                        break;

                    default:
                        response.setContentType("application/octet-stream; charset=utf-8");
                        break;

                }

//	        	response.setContentType("application/octet-stream; charset=utf-8");

                response.setContentLength((int) f.length());//size setting


                try {

                    bis = new BufferedInputStream(new FileInputStream(f));
                    bos = new BufferedOutputStream(response.getOutputStream());

                    while ((read = bis.read(b)) != -1) {
                        bos.write(b, 0, read);
                    }

                    bis.close();
                    bos.flush();
                    bos.close();

                } catch (Exception e) {
                    e.printStackTrace();
//                    throw new EgovBizException(" 파일 생성 에러가 발생하였습니다.");

                } finally {

                    if (bis != null) {

                        bis.close();

                    }

                    //f.delete();

                }


            } else {
                System.out.println("파일이 잘못입니다");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}

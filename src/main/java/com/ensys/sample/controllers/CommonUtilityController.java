package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.CommonUtility.CommonUtilityService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/api/commonutility")
public class CommonUtilityController extends BaseController {

    @Inject
    public CommonUtilityService service;

    /**
     * 공통코드 API
     *
     * @PARAM : CD_COMPANY
     * @PARAM : CD_FIELD
     * RESULT : CD_SYSDEF , NM_SYSDEF
     */
    @RequestMapping(value = "getCodeDataList", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse getCommonCode(@RequestBody HashMap<String, Object> param) {
        System.out.println("[ *** CommonUtilityCode : 공통코드 API *** ]");
        System.out.println("[ ***  CommonUtilityCode PARAM INFO   *** ]");
        System.out.println("[ CD_COMPANY : " + param.get("CD_COMPANY") + " CD_FIELD : " + param.get("CD_FIELD") + " ]");
        return Responses.ListResponse.of(service.CommonCodeList(param));
    }

    @RequestMapping(value = "GETNO", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.MapResponse GETNO(@RequestBody HashMap<String, Object> param) {
        service.GETNO(param);
        return Responses.MapResponse.of(param);
    }

//    @RequestMapping(value = "tempMethod", method = RequestMethod.POST)
//    @ResponseBody
//    public ModelAndView tempMethod(@RequestParam HashMap<String, Object> param) {
    @RequestMapping(value = "tempMethod", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse tempMethod(@RequestBody HashMap<String, Object> param) {

//        ModelAndView mv = new ModelAndView();
//        HashMap<String, Object> item = new HashMap<>();
//        item.put("CD_FILED",param.get);
//        mv.addObject(service.tempMethod(param));
//        mv.setViewName("/joinMember");
        param.put("CD_COMPANY","1000");
        return Responses.ListResponse.of(service.tempMethod(param));
    }


    @RequestMapping(value = "checkMagam", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.MapResponse checkMagam(@RequestBody HashMap<String, Object> param) {
        System.out.println("[ *** CommonUtilityCode : 마감 월 체크 API *** ]");
        return Responses.MapResponse.of(service.checkMagam(param));
    }

    @ResponseBody
    @RequestMapping(value = "/excelUpload", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse excelUpload(@RequestParam("files") MultipartFile excelFile) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();

        try {
            XSSFWorkbook workbook = new XSSFWorkbook(excelFile.getInputStream());

            int rowindex = 0;
            int columnindex = 0;
            //시트 수 (첫번째에만 존재하므로 0을 준다)
            //만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
            XSSFSheet sheet = workbook.getSheetAt(0);
            //행의 수
            int rows = sheet.getPhysicalNumberOfRows();

            XSSFRow firstRow = sheet.getRow(0);
            int cells = firstRow.getPhysicalNumberOfCells();
            List<String> code = new ArrayList<String>();
            for (rowindex = 0; rowindex < rows; rowindex++) {
                //행을읽는다
                XSSFRow row = sheet.getRow(rowindex);
                if (row != null) {
                    /*//셀의 수
                    int cells = row.getPhysicalNumberOfCells();*/
                    HashMap<String, Object> resultMap = new HashMap<String, Object>();
                    for (columnindex = 0; columnindex <= cells; columnindex++) {
                        //셀값을 읽는다
                        XSSFCell cell = row.getCell(columnindex);
                        String value = "";
                        //셀이 빈값일경우를 위한 널체크
                        if (cell == null) {
                            continue;
                        } else {
                            //타입별로 내용 읽기
                            switch (cell.getCellType()) {
                                case XSSFCell.CELL_TYPE_FORMULA:
                                    value = cell.getCellFormula();
                                    break;
                                case XSSFCell.CELL_TYPE_NUMERIC:
                                    value = cell.getNumericCellValue() + "";
                                    break;
                                case XSSFCell.CELL_TYPE_STRING:
                                    value = cell.getStringCellValue() + "";
                                    break;
                                case XSSFCell.CELL_TYPE_BLANK:
                                    value = cell.getBooleanCellValue() + "";
                                    break;
                                case XSSFCell.CELL_TYPE_ERROR:
                                    value = cell.getErrorCellValue() + "";
                                    break;
                                default:
                                    value = "";
                                    break;
                            }
                        }
                        if (rowindex == 0) {
                            break;
                        } else if (rowindex == 1) {
                            code.add(value);
                        } else if (rowindex > 3) {    // 0 : 컬럼명, 1 : 컬럼코드, 2: 예제, 3: 안내
                            resultMap.put(code.get(columnindex), value);
                        }
                    }
                    if (resultMap.size() > 0) {
                        result.add(resultMap);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Responses.ListResponse.of(result);
    }


    @ResponseBody
    @RequestMapping(value = "/excelDown", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public void excelDown(HttpServletResponse response, @RequestBody HashMap<String, Object> param) throws
            Exception {
        try {
            File file = new File(getClass().getResource("/FILE/Excel/" + param.get("fileName") + ".xlsx").toURI());
            //저장경로, 파일이름

            BufferedInputStream bis = null;
            BufferedOutputStream bos = null;
            byte[] b = new byte[4096];
            int read = 0;

            if (file.isFile()) {
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Accept-Ranges", "bytes");
                response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("매출세금계산서발행요청", "UTF-8") + ";");
                response.setHeader("Content-Transfer-Encoding", "binary;");
                response.setCharacterEncoding("UTF-8");
                response.setContentType("application/vnd.ms-excel; charset=utf-8");
                response.setContentLength((int) file.length());//size setting
                try {
                    bis = new BufferedInputStream(new FileInputStream(file));
                    bos = new BufferedOutputStream(response.getOutputStream());

                    while ((read = bis.read(b)) != -1) {
                        bos.write(b, 0, read);
                    }
                    bis.close();
                    bos.flush();
                    bos.close();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (bis != null) {
                        bis.close();
                    }
                }
            } else {
                System.out.println("파일이 잘못입니다");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ResponseBody   // 동적 엑셀다운로드 기능
    @RequestMapping(value = "/excelDown2", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public void excelDown2(HttpServletResponse response, @RequestBody HashMap<String, Object> param) throws
            Exception {


        //getExcelList의 return type은 List타입의 제너릭은 SampleVO로 정함.
        //문자열 형식의 제목을 excelTtitle변수에 담는다(후에 split을 통해서 배열로 만들것임)
        //다운받을 파일명
        String downFileNm = "양식";
        XSSFWorkbook workbook = new XSSFWorkbook();
        //시트 생성
        XSSFSheet sheet = workbook.createSheet(downFileNm);

        // 첫번째 행에 각각의 컬럼 제목작성

        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) param.get("items");

        //스타일 설정
        XSSFCellStyle style = workbook.createCellStyle();

        Font font = workbook.createFont();

        font.setFontName("나눔고딕");
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);


        //정렬
        style.setAlignment(CellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        //테두리 라인
        style.setBorderRight(XSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
        style.setBorderTop(XSSFCellStyle.BORDER_THIN);
        style.setBorderBottom(XSSFCellStyle.BORDER_THIN);

        //배경색
        style.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
        style.setFillPattern(CellStyle.SOLID_FOREGROUND);


        //DB에서 조회한 목록데이터를 담은 LIST객체를 OBJECT타입으로 돌린다
        Row row0 = sheet.createRow(0);
        Row row1 = sheet.createRow(1);

        //VO종류가 무엇이든 상관없음?
        for (int i = 0; i < items.size(); i++) {


            //////////////////////////////////////////////////////////////////////////////////////////

            Cell cell0 = row0.createCell(i);
            font.setColor(IndexedColors.BLACK.getIndex());
            style.setFont(font);
            cell0.setCellStyle(style);
            cell0.setCellValue((String) items.get(i).get("label"));

            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + (short) 1024);

            if (items.get(i).get("desc") != null && !items.get(i).get("desc").equals("")) {

                Drawing drawing = cell0.getSheet().createDrawingPatriarch();
                //메모크기(0,0,0,0,col,row,col,row)
                ClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0, 5, 10, 15, 15);

                Comment comment = drawing.createCellComment(anchor);
                comment.setVisible(false);  //  숨김, 보임
                RichTextString textString = new XSSFRichTextString((String) items.get(i).get("desc"));//메모내용
                comment.setString(textString);
                cell0.setCellComment(comment);
            }

            Cell cell1 = row1.createCell(i);
            font.setColor(IndexedColors.RED.getIndex());
            style.setFont(font);
            cell1.setCellStyle(style);
            cell1.setCellValue((String) items.get(i).get("key"));

            ////////////////////////////////////////////////////////////////////////////////
        }


        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");

        // 엑셀 출력
        workbook.write(response.getOutputStream());
        workbook.close();

    }

    private String exe(String fileName) {
        int fileNameExtensionIndex = fileName.lastIndexOf('.') + 1;
        String fileNameExtension = fileName.toLowerCase().substring(fileNameExtensionIndex, fileName.length());
        return fileNameExtension;
    }
}



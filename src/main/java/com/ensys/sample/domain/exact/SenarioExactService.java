package com.ensys.sample.domain.exact;

import com.ensys.sample.controllers.Employee;
import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.common.MailSenderService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class SenarioExactService extends BaseService {
    @Inject
    private SenarioExactMapper senarioExactMapper;

    @Inject
    private com.ensys.sample.domain.file.fileService fileService;


    public List<HashMap<String, Object>> getData(HashMap<String, Object> param) {
        return senarioExactMapper.getData(param);
    }

    public List<HashMap<String, Object>> getChartData(HashMap<String, Object> param) {
        return senarioExactMapper.getChartData(param);
    }

    public List<HashMap<String, Object>> getDetailData(HashMap<String, Object> param) {
        return senarioExactMapper.getDetailData(param);
    }

    public List<HashMap<String, Object>> getReportData(HashMap<String, Object> param) {
        return senarioExactMapper.getReportData(param);
    }

    @Transactional
    public void notifyInsert(HashMap<String, Object> request) {
        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) request.get("gridData");
        HashMap<String, Object> fileData = (HashMap<String, Object>) request.get("fileData");
        HashMap<String, Object> p_file = new HashMap<String, Object>();
        List<HashMap<String, Object>> re_file = new ArrayList<HashMap<String, Object>>();

        SessionUser user = SessionUtils.getCurrentUser();
        for (HashMap<String, Object> item : items) {

            HashMap<String, Object> parameterMap = new HashMap<String, Object>();

            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("C_CODE", item.get("C_CODE"));
            parameterMap.put("ACCT_NO", item.get("ACCT_NO"));
            parameterMap.put("BANK_CODE", item.get("BANK_CODE"));
            parameterMap.put("TRADE_DATE", item.get("TRADE_DATE"));
            parameterMap.put("TRADE_TIME", item.get("TRADE_TIME"));
            parameterMap.put("SEQ", item.get("SEQ"));
            parameterMap.put("NO_SENARIO", item.get("NO_SENARIO"));
            parameterMap.put("NOTIFY_SEQ", item.get("NOTIFY_SEQ"));
            parameterMap.put("SEND_CDEMP", item.get("SEND_CDEMP"));
            parameterMap.put("SEND_NMEMP", item.get("SEND_NMEMP"));
            parameterMap.put("NOTIFY_CDEMP", item.get("NOTIFY_CDEMP"));
            parameterMap.put("NOTIFY_NMEMP", item.get("NOTIFY_NMEMP"));
            parameterMap.put("TITLE", item.get("TITLE"));
            parameterMap.put("CONTENT", item.get("CONTENT"));
            parameterMap.put("ID_INSERT", user.getIdUser());
            parameterMap.put("ID_UPDATE", user.getIdUser());

            senarioExactMapper.notifyInsert(parameterMap);
            if (fileData != null) {
                fileService.BbsFileModify("senario", item.get("NOTIFY_SEQ").toString(), fileData);
            }

            p_file.put("CD_COMPANY", user.getCdCompany());
            p_file.put("BOARD_TYPE", "senario");
            p_file.put("SEQ", item.get("NOTIFY_SEQ"));


            re_file = fileService.BbsFileSearch(p_file);


            MailSenderService mailSender = new MailSenderService();

            MailSenderService.sendMail("un2238@naver.com",item.get("TITLE").toString(), item.get("CONTENT").toString(), re_file);


        }
    }

    @Transactional
    public HashMap<String, Object> actionInsert(HashMap<String, Object> request) {
        List<HashMap<String, Object>> items = (List<HashMap<String, Object>>) request.get("gridData");
        HashMap<String, Object> fileData = (HashMap<String, Object>) request.get("fileData");
        HashMap<String, Object> p_file = new HashMap<String, Object>();
        List<HashMap<String, Object>> re_file = new ArrayList<HashMap<String, Object>>();

        SessionUser user = SessionUtils.getCurrentUser();
        String BOARD_TYPE = "action";
        HashMap<String, Object> result = new HashMap<String, Object>();

        for (HashMap<String, Object> item : items) {

            HashMap<String, Object> parameterMap = new HashMap<String, Object>();

            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("C_CODE", item.get("C_CODE"));
            parameterMap.put("ACCT_NO", item.get("ACCT_NO"));
            parameterMap.put("BANK_CODE", item.get("BANK_CODE"));
            parameterMap.put("TRADE_DATE", item.get("TRADE_DATE"));
            parameterMap.put("TRADE_TIME", item.get("TRADE_TIME"));
            parameterMap.put("SEQ", item.get("SEQ"));
            parameterMap.put("NO_SENARIO", item.get("NO_SENARIO"));
            parameterMap.put("ACTION_SEQ", item.get("ACTION_SEQ"));
            parameterMap.put("EXPLAN_CDEMP", item.get("EXPLAN_CDEMP"));
            parameterMap.put("EXPLAN_NMEMP", item.get("EXPLAN_NMEMP"));
            parameterMap.put("ACTION_CDEMP", item.get("ACTION_CDEMP"));
            parameterMap.put("ACTION_NMEMP", item.get("ACTION_NMEMP"));
            parameterMap.put("TITLE", item.get("TITLE"));
            parameterMap.put("CONTENT", item.get("CONTENT"));
            parameterMap.put("ID_INSERT", user.getIdUser());
            parameterMap.put("ID_UPDATE", user.getIdUser());


            System.out.println("actionInsert");
            senarioExactMapper.actionInsert(parameterMap);
            System.out.println("fileInsert");
            if (fileData != null) {
                fileService.BbsFileModify("senario", item.get("ACTION_SEQ").toString(), fileData);
            }
//            result = fileService.fileUpload(FILE_PATH, images, BOARD_TYPE, (String) item.get("ACTION_SEQ"));

            p_file.put("CD_COMPANY", user.getCdCompany());
            p_file.put("BOARD_TYPE", BOARD_TYPE);
            p_file.put("SEQ", item.get("ACTION_SEQ"));

        }
        return result;
    }

    public HashMap<String, Object> getSeq(HashMap<String, Object> request) {
        SessionUser user = SessionUtils.getCurrentUser();
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
            Calendar c1 = Calendar.getInstance();
            String strToday = sdf.format(c1.getTime());

            HashMap<String, Object> parameterMap = new HashMap<String, Object>();
            parameterMap.put("CD_COMPANY", user.getCdCompany());

            result = senarioExactMapper.getSeq(parameterMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private List<Employee> empList = Arrays.asList(
            new Employee("01", "이재옥", "이재옥", "1212", "12121"),
            new Employee("01", "이재옥", "이재옥", "13312", "1333"),
            new Employee("01", "이재옥", "이재옥", "4545", "12121"),
            new Employee("01", "이재옥", "이재옥", "56565", "12121"));

    /*
     *
     * */
    public String generateReport(List<HashMap<String, Object>> list, HashMap<String, Object> map, String reportName) {
        try {
            File file = new File("../");
            String Path = this.getClass().getResource("/").getPath();
            String outPutFileName = "";
            String reportPath = "";
            if(map.get("FLAG").toString().equals("LOCAL")){
                reportPath = Path.substring(0,Path.length()-16)+"assets/report/web/";
            }else{
                reportPath = "C:\\Program Files (x86)\\Apache Software Foundation\\Tomcat 9.0_Tomcat9_qray\\webapps\\ROOT\\assets\\report\\web\\";
            }

            // Compile the Jasper report from .jrxml to .japser
            JasperReport jasperReport = JasperCompileManager.compileReport(reportPath + reportName + ".jrxml");

            // Get your data source
            JRBeanCollectionDataSource jrBeanCollectionDataSource = new JRBeanCollectionDataSource(list);


            // Fill the report
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, map,
                    jrBeanCollectionDataSource);


            // Export the report to a PDF file
            //  outPutFileName =  "PDF_" + System.currentTimeMillis();

            outPutFileName = "PDF_" + System.currentTimeMillis();

            JasperExportManager.exportReportToPdfFile(jasperPrint, reportPath + outPutFileName + ".pdf");

            /*String html = JasperExportManager.exportReportToHtmlFile(reportPath + outPutFileName + ".pdf");

            System.out.println(html);*/

            System.out.println("Done");

            return outPutFileName;

        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }


    public String sendEmail(List<HashMap<String, Object>> list,  String reportName, HashMap<String, Object> param) {
        try {
            File file = new File("../");
            String Path = this.getClass().getResource("/").getPath();
            String outPutFileName = "";
            String reportPath = "";
            if(param.get("FLAG").toString().equals("LOCAL")){
                reportPath = Path.substring(0,Path.length()-16)+"assets/report/web/";
            }else{
                reportPath = "C:\\Program Files (x86)\\Apache Software Foundation\\Tomcat 9.0_Tomcat9_qray\\webapps\\ROOT\\assets\\report\\web\\";
            }

            // Compile the Jasper report from .jrxml to .japser
            JasperReport jasperReport = JasperCompileManager.compileReport(reportPath + reportName + ".jrxml");

            // Get your data source
            JRBeanCollectionDataSource jrBeanCollectionDataSource = new JRBeanCollectionDataSource(list);


            // Fill the report
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, param,
                    jrBeanCollectionDataSource);

            outPutFileName = "PDF_" + System.currentTimeMillis();

            JasperExportManager.exportReportToPdfFile(jasperPrint, reportPath + outPutFileName + ".pdf");
            String[] array_addr = null;
            String mailAddr = "";
            if (param.get("MAIL_ADDR") != null) {
                mailAddr = param.get("MAIL_ADDR").toString();
                array_addr = mailAddr.split(":");
            }


            List<HashMap<String, Object>> re_file = new ArrayList<HashMap<String, Object>>();

            HashMap<String, Object> fileData = new HashMap<String, Object>();
            fileData.put("FILE_EXT", "pdf");
            fileData.put("FILE_NAME", outPutFileName);
            fileData.put("FILE_PATH", reportPath);
            re_file.add(fileData);


            for (int i = 0; i < array_addr.length; i++) {
                MailSenderService mailSender = new MailSenderService();

                MailSenderService.sendMail(array_addr[i],param.get("TITLE").toString(), param.get("CONTENT").toString(), re_file);
            }


            return outPutFileName;

        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }
}

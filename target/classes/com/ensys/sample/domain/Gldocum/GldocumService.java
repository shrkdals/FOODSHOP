package com.ensys.sample.domain.Gldocum;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GldocumService extends BaseService {

    @Inject
    private GldocumMapper disbDocsMapper;

    @Inject
    private fileService fileService;


    public List<HashMap<String, Object>> getHeaderList(HashMap<String, Object> up) {
        return disbDocsMapper.getHeaderList(up);
    }

    public List<HashMap<String, Object>> getDetailList(HashMap<String, Object> up) {
        return disbDocsMapper.getDetailList(up);
    }

    public List<HashMap<String, Object>> tpdocuAcct(HashMap<String, Object> up) {
        return disbDocsMapper.tpdocuAcct(up);

    }

    public List<Map<String, Object>> ccAddRow(Map<String, Object> param) {
        return disbDocsMapper.ccAddRow(param);
    }

    public Map<String, Object> getTpDocu() {
        SessionUser user = SessionUtils.getCurrentUser();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CD_COMPANY", user.getCdCompany());
        return disbDocsMapper.getTpDocu(map);

    }

    public Map<String, Object> getRtExch(Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("CD_COMPANY", user.getCdCompany());
        map.put("CD_EXCH", param.get("CD_EXCH"));
        map.put("DT_TARGET", param.get("DT_TARGET"));

        return disbDocsMapper.getRtExch(map);

    }


    @Transactional
    public String dataProcess(Map<String, Object> param) {
        List<Map<String, Object>> header = (List<Map<String, Object>>) param.get("header");
        List<Map<String, Object>> gridDetailLeft = (List<Map<String, Object>>) param.get("gridDetailLeft");
        List<Map<String, Object>> gridDetailRight = (List<Map<String, Object>>) param.get("gridDetailRight");
        List<HashMap<String, Object>> benefitList = (List<HashMap<String, Object>>) param.get("benefitList");
        HashMap<String, Object> fileData = (HashMap<String, Object>) param.get("file");
        List<HashMap<String, Object>> filelist = new ArrayList<HashMap<String, Object>>();

        SessionUser user = SessionUtils.getCurrentUser();

        Map<String, Object> map = new HashMap();
        map.put("CD_COMPANY", user.getCdCompany());
        map.put("CD_PC", user.getCdPc());
        map.put("cdDept", param.get("cdDept"));
        map.put("cdEmp", param.get("cdEmp"));
        map.put("dtAcct", param.get("dtAcct"));
        map.put("remark", param.get("remark"));
        map.put("tp_gb", param.get("tp_gb"));  //  유형
        map.put("etcdocu", param.get("etcdocu"));
        map.put("ID_INSERT", user.getIdUser());

        String group_number = disbDocsMapper.insertDocu(map);

        if (fileData != null) {
            fileService.BbsFileModify("DOCU", group_number, fileData);
        }
        HashMap<String, Object> file = new HashMap<>();

        file.put("CD_COMPANY", user.getCdCompany());
        file.put("BOARD_TYPE", "DOCU");
        file.put("SEQ", group_number);

        filelist.addAll(fileService.BbsFileSearch(file));

        for (Map<String, Object> obj : header) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("cdDept", param.get("cdDept"));
            obj.put("dtAcct", param.get("dtAcct"));
            obj.put("ID_INSERT", user.getIdUser());
            obj.put("dtTrans", chkDate((String) obj.get("dtTrans")));
            /*
            for (String mapkey : obj.keySet()){
                System.out.println("[ *** KEY : " + mapkey + " || VALUE : "+obj.get(mapkey)+" *** ]");
            }
            */
            disbDocsMapper.insertPusaiv(obj);
        }

        int index = 1;
        for (Map<String, Object> obj : gridDetailLeft) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("tpDrCr", obj.get("tpDrCr"));
            obj.put("SEQ", String.valueOf(index++));
            obj.put("ID_INSERT", user.getIdUser());

            disbDocsMapper.insertAcctent(obj);
        }

        index = 1;
        for (Map<String, Object> obj : gridDetailRight) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("tpDrCr", obj.get("tpDrCr"));
            obj.put("SEQ", String.valueOf(index++));
            obj.put("ID_INSERT", user.getIdUser());
            disbDocsMapper.insertAcctent(obj);
        }

        if (benefitList != null && benefitList.size() > 0) {
            for (HashMap<String, Object> item : benefitList) {

                item.put("CD_COMPANY", user.getCdCompany());
                item.put("GROUP_NUMBER", group_number);

                if (item.get("__created__") != null) {
                    if (item.get("__created__").toString() == "true") {
                        disbDocsMapper.insertBenefit(item);
                    }
                }
            }
        }

        Map<String, String> fimap = new HashMap();
        fimap.put("CD_COMPANY", user.getCdCompany());
        fimap.put("CD_PC", user.getCdPc());
        fimap.put("ID_WRITE", (String) param.get("cdEmp"));
        fimap.put("CD_WDEPT", (String) param.get("cdDept"));
        fimap.put("ID_USER", user.getIdUser());
        fimap.put("GROUP_NUMBER", group_number);
        fimap.put("DT_ACCT", (String) param.get("dtAcct"));
        fimap.put("ST_DOCU", "1");

        String no_docu = disbDocsMapper.insertFiDocu(fimap);

        for (HashMap<String, Object> obj : filelist) {

            fileService.copyfidocuFile(obj, user.getCdCompany(), no_docu);

            obj.put("NO_DOCU", no_docu);
            obj.put("NO_SEQ", obj.get("SEQ_FILE"));
            obj.put("CD_PC", user.getCdPc());
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("FILE_PATH", "/shared/Download/FI/" + user.getCdCompany() + "/" + no_docu + "/");
            obj.put("FILE_NAME", obj.get("ORGN_FILE_NAME"));
            obj.put("ID_INSERT", user.getIdUser());
            obj.put("ID_UPDATE", user.getIdUser());
            obj.put("FILE_SIZE", obj.get("FILE_BYTE"));
            obj.put("YN_GW", "");

            disbDocsMapper.fi_docu_file_i(obj);

        }

        return group_number;
    }

    @Transactional
    public String dataProcessBan(Map<String, Object> param) {
        List<Map<String, Object>> header = (List<Map<String, Object>>) param.get("header");
        List<Map<String, Object>> gridDetailLeft = (List<Map<String, Object>>) param.get("gridDetailLeft");
        List<Map<String, Object>> gridDetailRight = (List<Map<String, Object>>) param.get("gridDetailRight");
        List<HashMap<String, Object>> benefitList = (List<HashMap<String, Object>>) param.get("benefitList");


        SessionUser user = SessionUtils.getCurrentUser();

        Map<String, Object> map = new HashMap();
        map.put("CD_COMPANY", user.getCdCompany());
        map.put("CD_PC", user.getCdPc());
        map.put("cdDept", param.get("cdDept"));
        map.put("cdEmp", param.get("cdEmp"));
        map.put("dtAcct", param.get("dtAcct"));
        map.put("remark", param.get("remark"));
        map.put("tp_gb", param.get("tp_gb"));  //  유형
        map.put("etcdocu", param.get("etcdocu"));
        map.put("ID_INSERT", user.getIdUser());

        String group_number = disbDocsMapper.insertDocu(map);

        for (Map<String, Object> obj : header) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("cdDept", param.get("cdDept"));
            obj.put("cdEmp", param.get("cdEmp"));
            obj.put("dtAcct", param.get("dtAcct"));
            obj.put("ID_INSERT", user.getIdUser());
            obj.put("dtTrans", chkDate((String) obj.get("dtTrans")));
            disbDocsMapper.insertPusaiv(obj);
        }

        int index = 1;
        for (Map<String, Object> obj : gridDetailLeft) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("tpDrCr", obj.get("tpDrCr"));
            obj.put("SEQ", String.valueOf(index++));
            obj.put("ID_INSERT", user.getIdUser());

            disbDocsMapper.insertAcctent(obj);
        }

        index = 1;
        for (Map<String, Object> obj : gridDetailRight) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("tpDrCr", obj.get("tpDrCr"));
            obj.put("SEQ", String.valueOf(index++));
            obj.put("ID_INSERT", user.getIdUser());
            disbDocsMapper.insertAcctent(obj);
        }

        Map<String, String> fimap = new HashMap();
        fimap.put("CD_COMPANY", user.getCdCompany());
        fimap.put("CD_PC", user.getCdPc());
        fimap.put("ID_WRITE", (String) param.get("cdEmp"));
        fimap.put("CD_WDEPT", (String) param.get("cdDept"));
        fimap.put("ID_USER", user.getIdUser());
        fimap.put("GROUP_NUMBER", group_number);
        fimap.put("DT_ACCT", (String) param.get("dtAcct"));
        fimap.put("ST_DOCU", "1");

        disbDocsMapper.insertFiDocuBan(fimap);

        return group_number;
    }

    public Map<String, Object> getMngd(Map<String, Object> item) {
        return disbDocsMapper.getMNGD(item);
    }

    public Map<String, Object> getAutoMngd(Map<String, Object> item) {
        return disbDocsMapper.getAutoMngd(item);
    }

    private String chkDate(String date) {
        if (date != null) {
            return date.replace("-", "");
        }
        return date;
    }

    public HashMap<String, Object> getAcctcode(Map<String, Object> map) {
        return disbDocsMapper.getAcctcode(map);
    }

    @Transactional
    public String receptInsert(Map<String, String> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        param.put("CD_PC", user.getCdPc());
        if (param.get("GUBUN").equals('1')) {
            param.put("GUBUN", "1");
        } else {
            param.put("GUBUN", "2");
        }


        return disbDocsMapper.receptInsert(param);
    }

    public Map<String, Object> getRecept(Map<String, Object> map) {
        return disbDocsMapper.getRecept(map);
    }

    public List<Map<String, Object>> getTaxBillList(Map<String, Object> map) {
        return disbDocsMapper.getTaxBillList(map);

    }

    public Map<String, Object> getBnftAmt(HashMap<String, Object> param) {  //  편익누적금액 가져오기
        return disbDocsMapper.getBnftAmt(param);
    }

    public List<HashMap<String, Object>> getDocuCopy(HashMap<String, Object> param) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        result = disbDocsMapper.getDocuCopy(param);
        return result;
    }

    public List<HashMap<String, Object>> getDocuPusaivCopy(HashMap<String, Object> param) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        result = disbDocsMapper.getDocuPusaivCopy(param);
        return result;
    }

    public List<HashMap<String, Object>> getDocuAcctentCopy(HashMap<String, Object> param) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        SessionUser user = SessionUtils.getCurrentUser();

        HashMap<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("GROUP_NUMBER", param.get("P_GROUP_NUMBER"));
        parameterMap.put("NO_TPDOCU", param.get("P_NO_TPDOCU"));

        result = disbDocsMapper.getDocuAcctentCopy(parameterMap);

        return result;
    }

    public HashMap<String, Object> getchkValidate(HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());

        result = disbDocsMapper.getchkValidate(param);
        return result;
    }

    public HashMap<String, Object> acctBanCheck(HashMap<String, Object> map) {
        return disbDocsMapper.acctBanCheck(map);

    }

    public List<HashMap<String, Object>> getBanjanList(HashMap<String, Object> map) {
        return disbDocsMapper.getBanjanList(map);
    }

    public List<HashMap<String, Object>> getBanList(HashMap<String, Object> map) {
        return disbDocsMapper.getBanList(map);
    }
}
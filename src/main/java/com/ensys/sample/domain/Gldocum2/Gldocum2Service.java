package com.ensys.sample.domain.Gldocum2;


import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.CommonCodeUtils;
import com.ensys.sample.utils.SessionUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class Gldocum2Service extends BaseService {

    @Inject
    private Gldocum2Mapper disbDocsMapper;

    @Inject
    private com.ensys.sample.domain.file.fileService fileService;


    public List<HashMap<String, Object>> getHeaderList(HashMap<String, Object> up) {
        return disbDocsMapper.getHeaderList(up);
    }

    public HashMap<String, Object> getDetailList(HashMap<String, Object> up) {
        HashMap<String, Object> result = new HashMap<>();

        up.put("GB", "1");
        List<HashMap<String, Object>> GRID_DR = disbDocsMapper.getDetailList(up);

        up.put("GB", "2");
        List<HashMap<String, Object>> GRID_CR = disbDocsMapper.getDetailList(up);

        result.put("GRID_DR", GRID_DR);
        result.put("GRID_CR", GRID_CR);
        return result;
    }

    public List<HashMap<String, Object>> tpdocuAcct(HashMap<String, Object> up) {
        return disbDocsMapper.tpdocuAcct(up);
    }

    @Transactional
    public HashMap<String, Object> saveimsi(HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        SessionUser user = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> data_h = (ArrayList<HashMap<String, Object>>) param.get("data_h");
        List<HashMap<String, Object>> data_l = (ArrayList<HashMap<String, Object>>) param.get("data_l");
        List<HashMap<String, Object>> data_r = (ArrayList<HashMap<String, Object>>) param.get("data_r");

        if (data_h != null && data_h.size() > 0) {
            for (HashMap<String, Object> item : data_h) {

                item.put("CD_COMPANY", user.getCdCompany());
                item.put("ID_USER", user.getIdUser());
                item.put("ID_WRITE", user.getNoEmp());
                item.put("CD_DEPT", user.getCdDept());
                item.put("ID_INSERT", user.getIdUser());
                item.put("DT_TRANS", chkDate((String) item.get("DT_TRANS")));


                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        disbDocsMapper.deletePusaivImsi(item);
                    }
                } else {
                    if (item.get("__created__") != null) {
                        if ((boolean) item.get("__created__")) {
                            disbDocsMapper.insertPusaivImsi(item);

                        }
                    } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                        if ((boolean) item.get("__modified__")) {
                            disbDocsMapper.updatePusaivImsi(item);
                        }
                    }

                    if (item.get("BENEFIT") != null) {
                        List<HashMap<String, Object>> benefitList = (ArrayList<HashMap<String, Object>>) item.get("BENEFIT");

                        disbDocsMapper.deleteBenefit(item);

                        for (HashMap<String, Object> benefitItem : benefitList) {

                            benefitItem.put("CD_COMPANY", user.getCdCompany());
                            benefitItem.put("GROUP_NUMBER", item.get("GROUP_NUMBER"));

                            disbDocsMapper.insertBenefit(benefitItem);
                        }
                    }
                    if (item.get("fileData") != null) {
                        fileService.BbsFileModify("DOCU", (String) item.get("GROUP_NUMBER"), (HashMap<String, Object>) item.get("fileData"));
                    }

                }
            }
        }

        if (data_l != null && data_l.size() > 0) {
            for (HashMap<String, Object> item : data_l) {
                item.put("CD_COMPANY", user.getCdCompany());
                item.put("ID_USER", user.getIdUser());
                item.put("ID_WRITE", user.getNoEmp());
                item.put("CD_DEPT", user.getCdDept());
                item.put("ID_INSERT", user.getIdUser());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        disbDocsMapper.deleteAcctentImsi(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        item.put("CD_COMPANY", user.getCdCompany());
                        disbDocsMapper.insertAcctentImsi(item);

                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        item.put("CD_COMPANY", user.getCdCompany());
                        disbDocsMapper.updateAcctentImsi(item);
                    }
                }
            }
        }

        if (data_r != null && data_r.size() > 0) {
            for (HashMap<String, Object> item : data_r) {
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        item.put("CD_COMPANY", user.getCdCompany());
                        disbDocsMapper.deleteAcctentImsi(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        item.put("CD_COMPANY", user.getCdCompany());
                        disbDocsMapper.insertAcctentImsi(item);

                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        item.put("CD_COMPANY", user.getCdCompany());
                        disbDocsMapper.updateAcctentImsi(item);
                    }
                }
            }
        }

        return result;
    }


    public List<HashMap<String, Object>> getBenefit(Map<String, Object> param) {
        return disbDocsMapper.getBenefit(param);
    }

    public List<Map<String, Object>> ccAddRow(Map<String, Object> param) {
        return disbDocsMapper.ccAddRow(param);
    }

    public HashMap<String, Object> getGroupNumber() {
        SessionUser user = SessionUtils.getCurrentUser();
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            HashMap<String, Object> map = new HashMap();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
            Calendar c1 = Calendar.getInstance();
            String strToday = sdf.format(c1.getTime());

            HashMap<String, Object> parameterMap = new HashMap<String, Object>();
            parameterMap.put("CD_COMPANY", user.getCdCompany());
            parameterMap.put("CD_MODULE", "CZ");
            parameterMap.put("CD_CLASS", "14");
            parameterMap.put("DOCU_YM", strToday);

            disbDocsMapper.getSeq(parameterMap);
            result.put("GROUP_NUMBER", parameterMap.get("NO"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
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
        List<HashMap<String, Object>> header = (List<HashMap<String, Object>>) param.get("header");
        List<HashMap<String, Object>> gridDetailLeft = (List<HashMap<String, Object>>) param.get("gridDetailLeft");
        List<HashMap<String, Object>> gridDetailRight = (List<HashMap<String, Object>>) param.get("gridDetailRight");
        /*        HashMap<String, Object> fileData = (HashMap<String, Object>) param.get("file");*/
        List<HashMap<String, Object>> filelist = new ArrayList<HashMap<String, Object>>();
        SessionUser user = SessionUtils.getCurrentUser();

        Map<String, Object> map = new HashMap();
        map.put("CD_COMPANY", user.getCdCompany());
        map.put("CD_PC", user.getCdPc());
        map.put("cdDept", user.getCdDept());
        map.put("cdEmp", user.getNoEmp());
        map.put("dtAcct", param.get("dtAcct"));
        map.put("remark", param.get("remark"));
        map.put("tp_gb", param.get("tp_gb"));  //  유형
        map.put("etcdocu", param.get("etcdocu"));
        map.put("ID_INSERT", user.getIdUser());

        String group_number = disbDocsMapper.insertDocu(map);

        List<HashMap<String, Object>> delete = new ArrayList<>();

        for (HashMap<String, Object> obj : header) {

            HashMap<String, Object> deleteMap = new HashMap<>();

            deleteMap.put("CD_COMPANY", user.getCdCompany());
            deleteMap.put("NO_TPDOCU", obj.get("NO_TPDOCU"));
            deleteMap.put("OLD_GROUP_NUMBER", obj.get("GROUP_NUMBER"));
            deleteMap.put("NEW_GROUP_NUMBER", group_number);

            delete.add(deleteMap);

            HashMap<String, Object> file = new HashMap<>();

            file.put("CD_COMPANY", user.getCdCompany());
            file.put("BOARD_TYPE", "DOCU");
            file.put("SEQ", obj.get("GROUP_NUMBER"));

            filelist.addAll(fileService.BbsFileSearch(file));

            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("DT_ACCT", param.get("dtAcct"));
            //  20200320 CZ_Q_PUSAIV 테이블에 INSERT 할 때, 전표처리자로 수정
            obj.put("CD_DEPT", user.getCdDept());
            obj.put("CD_EMP", user.getNoEmp());
            //
            obj.put("ID_INSERT", user.getIdUser());
            obj.put("DT_TRANS", chkDate((String) obj.get("DT_TRANS")));

            disbDocsMapper.insertPusaiv(obj);
        }

        int index = 1;
        for (Map<String, Object> obj : gridDetailLeft) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("SEQ", String.valueOf(index++));
            obj.put("ID_INSERT", user.getIdUser());

            disbDocsMapper.insertAcctent(obj);
        }

        index = 1;
        for (Map<String, Object> obj : gridDetailRight) {
            obj.put("GROUP_NUMBER", group_number);
            obj.put("CD_COMPANY", user.getCdCompany());
            obj.put("SEQ", String.valueOf(index++));
            obj.put("ID_INSERT", user.getIdUser());
            disbDocsMapper.insertAcctent(obj);
        }

        Map<String, String> fimap = new HashMap();
        fimap.put("CD_COMPANY", user.getCdCompany());
        fimap.put("CD_PC", user.getCdPc());
        fimap.put("ID_WRITE", user.getNoEmp());
        fimap.put("CD_WDEPT", user.getCdDept());
        fimap.put("ID_USER", user.getIdUser());
        fimap.put("GROUP_NUMBER", group_number);
        fimap.put("DT_ACCT", (String) param.get("dtAcct"));
        fimap.put("ST_DOCU", "1");

        String no_docu = disbDocsMapper.insertFiDocu(fimap);
        System.out.println("NO_DOCU : " + no_docu);

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


        for (HashMap<String, Object> obj : delete) {
            disbDocsMapper.deleteImsi(obj);
        }
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
}
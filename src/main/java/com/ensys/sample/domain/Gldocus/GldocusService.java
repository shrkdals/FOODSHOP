package com.ensys.sample.domain.Gldocus;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GldocusService extends BaseService {

    @Inject
    public GldocusMapper Mapper;

    @Inject
    private com.ensys.sample.domain.file.fileService fileService;

    public List<Map<String, Object>> MasterList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return Mapper.MasterList(param);
    }

    public List<Map<String, Object>> getSelectList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
//        if(param.get("NO_DOCU")!= null){
//            param.put("NO_DOCU", Arrays.asList(param.get("NO_DOCU").toString().split("\\|")));
//        }
//        if(param.get("GROUP_NUMBER")!= null) {
//            param.put("GROUP_NUMBER", Arrays.asList(param.get("GROUP_NUMBER").toString().split("\\|")));
//        }
        return Mapper.SelectList(param);
    }

    public List<Map<String, Object>> DetailList(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return Mapper.DetailList(param);
    }

    public Map<String, Object> getNoDraft() {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        Map<String, Object> param = new HashMap<>();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return Mapper.getNoDraft(param);
    }

    @Transactional
    public void applyDocu(Map<String, Object> param) {
        HashMap<String, Object> fileData = (HashMap<String, Object>) param.get("fileData");
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", user.getCdCompany());
        //품의번호 채번
        String NO_DRAFT = (String) Mapper.getNoDraft(param).get("NO_DRAFT");
        param.put("NO_DRAFT", NO_DRAFT);
        param.put("DT_ACCT", param.get("DT_ACCT").toString().replace("-", ""));
        Mapper.applyDocu(param);

        if (fileData != null) {
            fileService.BbsFileModify("DRAFT",NO_DRAFT, fileData);
        }

        //사업부결재선
        if (param.get("CD_APPROVE") != null) {
            param.put("CD_SETTLE_KIND", "01");
            List<Map<String, Object>> list = Mapper.selectListApprove(param);
            System.out.println("사업부 IN");

            Map<String, Object> one = new HashMap<>();
            one.put("CD_COMPANY", user.getCdCompany());
            one.put("NO_DRAFT", param.get("NO_DRAFT"));
            one.put("CD_APPROVE", param.get("CD_APPROVE"));
            one.put("SEQ", 0);
            one.put("SEQ_APPROVE", 0);
            one.put("CD_DEPT", user.getCdDept());
            one.put("GB_APPROVE", "001");
            one.put("CD_SETTLE_KIND", "01");
            one.put("CD_DUTY_RANK", user.getCdDutyRank());
            one.put("CD_APPROVE_EMP", user.getNoEmp());
            one.put("ST_APPROVE", "Y");
            one.put("DT_APPROVE", "Y");
            Mapper.insertApproveAgree(one);

            for (Map<String, Object> item : list) {
                item.put("CD_COMPANY", param.get("CD_COMPANY"));
                item.put("NO_DRAFT", param.get("NO_DRAFT"));
                item.put("CD_APPROVE", item.get("CD_APPROVE"));
                item.put("CD_DEPT", item.get("CD_DEPT"));
                item.put("CD_SETTLE_KIND", "01");
                item.put("CD_DUTY_RANK", item.get("CD_DUTYRANK"));
                item.put("SEQ_APPROVE", item.get("SEQ_APPROVE"));
                item.put("GB_APPROVE", item.get("GB_APPROVE"));
                item.put("CD_APPROVE_EMP", item.get("CD_APPROVE_EMP"));
                Mapper.insertApproveAgree(item);
            }
        }

        //회계팀결재선
        if (param.get("CD_APPROVEFI") != null) {
            param.put("CD_SETTLE_KIND", "02");
            List<Map<String, Object>> list = Mapper.selectListApproveFi(param);
            System.out.println("회계팀 IN");
//            if (param.get("CD_APPROVE") == null) {
//                Map<String, Object> one = new HashMap<>();
//                one.put("CD_COMPANY", user.getCdCompany());
//                one.put("NO_DRAFT", param.get("NO_DRAFT"));
//                one.put("CD_APPROVE", param.get("CD_APPROVEFI"));
//                one.put("SEQ", 0);
//                one.put("SEQ_APPROVE", 0);
//                one.put("CD_DEPT", user.getCdDept());
//                one.put("GB_APPROVE", "001");
//                one.put("CD_DUTY_RANK", user.getCdDutyRank());
//                one.put("CD_APPROVE_EMP", user.getNoEmp());
//                one.put("ST_APPROVE", "Y");
//                one.put("DT_APPROVE", "Y");
//                Mapper.insertApproveAgree(one);
//            }

            for (Map<String, Object> item : list) {
                item.put("CD_COMPANY", param.get("CD_COMPANY"));
                item.put("NO_DRAFT", param.get("NO_DRAFT"));
                item.put("CD_APPROVE", item.get("CD_APPROVE"));
                item.put("CD_DEPT", item.get("CD_DEPT"));
                item.put("CD_SETTLE_KIND", "02");
                item.put("CD_DUTY_RANK", item.get("CD_DUTYRANK"));
                item.put("SEQ_APPROVE", item.get("SEQ_APPROVE"));
                item.put("GB_APPROVE", item.get("GB_APPROVE"));
                item.put("CD_APPROVE_EMP", item.get("CD_APPROVE_EMP"));
                Mapper.insertApproveAgree(item);
            }
        }
        System.out.println("그룹넘버 : " + param.get("GROUP_NUMBER"));
        String[] gNoList = param.get("GROUP_NUMBER").toString().split("[|]");
        for (int i = 0; i < gNoList.length; i++) {
            System.out.println(gNoList[i]);
            Map<String, Object> item = new HashMap<>();
            item.put("GROUP_NUMBER", gNoList[i]);
            item.put("NO_DRAFT", param.get("NO_DRAFT"));
            item.put("CD_COMPANY", user.getCdCompany());
            Mapper.updateDocu(item);
        }
    }

    public void TEST(Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        Map<String, Object> item = new HashMap<>();
        item.put("NO_DOCU",param.get("NO_DOCU"));
        item.put("CD_COMPANY",user.getCdCompany());
        item.put("USER_ID",user.getNoEmp());
        item.put("USER_DEPT",user.getCdDept());
        item.put("NO_DRAFT",param.get("NO_DRAFT"));
        item.put("GUBUN",param.get("GUBUN"));
        item.put("GROUP_NUMBER",param.get("GROUP_NUMBER"));
        Mapper.TEST(item);
    }


    public void docu_crud(Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        Map<String, Object> item = new HashMap<>();
        item.put("NO_DOCU",param.get("NO_DOCU"));
        item.put("CD_COMPANY",user.getCdCompany());
        item.put("USER_ID",user.getNoEmp());
        item.put("USER_DEPT",user.getCdDept());
        item.put("NO_DRAFT",param.get("NO_DRAFT"));
        item.put("GUBUN",param.get("GUBUN"));
        item.put("GROUP_NUMBER",param.get("GROUP_NUMBER"));
        Mapper.docu_crud(item);

    }

    public void applyInsert(Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(Map<String, Object> item : (List<Map<String, Object>>)param.get("list")){
            item.put("NO_DRAFT",param.get("NO_DRAFT"));
            item.put("CD_COMPANY",user.getCdCompany());
            Mapper.applyInsert(item);
        }
    }

    public void applyUpdate(Map<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(Map<String, Object> item : (List<Map<String, Object>>)param.get("list")){
            item.put("CD_COMPANY",user.getCdCompany());
            item.put("NO_DRAFT",param.get("NO_DRAFT"));
            Mapper.applyUpdate(item);
        }
    }

    public void applyCancel(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("list")){
            item.put("CD_COMPANY",user.getCdCompany());
            Mapper.applyCancel(item);
        }

    }
}
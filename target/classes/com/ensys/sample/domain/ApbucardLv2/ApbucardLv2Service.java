package com.ensys.sample.domain.ApbucardLv2;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class ApbucardLv2Service extends BaseService {

    @Inject
    private ApbucardLv2Mapper bucardMapper;


    @Transactional
    public void save(HashMap<String, Object> bucard ) throws Exception {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println("서비스실행");
        HashMap<String, Object> itemH = (HashMap<String, Object>)bucard.get("listH");
        HashMap<String, Object> itemD = (HashMap<String, Object>)bucard.get("listD");

        try{
            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemH.get("updated")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                System.out.println("[ *** 법인카드 헤더 수정 *** ]");
                bucardMapper.updateH(data);
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("created")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.insertD(data);
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("updated")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.updateD(data);
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("deleted")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.deleteD(data);
            }


            //금액 체크
            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("created")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                HashMap<String, Object> result = bucardMapper.amtCheck(data);
                if(result.get("result").toString().equals("FALSE")){
                    throw new Exception("금액 설정이 다른 데이터가 존재합니다.");
                }

            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("updated")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                HashMap<String, Object> result = bucardMapper.amtCheck(data);
                if(result.get("result").toString().equals("FALSE")){
                    throw new Exception("금액 설정이 다른 데이터가 존재합니다.");
                }
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("deleted")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                HashMap<String, Object> result = bucardMapper.amtCheck(data);
                if(result.get("result").toString().equals("FALSE")){
                    throw new Exception("금액 설정이 다른 데이터가 존재합니다.");
                }
            }
        }catch(Exception e){
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw e;
        }


    }
    public HashMap<String, Object> getNoDraft() {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        HashMap<String, Object> param = new HashMap<>();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.getNoDraft(param);
    }

    public void applyUpdate(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("list")){
            item.put("CD_COMPANY",user.getCdCompany());
            item.put("NO_DRAFT",param.get("NO_DRAFT"));
            bucardMapper.applyUpdate(item);
        }
    }

    public void applyInsert(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        for(HashMap<String, Object> item : (List<HashMap<String, Object>>)param.get("list")){
            item.put("NO_DRAFT",param.get("NO_DRAFT"));
            item.put("CD_COMPANY",user.getCdCompany());
            item.put("NO_EMP",user.getNoEmp());
            item.put("CD_PC",user.getCdPc());
            item.put("CD_DEPT",user.getCdDept());
            bucardMapper.applyInsert(item);
        }
    }

    public Map<String, Object> acctLink(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY",user.getCdCompany());
        return bucardMapper.acctLink(param);
    }

    public Map<String, Object> apbuPartner(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY",user.getCdCompany());
        return bucardMapper.apbuPartner(param);
    }

    public void budgetCheck(HashMap<String, Object> param) {
        List<HashMap<String, Object>> info = bucardMapper.budgetCheck(param);
        try{
            for(HashMap<String, Object> item : info){
                HashMap<String, Object> budgetInfo = bucardMapper.budgetControl(item);
                if(budgetInfo.get("MESSAGE").toString().indexOf("예산금액을 초과하였습니다") > -1) {
                    throw new Exception(budgetInfo.get("MESSAGE").toString());
                }
            }


        }catch(Exception e){

        }
    }

    @Transactional
    public void saveCMS(HashMap<String, Object> bucard ) throws Exception {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println("서비스실행");
        HashMap<String, Object> itemH = (HashMap<String, Object>)bucard.get("listH");
        HashMap<String, Object> itemD = (HashMap<String, Object>)bucard.get("listD");

        try{
            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemH.get("updated")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                System.out.println("[ *** 법인카드 헤더 수정 *** ]");
                bucardMapper.updateH(data);
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("created")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.insertDCMS(data);
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("updated")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.updateDCMS(data);
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("deleted")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.deleteD(data);
            }


            //금액 체크
            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("created")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                HashMap<String, Object> result = bucardMapper.amtCheck(data);
                if(result.get("result").toString().equals("FALSE")){
                    throw new Exception("금액 설정이 다른 데이터가 존재합니다.");
                }

            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("updated")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                HashMap<String, Object> result = bucardMapper.amtCheck(data);
                if(result.get("result").toString().equals("FALSE")){
                    throw new Exception("금액 설정이 다른 데이터가 존재합니다.");
                }
            }

            for (Map<String, Object> data : (List<HashMap<String, Object>>)itemD.get("deleted")) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                HashMap<String, Object> result = bucardMapper.amtCheck(data);
                if(result.get("result").toString().equals("FALSE")){
                    throw new Exception("금액 설정이 다른 데이터가 존재합니다.");
                }
            }
        }catch(Exception e){
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw e;
        }


    }

    public void acctTemp(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println("서비스실행");
        HashMap<String, Object> info = (HashMap<String, Object>)param.get("info");
        for (Map<String, Object> data : (List<HashMap<String, Object>>)param.get("list")) {

            data.put("CD_COMPANY", sessionUser.getCdCompany());
            data.put("JOB_TP",info.get("JOB_TP"));
            data.put("DT_ACCT",info.get("DT_ACCT_T"));
            data.put("COMMNETS",info.get("REMARK"));
            data.put("CD_USERDEF1",info.get("CD_USERDEF1"));
            data.put("CD_ACCT",info.get("CD_ACCT"));
            data.put("ACCTREMARK",info.get("ACCTREMARK"));
            data.put("CD_CC",info.get("CD_CC"));
            data.put("CR_CD_ACCT",info.get("CR_CD_ACCT"));
            data.put("CD_BUDGET",info.get("CD_BUDGET"));
            data.put("CD_BGACCT",info.get("CD_BGACCT"));
            data.put("CD_BIZCAR",info.get("CD_BIZCAR"));
            data.put("CR_NM_ACCT",info.get("CR_NM_ACCT"));
            data.put("NM_BUDGET",info.get("NM_BUDGET"));
            data.put("NM_BGACCT",info.get("NM_BGACCT"));
            data.put("NM_BIZCAR",info.get("NM_BIZCAR"));
            data.put("NM_ACCT",info.get("NM_ACCT"));
            data.put("NM_CC",info.get("NM_CC"));
            bucardMapper.batchInsert(data);

        }
    }

    public List<HashMap<String, Object>> deptJobList(HashMap<String, Object> param) {
        return bucardMapper.deptJobList(param);
    }
}
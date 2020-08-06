package com.ensys.sample.domain.ApbucardLv1;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class ApbucardLv1Service extends BaseService {

    @Inject
    private ApbucardLv1Mapper bucardMapper;


    public List<HashMap<String, Object>> select(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.select(param);
    }

    @Transactional
    public void save(HashMap<String, Object> param ) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        for (Map<String, Object> data : (List<HashMap<String, Object>>)param.get("updated"))
        {
            data.put("CD_COMPANY", sessionUser.getCdCompany());
            bucardMapper.update(data);
            bucardMapper.update2(data);
        }

    }

    @Transactional
    public String statement(HashMap<String, Object> bucard) throws Exception {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        bucard.put("NO_EMP", sessionUser.getNoEmp());
        bucard.put("CD_DEPT", sessionUser.getCdDept());
        HashMap<String, Object> item = bucardMapper.insertDocu(bucard);
        bucard.put("NO_TPDOCU",item.get("NO_TPDOCU"));
        bucard.put("GROUP_NUMBER",item.get("GROUP_NUMBER"));
        bucard.put("CD_COMPANY", sessionUser.getCdCompany());
        taxInsert(bucard);
        bucardMapper.insertAcctEnt(bucard);
        bucard.put("CD_PC",sessionUser.getCdPc());
        bucard.put("ID_USER", sessionUser.getIdUser());
        bucard.put("CD_DEPT", sessionUser.getCdDept());
        bucard.put("EMP_NO", sessionUser.getNoEmp());
        bucardMapper.fiDocuMulti(bucard);

        return item.get("GROUP_NUMBER").toString();
    }

    @Transactional
    public String statementMulti(HashMap<String, Object> bucard) throws Exception {


            SessionUser sessionUser = SessionUtils.getCurrentUser();
            bucard.put("CD_COMPANY", sessionUser.getCdCompany());
            HashMap<String, Object> grNo = new HashMap<>();
            HashMap<String, Object> tpNo = new HashMap<>();
            //그룹넘버 채번
            grNo = bucardMapper.createNum(bucard);
            //다중건 전표처리시 대표회계일자
            String DT_ACCT_T = bucard.get("DT_ACCT_T").toString();
            //사용내역
            String REMARK = bucard.get("REMARK").toString();

            for(HashMap<String, Object> itemH : (List<HashMap<String, Object>>)bucard.get("list")){
                int sum = 0;
                //지출결의넘버 채번
                tpNo = bucardMapper.createNum2(bucard);
                itemH.put("CD_COMPANY", sessionUser.getCdCompany());
                itemH.put("ID_USER", sessionUser.getIdUser());
                itemH.put("GROUP_NUMBER", grNo.get("GROUP_NUMBER"));
                itemH.put("NO_TPDOCU", tpNo.get("NO_TPDOCU"));
                itemH.put("DT_ACCT_T", DT_ACCT_T);
                itemH.put("DT_ACCT", DT_ACCT_T);
                itemH.put("REMARK", REMARK);
                itemH.put("TAX_CD",bucard.get("TAX_CD"));
                taxInsert(itemH);
                itemH.put("NO_EMP", sessionUser.getNoEmp());
                itemH.put("CD_DEPT", sessionUser.getCdDept());
                bucardMapper.insertMultiDocu(itemH);
                bucardMapper.insertAcctEnt(itemH);
            }
            bucard.put("CD_PC",sessionUser.getCdPc());
            bucard.put("CD_COMPANY", sessionUser.getCdCompany());
            bucard.put("ID_USER", sessionUser.getIdUser());
            bucard.put("GROUP_NUMBER", grNo.get("GROUP_NUMBER"));
            bucard.put("DT_ACCT", DT_ACCT_T);
            bucard.put("CD_DEPT", sessionUser.getCdDept());
            bucard.put("EMP_NO", sessionUser.getNoEmp());

            bucardMapper.fiDocuMulti(bucard);

            return grNo.get("GROUP_NUMBER").toString();

    }


    //부가세계정이 있을경우 부가세 처리를 하고 전표처리대상 데이터에 대해 예외처리항목 체크
    public void taxInsert(HashMap<String, Object> itemH) throws Exception {
        try{
            SessionUser sessionUser = SessionUtils.getCurrentUser();
            itemH.put("CD_COMPANY",sessionUser.getCdCompany());
            itemH.put("CD_BIZAREA",sessionUser.getCdBizarea());
            itemH.put("CD_PC",sessionUser.getCdPc());

            List<HashMap<String, Object>> HList =  bucardMapper.selectOneH(itemH);

            if(HList.size() == 0){
                throw new Exception("법인카드 내역 데이터가 충분하지 않습니다.");
            }

            List<HashMap<String, Object>> DList =  bucardMapper.selectD(itemH);
            HashMap<String, Object> notax = bucardMapper.getTax_no(itemH);

            int sum = 0;

            if(DList.size() == 0){
                throw new Exception("계정설정 데이터가 충분하지 않습니다.");
            }
            for(HashMap<String, Object> itemD : DList){
                BigDecimal amt = (BigDecimal)itemD.get("AMT");
                sum += amt.intValue();
            }
            int admin_amt = Integer.parseInt(itemH.get("ADMIN_AMT").toString());
            if(sum != admin_amt){
                throw new Exception("계정설정의 금액이 일치하지 않습니다.");
            }

            for(HashMap<String, Object> param : DList){
                if(itemH.get("TAX_CD").toString().indexOf(param.get("CD_TAX_ACCT").toString()) > -1 && param.get("TAX_GB") == null){
                    throw new Exception("["+param.get("CD_TAX_ACCT")+"]"+param.get("NM_TAX_ACCT")+" 부가세 계정의 세무구분이 선택되지 않았습니다.");
                }
                if(itemH.get("TAX_CD").toString().indexOf(param.get("CD_TAX_ACCT").toString()) > -1 && param.get("TAX_GB").toString().equals("22") && param.get("NON_TAX") == null){
                    throw new Exception("["+param.get("CD_TAX_ACCT")+"]"+param.get("NM_TAX_ACCT")+" 불공제 계정의 불공제구분이 선택되지 않았습니다.");
                }
                if(itemH.get("TAX_CD").toString().indexOf(param.get("CD_TAX_ACCT").toString()) > -1 && itemH.get("CD_TRADE_PLACE") != null){
                    System.out.println("[ *** 부가세 정보 생성 *** ]");
                    if(param.get("TAX_GB").toString().equals("22")){
                        double amt = Integer.parseInt(itemH.get("ADMIN_AMT").toString()) - Math.floor(Integer.parseInt(itemH.get("ADMIN_AMT").toString())/1.1);
                        itemH.put("D_AMT",amt);
                    }else{
                        itemH.put("D_AMT",param.get("LVL1_VAT_AMT"));
                    }
                    itemH.put("NO_TAX",notax.get("NO_TAX"));
                    itemH.put("CD_COMPANY",sessionUser.getCdCompany());
                    itemH.put("CD_PARTNER",itemH.get("CD_PARTNER"));
                    itemH.put("NO_COMPANY",itemH.get("CD_TRADE_PLACE"));
                    itemH.put("NO_CARD",itemH.get("ACCT_NO"));
                    itemH.put("TP_TAX",param.get("TAX_GB"));
                    itemH.put("ST_MUTUAL",param.get("NON_TAX"));
                    itemH.put("CD_BANK",itemH.get("BANK_CODE"));
                    itemH.put("ST_DOCU","1");
                    itemH.put("LEVEL","1");
                    param.put("DT_ACCT",itemH.get("DT_ACCT"));
                    param.put("NO_TAX",notax.get("NO_TAX"));
                    bucardMapper.updateD(param);
                    bucardMapper.taxInsert(itemH);


                }
            }

        }catch(Exception e){
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//            if(e.getMessage().indexOf("예산금액을 초과하였습니다") > -1) {
//                throw new Exception(e.getMessage());
//            }
            throw e;
        }
    }

}
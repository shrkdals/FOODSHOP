package com.ensys.sample.domain.Apbucard;

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
public class ApbucardService extends BaseService {

    @Inject
    private ApbucardMapper bucardMapper;


    public List<HashMap<String, Object>> select(HashMap<String, Object> bucard) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        bucard.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.select(bucard);
    }

    public List<HashMap<String, Object>> selectD(HashMap<String, Object> bucard) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        bucard.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.selectD(bucard);
    }

    public List<HashMap<String, Object>> selectCust(HashMap<String, Object> bucard) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        bucard.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.selectCust(bucard);
    }

//    @Transactional
//    public void save(HashMap<String, Object> bucard ) {
//        SessionUser sessionUser = SessionUtils.getCurrentUser();
//        System.out.println("서비스실행");
//        List<HashMap<String, Object>> bucardH = (List<HashMap<String, Object>>)bucard.get("listH");
//
//        List<HashMap<String, Object>> bucardD = (List<HashMap<String, Object>>)bucard.get("listM");
//
//        List<HashMap<String, Object>> bucardC = (List<HashMap<String, Object>>)bucard.get("listD");
//
//        for (Map<String, Object> data : bucardH)
//        {
//            data.put("CD_COMPANY", sessionUser.getCdCompany());
//            if(data.get("__deleted__") != null){
//                if(data.get("__deleted__").toString() == "true"){
//                    System.out.println("[ *** 법인카드 헤더 삭제 *** ]");
//                    bucardMapper.deleteH(data);
//                }
//            }
//            else if(data.get("__created__") != null)
//            {
//                if(data.get("__created__").toString() == "true"){
//                    System.out.println("[ *** 법인카드 헤더 추가 *** ]" );
//                    bucardMapper.insertH(data);
//                }
//            }
//            else if(data.get("__modified__") != null)
//            {
//                if(data.get("__modified__").toString() == "true" ){
//                    System.out.println("[ *** 법인카드 헤더 수정 *** ]");
//                    bucardMapper.updateH(data);
//                }
//            }
//
//        }
//
//        for (Map<String, Object> data : bucardD)
//        {
//            data.put("CD_COMPANY", sessionUser.getCdCompany());
//            if(data.get("__deleted__") != null){
//                if(data.get("__deleted__").toString() == "true"){
//                    System.out.println("[ *** 법인카드 라인 삭제 *** ]");
//                    bucardMapper.deleteD(data);
//                }
//            }
//            else if(data.get("__created__") != null)
//            {
//                if(data.get("__created__").toString() == "true"){
//                    System.out.println("[ *** 법인카드 라인 추가 *** ]" );
//                    bucardMapper.insertD(data);
//                }
//            }
//            else if(data.get("__modified__") != null)
//            {
//                if(data.get("__modified__").toString() == "true" ){
//                    System.out.println("[ *** 법인카드 라인 수정 *** ]");
//                    bucardMapper.updateD(data);
//                 }
//            }
//
//        }
//
//        for (Map<String, Object> data : bucardC)
//        {
//            for (String mapkey : data.keySet()){
//                System.out.println("KEY : " + mapkey + " || VALUE : "+data.get(mapkey));
//            }
//            data.put("CD_COMPANY",sessionUser.getCdCompany());
//            if(data.get("__deleted__") != null){
//                if(data.get("__deleted__").toString() == "true"){
//                    System.out.println("[ *** 법인카드 편익 삭제 *** ]");
//                    bucardMapper.deleteD2(data);
//                }
//            }
//            else if(data.get("__created__") != null)
//            {
//                if(data.get("__created__").toString() == "true"){
//                    System.out.println("[ *** 법인카드 편익 추가 *** ]" );
//                    bucardMapper.insertD2(data);
//                }
//            }else if(data.get("__modified__") != null)
//            {
//                if(data.get("__modified__").toString() == "true" ){
//                    System.out.println("[ *** 법인카드 편익 수정 *** ]");
//                    bucardMapper.updateD2(data);
//                }
//
//            }
//        }
//    }

    @Transactional
    public void save(HashMap<String, Object> bucard ) throws Exception{
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        System.out.println("서비스실행");
        List<HashMap<String, Object>> bucardH = (List<HashMap<String, Object>>)bucard.get("listH");
        List<HashMap<String, Object>> bucardD = (List<HashMap<String, Object>>)bucard.get("listM");
        List<HashMap<String, Object>> bucardC = (List<HashMap<String, Object>>)bucard.get("listD");
        try{

            for (Map<String, Object> data : bucardH) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                List<HashMap<String, Object>> check = bucardMapper.selectOneH((HashMap<String, Object>) data);
                if(check.size() > 0){
                    if(check.get(0).get("GROUP_NUMBER") != null){
                        throw new Exception("전표 처리된 데이터가 존재합니다.");
                    }
                }
                bucardMapper.insertH(data);
            }

            for (Map<String, Object> data : bucardD) {
                data.put("CD_COMPANY", sessionUser.getCdCompany());
                bucardMapper.insertD(data);
            }

            for (Map<String, Object> data : bucardC) {
                data.put("CD_COMPANY",sessionUser.getCdCompany());
                bucardMapper.insertD2(data);
            }
        }catch(Exception e){
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw e;
        }


    }

    @Transactional
    public String statement(HashMap<String, Object> bucard) throws Exception {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        List<HashMap<String, Object>> HList =  bucardMapper.selectOneH(bucard);
        if(HList.size() == 0){
            throw new Exception("법인카드 계정설정 내역이 없습니다.");
        }
        if(HList.get(0).get("GROUP_NUMBER") != null){
            throw new Exception("전표 처리된 데이터가 존재합니다.");
        }
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
        bucard.put("NO_EMP", sessionUser.getNoEmp());
        bucardMapper.fiDocuMulti(bucard);

        return item.get("GROUP_NUMBER").toString();
    }

    @Transactional
    public HashMap<String, Object> statementMulti(HashMap<String, Object> bucard) throws Exception {

            SessionUser sessionUser = SessionUtils.getCurrentUser();
            bucard.put("CD_COMPANY", sessionUser.getCdCompany());
            List<HashMap<String, Object>> vH = (List<HashMap<String, Object>>) bucard.get("list");

//            vH.get(0).put("CD_COMPANY", sessionUser.getCdCompany());
            for(HashMap<String, Object> d : vH){
                d.put("CD_COMPANY", sessionUser.getCdCompany());
                List<HashMap<String, Object>> HList =  bucardMapper.selectOneH(d);
                if(HList.size() == 0){
                    throw new Exception("법인카드 계정설정 내역이 없습니다.");
                }
                if(HList.get(0).get("GROUP_NUMBER") != null){
                    throw new Exception("전표 처리된 데이터가 존재합니다.");
                }
            }


            HashMap<String, Object> grNo = new HashMap<>();
            HashMap<String, Object> tpNo = new HashMap<>();
            HashMap<String, Object> noDocu = new HashMap<>();
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
            bucard.put("NO_EMP", sessionUser.getNoEmp());
            try{
                noDocu = bucardMapper.fiDocuMulti(bucard);
            }catch(Exception e){
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                throw e;
            }
            grNo.put("NO_DOCU",noDocu.get("NO_DOCU"));
            return grNo;

    }


    //부가세계정이 있을경우 부가세 처리를 하고 전표처리대상 데이터에 대해 예외처리항목 체크
    public void taxInsert(HashMap<String, Object> itemH) throws Exception {
        try{
            SessionUser sessionUser = SessionUtils.getCurrentUser();
            itemH.put("CD_COMPANY",sessionUser.getCdCompany());
            itemH.put("CD_BIZAREA",sessionUser.getCdBizarea());
            itemH.put("CD_PC",sessionUser.getCdPc());
            List<HashMap<String, Object>> DList =  bucardMapper.selectD(itemH);

            List<HashMap<String, Object>> HList =  bucardMapper.selectOneH(itemH);

            if(HList.size() == 0){
                throw new Exception("법인카드 내역 데이터가 충분하지 않습니다.");
            }

            if(itemH.get("JOB_TP") == null){
                throw new Exception("업무구분 선택은 필수입니다.");
            }

            if(itemH.get("JOB_TP").toString().equals("2") && (itemH.get("BNFT_GB").toString().equals("") || itemH.get("BNFT_GB") == null)){
                throw new Exception("업무구분 영업활동비일때 편익구분 선택은 필수입니다.");
            }
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

                HashMap<String, Object> notax = bucardMapper.getTax_no(itemH);

                if(itemH.get("TAX_CD").toString().indexOf(param.get("CD_ACCT").toString()) > -1 && param.get("TAX_GB") == null){
                    throw new Exception("["+param.get("CD_ACCT")+"]"+param.get("NM_ACCT")+" 부가세 계정의 세무구분이 선택되지 않았습니다.");
                }
                if(itemH.get("TAX_CD").toString().indexOf(param.get("CD_ACCT").toString()) > -1 && param.get("TAX_GB").toString().equals("22") && param.get("NON_TAX") == null){
                    throw new Exception("["+param.get("CD_ACCT")+"]"+param.get("NM_ACCT")+" 불공제 계정의 불공제구분이 선택되지 않았습니다.");
                }
                /*
                HashMap<String, Object> new_param = new HashMap<>();
                Map<String, Object> return_link = bucardMapper.acctLink(itemH);
                if(return_link != null){
                    for (String mapkey : return_link.keySet()){
                        HashMap<String, Object> change_param = new HashMap<>();
                        System.out.println("[ *** KEY : " + mapkey + "  VALUE : "+return_link.get(mapkey)+" *** ]");
                        if(param.get(mapkey).equals("A06")){
                            int len = mapkey.length();
                            String num = mapkey.substring(len,len-1);
                            System.out.println();
                            String value = return_link.get("CD_MNGD"+num).toString();
                            change_param.put("CD_PARTNER",value);
                            bucardMapper.apbuPartner(param);
                        }
                    }
                }
                */

                if(itemH.get("TAX_CD").toString().indexOf(param.get("CD_ACCT").toString()) > -1 && param.get("S_IDNO") != null){
                    System.out.println("[ *** 부가세 정보 생성 *** ]");
                    if(param.get("TAX_GB").toString().equals("22")){
                        double amt = Integer.parseInt(itemH.get("ADMIN_AMT").toString()) - Math.floor(Integer.parseInt(itemH.get("ADMIN_AMT").toString())/1.1);
                        itemH.put("D_AMT",amt);
                    }else{
                        itemH.put("D_AMT",param.get("AMT"));
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
                    param.put("NO_TAX",notax.get("NO_TAX"));
                    bucardMapper.updateD(param);
                    bucardMapper.taxInsert(itemH);

                }
            }


            //예산통제전에 업무구분 복리후생일 경우 복리후생비 계정의 금액이 만원을 넘지 않도록 체크해야한다.
            if(itemH.get("JOB_TP").toString().equals("5")){
                List<HashMap<String, Object>> DList3 =  bucardMapper.selectD3(itemH);
                for(HashMap<String, Object> itemD : DList3) {
                    String a = String.valueOf(itemD.get("AMT"));
                    String b = String.valueOf(itemD.get("CHECK_AMT"));
                    int amt1 = (int) Double.parseDouble(a);
                    int amt2 = (int) Double.parseDouble(b);
                    if (amt1 > amt2) {
                        throw new Exception("복리후생비 통제금액을 초과하였습니다.");
                    }
                }
            }

            //예산통제를 위해 계정 예산단위 예산계정을 그룹바이하여 다시 조회함
            List<HashMap<String, Object>> DList2 =  bucardMapper.selectD2(itemH);
            for(HashMap<String, Object> itemD : DList2){
                //차변계정 예산단위 예산계정이 모두 존재할 경우에만 예산통제 대상
                //따로 받은 회계일자를 따라감
                itemD.put("DT_ACCT",itemH.get("DT_ACCT"));
                itemD.put("APPLY_AMT",itemD.get("AMT"));
                if( itemD.get("CD_BUDGET") != null && itemD.get("CD_BGACCT") != null && itemD.get("CD_ACCT") != null
                        &&  itemD.get("CD_BUDGET") != ""   && itemD.get("CD_BGACCT") != ""   && itemD.get("CD_ACCT") != ""){
                    //예산체크 프로시저 실행
                    Map<String, Object> budgetInfo = bucardMapper.acctBudgetAmt2(itemD);
                    //예산통제 대상이며 금액이 초과했을경우 진행된 모든 트랜잭션을 롤백처리
                    if(budgetInfo.get("MESSAGE").toString().indexOf("예산금액을 초과하였습니다") > -1) {
                        throw new Exception(budgetInfo.get("MESSAGE").toString());
                    }
//                    if(budgetInfo.get("CONTROL_YN").toString().equals("Y") && budgetInfo.get("OVER_YN").toString().equals("Y")){
//                        throw new Exception("["+itemD.get("CD_ACCT")+"]"+itemD.get("NM_ACCT")+" 계정의 예산이 초과되었습니다.");
//                    }
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

    public Map<String, Object> acctAddRow(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.acctAddRow(param);
    }
    public Map<String, Object> ccAddRow(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.ccAddRow(param);
    }

    public List<Map<String, Object>> acctBudgetAmt(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.acctBudgetAmt(param);
    }

    public List<Map<String, Object>> bgacctSetting(Map<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        return bucardMapper.bgacctSetting(param);
    }

    public void docuCancel(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
        bucardMapper.docuCancel(param);
    }

    public Map<String, Object> getBnftAmt(HashMap<String, Object> param) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        param.put("CD_COMPANY", sessionUser.getCdCompany());
//        bucardMapper.docuBnftCancel(param);
        return bucardMapper.getBnftAmt(param);
    }

    //부가세 연동버젼
    @Transactional
    public String statement2(HashMap<String, Object> bucard) {
        SessionUser sessionUser = SessionUtils.getCurrentUser();
        bucard.put("CD_COMPANY", sessionUser.getCdCompany());
        HashMap<String, Object> item = bucardMapper.insertDocu(bucard);

        bucard.put("NO_TPDOCU",item.get("NO_TPDOCU"));
        bucard.put("GROUP_NUMBER",item.get("GROUP_NUMBER"));
        bucardMapper.insertAcctEnt(bucard);
        return item.get("GROUP_NUMBER").toString();
    }
    //부가세 연동버젼
    @Transactional
    public String statementMulti2(HashMap<String, Object> bucard) throws Exception {

        try{
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
                itemH.put("REMARK", REMARK);
                //법인카드에 설정된 전표 계정내역을 불러옴
                List<HashMap<String, Object>> DList =  bucardMapper.selectD(itemH);
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

                //예산통제를 위해 계정 예산단위 예산계정을 그룹바이하여 다시 조회함
                List<HashMap<String, Object>> DList2 =  bucardMapper.selectD2(itemH);
                for(HashMap<String, Object> itemD : DList2){
                    //차변계정 예산단위 예산계정이 모두 존재할 경우에만 예산통제 대상
                    //따로 받은 회계일자를 따라감
                    itemD.put("DT_ACCT",DT_ACCT_T);
                    itemD.put("APPLY_AMT",itemD.get("AMT"));
                    if( itemD.get("CD_BUDGET") != null && itemD.get("CD_BGACCT") != null && itemD.get("CD_ACCT") != null
                            &&  itemD.get("CD_BUDGET") != ""   && itemD.get("CD_BGACCT") != ""   && itemD.get("CD_ACCT") != ""){
                        //예산체크 프로시저 실행
                        Map<String, Object> budgetInfo = bucardMapper.acctBudgetAmt(itemD);
                        //예산통제 대상이며 금액이 초과했을경우 진행된 모든 트랜잭션을 롤백처리
                        if(budgetInfo.get("CONTROL_YN").toString().equals("Y") && budgetInfo.get("OVER_YN").toString().equals("Y")){
                            throw new Exception("["+itemD.get("CD_ACCT")+"]"+itemD.get("NM_ACCT")+" 계정의 예산이 초과되었습니다.");
                        }
                    }
                }

                bucardMapper.insertMultiDocu(itemH);
                bucardMapper.insertAcctEnt(itemH);
            }
            return grNo.get("GROUP_NUMBER").toString();
        }catch(Exception e){
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw e;
        }
    }

}
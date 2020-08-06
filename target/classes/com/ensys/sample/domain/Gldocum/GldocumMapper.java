package com.ensys.sample.domain.Gldocum;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface GldocumMapper extends MyBatisMapper {

    List<HashMap<String, Object>> getHeaderList(HashMap<String, Object> acctmapping_m);

    List<HashMap<String, Object>> getDetailList(HashMap<String, Object> acctmapping_m);

    List<HashMap<String, Object>> tpdocuAcct(HashMap<String, Object> acctmapping_m);

    Map<String, Object> getTpDocu(Map<String, Object> map);

    List<Map<String, Object>> ccAddRow(Map<String, Object> param);


    Map<String, Object> getRtExch(Map<String, Object> map);

    Map<String, Object> getMNGD(Map<String, Object> map);

    Map<String, Object> getAutoMngd(Map<String, Object> map);

    String insertDocu(Map<String, Object> map);

    int insertPusaiv(Map<String, Object> map);

    int insertAcctent(Map<String, Object> map);

    HashMap<String, Object> getAcctcode(Map<String, Object> map); //사용중

    int fi_docu_file_i(Map<String, Object> map);

    String insertFiDocu(Map<String, String> map);

    int insertFiDocuBan(Map<String, String> map);

    String receptInsert(Map<String, String> map);

    Map<String, Object> getRecept(Map<String, Object> map);

    List<Map<String, Object>> getTaxBillList(Map<String, Object> map);

    Map<String, Object> getBnftAmt(HashMap<String, Object> param);      //  편익누적금액 가져오기

    int insertBenefit(HashMap<String, Object> param);

    List<HashMap<String, Object>> getDocuCopy(HashMap<String, Object> map);

    List<HashMap<String, Object>> getDocuPusaivCopy(HashMap<String, Object> map);

    List<HashMap<String, Object>> getDocuAcctentCopy(HashMap<String, Object> map);

    HashMap<String, Object> getchkValidate(HashMap<String, Object> map);

    HashMap<String, Object> acctBanCheck(HashMap<String, Object> map);

    List<HashMap<String, Object>> getBanjanList(HashMap<String, Object> map);

    List<HashMap<String, Object>> getBanList(HashMap<String, Object> map);
}

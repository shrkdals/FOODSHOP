package com.ensys.sample.domain.Apbucard;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ApbucardMapper extends MyBatisMapper {

    List<HashMap<String, Object>> select(HashMap<String, Object> bucard);

    List<HashMap<String, Object>> selectD(HashMap<String, Object> bucard);
    List<HashMap<String, Object>> selectD2(HashMap<String, Object> bucard);
    List<HashMap<String, Object>> selectCust(HashMap<String, Object> bucard);

    //헤더
    int updateH(Map<String, Object> bucard);

    int deleteH(Map<String, Object> bucard);

    int insertH(Map<String, Object> bucard);

    //계정
    int updateD(Map<String, Object> bucar);

    int deleteD(Map<String, Object> bucar);

    int insertD(Map<String, Object> bucar);

    //편익
    int deleteD2(Map<String, Object> item);

    int insertD2(Map<String, Object> item);

    int updateD2(Map<String, Object> item);

    void statement(HashMap<String, Object> param);

    HashMap<String, Object> insertDocu(HashMap<String, Object> param);

    void insertPusaiv(HashMap<String, Object> param);

    void insertAcctEnt(HashMap<String, Object> param);

    HashMap<String, Object> createNum(HashMap<String, Object> param);

    HashMap<String, Object> createNum2(HashMap<String, Object> param);

    void insertMultiDocu(HashMap<String, Object> param);

    Map<String, Object> acctAddRow(Map<String, Object> param);

    Map<String, Object> ccAddRow(Map<String, Object> param);

    List<Map<String, Object>> acctBudgetAmt(Map<String, Object> param);

    Map<String, Object> acctBudgetAmt(HashMap<String, Object> param);

    List<Map<String, Object>> bgacctSetting(Map<String, Object> param);

    void docuCancel(HashMap<String, Object> param);

    Map<String, Object> getBnftAmt(HashMap<String, Object> param);

    void docuBnftCancel(HashMap<String, Object> param);

    void taxInsert(HashMap<String, Object> itemH);

    HashMap<String, Object> getTax_no(HashMap<String, Object> itemH);

    HashMap<String, Object> fiDocuMulti(HashMap<String, Object> bucard);

    Map<String, Object> acctBudgetAmt2(HashMap<String, Object> itemD);

    List<HashMap<String, Object>> selectOneH(HashMap<String, Object> itemH);

    List<HashMap<String, Object>> selectD3(HashMap<String, Object> itemH);

    Map<String, Object> apbuPartner(HashMap<String, Object> param);

    Map<String, Object> acctLink(HashMap<String, Object> param);
}

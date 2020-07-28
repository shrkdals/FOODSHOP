package com.ensys.sample.domain.CommonHelp;

import com.chequer.axboot.core.mybatis.MyBatisMapper;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public interface CommonHelpMapper extends MyBatisMapper {
	
	List<HashMap<String, Object>> HELP_USER_NOTICE(Map<String, Object> param);
	
    List<HashMap<String, Object>> HELP_BRAND_ITEM(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BRAND_PARTNER(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ACCT(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PARTNER(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_CARD(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BIZAREA(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ETAX_EMP(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BANK(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_DISBDOC(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BUDGET(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_CC(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_DEPT(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ALL_DEPT(Map<String, Object> param);


    List<HashMap<String, Object>> HELP_APPROVEBU(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_APPROVEFI(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_EMP(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_MULTI_EMP(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_USER(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PROG(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_AUTHGROUP(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PROJECT(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_TPDOCU(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_DEPOSIT(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PC(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_CODEDTL(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BILLREC(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PAYMENT_BILLREC(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BGACCT(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BIZCAR(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ASSET_PROCGB(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ASSET_MNGDNO(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PARTNER_DEPOSIT(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BAN_HELP(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BGACCT_REPORT(HashMap<String, Object> param);

    List<HashMap<String, Object>> HELP_PAYMENT_SUB(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_BUDGET_REPORT(HashMap<String, Object> param);

    List<HashMap<String, Object>> HELP_AREA(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ITEM(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_ITEM_CATEGORY(Map<String, Object> param);

    List<HashMap<String, Object>> HELP_PARTNER_CONTRACT(HashMap<String, Object> param);

    List<HashMap<String, Object>> HELP_PARTNER3(HashMap<String, Object> param);

    List<HashMap<String, Object>> HELP_AREA2(Map<String, Object> param);
}

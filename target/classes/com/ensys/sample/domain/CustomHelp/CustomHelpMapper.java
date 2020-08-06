package com.ensys.sample.domain.CustomHelp;

import com.chequer.axboot.core.mybatis.MyBatisMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CustomHelpMapper extends MyBatisMapper {

    List<Map<String, Object>> getCardList(Map<String, Object> param);

    List<Map<String, Object>> getAcctList(Map<String, Object> param);

    List<Map<String, Object>> getPcList(Map<String, Object> param);

    List<Map<String, Object>> tpdocuListHelp(Map<String, Object> param);

    List<Map<String, Object>> getPartnerTemp(Map<String, Object> param);

    List<Map<String, Object>> getBuAcctList(Map<String, Object> param);

    List<Map<String, Object>> CUSTOM_HELP_USER_DEPT(Map<String, Object> param);

    List<Map<String, Object>> CUSTOM_HELP_BIZTRIP_APPLY(Map<String, Object> param);

    List<Map<String, Object>> CUSTOM_HELP_BIZTRIP_BUCARD(Map<String, Object> param);

}

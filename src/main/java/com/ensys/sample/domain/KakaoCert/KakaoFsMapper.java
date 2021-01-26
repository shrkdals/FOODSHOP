package com.ensys.sample.domain.KakaoCert;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;

public interface KakaoFsMapper extends MyBatisMapper {

    void saveReceiptID(HashMap<String, Object> param);

    void contractUpdate(HashMap<String, Object> param);

    void stateUpdate(HashMap<String, Object> param);

    void signDataUpdate(HashMap<String, Object> item);
}

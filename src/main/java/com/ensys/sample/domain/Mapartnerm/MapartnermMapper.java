package com.ensys.sample.domain.Mapartnerm;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface MapartnermMapper extends MyBatisMapper {

    List<HashMap<String, Object>> select(HashMap<String, Object> param);
    void insert(HashMap<String, Object> param);
    void delete(HashMap<String, Object> param);

    void insertCONT(HashMap<String, Object> param);
    void deleteCONT(HashMap<String, Object> param);

    void insert2(HashMap<String, Object> param);
    void delete2(HashMap<String, Object> param);

    List<HashMap<String, Object>> getPartnerCommitionList(HashMap<String, Object> param);

    void SAVE_USERMAPPING_I(HashMap<String, Object> item);

    void SAVE_USERMAPPING_D(HashMap<String, Object> item);

    List<HashMap<String, Object>> SAVE_USERMAPPING_S(HashMap<String, Object> param);
}

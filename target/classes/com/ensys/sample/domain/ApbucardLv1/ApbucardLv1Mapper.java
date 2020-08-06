package com.ensys.sample.domain.ApbucardLv1;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ApbucardLv1Mapper extends MyBatisMapper {

    List<HashMap<String, Object>> select(HashMap<String, Object> bucard);

    //헤더
    int update(Map<String, Object> bucard);
    int update2(Map<String, Object> bucard);


    void statement(HashMap<String, Object> param);

    HashMap<String, Object> insertDocu(HashMap<String, Object> param);
    
    void insertAcctEnt(HashMap<String, Object> param);

    HashMap<String, Object> createNum(HashMap<String, Object> param);

    HashMap<String, Object> createNum2(HashMap<String, Object> param);

    void insertMultiDocu(HashMap<String, Object> param);
    
    void taxInsert(HashMap<String, Object> itemH);

    HashMap<String, Object> getTax_no(HashMap<String, Object> itemH);

    void fiDocuMulti(HashMap<String, Object> bucard);

    List<HashMap<String, Object>> selectD(HashMap<String, Object> itemH);

    List<HashMap<String, Object>> selectOneH(HashMap<String, Object> itemH);

    void updateD(HashMap<String, Object> param);
}

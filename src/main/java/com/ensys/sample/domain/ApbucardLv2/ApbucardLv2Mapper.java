package com.ensys.sample.domain.ApbucardLv2;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ApbucardLv2Mapper extends MyBatisMapper {
    void updateH(Map<String, Object> data);

    void updateD(Map<String, Object> data);

    void deleteD(Map<String, Object> data);

    void insertD(Map<String, Object> data);

    void applyInsert(HashMap<String, Object> item);

    HashMap<String, Object> getNoDraft(HashMap<String, Object> item);

    void applyUpdate(HashMap<String, Object> item);

    HashMap<String, Object> amtCheck(Map<String, Object> data);

    Map<String, Object> acctLink(HashMap<String, Object> param);

    Map<String, Object> apbuPartner(HashMap<String, Object> param);

    List<HashMap<String, Object>> budgetCheck(HashMap<String, Object> param);

    HashMap<String, Object> budgetControl(HashMap<String, Object> info);

    void updateDCMS(Map<String, Object> data);

    void insertDCMS(Map<String, Object> data);

    void batchInsert(Map<String, Object> data);

    List<HashMap<String, Object>> deptJobList(HashMap<String, Object> param);
}

package com.ensys.sample.domain.Gldocus;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface GldocusMapper extends MyBatisMapper {

    List<Map<String, Object>> MasterList(Map<String, Object> param);

    List<Map<String, Object>> SelectList(Map<String, Object> param);

    List<Map<String, Object>> DetailList(Map<String, Object> param);

    void applyDocu(Map<String, Object> param);

    List<Map<String, Object>> selectListApprove(Map<String, Object> param);

    List<Map<String, Object>> selectListApproveFi(Map<String, Object> param);

    Map<String, Object> getNoDraft(Map<String, Object> param);

    void insertApproveAgree(Map<String, Object> param);

    void updateDocu(Map<String, Object> param);

    void TEST(Map<String, Object> item);

    void docu_crud(Map<String, Object> item);

    void applyInsert(Map<String, Object> param);

    void applyUpdate(Map<String, Object> item);

    void applyCancel(HashMap<String, Object> param);
}

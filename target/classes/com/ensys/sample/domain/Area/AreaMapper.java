package com.ensys.sample.domain.Area;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface AreaMapper extends MyBatisMapper {

    List<HashMap<String, Object>> select1(HashMap<String, Object> param);
    List<HashMap<String, Object>> select2(HashMap<String, Object> param);
    List<HashMap<String, Object>> select3(HashMap<String, Object> param);

    void FS_AREA_M_CRUD(HashMap<String, Object> item);

    void FS_AREA_D_CRUD(HashMap<String, Object> item);

    void FS_AREA_SALES_PERSON_CRUD(HashMap<String, Object> item);
}

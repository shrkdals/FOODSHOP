package com.ensys.sample.domain.Categorym;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface CategorymMapper extends MyBatisMapper {

    List<HashMap<String, Object>> getBrcode(HashMap<String, Object> param);

    List<HashMap<String, Object>> getParentBrcode(HashMap<String, Object> param);

    List<HashMap<String, Object>> categorymSearchMain(HashMap<String, Object> param);

    void insert(HashMap<String, Object> param);
    void delete(HashMap<String, Object> param);
}

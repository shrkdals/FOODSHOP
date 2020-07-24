package com.ensys.sample.domain.Request;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface RequestMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectH(HashMap<String, Object> param);
    List<HashMap<String, Object>> selectD(HashMap<String, Object> param);

    void update(HashMap<String, Object> param);
}

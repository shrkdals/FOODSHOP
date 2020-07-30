package com.ensys.sample.domain.Order;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface OrderMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectH(HashMap<String, Object> param);
    List<HashMap<String, Object>> selectD(HashMap<String, Object> param);

    void success(HashMap<String, Object> param);

    List<HashMap<String, Object>> excel1(HashMap<String, Object> param);
    List<HashMap<String, Object>> excel2(HashMap<String, Object> param);

    void success2(HashMap<String, Object> item);
}

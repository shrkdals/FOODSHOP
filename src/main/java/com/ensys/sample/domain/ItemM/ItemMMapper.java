package com.ensys.sample.domain.ItemM;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface ItemMMapper extends MyBatisMapper {

    List<HashMap<String, Object>> search(HashMap<String, Object> param);

    int insert(HashMap<String, Object> param);

    int update(HashMap<String, Object> param);

    int delete(HashMap<String, Object> param);

}

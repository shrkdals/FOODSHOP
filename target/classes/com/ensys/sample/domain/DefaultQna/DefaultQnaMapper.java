package com.ensys.sample.domain.DefaultQna;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface DefaultQnaMapper extends MyBatisMapper {

    List<HashMap<String, Object>> search(HashMap<String, Object> param);

    int insert(HashMap<String, Object> param);

    int update(HashMap<String, Object> param);

    int delete(HashMap<String, Object> param);
}
package com.ensys.sample.domain.Terms;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface TermsMapper extends MyBatisMapper {

    List<HashMap<String, Object>> select(HashMap<String, Object> param);


    int save(HashMap<String, Object> param);


}

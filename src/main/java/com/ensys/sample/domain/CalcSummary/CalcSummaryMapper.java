package com.ensys.sample.domain.CalcSummary;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface CalcSummaryMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectH(HashMap<String, Object> param);
}

package com.ensys.sample.domain.exact;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface SenarioExactMapper extends MyBatisMapper {

    List<HashMap<String, Object>> getData(HashMap<String, Object> param);

    List<HashMap<String, Object>> getChartData(HashMap<String, Object> param);

    List<HashMap<String, Object>> getDetailData(HashMap<String, Object> param);

    List<HashMap<String, Object>> getReportData(HashMap<String, Object> param);

    int notifyInsert(HashMap<String, Object> param);

    int actionInsert(HashMap<String, Object> param);

    HashMap<String, Object> getSeq(HashMap<String, Object> request);

}

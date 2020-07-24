package com.ensys.sample.domain.schedule;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;


public interface scheduleMapper extends MyBatisMapper {


    List<HashMap<String, Object>> selectList(HashMap<String, Object> PARAM);

    List<HashMap<String, Object>> selectDetail(HashMap<String, Object> PARAM);

    HashMap<String, Object> updateWrite(HashMap<String, Object> PARAM);

    HashMap<String, Object> write(HashMap<String, Object> PARAM);

    List<HashMap<String, Object>> deleteWrite(HashMap<String, Object> PARAM);
}

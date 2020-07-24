package com.ensys.sample.domain.Maacctmapping;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;


public interface MaacctmappingMapper extends MyBatisMapper {

    List<HashMap<String, Object>> acctListHelp(HashMap<String, Object> acctmapping_m);

    List<HashMap<String, Object>> select(HashMap<String, Object> acctmapping_m);

    List<HashMap<String, Object>> selectDtl(HashMap<String, Object> acctmapping_m);

    List<HashMap<String, Object>> selectDept(HashMap<String, Object> acctmapping_m);

    int update(HashMap<String, Object> acctmapping_m);

    int delete(HashMap<String, Object> acctmapping_m);

    HashMap<String, Object> insert(HashMap<String, Object> acctmapping_m);


    int insertDtl(HashMap<String, Object> acctmapping_m);

    int deleteDtl(HashMap<String, Object> acctmapping_m);

    int updateDtl(HashMap<String, Object> acctmapping_m);


    int insertDept(HashMap<String, Object> acctmapping_m);

    int deleteDept(HashMap<String, Object> acctmapping_m);

    int updateDept(HashMap<String, Object> acctmapping_m);


}

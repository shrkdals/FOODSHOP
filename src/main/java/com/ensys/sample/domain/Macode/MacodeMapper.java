package com.ensys.sample.domain.Macode;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MacodeMapper extends MyBatisMapper {


    void getCdfield(Map<String, String> param);

    List<HashMap<String, Object>> select(HashMap<String, Object> macode);

    int update(HashMap<String, Object> macode);

    int delete(HashMap<String, Object> macode);

    HashMap<String, Object> insert(HashMap<String, Object> macode);


    List<HashMap<String, Object>> selectDtl(HashMap<String, Object> macode);

    int updateDtl(HashMap<String, Object> macodeDtl);

    int deleteDtl(HashMap<String, Object> macodeDtl);

    int insertDtl(HashMap<String, Object> macodeDtl);

}

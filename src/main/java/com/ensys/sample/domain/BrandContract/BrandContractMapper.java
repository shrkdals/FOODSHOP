package com.ensys.sample.domain.BrandContract;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface BrandContractMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectH(HashMap<String, Object> param);
    
    List<HashMap<String, Object>> selectD(HashMap<String, Object> param);
    List<HashMap<String, Object>> selectD2(HashMap<String, Object> param);
    List<HashMap<String, Object>> S_1(HashMap<String, Object> param);
    List<HashMap<String, Object>> S_2(HashMap<String, Object> param);

    void save(HashMap<String, Object> item);

    List<HashMap<String, Object>> S_3(HashMap<String, Object> param);

    void contract_cancel(HashMap<String, Object> item);
    
    List<HashMap<String, Object>> selectH_B(HashMap<String, Object> param);
    
    List<HashMap<String, Object>> selectD_B(HashMap<String, Object> param);
}

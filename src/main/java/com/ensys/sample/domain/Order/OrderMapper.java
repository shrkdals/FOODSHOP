package com.ensys.sample.domain.Order;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface OrderMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectH(HashMap<String, Object> param);
    List<HashMap<String, Object>> selectD(HashMap<String, Object> param);

    void success(HashMap<String, Object> param);
    
    List<HashMap<String, Object>> success3(HashMap<String, Object> param);

    List<HashMap<String, Object>> excel1(HashMap<String, Object> param);
    List<HashMap<String, Object>> excel2(HashMap<String, Object> param);
    
    List<HashMap<String, Object>> pdf1(HashMap<String, Object> param);
    List<HashMap<String, Object>> pdf2(HashMap<String, Object> param);
    List<HashMap<String, Object>> pdf_pt(HashMap<String, Object> param);
    void success2(HashMap<String, Object> item);
    
    void adjust(HashMap<String, Object> item);

    void orderCancel(HashMap<String, Object> param);

    void DEL_DT_SAVE(HashMap<String, Object> item);

    void REMARK_SAVE(HashMap<String, Object> param);

    void adjust2(HashMap<String, Object> stringObjectHashMap);
}

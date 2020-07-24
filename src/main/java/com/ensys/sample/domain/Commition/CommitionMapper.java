package com.ensys.sample.domain.Commition;

import com.chequer.axboot.core.mybatis.MyBatisMapper;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public interface CommitionMapper extends MyBatisMapper {

    List<HashMap<String, Object>> getCommitionHList(HashMap<String, Object> param);
    List<HashMap<String, Object>> getCommitionDList(HashMap<String, Object> param);
    void insertH(HashMap<String, Object> param);
    void insertD(HashMap<String, Object> param);
    void deleteH(HashMap<String, Object> param);
    void deleteD(HashMap<String, Object> param);


}

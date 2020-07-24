package com.ensys.sample.domain.CommonUtility;

import com.chequer.axboot.core.domain.base.AXBootJPAQueryDSLRepository;
import com.chequer.axboot.core.mybatis.MyBatisMapper;
import com.ensys.sample.domain.dept.Dept;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public interface CommonUtilityMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectList(HashMap<String, Object> param);

    Map<String, Object> checkMagam(HashMap<String, Object> param);

    Map<String, Object> GETNO(HashMap<String, Object> param);
}

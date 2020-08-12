package com.ensys.sample.domain.PtOrder;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface PtOrderMapper extends MyBatisMapper {

	List<HashMap<String, Object>> selectH(HashMap<String, Object> param);

	List<HashMap<String, Object>> selectD(HashMap<String, Object> param);

}

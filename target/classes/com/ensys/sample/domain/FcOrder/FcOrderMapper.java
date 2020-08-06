package com.ensys.sample.domain.FcOrder;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface FcOrderMapper extends MyBatisMapper {

	List<HashMap<String, Object>> selectH(HashMap<String, Object> param);

	List<HashMap<String, Object>> selectD(HashMap<String, Object> param);

}

package com.ensys.sample.domain.BrdHeadPayStatus;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface BrdHeadPayStatusMapper extends MyBatisMapper {

	List<HashMap<String, Object>> select(HashMap<String, Object> param);
	
	List<HashMap<String, Object>> selectDtl(HashMap<String, Object> param);
	
}

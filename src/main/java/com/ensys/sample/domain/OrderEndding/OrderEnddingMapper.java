package com.ensys.sample.domain.OrderEndding;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface OrderEnddingMapper extends MyBatisMapper {

	List<HashMap<String, Object>> search(HashMap<String, Object> param);

	void save(HashMap<String, Object> item);
}

package com.ensys.sample.domain.Banner;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface BannerMapper extends MyBatisMapper {

	List<HashMap<String, Object>> search(HashMap<String, Object> param);

	int insert(HashMap<String, Object> param);

	int update(HashMap<String, Object> param);

	int delete(HashMap<String, Object> param);

}

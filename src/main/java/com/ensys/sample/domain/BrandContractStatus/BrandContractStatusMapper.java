package com.ensys.sample.domain.BrandContractStatus;

import java.util.HashMap;
import java.util.List;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

public interface BrandContractStatusMapper extends MyBatisMapper {

	List<HashMap<String, Object>> select(HashMap<String, Object> param);

	List<HashMap<String, Object>> selectDtl(HashMap<String, Object> param);
}

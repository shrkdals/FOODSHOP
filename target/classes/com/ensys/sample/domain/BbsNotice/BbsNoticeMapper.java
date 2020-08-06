package com.ensys.sample.domain.BbsNotice;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface BbsNoticeMapper extends MyBatisMapper {

	List<HashMap<String, Object>> select(HashMap<String, Object> param);
	
	int write(HashMap<String, Object> param);
	int updateWrite(HashMap<String, Object> param);
	int deleteWrite(HashMap<String, Object> param);
	/*
	 * List<HashMap<String, Object>> selectList(HashMap<String, Object> param);
	 * 
	 * List<HashMap<String, Object>> selectDetail(HashMap<String, Object> param);
	 * 
	 * HashMap<String, Object> write(HashMap<String, Object> param);
	 * 
	 * HashMap<String, Object> updateWrite(HashMap<String, Object> param);
	 * 
	 * List<HashMap<String, Object>> deleteWrite(HashMap<String, Object> param);
	 */


}


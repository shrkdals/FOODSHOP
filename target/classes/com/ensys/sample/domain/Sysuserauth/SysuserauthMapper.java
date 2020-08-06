package com.ensys.sample.domain.Sysuserauth;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface SysuserauthMapper extends MyBatisMapper {

    List<HashMap<String, Object>> select(HashMap<String, Object> auth);

    List<HashMap<String, Object>> selectDtl(HashMap<String, Object> auth);

    int delete(HashMap<String, Object> auth);

    int insert(HashMap<String, Object> auth);

    int deleteUser(HashMap<String, Object> auth);

}

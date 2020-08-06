package com.ensys.sample.domain.auth;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface authMapper extends MyBatisMapper {

    List<HashMap<String, Object>> authMselect(HashMap<String, Object> auth);

    List<HashMap<String, Object>> authDselect(HashMap<String, Object> auth);

    int authMinsert(HashMap<String, Object> auth);

    int authMdelete(HashMap<String, Object> auth);

    int authDdelete(HashMap<String, Object> auth);

    int AUTHD_UPDATE(HashMap<String, Object> auth);

    int authDinsert(HashMap<String, Object> auth);


}

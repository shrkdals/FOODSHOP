package com.ensys.sample.domain.Sysusermenu;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SysusermenuMapper extends MyBatisMapper {


    List<HashMap<String, Object>> selectMst(HashMap<String, Object> param);

    List<HashMap<String, Object>> select(HashMap<String, Object> auth);

    List<HashMap<String, Object>> selectDtl(HashMap<String, Object> auth);

    int authDinsert(HashMap<String, Object> auth);

    int authDdelete(HashMap<String, Object> auth);

}

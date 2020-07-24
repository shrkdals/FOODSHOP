package com.ensys.sample.domain.Sysmenu;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface SysmenuMapper extends MyBatisMapper {

    List<HashMap<String, Object>> menuSelect(HashMap<String, Object> param);

    int menuInsert(HashMap<String, Object> Menu);

    int menuUpdate(HashMap<String, Object> Menu);

    int menuDelete(HashMap<String, Object> Menu);

    HashMap<String, Object> chkMenuId(HashMap<String, Object> param);


}

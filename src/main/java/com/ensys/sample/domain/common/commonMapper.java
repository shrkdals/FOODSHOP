package com.ensys.sample.domain.common;

import com.chequer.axboot.core.mybatis.MyBatisMapper;
import com.ensys.sample.domain.newMenu.newMenu;
import com.ensys.sample.domain.program.Program;
import com.ensys.sample.domain.program.menu.Menu;
import com.ensys.sample.domain.user.User;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface commonMapper extends MyBatisMapper {

    void getSeq(Map<String, String> param);

    List<Map<String, String>> getWebSeq(HashMap<String, Object> param);

    List<Map<String, String>> getCodeList(common common);

    List<newMenu> selectMenu(HashMap<String, Object> param);

    List<Program> selectProg(HashMap<String, Object> param);

    List<HashMap<String, Object>> HELP_CHECK_SEARCH(HashMap<String, Object> param);

}

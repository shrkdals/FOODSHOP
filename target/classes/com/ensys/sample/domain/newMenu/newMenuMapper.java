package com.ensys.sample.domain.newMenu;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.List;

public interface newMenuMapper extends MyBatisMapper {

    List<newMenu> menuSelect(newMenu Menu);

    List<newMenu> progSelect(newMenu Menu);


    int menuInsert(newMenu Menu);

    int menuUpdate(newMenu Menu);

    int menuDelete(newMenu Menu);


    int progInsert(newMenu Menu);

    int progUpdate(newMenu Menu);

    int progDelete(newMenu Menu);


}

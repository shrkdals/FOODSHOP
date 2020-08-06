package com.ensys.sample.domain.Sysprogram;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.List;

public interface SysprogramMapper extends MyBatisMapper {


    List<Sysprogram> progSelect(Sysprogram Menu);

    int progInsert(Sysprogram Menu);

    int progUpdate(Sysprogram Menu);

    int progDelete(Sysprogram Menu);


}

package com.ensys.sample.domain.Sysgroupuser;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.List;

public interface SysgroupuserMapper extends MyBatisMapper {

    List<Sysgroupuser> groupMselect(Sysgroupuser authGroup);

    List<Sysgroupuser> groupDselect(Sysgroupuser authGroup);

    int groupMinsert(Sysgroupuser authGroup);
    int groupMupdate(Sysgroupuser authGroup);
    int groupMdelete(Sysgroupuser authGroup);
    int groupDinsert(Sysgroupuser authGroup);
    int groupDdelete(Sysgroupuser authGroup);


}

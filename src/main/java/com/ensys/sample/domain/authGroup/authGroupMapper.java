package com.ensys.sample.domain.authGroup;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.List;

public interface authGroupMapper extends MyBatisMapper {

    List<authGroup> groupMselect(authGroup authGroup);

    List<authGroup> groupDselect(authGroup authGroup);

    int groupMinsert(authGroup authGroup);
    int groupMupdate(authGroup authGroup);
    int groupMdelete(authGroup authGroup);
    int groupDinsert(authGroup authGroup);
    int groupDdelete(authGroup authGroup);



    List<authGroup> deptUserSelect(authGroup authGroup);
    int deptUserInsert(authGroup authGroup);
    int deptUserDelete(authGroup authGroup);

}

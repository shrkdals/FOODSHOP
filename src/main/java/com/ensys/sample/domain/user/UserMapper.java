package com.ensys.sample.domain.user;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface UserMapper extends MyBatisMapper {
    User findByIdUserAndCdCompanyAndCdGroup(User user);

    List<HashMap<String, Object>> findId(HashMap<String, Object> param);

    HashMap<String, Object> chkPw(HashMap<String, Object> param);

    HashMap<String, Object> findPw(HashMap<String, Object> param);


    HashMap<String, Object> getYnPwClear(HashMap<String, Object> param);

    int passwordModify(HashMap<String, Object> param);

    List<HashMap<String, Object>> ensysLoginChk(String param);

    void join(HashMap<String, Object> param);

    void USER_SAVE(HashMap<String, Object> param);

    List<HashMap<String, Object>> USER_SEARCH(HashMap<String, Object> param);
}

package com.ensys.sample.domain;

import com.ensys.sample.domain.code.QCommonCode;
import com.ensys.sample.domain.program.QProgram;
import com.ensys.sample.domain.program.menu.QMenu;
import com.ensys.sample.domain.user.QUser;
import com.ensys.sample.domain.user.auth.QUserAuth;
import com.ensys.sample.domain.user.auth.menu.QAuthGroupMenu;
import com.ensys.sample.domain.user.role.QUserRole;
import com.chequer.axboot.core.domain.base.AXBootBaseService;
import com.chequer.axboot.core.domain.base.AXBootJPAQueryDSLRepository;



import java.io.Serializable;


public class BaseService<T, ID extends Serializable> extends AXBootBaseService<T, ID> {

    // 만약 여기서 에러가 뜬다면. clean을 한번 한 후, compile을 한번 실행시킨 후 기다린 다음 서버실행시키세요

    protected QUserRole qUserRole = QUserRole.userRole;
    protected QAuthGroupMenu qAuthGroupMenu = QAuthGroupMenu.authGroupMenu;
    protected QCommonCode qCommonCode = QCommonCode.commonCode;
    protected QUser qUser = QUser.user;
    protected QProgram qProgram = QProgram.program;
    protected QUserAuth qUserAuth = QUserAuth.userAuth;
    protected QMenu qMenu = QMenu.menu;


    protected AXBootJPAQueryDSLRepository<T, ID> repository;

    public BaseService() {
        super();
    }

    public BaseService(AXBootJPAQueryDSLRepository<T, ID> repository) {
        super(repository);
        this.repository = repository;
    }
}

package com.ensys.sample.domain.user;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QUser is a Querydsl query type for User
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QUser extends EntityPathBase<User> {

    private static final long serialVersionUID = 1422554417L;

    public static final QUser user = new QUser("user");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdBizarea = createString("cdBizarea");

    public final StringPath cdCc = createString("cdCc");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdDept = createString("cdDept");

    public final StringPath cdDutyRank = createString("cdDutyRank");

    public final StringPath cdGroup = createString("cdGroup");

    public final StringPath cdPc = createString("cdPc");

    public final StringPath idUser = createString("idUser");

    public final StringPath menu_id = createString("menu_id");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmBIZRAREA = createString("nmBIZRAREA");

    public final StringPath nmCc = createString("nmCc");

    public final StringPath nmDept = createString("nmDept");

    public final StringPath nmDutyRank = createString("nmDutyRank");

    public final StringPath nmEmp = createString("nmEmp");

    public final StringPath nmPc = createString("nmPc");

    public final StringPath nmUser = createString("nmUser");

    public final StringPath noEmp = createString("noEmp");

    public final StringPath passWord = createString("passWord");

    public QUser(String variable) {
        super(User.class, forVariable(variable));
    }

    public QUser(Path<? extends User> path) {
        super(path.getType(), path.getMetadata());
    }

    public QUser(PathMetadata metadata) {
        super(User.class, metadata);
    }

}


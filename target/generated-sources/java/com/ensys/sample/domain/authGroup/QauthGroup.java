package com.ensys.sample.domain.authGroup;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QauthGroup is a Querydsl query type for authGroup
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QauthGroup extends EntityPathBase<authGroup> {

    private static final long serialVersionUID = -157501565L;

    public static final QauthGroup authGroup = new QauthGroup("authGroup");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdDept = createString("cdDept");

    public final StringPath groupCd = createString("groupCd");

    public final StringPath groupGb = createString("groupGb");

    public final StringPath groupNm = createString("groupNm");

    public final StringPath idUser = createString("idUser");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmUser = createString("nmUser");

    public QauthGroup(String variable) {
        super(authGroup.class, forVariable(variable));
    }

    public QauthGroup(Path<? extends authGroup> path) {
        super(path.getType(), path.getMetadata());
    }

    public QauthGroup(PathMetadata metadata) {
        super(authGroup.class, metadata);
    }

}


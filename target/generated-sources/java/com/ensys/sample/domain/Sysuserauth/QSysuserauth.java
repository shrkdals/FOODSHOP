package com.ensys.sample.domain.Sysuserauth;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QSysuserauth is a Querydsl query type for Sysuserauth
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QSysuserauth extends EntityPathBase<Sysuserauth> {

    private static final long serialVersionUID = 800543253L;

    public static final QSysuserauth sysuserauth = new QSysuserauth("sysuserauth");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdDept = createString("cdDept");

    public final StringPath groupCd = createString("groupCd");

    public final StringPath groupGb = createString("groupGb");

    public final StringPath groupNm = createString("groupNm");

    public final StringPath idUser = createString("idUser");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmUser = createString("nmUser");

    public QSysuserauth(String variable) {
        super(Sysuserauth.class, forVariable(variable));
    }

    public QSysuserauth(Path<? extends Sysuserauth> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSysuserauth(PathMetadata metadata) {
        super(Sysuserauth.class, metadata);
    }

}


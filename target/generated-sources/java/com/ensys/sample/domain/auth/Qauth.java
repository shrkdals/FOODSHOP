package com.ensys.sample.domain.auth;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * Qauth is a Querydsl query type for auth
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class Qauth extends EntityPathBase<auth> {

    private static final long serialVersionUID = -1750686927L;

    public static final Qauth auth = new Qauth("auth");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath authCode = createString("authCode");

    public final StringPath authD = createString("authD");

    public final StringPath authI = createString("authI");

    public final StringPath authName = createString("authName");

    public final StringPath authS = createString("authS");

    public final StringPath authType = createString("authType");

    public final StringPath authU = createString("authU");

    public final StringPath menuId = createString("menuId");

    public final StringPath menuNm = createString("menuNm");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath parentId = createString("parentId");

    public final StringPath parentNm = createString("parentNm");

    public final StringPath progCd = createString("progCd");

    public final StringPath progNm = createString("progNm");

    public final StringPath useYn = createString("useYn");

    public Qauth(String variable) {
        super(auth.class, forVariable(variable));
    }

    public Qauth(Path<? extends auth> path) {
        super(path.getType(), path.getMetadata());
    }

    public Qauth(PathMetadata metadata) {
        super(auth.class, metadata);
    }

}


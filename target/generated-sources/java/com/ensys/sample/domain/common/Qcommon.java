package com.ensys.sample.domain.common;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * Qcommon is a Querydsl query type for common
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class Qcommon extends EntityPathBase<common> {

    private static final long serialVersionUID = -706568495L;

    public static final Qcommon common = new Qcommon("common");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdField = createString("cdField");

    public final StringPath CODE = createString("CODE");

    public final StringPath NAME = createString("NAME");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public Qcommon(String variable) {
        super(common.class, forVariable(variable));
    }

    public Qcommon(Path<? extends common> path) {
        super(path.getType(), path.getMetadata());
    }

    public Qcommon(PathMetadata metadata) {
        super(common.class, metadata);
    }

}


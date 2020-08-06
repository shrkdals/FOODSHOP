package com.ensys.sample.domain.Macode;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QMacodeDtl is a Querydsl query type for MacodeDtl
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QMacodeDtl extends EntityPathBase<MacodeDtl> {

    private static final long serialVersionUID = -1043209717L;

    public static final QMacodeDtl macodeDtl = new QMacodeDtl("macodeDtl");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdField = createString("cdField");

    public final StringPath cdFlag1 = createString("cdFlag1");

    public final StringPath cdFlag2 = createString("cdFlag2");

    public final StringPath cdFlag3 = createString("cdFlag3");

    public final StringPath cdSysdef = createString("cdSysdef");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmSysdef = createString("nmSysdef");

    public final StringPath nmSysdefe = createString("nmSysdefe");

    public final StringPath use_YN = createString("use_YN");

    public QMacodeDtl(String variable) {
        super(MacodeDtl.class, forVariable(variable));
    }

    public QMacodeDtl(Path<? extends MacodeDtl> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMacodeDtl(PathMetadata metadata) {
        super(MacodeDtl.class, metadata);
    }

}


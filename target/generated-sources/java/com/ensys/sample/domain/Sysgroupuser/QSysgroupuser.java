package com.ensys.sample.domain.Sysgroupuser;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QSysgroupuser is a Querydsl query type for Sysgroupuser
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QSysgroupuser extends EntityPathBase<Sysgroupuser> {

    private static final long serialVersionUID = -1899855535L;

    public static final QSysgroupuser sysgroupuser = new QSysgroupuser("sysgroupuser");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdDept = createString("cdDept");

    public final StringPath groupCd = createString("groupCd");

    public final StringPath groupGb = createString("groupGb");

    public final StringPath groupNm = createString("groupNm");

    public final StringPath idUser = createString("idUser");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmUser = createString("nmUser");

    public QSysgroupuser(String variable) {
        super(Sysgroupuser.class, forVariable(variable));
    }

    public QSysgroupuser(Path<? extends Sysgroupuser> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSysgroupuser(PathMetadata metadata) {
        super(Sysgroupuser.class, metadata);
    }

}


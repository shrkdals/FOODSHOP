package com.ensys.sample.domain.Macode;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QMacode is a Querydsl query type for Macode
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QMacode extends EntityPathBase<Macode> {

    private static final long serialVersionUID = -698538479L;

    public static final QMacode macode = new QMacode("macode");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdField = createString("cdField");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmField = createString("nmField");

    public QMacode(String variable) {
        super(Macode.class, forVariable(variable));
    }

    public QMacode(Path<? extends Macode> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMacode(PathMetadata metadata) {
        super(Macode.class, metadata);
    }

}


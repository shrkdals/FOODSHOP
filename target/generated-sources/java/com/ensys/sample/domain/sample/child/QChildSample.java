package com.ensys.sample.domain.sample.child;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QChildSample is a Querydsl query type for ChildSample
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QChildSample extends EntityPathBase<ChildSample> {

    private static final long serialVersionUID = 1338684749L;

    public static final QChildSample childSample = new QChildSample("childSample");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath etc1 = createString("etc1");

    public final StringPath etc2 = createString("etc2");

    public final StringPath etc3 = createString("etc3");

    public final StringPath key = createString("key");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath parentKey = createString("parentKey");

    public final StringPath value = createString("value");

    public QChildSample(String variable) {
        super(ChildSample.class, forVariable(variable));
    }

    public QChildSample(Path<? extends ChildSample> path) {
        super(path.getType(), path.getMetadata());
    }

    public QChildSample(PathMetadata metadata) {
        super(ChildSample.class, metadata);
    }

}


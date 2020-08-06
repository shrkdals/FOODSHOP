package com.ensys.sample.domain.Sysmenu;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QSysmenu is a Querydsl query type for Sysmenu
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QSysmenu extends EntityPathBase<Sysmenu> {

    private static final long serialVersionUID = -876064275L;

    public static final QSysmenu sysmenu = new QSysmenu("sysmenu");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdCompany = createString("cdCompany");

    public final NumberPath<Integer> level = createNumber("level", Integer.class);

    public final StringPath menuGrpCd = createString("menuGrpCd");

    public final StringPath menuId = createString("menuId");

    public final StringPath menuNm = createString("menuNm");

    public final SimplePath<com.fasterxml.jackson.databind.JsonNode> multiLanguageJson = createSimple("multiLanguageJson", com.fasterxml.jackson.databind.JsonNode.class);

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath parentId = createString("parentId");

    public final StringPath parentNm = createString("parentNm");

    public final StringPath progCd = createString("progCd");

    public final StringPath progNm = createString("progNm");

    public final StringPath progPh = createString("progPh");

    public final NumberPath<Integer> sort = createNumber("sort", Integer.class);

    public QSysmenu(String variable) {
        super(Sysmenu.class, forVariable(variable));
    }

    public QSysmenu(Path<? extends Sysmenu> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSysmenu(PathMetadata metadata) {
        super(Sysmenu.class, metadata);
    }

}


package com.ensys.sample.domain.newMenu;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QnewMenu is a Querydsl query type for newMenu
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QnewMenu extends EntityPathBase<newMenu> {

    private static final long serialVersionUID = -691971565L;

    public static final QnewMenu newMenu = new QnewMenu("newMenu");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

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

    public QnewMenu(String variable) {
        super(newMenu.class, forVariable(variable));
    }

    public QnewMenu(Path<? extends newMenu> path) {
        super(path.getType(), path.getMetadata());
    }

    public QnewMenu(PathMetadata metadata) {
        super(newMenu.class, metadata);
    }

}


package com.ensys.sample.domain.Sysusermenu;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QSysusermenu is a Querydsl query type for Sysusermenu
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QSysusermenu extends EntityPathBase<Sysusermenu> {

    private static final long serialVersionUID = -162470141L;

    public static final QSysusermenu sysusermenu = new QSysusermenu("sysusermenu");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath authCode = createString("authCode");

    public final StringPath authD = createString("authD");

    public final StringPath authI = createString("authI");

    public final StringPath authName = createString("authName");

    public final StringPath authS = createString("authS");

    public final StringPath authType = createString("authType");

    public final StringPath authU = createString("authU");

    public final StringPath cdGroup = createString("cdGroup");

    public final StringPath disYn = createString("disYn");

    public final StringPath groupcd = createString("groupcd");

    public final StringPath idUser = createString("idUser");

    public final StringPath menuId = createString("menuId");

    public final StringPath menuNm = createString("menuNm");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath parentId = createString("parentId");

    public final StringPath parentNm = createString("parentNm");

    public final StringPath progCd = createString("progCd");

    public final StringPath progNm = createString("progNm");

    public final StringPath useYn = createString("useYn");

    public QSysusermenu(String variable) {
        super(Sysusermenu.class, forVariable(variable));
    }

    public QSysusermenu(Path<? extends Sysusermenu> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSysusermenu(PathMetadata metadata) {
        super(Sysusermenu.class, metadata);
    }

}


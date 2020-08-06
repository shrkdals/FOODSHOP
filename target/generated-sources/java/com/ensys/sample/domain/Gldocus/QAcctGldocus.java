package com.ensys.sample.domain.Gldocus;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QAcctGldocus is a Querydsl query type for AcctGldocus
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QAcctGldocus extends EntityPathBase<AcctGldocus> {

    private static final long serialVersionUID = 364815140L;

    public static final QAcctGldocus acctGldocus = new QAcctGldocus("acctGldocus");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath AM_AMT = createString("AM_AMT");

    public final StringPath AM_CR = createString("AM_CR");

    public final StringPath AM_DR = createString("AM_DR");

    public final StringPath CD_ACCT_COMMON = createString("CD_ACCT_COMMON");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath DT_ACCT = createString("DT_ACCT");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath NM_ACCT_COMMON = createString("NM_ACCT_COMMON");

    public final StringPath NM_DEPT = createString("NM_DEPT");

    public final StringPath NM_NOTE = createString("NM_NOTE");

    public final StringPath NM_PARTNER = createString("NM_PARTNER");

    public final StringPath NM_PC = createString("NM_PC");

    public final StringPath NM_WRITE = createString("NM_WRITE");

    public final StringPath NO_ACCT = createString("NO_ACCT");

    public final StringPath NO_DOCU = createString("NO_DOCU");

    public final StringPath NO_DOLINE = createString("NO_DOLINE");

    public QAcctGldocus(String variable) {
        super(AcctGldocus.class, forVariable(variable));
    }

    public QAcctGldocus(Path<? extends AcctGldocus> path) {
        super(path.getType(), path.getMetadata());
    }

    public QAcctGldocus(PathMetadata metadata) {
        super(AcctGldocus.class, metadata);
    }

}


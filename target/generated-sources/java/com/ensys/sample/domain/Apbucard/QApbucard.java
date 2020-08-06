package com.ensys.sample.domain.Apbucard;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QApbucard is a Querydsl query type for Apbucard
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QApbucard extends EntityPathBase<Apbucard> {

    private static final long serialVersionUID = 675811441L;

    public static final QApbucard apbucard = new QApbucard("apbucard");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath acctNo = createString("acctNo");

    public final NumberPath<java.math.BigDecimal> adminAmt = createNumber("adminAmt", java.math.BigDecimal.class);

    public final StringPath adminGu = createString("adminGu");

    public final NumberPath<java.math.BigDecimal> amt = createNumber("amt", java.math.BigDecimal.class);

    public final StringPath bankCode = createString("bankCode");

    public final StringPath cdAcct = createString("cdAcct");

    public final StringPath cdBudget = createString("cdBudget");

    public final StringPath cdCc = createString("cdCc");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdEmp = createString("cdEmp");

    public final StringPath cdMdept = createString("cdMdept");

    public final StringPath dtDraft = createString("dtDraft");

    public final StringPath groupNumber = createString("groupNumber");

    public final StringPath jobTp = createString("jobTp");

    public final StringPath mccCodeName = createString("mccCodeName");

    public final StringPath mercAddr = createString("mercAddr");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmAcct = createString("nmAcct");

    public final StringPath nmBudget = createString("nmBudget");

    public final StringPath nmCard = createString("nmCard");

    public final StringPath nmCc = createString("nmCc");

    public final StringPath nmDept = createString("nmDept");

    public final StringPath nmDraft = createString("nmDraft");

    public final StringPath nmUser = createString("nmUser");

    public final NumberPath<Integer> no = createNumber("no", Integer.class);

    public final StringPath noDocu = createString("noDocu");

    public final StringPath noDraft = createString("noDraft");

    public final StringPath noTpdocu = createString("noTpdocu");

    public final StringPath s = createString("s");

    public final StringPath seq = createString("seq");

    public final StringPath sIdno = createString("sIdno");

    public final StringPath stDraft = createString("stDraft");

    public final NumberPath<java.math.BigDecimal> supplyAmt = createNumber("supplyAmt", java.math.BigDecimal.class);

    public final StringPath tpJob = createString("tpJob");

    public final StringPath tradeDate = createString("tradeDate");

    public final StringPath tradeDateF = createString("tradeDateF");

    public final StringPath tradeDateT = createString("tradeDateT");

    public final StringPath tradePlace = createString("tradePlace");

    public final StringPath tradeTime = createString("tradeTime");

    public final NumberPath<java.math.BigDecimal> vatAmt = createNumber("vatAmt", java.math.BigDecimal.class);

    public final StringPath ynDocu = createString("ynDocu");

    public final StringPath ynVat = createString("ynVat");

    public QApbucard(String variable) {
        super(Apbucard.class, forVariable(variable));
    }

    public QApbucard(Path<? extends Apbucard> path) {
        super(path.getType(), path.getMetadata());
    }

    public QApbucard(PathMetadata metadata) {
        super(Apbucard.class, metadata);
    }

}


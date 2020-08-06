package com.ensys.sample.domain.Gldocus;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QGldocus is a Querydsl query type for Gldocus
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QGldocus extends EntityPathBase<Gldocus> {

    private static final long serialVersionUID = -53112393L;

    public static final QGldocus gldocus = new QGldocus("gldocus");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final NumberPath<java.math.BigDecimal> amt = createNumber("amt", java.math.BigDecimal.class);

    public final NumberPath<java.math.BigDecimal> amtSum = createNumber("amtSum", java.math.BigDecimal.class);

    public final NumberPath<java.math.BigDecimal> amtSupply = createNumber("amtSupply", java.math.BigDecimal.class);

    public final NumberPath<java.math.BigDecimal> amtVat = createNumber("amtVat", java.math.BigDecimal.class);

    public final StringPath cdAcct = createString("cdAcct");

    public final StringPath cdBank = createString("cdBank");

    public final StringPath cdBudget = createString("cdBudget");

    public final StringPath cdCc = createString("cdCc");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdDept = createString("cdDept");

    public final StringPath cdDmk = createString("cdDmk");

    public final StringPath cdEmp = createString("cdEmp");

    public final StringPath cdPartner = createString("cdPartner");

    public final StringPath cdProject = createString("cdProject");

    public final StringPath dtAcct = createString("dtAcct");

    public final StringPath dtAcctFrom = createString("dtAcctFrom");

    public final StringPath dtAcctTo = createString("dtAcctTo");

    public final StringPath dtEnd = createString("dtEnd");

    public final StringPath dtsInsert = createString("dtsInsert");

    public final StringPath dtsUpdate = createString("dtsUpdate");

    public final StringPath fgVat = createString("fgVat");

    public final StringPath groupNumber = createString("groupNumber");

    public final StringPath idInsert = createString("idInsert");

    public final StringPath idUpdate = createString("idUpdate");

    public final StringPath idWrite = createString("idWrite");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmAcct = createString("nmAcct");

    public final StringPath nmBank = createString("nmBank");

    public final StringPath nmBudget = createString("nmBudget");

    public final StringPath nmCard = createString("nmCard");

    public final StringPath nmCc = createString("nmCc");

    public final StringPath nmDeposit = createString("nmDeposit");

    public final StringPath nmDept = createString("nmDept");

    public final StringPath nmDmk = createString("nmDmk");

    public final StringPath nmEmp = createString("nmEmp");

    public final StringPath nmPartner = createString("nmPartner");

    public final StringPath nmProject = createString("nmProject");

    public final StringPath nmStCard = createString("nmStCard");

    public final StringPath nmWrite = createString("nmWrite");

    public final StringPath noBank = createString("noBank");

    public final StringPath noCard = createString("noCard");

    public final StringPath noTpdocu = createString("noTpdocu");

    public final StringPath remark = createString("remark");

    public final NumberPath<java.math.BigDecimal> seq = createNumber("seq", java.math.BigDecimal.class);

    public final StringPath tpBill = createString("tpBill");

    public final StringPath tpDrcr = createString("tpDrcr");

    public final StringPath tpEvidence = createString("tpEvidence");

    public final StringPath ynIss = createString("ynIss");

    public QGldocus(String variable) {
        super(Gldocus.class, forVariable(variable));
    }

    public QGldocus(Path<? extends Gldocus> path) {
        super(path.getType(), path.getMetadata());
    }

    public QGldocus(PathMetadata metadata) {
        super(Gldocus.class, metadata);
    }

}


package com.ensys.sample.domain.dept;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QDept is a Querydsl query type for Dept
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QDept extends EntityPathBase<Dept> {

    private static final long serialVersionUID = 389345649L;

    public static final QDept dept = new QDept("dept");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath cdAccount = createString("cdAccount");

    public final StringPath cdBgdeptMap = createString("cdBgdeptMap");

    public final StringPath cdBizarea = createString("cdBizarea");

    public final StringPath cdCc = createString("cdCc");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdDept = createString("cdDept");

    public final StringPath cdDeptMap = createString("cdDeptMap");

    public final StringPath cdLevel = createString("cdLevel");

    public final StringPath cdUser1 = createString("cdUser1");

    public final StringPath cdUser2 = createString("cdUser2");

    public final StringPath cdUserdef3 = createString("cdUserdef3");

    public final StringPath cdUserdef4 = createString("cdUserdef4");

    public final StringPath dcRmk1 = createString("dcRmk1");

    public final StringPath dcRmk2 = createString("dcRmk2");

    public final StringPath dtEnd = createString("dtEnd");

    public final StringPath dtsInsert = createString("dtsInsert");

    public final StringPath dtStart = createString("dtStart");

    public final StringPath dtsUpdate = createString("dtsUpdate");

    public final StringPath edDept = createString("edDept");

    public final StringPath enDept = createString("enDept");

    public final StringPath hDept = createString("hDept");

    public final StringPath idInsert = createString("idInsert");

    public final StringPath idUpdate = createString("idUpdate");

    public final NumberPath<java.math.BigDecimal> lbDept = createNumber("lbDept", java.math.BigDecimal.class);

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmDept = createString("nmDept");

    public final StringPath nmDeptL1 = createString("nmDeptL1");

    public final StringPath nmDeptL2 = createString("nmDeptL2");

    public final StringPath nmDeptL3 = createString("nmDeptL3");

    public final StringPath nmDeptL4 = createString("nmDeptL4");

    public final StringPath nmDeptL5 = createString("nmDeptL5");

    public final StringPath nmDeptMap = createString("nmDeptMap");

    public final StringPath nmUserdef2 = createString("nmUserdef2");

    public final StringPath nmUserdef3 = createString("nmUserdef3");

    public final StringPath nmUserdef4 = createString("nmUserdef4");

    public final StringPath noEmpmng = createString("noEmpmng");

    public final StringPath noFax = createString("noFax");

    public final StringPath noSort = createString("noSort");

    public final StringPath noTel = createString("noTel");

    public final StringPath sdDept = createString("sdDept");

    public final StringPath tpCal = createString("tpCal");

    public final StringPath tpDept = createString("tpDept");

    public final StringPath ynRest = createString("ynRest");

    public QDept(String variable) {
        super(Dept.class, forVariable(variable));
    }

    public QDept(Path<? extends Dept> path) {
        super(path.getType(), path.getMetadata());
    }

    public QDept(PathMetadata metadata) {
        super(Dept.class, metadata);
    }

}


package com.ensys.sample.domain.Mapartnerm;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QMapartnerm is a Querydsl query type for Mapartnerm
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QMapartnerm extends EntityPathBase<Mapartnerm> {

    private static final long serialVersionUID = 2035356049L;

    public static final QMapartnerm mapartnerm = new QMapartnerm("mapartnerm");

    public final com.ensys.sample.domain.QSimpleJpaModel _super = new com.ensys.sample.domain.QSimpleJpaModel(this);

    public final StringPath ads = createString("ads");

    public final StringPath cdBank = createString("cdBank");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdPartner = createString("cdPartner");

    public final StringPath clsJob = createString("clsJob");

    public final StringPath dcAds1d = createString("dcAds1d");

    public final StringPath dcAds1h = createString("dcAds1h");

    public final StringPath dtsInsert = createString("dtsInsert");

    public final StringPath dtsUpdate = createString("dtsUpdate");

    public final StringPath fgPartner = createString("fgPartner");

    public final StringPath idInsert = createString("idInsert");

    public final StringPath idUpdate = createString("idUpdate");

    public final StringPath lnPartner = createString("lnPartner");

    //inherited
    public final BooleanPath new$ = _super.new$;

    public final StringPath nmBank = createString("nmBank");

    public final StringPath nmCeo = createString("nmCeo");

    public final StringPath nmDeposit = createString("nmDeposit");

    public final StringPath nmEmail = createString("nmEmail");

    public final StringPath nmKord = createString("nmKord");

    public final StringPath nmNote = createString("nmNote");

    public final StringPath nmPtr = createString("nmPtr");

    public final StringPath noCompany = createString("noCompany");

    public final StringPath noDeposit = createString("noDeposit");

    public final StringPath noEamil = createString("noEamil");

    public final StringPath noFax = createString("noFax");

    public final StringPath noFax1 = createString("noFax1");

    public final StringPath noHp = createString("noHp");

    public final StringPath noPost1 = createString("noPost1");

    public final StringPath noRes = createString("noRes");

    public final StringPath noTel = createString("noTel");

    public final StringPath noTel1 = createString("noTel1");

    public final StringPath noTelEmer = createString("noTelEmer");

    public final NumberPath<java.math.BigDecimal> seq = createNumber("seq", java.math.BigDecimal.class);

    public final StringPath tpJob = createString("tpJob");

    public final StringPath useYn = createString("useYn");

    public QMapartnerm(String variable) {
        super(Mapartnerm.class, forVariable(variable));
    }

    public QMapartnerm(Path<? extends Mapartnerm> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMapartnerm(PathMetadata metadata) {
        super(Mapartnerm.class, metadata);
    }

}


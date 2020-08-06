package com.ensys.sample.domain.dept;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;


/**
 * QDept_DeptId is a Querydsl query type for DeptId
 */
@Generated("com.querydsl.codegen.EmbeddableSerializer")
public class QDept_DeptId extends BeanPath<Dept.DeptId> {

    private static final long serialVersionUID = -149235331L;

    public static final QDept_DeptId deptId = new QDept_DeptId("deptId");

    public final StringPath cdCompany = createString("cdCompany");

    public final StringPath cdDept = createString("cdDept");

    public QDept_DeptId(String variable) {
        super(Dept.DeptId.class, forVariable(variable));
    }

    public QDept_DeptId(Path<? extends Dept.DeptId> path) {
        super(path.getType(), path.getMetadata());
    }

    public QDept_DeptId(PathMetadata metadata) {
        super(Dept.DeptId.class, metadata);
    }

}


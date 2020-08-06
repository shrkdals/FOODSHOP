package com.ensys.sample.domain.Gldocus;


import com.chequer.axboot.core.annotations.Comment;
import com.ensys.sample.domain.SimpleJpaModel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "CZ_ACCT")
@Comment(value = "")

@Alias("AcctGldocus")
public class AcctGldocus extends SimpleJpaModel {


    @Id
    @Column(name = "CD_COMPANY", length = 7, nullable = false)
    @Comment(value = "")
    private String cdCompany;


    @Column(name = "CD_ACCT_COMMON", length = 50, nullable = false)
    @Comment(value = "")
    private String CD_ACCT_COMMON;

    @Column(name = "NM_ACCT_COMMON", length = 50, nullable = false)
    @Comment(value = "")
    private String NM_ACCT_COMMON;


    @Column(name = "DT_ACCT", length = 50, nullable = false)
    @Comment(value = "")
    private String DT_ACCT;

    @Column(name = "NO_ACCT", length = 50, nullable = false)
    @Comment(value = "")
    private String NO_ACCT;


    @Column(name = "NM_NOTE", length = 50, nullable = false)
    @Comment(value = "")
    private String NM_NOTE;

    @Column(name = "NM_PARTNER", length = 50, nullable = false)
    @Comment(value = "")
    private String NM_PARTNER;


    @Column(name = "AM_DR", length = 50, nullable = false)
    @Comment(value = "")
    private String AM_DR;

    @Column(name = "AM_CR", length = 50, nullable = false)
    @Comment(value = "")
    private String AM_CR;

    @Column(name = "AM_AMT", length = 50, nullable = false)
    @Comment(value = "")
    private String AM_AMT;

    @Column(name = "NM_PC", length = 50, nullable = false)
    @Comment(value = "")
    private String NM_PC;

    @Column(name = "NM_DEPT", length = 50, nullable = false)
    @Comment(value = "")
    private String NM_DEPT;

    @Column(name = "NM_WRITE", length = 50, nullable = false)
    @Comment(value = "")
    private String NM_WRITE;

    @Column(name = "NO_DOCU", length = 50, nullable = false)
    @Comment(value = "")
    private String NO_DOCU;

    @Column(name = "NO_DOLINE", length = 50, nullable = false)
    @Comment(value = "")
    private String NO_DOLINE;

    @Override
    public String getId() {
        return cdCompany;
    }
}



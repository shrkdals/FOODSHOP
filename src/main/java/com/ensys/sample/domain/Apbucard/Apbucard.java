package com.ensys.sample.domain.Apbucard;


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
@Table(name = "CARD_TEMP")
@Comment(value = "")
@Alias("Apbucard")
public class Apbucard extends SimpleJpaModel {

    @Id
    @Column(name = "CD_COMPANY", length = 7)
    @Comment(value = "")
    private String cdCompany;

    @Column(name = "ACCT_NO", length = 20)
    @Comment(value = "")
    private String acctNo;

    @Column(name = "NM_CARD", length = 20)
    @Comment(value = "")
    private String nmCard;


    @Column(name = "S", length = 1)
    @Comment(value = "")
    private String s;

    @Column(name = "BANK_CODE", length = 10)
    @Comment(value = "")
    private String bankCode;

    @Column(name = "TRADE_DATE", length = 8)
    @Comment(value = "")
    private String tradeDate;

    @Column(name = "TRADE_DATE_F", length = 8)
    @Comment(value = "")
    private String tradeDateF;

    @Column(name = "TRADE_DATE_T", length = 8)
    @Comment(value = "")
    private String tradeDateT;

    @Column(name = "TRADE_TIME", length = 6)
    @Comment(value = "")
    private String tradeTime;

    @Column(name = "SEQ", length = 6)
    @Comment(value = "")
    private String seq;

    @Column(name = "NO", precision = 10)
    @Comment(value = "")
    private Integer no;

    @Column(name = "CD_ACCT", length = 10)
    @Comment(value = "")
    private String cdAcct;

    @Column(name = "NM_ACCT", length = 50)
    @Comment(value = "")
    private String nmAcct;


    @Column(name = "CD_CC", length = 6)
    @Comment(value = "")
    private String cdCc;

    @Column(name = "NM_CC", length = 50)
    @Comment(value = "")
    private String nmCc;

    @Column(name = "CD_BUDGET", length = 12)
    @Comment(value = "")
    private String cdBudget;

    @Column(name = "NM_BUDGET", length = 12)
    @Comment(value = "")
    private String nmBudget;

    @Column(name = "AMT", precision = 17, scale = 4)
    @Comment(value = "")
    private BigDecimal amt;


    @Column(name = "TRADE_PLACE", length = 100)
    @Comment(value = "")
    private String tradePlace;


    @Column(name = "S_IDNO", length = 13)
    @Comment(value = "")
    private String sIdno;

    @Column(name = "MCC_CODE_NAME", length = 50)
    @Comment(value = "")
    private String mccCodeName;

    @Column(name = "GROUP_NUMBER", length = 50)
    @Comment(value = "")
    private String groupNumber;

    @Column(name = "NO_TPDOCU", length = 13)
    @Comment(value = "")
    private String noTpdocu;

    @Column(name = "NO_DRAFT", length = 13)
    @Comment(value = "")
    private String noDraft;


    @Column(name = "YN_VAT", length = 1)
    @Comment(value = "")
    private String ynVat;


    @Column(name = "SUPPLY_AMT", precision = 19, scale = 4)
    @Comment(value = "")
    private BigDecimal supplyAmt;


    @Column(name = "VAT_AMT", precision = 19, scale = 4)
    @Comment(value = "")
    private BigDecimal vatAmt;


    @Column(name = "ADMIN_GU", length = 1)
    @Comment(value = "")
    private String adminGu;

    @Column(name = "ADMIN_AMT", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private BigDecimal adminAmt;

    @Column(name = "JOB_TP", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String jobTp;

    @Column(name = "DT_DRAFT", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String dtDraft;


    @Column(name = "ST_DRAFT", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String stDraft;

    @Column(name = "NM_DRAFT", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String nmDraft;

    @Column(name = "YN_DOCU", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String ynDocu;

    @Column(name = "CD_EMP", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String cdEmp;

    @Column(name = "NM_USER", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String nmUser;

    @Column(name = "CD_MDEPT", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String cdMdept;

    @Column(name = "NM_DEPT", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String nmDept;

    @Column(name = "TP_JOB", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String tpJob;

    @Column(name = "MERC_ADDR", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String mercAddr;

    @Column(name = "NO_DOCU", precision = 19, scale = 4, nullable = false)
    @Comment(value = "")
    private String noDocu;



    @Override
    public String getId() {
        return cdCompany;
    }

}
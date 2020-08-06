package com.ensys.sample.domain.Gldocus;


import com.ensys.sample.domain.SimpleJpaModel;
import lombok.*;
import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import com.chequer.axboot.core.annotations.Comment;
import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "CZ_DISBDOC")
@Comment(value = "")

@Alias("Gldocus")
public class Gldocus extends SimpleJpaModel {

    @Id
    @Column(name = "CD_COMPANY", length = 7, nullable = false)
    @Comment(value = "")
    private String cdCompany;


    @Column(name = "NO_TPDOCU", length = 50, nullable = false)
    @Comment(value = "")
    private String noTpdocu;


    @Column(name = "GROUP_NUMBER", length = 50, nullable = false)
    @Comment(value = "")
    private String groupNumber;

    @Column(name = "TP_BILL", length = 30, nullable = false)
    @Comment(value = "")
    private String tpBill;

    @Column(name = "CD_DMK", length = 30, nullable = false)
    @Comment(value = "")
    private String cdDmk;

    @Column(name = "NM_DMK", length = 30, nullable = false)
    @Comment(value = "")
    private String nmDmk;

    @Column(name = "CD_EMP", length = 20, nullable = false)
    @Comment(value = "")
    private String cdEmp;

    @Column(name = "NM_EMP", length = 20, nullable = false)
    @Comment(value = "")
    private String nmEmp;

    @Column(name = "CD_DEPT", length = 20, nullable = false)
    @Comment(value = "")
    private String cdDept;

    @Column(name = "NM_DEPT", length = 20, nullable = false)
    @Comment(value = "")
    private String nmDept;

    @Column(name = "DT_ACCT", length = 20, nullable = false)
    @Comment(value = "")
    private String dtAcct;

    @Column(name = "DT_ACCT_FROM", length = 20, nullable = false)
    @Comment(value = "")
    private String dtAcctFrom;

    @Column(name = "DT_ACCT_TO", length = 20, nullable = false)
    @Comment(value = "")
    private String dtAcctTo;

    @Column(name = "CD_PARTNER", length = 20)
    @Comment(value = "")
    private String cdPartner;

    @Column(name = "NM_PARTNER", length = 20)
    @Comment(value = "")
    private String nmPartner;

    @Column(name = "AMT_SUPPLY", precision = 17, scale = 4, nullable = false)
    @Comment(value = "")
    private BigDecimal amtSupply;

    @Column(name = "AMT_VAT", precision = 17, scale = 4)
    @Comment(value = "")
    private BigDecimal amtVat;

    @Column(name = "AMT_SUM", precision = 17, scale = 4)
    @Comment(value = "")
    private BigDecimal amtSum;

    @Column(name = "FG_VAT", length = 5)
    @Comment(value = "")
    private String fgVat;

    @Column(name = "YN_ISS", length = 1, nullable = false)
    @Comment(value = "")
    private String ynIss;

    @Column(name = "REMARK", length = 500)
    @Comment(value = "")
    private String remark;

    @Column(name = "ID_INSERT", length = 30)
    @Comment(value = "")
    private String idInsert;

    @Column(name = "DTS_INSERT", length = 30)
    @Comment(value = "")
    private String dtsInsert;

    @Column(name = "ID_UPDATE", length = 30)
    @Comment(value = "")
    private String idUpdate;

    @Column(name = "DTS_UPDATE", length = 30)
    @Comment(value = "")
    private String dtsUpdate;

    @Column(name = "ID_WRITE", length = 20, nullable = false)
    @Comment(value = "")
    private String idWrite;

    @Column(name = "NM_WRITE", length = 20, nullable = false)
    @Comment(value = "")
    private String nmWrite;

    @Column(name = "AMT", precision = 17, scale = 4)
    @Comment(value = "")
    private BigDecimal amt;


    @Column(name = "TP_EVIDENCE", length = 20, nullable = false)
    @Comment(value = "")
    private String tpEvidence;

    @Column(name = "CD_BUDGET", length = 20, nullable = false)
    @Comment(value = "")
    private String cdBudget;

    @Column(name = "NM_BUDGET", length = 20, nullable = false)
    @Comment(value = "")
    private String nmBudget;

    @Column(name = "CD_CC", length = 20, nullable = false)
    @Comment(value = "")
    private String cdCc;

    @Column(name = "NM_CC", length = 20, nullable = false)
    @Comment(value = "")
    private String nmCc;

    @Column(name = "DT_END", length = 20, nullable = false)
    @Comment(value = "")
    private String dtEnd;

    @Column(name = "CD_BANK", length = 20, nullable = false)
    @Comment(value = "")
    private String cdBank;

    @Column(name = "NM_BANK", length = 20, nullable = false)
    @Comment(value = "")
    private String nmBank;

    @Column(name = "NO_BANK", length = 20, nullable = false)
    @Comment(value = "")
    private String noBank;

    @Column(name = "NM_DEPOSIT", length = 20, nullable = false)
    @Comment(value = "")
    private String nmDeposit;

    @Column(name = "NO_CARD", length = 20, nullable = false)
    @Comment(value = "")
    private String noCard;

    @Column(name = "NM_CARD", length = 20, nullable = false)
    @Comment(value = "")
    private String nmCard;

    @Column(name = "NM_ST_CARD", length = 20, nullable = false)
    @Comment(value = "")
    private String nmStCard;


    @Column(name = "TP_DRCR", length = 20, nullable = false)
    @Comment(value = "")
    private String tpDrcr;

    @Column(name = "CD_ACCT", length = 20, nullable = false)
    @Comment(value = "")
    private String cdAcct;

    @Column(name = "NM_ACCT", length = 20, nullable = false)
    @Comment(value = "")
    private String nmAcct;


    @Column(name = "CD_PROJECT", length = 20, nullable = false)
    @Comment(value = "")
    private String cdProject;

    @Column(name = "NM_PROJECT", length = 20, nullable = false)
    @Comment(value = "")
    private String nmProject;

    @Column(name = "SEQ", length = 20, nullable = false)
    @Comment(value = "")
    private BigDecimal seq;


    @Override
    public String getId() {
        return cdCompany;
    }
}


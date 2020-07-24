package com.ensys.sample.domain.Gldocus;

import com.chequer.axboot.core.annotations.Comment;
import com.chequer.axboot.core.utils.ModelMapperUtils;
import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class GldocusVO extends BaseVO {

    private String cdCompany;
    private String noTpdocu;
    private String groupNumber;
    private String tpBill;
    private String cdDmk;
    private String nmDmk;
    private String cdEmp;
    private String nmEmp;
    private String cdDept;
    private String nmDept;
    private String dtAcct;

    private String dtAcctFrom;
    private String dtAcctTo;

    private String cdPartner;
    private String nmPartner;
    private BigDecimal amtSupply;
    private BigDecimal amtVat;
    private BigDecimal amtSum;
    private String fgVat;
    private String ynIss;
    private String remark;
    private String idInsert;
    private String dtsInsert;
    private String idUpdate;
    private String dtsUpdate;
    private String idWrite;
    private String nmWrite;
    private BigDecimal amt;
    private String tpEvidence;
    private String cdBudget;
    private String nmBudget;
    private String cdCc;
    private String nmCc;
    private String dtEnd;
    private String cdBank;
    private String noBank;
    private String nmDeposit;
    private String noCard;
    private String nmCard;
    private String nmStCard;
    private String tpDrcr;
    private String cdAcct;
    private String nmAcct;
    private BigDecimal seq;
    private String cdProject;
    private String nmProject;


    public static GldocusVO of(Gldocus disdocs) {
        GldocusVO disdocsVO = ModelMapperUtils.map(disdocs, GldocusVO.class);
        return disdocsVO;
    }


}

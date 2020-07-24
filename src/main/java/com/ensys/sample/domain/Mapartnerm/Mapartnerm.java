package com.ensys.sample.domain.Mapartnerm;


import com.chequer.axboot.core.annotations.Comment;
import com.ensys.sample.domain.SimpleJpaModel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import system.Decimal;

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
@Table(name = "MA_PARTNER")
@Comment(value = "")
@Alias("Mapartnerm")
public class Mapartnerm extends SimpleJpaModel {

    @Id
    @Column(name = "CD_COMPANY", length = 7)
    @Comment(value = "회사코드")
    private String cdCompany;

    @Column(name = "CD_PARTNER", length = 7)
    @Comment(value = "거래처코드")
    private String cdPartner;


    @Column(name = "LN_PARTNER", length = 50)
    @Comment(value = "거래처명")
    private String lnPartner;


    @Column(name = "NO_COMPANY", length = 10)
    @Comment(value = "사업자등록번호")
    private String noCompany;

    @Column(name = "FG_PARTNER", length = 3)
    @Comment(value = "거래처구분")
    private String fgPartner;

    @Column(name = "NM_CEO", length = 20)
    @Comment(value = "대표자명")
    private String nmCeo;

    @Column(name = "NO_RES", length = 20)
    @Comment(value = "대표자주민번호")
    private String noRes;

    @Column(name = "NO_POST1", length = 15)
    @Comment(value = "우편번호")
    private String noPost1;

    @Column(name = "DC_ADS1_H", length = 100)
    @Comment(value = "주소")
    private String dcAds1h;

    @Column(name = "DC_ADS1_D", length = 100)
    @Comment(value = "상세주소")
    private String dcAds1d;

    @Column(name = "NO_TEL1", length = 20)
    @Comment(value = "noTel1")
    private String noTel1;

    @Column(name = "NO_FAX1", length = 20)
    @Comment(value = "팩스번호")
    private String noFax1;

    @Column(name = "TP_JOB", length = 50)
    @Comment(value = "업태")
    private String tpJob;


    @Column(name = "CLS_JOB", length = 50)
    @Comment(value = "업종")
    private String clsJob;




    @Column(name = "ads", length = 50)
    @Comment(value = "주소")
    private String  ads		        ;

    @Column(name = "nmKord", length = 50)
    @Comment(value = "담당자명")
    private String  nmKord          ;

    @Column(name = "noTel", length = 50)
    @Comment(value = "담당자번화번호")
    private String  noTel           ;

    @Column(name = "noTelEmer", length = 50)
    @Comment(value = "담당자핸드폰번호")
    private String  noTelEmer       ;

    @Column(name = "noEamil", length = 50)
    @Comment(value = "담당자이메일")
    private String  noEamil         ;

    @Column(name = "nmDeposit", length = 50)
    @Comment(value = "예금주")
    private String  nmDeposit       ;

    @Column(name = "noDeposit", length = 50)
    @Comment(value = "계좌번호")
    private String  noDeposit       ;

    @Column(name = "idInsert", length = 50)
    @Comment(value = "입력자")
    private String  idInsert        ;

    @Column(name = "dtsInsert", length = 50)
    @Comment(value = "입력일")
    private String  dtsInsert       ;

    @Column(name = "idUpdate", length = 50)
    @Comment(value = "수정자")
    private String  idUpdate        ;

    @Column(name = "dtsUpdate", length = 50)
    @Comment(value = "수정일")
    private String  dtsUpdate       ;

    @Column(name = "nmNote", length = 50)
    @Comment(value = "비고")
    private String  nmNote          ;



    @Column(name = "cdBank", length = 20)
    @Comment(value = "은행코드")
    private String  cdBank          ;


    @Column(name = "nmBank", length = 20)
    @Comment(value = "은행코드")
    private String  nmBank          ;

    @Column(name = "useYn", length = 20)
    @Comment(value = "사용여부")
    private String  useYn          ;



    @Column(name = "seq", precision = 5)
    @Comment(value = "담당자 순번")
    private BigDecimal seq          ;


    @Column(name = "nmPtr", length = 20)
    @Comment(value = "거래처담당자")
    private String  nmPtr          ;

    @Column(name = "noHp", length = 20)
    @Comment(value = "담당자핸드폰번호")
    private String  noHp          ;

    @Column(name = "nmEmail", length = 20)
    @Comment(value = "담당자이메일")
    private String  nmEmail          ;


    @Column(name = "NO_FAX", length = 20)
    @Comment(value = "담당자 팩스번호")
    private String noFax;







    @Override
    public String getId() {
        return cdCompany;
    }

}
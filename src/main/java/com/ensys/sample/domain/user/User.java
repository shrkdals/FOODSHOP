package com.ensys.sample.domain.user;

import com.chequer.axboot.core.annotations.Comment;
import com.ensys.sample.domain.SimpleJpaModel;
import com.ensys.sample.domain.user.auth.UserAuth;
import com.ensys.sample.domain.user.role.UserRole;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;
import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@Table(name = "MA_USER")

//@Alias("user")
//@IdClass(User.UserPk.class)
//@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "idUser")
public class User extends SimpleJpaModel {


    @Column(name = "CD_COMPANY", length = 7, nullable = false)
    private String cdCompany;

    @Column(name = "CD_GROUP", length = 7, nullable = false)
    private String cdGroup;

    @Id
    @Column(name = "ID_USER", length = 15, nullable = false)
    private String idUser;

    @Column(name = "NM_USER", length = 40)
    private String nmUser;

    @Column(name = "PASS_WORD", length = 200)
    private String passWord;

    @Column(name = "NM_EMP", length = 40)
    private String nmEmp;

    @Column(name = "NO_EMP", length = 40)
    private String noEmp;

    @Column(name = "CD_DEPT", length = 40)
    private String cdDept;

    @Column(name = "NM_DEPT", length = 40)
    private String nmDept;

    @Column(name = "CD_BIZAREA", length = 40)
    private String cdBizarea;

    @Column(name = "NM_BIZAREA", length = 40)
    private String nmBIZRAREA;

    @Column(name = "CD_PC", length = 40)
    private String cdPc;

    @Column(name = "NM_PC", length = 40)
    private String nmPc;

    @Column(name = "CD_CC", length = 40)
    private String cdCc;

    @Column(name = "NM_CC", length = 40)
    private String nmCc;

    @Column(name = "NM_DUTY_RANK", length = 40)
    private String nmDutyRank;

    @Column(name = "CD_DUTY_RANK", length = 40)
    private String cdDutyRank;

    @Column(name = "MENU_ID", length = 40)
    private String menu_id;
//    @Id
//    @Column(name = "ID_USER", length = 15, nullable = false)
//    @Comment(value = "")
//    private String idUser;
//    @Id
//    @Column(name = "CD_COMPANY", length = 7, nullable = false)
//    @Comment(value = "")
//    private String cdCompany;
//    @Column(name = "NM_USER", length = 40)
//    @Comment(value = "")
//    private String nmUser;
//    @Column(name = "PASS_WORD", length = 200)
//    @Comment(value = "")
//    private String passWord;
//    @Column(name = "USR_GBN", length = 3, nullable = false)
//    @Comment(value = "")
//    private String usrGbn;
//    @Column(name = "NO_EMP", length = 10)
//    @Comment(value = "")
//    private String noEmp;
//    @Column(name = "ST_DOCUAPP", length = 3)
//    @Comment(value = "")
//    private String stDocuapp;
//    @Column(name = "DC_DOMAIN", length = 255)
//    @Comment(value = "")
//    private String dcDomain;
//    @Column(name = "DC_ACCOUNT", length = 255)
//    @Comment(value = "")
//    private String dcAccount;
//    @Column(name = "GRD_USER", length = 3)
//    @Comment(value = "")
//    private String grdUser;
//    @Column(name = "ID_INSERT", length = 15)
//    @Comment(value = "")
//    private String idInsert;
//    @Column(name = "DTS_INSERT", length = 14)
//    @Comment(value = "")
//    private String dtsInsert;
//    @Column(name = "ID_UPDATE", length = 15)
//    @Comment(value = "")
//    private String idUpdate;
//    @Column(name = "DTS_UPDATE", length = 14)
//    @Comment(value = "")
//    private String dtsUpdate;
//    @Column(name = "YN_NTC", length = 1)
//    @Comment(value = "")
//    private String ynNtc;
//    @Column(name = "YN_CRYPTO", length = 1)
//    @Comment(value = "")
//    private String ynCrypto;
//    @Column(name = "SET_PWD_DAY")
//    @Comment(value = "")
//    private Timestamp setPwdDay;
//    @Column(name = "USE_CNT", precision = 10)
//    @Comment(value = "")
//    private Integer useCnt;
//    @Column(name = "YN_GW", length = 1)
//    @Comment(value = "")
//    private String ynGw;
//    @Column(name = "CD_GW", length = 1)
//    @Comment(value = "")
//    private String cdGw;
//    @Column(name = "CD_PW", length = 1)
//    @Comment(value = "")
//    private String cdPw;
//    @Column(name = "EMAIL", length = 100)
//    @Comment(value = "")
//    private String email;
//    @Column(name = "NO_TEL", length = 20)
//    @Comment(value = "")
//    private String noTel;
//    @Column(name = "CD_PARTNER", length = 20)
//    @Comment(value = "")
//    private String cdPartner;
//    @Column(name = "CD_TPPTR", length = 20)
//    @Comment(value = "")
//    private String cdTpptr;
//    @Column(name = "CD_PLANT", length = 7)
//    @Comment(value = "")
//    private String cdPlant;
//    @Column(name = "CD_EXT", length = 3)
//    @Comment(value = "")
//    private String cdExt;
//    @Column(name = "ID_MENU", length = 30)
//    @Comment(value = "")
//    private String idMenu;
//    @Column(name = "CD_SALEGRP", length = 12)
//    @Comment(value = "")
//    private String cdSalegrp;
//    @Column(name = "CD_PURGRP", length = 12)
//    @Comment(value = "")
//    private String cdPurgrp;
//    @Column(name = "YN_DEPT_AUTH", length = 1)
//    @Comment(value = "")
//    private String ynDeptAuth;
//    @Column(name = "SMART_SFA", length = 30)
//    @Comment(value = "")
//    private String smartSfa;
//    @Column(name = "FG_INFORMATION", length = 1)
//    @Comment(value = "")
//    private String fgInformation;
//    @Column(name = "DC_RMK1", length = 100)
//    @Comment(value = "")
//    private String dcRmk1;
//    @Column(name = "DC_RMK2", length = 100)
//    @Comment(value = "")
//    private String dcRmk2;
//    @Column(name = "DC_RMK3", length = 100)
//    @Comment(value = "")
//    private String dcRmk3;
//    @Column(name = "DC_RMK4", length = 100)
//    @Comment(value = "")
//    private String dcRmk4;
//    @Column(name = "DC_RMK5", length = 100)
//    @Comment(value = "")
//    private String dcRmk5;
//    @Column(name = "CD_STOP", length = 1, nullable = false)
//    @Comment(value = "")
//    private String cdStop;
//    @Column(name = "CD_STOP_CLEAR", length = 1, nullable = false)
//    @Comment(value = "")
//    private String cdStopClear;
//    @Column(name = "NM_USER_L1", length = 40)
//    @Comment(value = "")
//    private String nmUserL1;
//    @Column(name = "NM_USER_L2", length = 40)
//    @Comment(value = "")
//    private String nmUserL2;
//    @Column(name = "NM_USER_L3", length = 40)
//    @Comment(value = "")
//    private String nmUserL3;
//    @Column(name = "NM_USER_L4", length = 40)
//    @Comment(value = "")
//    private String nmUserL4;
//    @Column(name = "NM_USER_L5", length = 40)
//    @Comment(value = "")
//    private String nmUserL5;
//
//    @Transient
//    private List<UserRole> roleList;
//
//    @Transient
//    private List<UserAuth> authList;

    @Override
    public String getId() {
        return idUser;
    }

//    @Embeddable
//    @Data
//    @NoArgsConstructor
//    @RequiredArgsConstructor(staticName = "of")
//    public static class UserPk implements Serializable {
//        @NonNull
//        private String idUser;
//        @NonNull
//        private String cdCompany;
//    }
}

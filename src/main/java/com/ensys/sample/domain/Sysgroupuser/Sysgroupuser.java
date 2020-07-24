package com.ensys.sample.domain.Sysgroupuser;


import com.chequer.axboot.core.annotations.ColumnPosition;
import com.chequer.axboot.core.annotations.Comment;
import com.chequer.axboot.core.jpa.JsonNodeConverter;
import com.ensys.sample.domain.SimpleJpaModel;
import com.fasterxml.jackson.databind.JsonNode;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "authGroup")
@Comment(value = "")
@Alias("Sysgroupuser")
public class Sysgroupuser extends SimpleJpaModel {

    @Id
    @Column(name = "CD_COMPANY", length = 7 )
    @Comment(value = "회사코드")
    @ColumnPosition(1)
    private String cdCompany;

    @Column(name = "GROUP_CD", length = 50 )
    @Comment(value = "그룹코드")
    @ColumnPosition(2)
    private String groupCd;

    @Column(name = "GROUP_GB", length = 50 )
    @Comment(value = "그룹구분 ")
    @ColumnPosition(3)
    private String groupGb;

    @Column(name = "GROUP_NM", length = 50 )
    @Comment(value = "그룹명")
    @ColumnPosition(4)
    private String groupNm;

    @Column(name = "ID_USER", length = 100)
    @Comment(value = "사용자아이디")
    @ColumnPosition(5)
    private String idUser;

    @Column(name = "NM_USER", length = 100)
    @Comment(value = "사용자명")
    @ColumnPosition(6)
    private String  nmUser;


    @Column(name = "CD_DEPT", length = 100)
    @Comment(value = "부서")
    @ColumnPosition(7)
    private String  cdDept;


    @Override
    public String getId() {
        return groupCd;
    }

}
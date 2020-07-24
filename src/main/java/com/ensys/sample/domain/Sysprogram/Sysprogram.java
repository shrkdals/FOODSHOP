package com.ensys.sample.domain.Sysprogram;


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
import java.math.BigDecimal;


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "newMenu")
@Comment(value = "")
@Alias("Sysprogram")
public class Sysprogram extends SimpleJpaModel {

    @Id
    @Column(name = "CD_COMPANY", length = 7 )
    @Comment(value = "회사 코드")
    @ColumnPosition(1)
    private String cdCompany;

    @Column(name = "MENU_ID", length = 20 )
    @Comment(value = "ID")
    @ColumnPosition(2)
    private String menuId;

    @Column(name = "MENU_GRP_CD", length = 100)
    @Comment(value = "메뉴 그룹코드")
    @ColumnPosition(3)
    private String menuGrpCd;

    @Column(name = "MENU_NM", length = 100)
    @Comment(value = "메뉴명")
    @ColumnPosition(4)
    private String menuNm;

    @Column(name = "MULTI_LANGUAGE", length = 100)
    @Comment(value = "메뉴 다국어 필드")
    @ColumnPosition(5)
    @Convert(converter = JsonNodeConverter.class)
    private JsonNode multiLanguageJson;

    @Column(name = "PARENT_ID", length = 20 )
    @Comment(value = "부모 ID")
    @ColumnPosition(6)
    private String parentId;

    @Column(name = "LEVEL", precision = 10)
    @Comment(value = "레벨")
    @ColumnPosition(7)
    private Integer level;

    @Column(name = "SORT", precision = 10)
    @Comment(value = "정렬")
    @ColumnPosition(8)
    private Integer sort;

    @Column(name = "PROG_CD", length = 50)
    @Comment(value = "프로그램 코드")
    @ColumnPosition(9)
    private String progCd;


    @Column(name = "PROG_NM", length = 50)
    @ColumnPosition(10)
    @NonNull
    private String progNm;

    @Column(name = "PROG_PH", length = 100)
    @ColumnPosition(11)
    @NonNull
    private String progPh;

    @Column(name = "PARENT_NM", length = 100)
    @ColumnPosition(12)
    @NonNull
    private String parentNm;

    @Override
    public String getId() {
        return menuId;
    }

}
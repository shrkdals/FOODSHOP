package com.ensys.sample.domain.Sysusermenu;


import com.chequer.axboot.core.annotations.ColumnPosition;
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


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "auth")
@Comment(value = "")
@Alias("Sysusermenu")
public class Sysusermenu extends SimpleJpaModel {

    @Id
    @Column(name = "AUTH_TYPE", length = 50 )
    @Comment(value = "권한 구분")
    @ColumnPosition(1)
    private String authType;

    @Column(name = "AUTH_CODE", length = 50 )
    @Comment(value = "권한코드")
    @ColumnPosition(2)
    private String authCode;

    @Column(name = "AUTH_NAME", length = 50 )
    @Comment(value = "권한명")
    @ColumnPosition(2)
    private String authName;

    @Column(name = "PARENT_ID", length = 100)
    @Comment(value = "상위메뉴아이디")
    @ColumnPosition(3)
    private String parentId;

    @Column(name = "PARENT_NM", length = 100)
    @Comment(value = "상위메뉴명")
    @ColumnPosition(4)
    private String  parentNm;


    @Column(name = "MENU_ID", length = 100)
    @Comment(value = "메뉴아이디")
    @ColumnPosition(5)
    private String  menuId;


    @Column(name = "MENU_NM", length = 100)
    @Comment(value = "메뉴명")
    @ColumnPosition(6)
    private String  menuNm;


    @Column(name = "PROG_CD", length = 100)
    @Comment(value = "프로그램코드")
    @ColumnPosition(7)
    private String  progCd;


    @Column(name = "PROG_NM", length = 100)
    @Comment(value = "프로그램명")
    @ColumnPosition(8)
    private String  progNm;


    @Column(name = "USE_YN", length = 1)
    @Comment(value = "사용여부")
    @ColumnPosition(9)
    private String  useYn;


    @Column(name = "AUTH_S", length = 1)
    @Comment(value = "조회권한")
    @ColumnPosition(10)
    private String  authS;


    @Column(name = "AUTH_I", length = 1)
    @Comment(value = "저장권한")
    @ColumnPosition(11)
    private String  authI;


    @Column(name = "AUTH_U", length = 1)
    @Comment(value = "수정권한")
    @ColumnPosition(12)
    private String  authU;


    @Column(name = "AUTH_D", length = 1)
    @Comment(value = "삭제권한")
    @ColumnPosition(13)
    private String  authD;


    @Column(name = "DISPLAY_YN", length = 20)
    @Comment(value = "컨트롤 사용유부")
    @ColumnPosition(14)
    private String  disYn;


    @Column(name = "CD_GROUP", length = 20)
    @Comment(value = "그룹")
    @ColumnPosition(14)
    private String  cdGroup;


    @Column(name = "ID_USER", length = 20)
    @Comment(value = "사용자")
    @ColumnPosition(15)
    private String  idUser;

    @Column(name = "groupcd", length = 50)
    @Comment(value = "그룹코드")
    @ColumnPosition(16)
    private String  groupcd;

    @Override
    public String getId() {
        return authType;
    }

}
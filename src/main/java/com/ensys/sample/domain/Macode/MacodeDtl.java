package com.ensys.sample.domain.Macode;


import com.chequer.axboot.core.annotations.Comment;
import com.ensys.sample.domain.SimpleJpaModel;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.math.BigDecimal;


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@Table(name = "MA_CODEDTL")
@Comment(value = "")
@Alias("MacodeDtl")
public class MacodeDtl extends SimpleJpaModel {

    @Id
    @Column(name = "CD_FIELD", length = 7, nullable = false)
    @Comment(value = "")
    private String cdField;

    @Column(name = "CD_SYSDEF", precision = 18, scale = 0)
    @Comment(value = "")
    private String cdSysdef;

    @Id
    @Column(name = "NM_SYSDEF", precision = 18, scale = 0, nullable = false)
    @Comment(value = "")
    private String nmSysdef;

    @Id
    @Column(name = "CD_FLAG1", length = 20, nullable = false)
    @Comment(value = "")
    private String cdFlag1;

    @Column(name = "CD_FLAG2", length = 20)
    @Comment(value = "")
    private String cdFlag2;

    @Column(name = "cd_FLAG3", length = 20)
    @Comment(value = "")
    private String cdFlag3;

    @Column(name = "NM_SYSDEF_E", length = 20)
    @Comment(value = "")
    private String nmSysdefe;

    @Column(name = "USE_YN", length = 20)
    @Comment(value = "")
    private String use_YN;


    @Override
    public Serializable getId() {
        return null;
    }
}




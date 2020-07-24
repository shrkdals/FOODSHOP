package com.ensys.sample.domain.Macode;


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
@Table(name = "MA_CODE")
@Comment(value = "")
@Alias("Macode")
public class Macode extends SimpleJpaModel {


    @Id
    @Column(name = "CD_FIELD", length = 10, nullable = false)
    @Comment(value = "")
    private String cdField;

    @Id
    @Column(name = "NM_FIELD", length = 20, nullable = false)
    @Comment(value = "")
    private String nmField;



    @Override
    public String getId() {
        return cdField;
    }

}
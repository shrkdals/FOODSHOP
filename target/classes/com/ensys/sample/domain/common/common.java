package com.ensys.sample.domain.common;


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
import java.io.Serializable;


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "MA_CODE")
@Comment(value = "")
@Alias("common")
public class common extends SimpleJpaModel {

	@Id
	@Column(name = "CD_COMPANY", length = 7, nullable = false)
	@Comment(value = "")
	private String cdCompany;


	@Column(name = "CODE", length = 10)
	@Comment(value = "")
	private String CODE;


	@Column(name = "NAME", length = 10)
	@Comment(value = "")
	private String NAME;

	@Column(name = "CD_FIELD", length = 10)
	@Comment(value = "")
	private String cdField;


	@Override
	public Serializable getId() {
		return null;
	}

}
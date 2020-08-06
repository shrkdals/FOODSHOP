package com.ensys.sample.domain.dept;


import com.chequer.axboot.core.annotations.ColumnPosition;
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
@Table(name = "MA_DEPT")
@Comment(value = "부서")
@IdClass(Dept.DeptId.class)
@Alias("dept")
public class Dept extends SimpleJpaModel<Dept.DeptId> {

	@Id
	@Column(name = "CD_DEPT", length = 12, nullable = false)
	@Comment(value = "")
	private String cdDept;

	@Id
	@Column(name = "CD_COMPANY", length = 7, nullable = false)
	@Comment(value = "")
	private String cdCompany;

	@Column(name = "NM_DEPT", length = 50, nullable = false)
	@Comment(value = "")
	private String nmDept;

	@Column(name = "CD_BIZAREA", length = 7)
	@Comment(value = "")
	private String cdBizarea;

	@Column(name = "CD_CC", length = 12)
	@Comment(value = "")
	private String cdCc;

	@Column(name = "TP_CAL", length = 3)
	@Comment(value = "")
	private String tpCal;

	@Column(name = "H_DEPT", length = 12)
	@Comment(value = "")
	private String hDept;

	@Column(name = "NO_EMPMNG", length = 10)
	@Comment(value = "")
	private String noEmpmng;

	@Column(name = "SD_DEPT", length = 4)
	@Comment(value = "")
	private String sdDept;

	@Column(name = "ED_DEPT", length = 4)
	@Comment(value = "")
	private String edDept;

	@Column(name = "DT_START", length = 8)
	@Comment(value = "")
	private String dtStart;

	@Column(name = "DT_END", length = 8)
	@Comment(value = "")
	private String dtEnd;

	@Column(name = "TP_DEPT", length = 3)
	@Comment(value = "")
	private String tpDept;

	@Column(name = "LB_DEPT", precision = 3, scale = 0)
	@Comment(value = "")
	private BigDecimal lbDept;

	@Column(name = "YN_REST", length = 1)
	@Comment(value = "")
	private String ynRest;

	@Column(name = "ID_INSERT", length = 15)
	@Comment(value = "")
	private String idInsert;

	@Column(name = "DTS_INSERT", length = 14)
	@Comment(value = "")
	private String dtsInsert;

	@Column(name = "ID_UPDATE", length = 15)
	@Comment(value = "")
	private String idUpdate;

	@Column(name = "DTS_UPDATE", length = 14)
	@Comment(value = "")
	private String dtsUpdate;

	@Column(name = "CD_DEPT_MAP", length = 12)
	@Comment(value = "")
	private String cdDeptMap;

	@Column(name = "NM_DEPT_MAP", length = 50)
	@Comment(value = "")
	private String nmDeptMap;

	@Column(name = "EN_DEPT", length = 100)
	@Comment(value = "")
	private String enDept;

	@Column(name = "DC_RMK1", length = 500)
	@Comment(value = "")
	private String dcRmk1;

	@Column(name = "DC_RMK2", length = 500)
	@Comment(value = "")
	private String dcRmk2;

	@Column(name = "CD_ACCOUNT", length = 3)
	@Comment(value = "")
	private String cdAccount;

	@Column(name = "CD_BGDEPT_MAP", length = 20)
	@Comment(value = "")
	private String cdBgdeptMap;

	@Column(name = "CD_USER1", length = 3)
	@Comment(value = "")
	private String cdUser1;

	@Column(name = "CD_USER2", length = 3)
	@Comment(value = "")
	private String cdUser2;

	@Column(name = "NM_DEPT_L1", length = 50)
	@Comment(value = "")
	private String nmDeptL1;

	@Column(name = "NM_DEPT_L2", length = 50)
	@Comment(value = "")
	private String nmDeptL2;

	@Column(name = "NM_DEPT_L3", length = 50)
	@Comment(value = "")
	private String nmDeptL3;

	@Column(name = "NM_DEPT_L4", length = 50)
	@Comment(value = "")
	private String nmDeptL4;

	@Column(name = "NM_DEPT_L5", length = 50)
	@Comment(value = "")
	private String nmDeptL5;

	@Column(name = "CD_LEVEL", length = 4)
	@Comment(value = "")
	private String cdLevel;

	@Column(name = "NO_SORT", length = 20)
	@Comment(value = "")
	private String noSort;

	@Column(name = "NO_TEL", length = 15)
	@Comment(value = "")
	private String noTel;

	@Column(name = "NO_FAX", length = 15)
	@Comment(value = "")
	private String noFax;

	@Column(name = "CD_USERDEF3", length = 20)
	@Comment(value = "")
	private String cdUserdef3;

	@Column(name = "CD_USERDEF4", length = 20)
	@Comment(value = "")
	private String cdUserdef4;

	@Column(name = "NM_USERDEF2", length = 100)
	@Comment(value = "")
	private String nmUserdef2;

	@Column(name = "NM_USERDEF3", length = 100)
	@Comment(value = "")
	private String nmUserdef3;

	@Column(name = "NM_USERDEF4", length = 100)
	@Comment(value = "")
	private String nmUserdef4;


@Override
public DeptId getId() {
return DeptId.of(cdDept, cdCompany);
}

@Embeddable
@Data
@NoArgsConstructor
@RequiredArgsConstructor(staticName = "of")
public static class DeptId implements Serializable {

		@NonNull
		private String cdDept;

		@NonNull
		private String cdCompany;

}
}
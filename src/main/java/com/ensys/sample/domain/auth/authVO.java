package com.ensys.sample.domain.auth;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class authVO extends BaseVO {

	private List<auth>  listM;
	private List<auth>  listD;



}

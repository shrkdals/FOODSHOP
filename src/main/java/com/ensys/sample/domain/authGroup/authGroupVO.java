package com.ensys.sample.domain.authGroup;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class authGroupVO extends BaseVO {

	private List<authGroup>  listM;
	private List<authGroup>  listD;



}

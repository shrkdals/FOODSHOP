package com.ensys.sample.domain.newMenu;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class newMenuVO extends BaseVO {

	private List<newMenu>  listM;
	private List<newMenu>  listD;



}

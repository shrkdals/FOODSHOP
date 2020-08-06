package com.ensys.sample.domain.common;

import com.chequer.axboot.core.vo.BaseVO;
import com.ensys.sample.domain.program.menu.Menu;
import com.ensys.sample.domain.newMenu.newMenu;
import com.ensys.sample.domain.program.Program;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class commonVO extends BaseVO {

	private List<newMenu>  listMenu;
	private List<Program>  listProgram;



}

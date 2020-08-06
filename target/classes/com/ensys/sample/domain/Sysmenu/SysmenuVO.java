package com.ensys.sample.domain.Sysmenu;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class SysmenuVO extends BaseVO {

    private List<Sysmenu>  listM;
    private List<Sysmenu>  listD;



}

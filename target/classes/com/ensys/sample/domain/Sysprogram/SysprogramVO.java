package com.ensys.sample.domain.Sysprogram;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class SysprogramVO extends BaseVO {

    private List<Sysprogram>  listM;
    private List<Sysprogram>  listD;



}

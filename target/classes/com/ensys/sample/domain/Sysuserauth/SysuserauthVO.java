package com.ensys.sample.domain.Sysuserauth;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class SysuserauthVO extends BaseVO {

    private List<Sysuserauth>  listM;
    private List<Sysuserauth>  listD;



}

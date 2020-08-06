package com.ensys.sample.domain.Sysusermenu;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class SysusermenuVO extends BaseVO {

    private List<Sysusermenu>  listM;
    private List<Sysusermenu>  listD;



}

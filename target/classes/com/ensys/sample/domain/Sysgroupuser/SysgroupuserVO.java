package com.ensys.sample.domain.Sysgroupuser;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class SysgroupuserVO extends BaseVO {

    private List<Sysgroupuser>  listM;
    private List<Sysgroupuser>  listD;



}

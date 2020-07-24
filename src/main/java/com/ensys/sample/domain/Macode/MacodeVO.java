package com.ensys.sample.domain.Macode;

import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class MacodeVO extends BaseVO {

    private List<Macode>  listM;
    private List<MacodeDtl>  listD;



}

package com.ensys.sample.domain.Apbucard;

import com.chequer.axboot.core.annotations.Comment;
import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.NoArgsConstructor;


import java.util.List;

@Data
@NoArgsConstructor
public class ApbucardVO extends BaseVO {

    private List<Apbucard>  listM;
    private List<Apbucard>  listD;



}

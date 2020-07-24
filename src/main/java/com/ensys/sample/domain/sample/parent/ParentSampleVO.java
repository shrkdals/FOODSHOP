package com.ensys.sample.domain.sample.parent;

import com.chequer.axboot.core.utils.ModelMapperUtils;
import com.chequer.axboot.core.vo.BaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class ParentSampleVO extends BaseVO {

    private String key;

    private String value;

    private String etc1;

    private String etc2;

    private String etc3;

    private String etc4;

    public static ParentSampleVO of(ParentSample parentSample) {
        ParentSampleVO parentVTO = ModelMapperUtils.map(parentSample, ParentSampleVO.class);
        return parentVTO;
    }

    public static List<ParentSampleVO> of(List<ParentSample> parentList) {
        List<ParentSampleVO> vtoList = new ArrayList<>();

        for (ParentSample object : parentList) {
            vtoList.add(of(object));
        }

        return vtoList;
    }
}

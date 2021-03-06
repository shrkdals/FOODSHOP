package com.ensys.sample.domain.DeliverPartner;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface DeliverPartnerMapper extends MyBatisMapper {

    List<HashMap<String, Object>> selectH(HashMap<String, Object> param);
    List<HashMap<String, Object>> selectD(HashMap<String, Object> param);

    void insertD(HashMap<String, Object> item);

    void deleteD(HashMap<String, Object> item);

    void insertM(HashMap<String, Object> item);

    void deleteM(HashMap<String, Object> item);




    List<HashMap<String, Object>> MkselectH(HashMap<String, Object> param);
    List<HashMap<String, Object>> MkselectD(HashMap<String, Object> param);

    void APPLY_INOUT(HashMap<String, Object> param);
    void MkinsertM(HashMap<String, Object> item);
    void MkdeleteM(HashMap<String, Object> item);
    void MkupdateM(HashMap<String, Object> item);
    void MkupdateD(HashMap<String, Object> item);

    void MkApplyTemp(HashMap<String, Object> item);

}

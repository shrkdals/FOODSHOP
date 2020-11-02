package com.ensys.sample.domain.Brandm;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface BrandmMapper extends MyBatisMapper {

    List<HashMap<String, Object>> getBrCode_service(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectBrandM(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectBrandMenu(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectBrandPredicSaleM(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectBrandPredicSaleD(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectBrandBeginItem(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectBrandItemCategory(HashMap<String, Object> param);

    HashMap<String, Object> selectTerms(HashMap<String, Object> param);
    
    void insert(HashMap<String, Object> param);
    void delete(HashMap<String, Object> param);
    void update(HashMap<String, Object> param);

    void insertMenu(HashMap<String, Object> param);
    void deleteMenu(HashMap<String, Object> param);
    void updateMenu(HashMap<String, Object> param);

    void insertPredicSaleM(HashMap<String, Object> param);
    void deletePredicSaleM(HashMap<String, Object> param);
    void updatePredicSaleM(HashMap<String, Object> param);

    void insertPredicSaleD(HashMap<String, Object> param);
    void deletePredicSaleD(HashMap<String, Object> param);
    void updatePredicSaleD(HashMap<String, Object> param);

    void insertBeginItem(HashMap<String, Object> param);
    void deleteBeginItem(HashMap<String, Object> param);
    void updateBeginItem(HashMap<String, Object> param);

    void insertItemCategory(HashMap<String, Object> param);
    void deleteItemCategory(HashMap<String, Object> param);
    void updateItemCategory(HashMap<String, Object> param);
    
    void modifyTerms(HashMap<String, Object> param);
}

package com.ensys.sample.domain.Brandm;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.file.fileService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;


@Service
public class BrandmService extends BaseService {

    @Inject
    private BrandmMapper mapper;

    @Inject
    private fileService fileservice;


    public List<HashMap<String, Object>> getBrCode_service(HashMap<String, Object> param) {
        return mapper.getBrCode_service(param);
    }

    public List<HashMap<String, Object>> selectBrandM(HashMap<String, Object> param) {
        return mapper.selectBrandM(param);
    }

    public List<HashMap<String, Object>> selectBrandMenu(HashMap<String, Object> param) {
        return mapper.selectBrandMenu(param);
    }

    public List<HashMap<String, Object>> selectBrandPredicSaleM(HashMap<String, Object> param) {
        return mapper.selectBrandPredicSaleM(param);
    }

    public List<HashMap<String, Object>> selectBrandPredicSaleD(HashMap<String, Object> param) {
        return mapper.selectBrandPredicSaleD(param);
    }



    public List<HashMap<String, Object>> selectBrandBeginItem(HashMap<String, Object> param) {
        return mapper.selectBrandBeginItem(param);
    }

    public List<HashMap<String, Object>> selectBrandItemCategory(HashMap<String, Object> param) {
        return mapper.selectBrandItemCategory(param);
    }

    @Transactional
    public void saveAll(HashMap<String, Object> param) throws Exception {
        SessionUser user = SessionUtils.getCurrentUser();

        List<HashMap<String, Object>> brand_m = (List<HashMap<String, Object>>) param.get("brand_m");   // 브랜드마스터
        List<HashMap<String, Object>> brand_menu = (List<HashMap<String, Object>>) param.get("brand_menu");   // 브랜드메뉴
        List<HashMap<String, Object>> brand_predic_sale_m = (List<HashMap<String, Object>>) param.get("brand_predic_sale_m");   // 브랜드수익률
        List<HashMap<String, Object>> brand_predic_sale_d = (List<HashMap<String, Object>>) param.get("brand_predic_sale_d");   // 브랜드수익률
        List<HashMap<String, Object>> brand_begin_item = (List<HashMap<String, Object>>) param.get("brand_begin_item");   // 브랜드초도물품
        List<HashMap<String, Object>> brand_item_category = (List<HashMap<String, Object>>) param.get("brand_item_category");   // 브랜드상품카테고리

        if (brand_m != null && brand_m.size() > 0){             //  브랜드마스터
            for (HashMap<String, Object> item : brand_m){
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        mapper.delete(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insert(item);
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.update(item);
                    }
                }
            }
        }

        if (brand_menu != null && brand_menu.size() > 0){           //  브랜드메뉴
            for (HashMap<String, Object> item : brand_menu){
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        item.put("COMPANY_CD", user.getCdCompany());
                        mapper.deleteMenu(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insertMenu(item);
                        
                        if (item.get("MENU_FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("MENU_FILE");
                            fileservice.insertFsFile(file);
                        }
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.updateMenu(item);
                        
                        if (item.get("MENU_FILE") != null){
                            HashMap<String, Object> file = (HashMap<String, Object>) item.get("MENU_FILE");
                            fileservice.insertFsFile(file);
                        }
                    }
                }
            }
        }

        if (brand_predic_sale_m != null && brand_predic_sale_m.size() > 0){
            for (HashMap<String, Object> item : brand_predic_sale_m){
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        mapper.deletePredicSaleM(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insertPredicSaleM(item);
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.updatePredicSaleM(item);
                    }
                }
            }
        }

        if (brand_predic_sale_d != null && brand_predic_sale_d.size() > 0){
            for (HashMap<String, Object> item : brand_predic_sale_d){
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        mapper.deletePredicSaleD(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insertPredicSaleD(item);
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.updatePredicSaleD(item);
                    }
                }
            }
        }

        if (brand_begin_item != null && brand_begin_item.size() > 0){             //  브랜드마스터
            for (HashMap<String, Object> item : brand_begin_item){
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());

                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        mapper.deleteBeginItem(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insertBeginItem(item);
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.updateBeginItem(item);
                    }
                }
            }
        }

        if (brand_item_category != null && brand_item_category.size() > 0){             //  브랜드마스터
            for (HashMap<String, Object> item : brand_item_category){
                item.put("COMPANY_CD", user.getCdCompany());
                item.put("USER_ID", user.getIdUser());
                if (item.get("__deleted__") != null) {
                    if ((boolean) item.get("__deleted__")) {
                        mapper.deleteItemCategory(item);
                    }
                } else if (item.get("__created__") != null) {
                    if ((boolean) item.get("__created__")) {
                        mapper.insertItemCategory(item);
                    }
                } else if (item.get("__modified__") != null && item.get("__created__") == null) {
                    if ((boolean) item.get("__modified__")) {
                        mapper.updateItemCategory(item);
                    }
                }
            }
        }

        HashMap<String, Object> logo = (HashMap<String, Object>) param.get("file_logo");
        if (logo != null) {
            fileservice.insertFsFile(logo);
        }
        HashMap<String, Object> dtl = (HashMap<String, Object>) param.get("file_dtl");
        if (dtl != null) {
            fileservice.insertFsFile(dtl);
        }
        HashMap<String, Object> main = (HashMap<String, Object>) param.get("file_main");
        if (main != null) {
            fileservice.insertFsFile(main);
        }


    }

}



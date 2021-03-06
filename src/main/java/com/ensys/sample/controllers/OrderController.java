package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.diewald_shapeFile.files.dbf.DBF_Field;
import com.ensys.sample.diewald_shapeFile.files.dbf.DBF_File;
import com.ensys.sample.diewald_shapeFile.files.shp.SHP_File;
import com.ensys.sample.diewald_shapeFile.files.shp.shapeTypes.ShpPolygon;
import com.ensys.sample.diewald_shapeFile.files.shp.shapeTypes.ShpShape;
import com.ensys.sample.diewald_shapeFile.files.shx.SHX_File;
import com.ensys.sample.diewald_shapeFile.shapeFile.ShapeFile;
import com.ensys.sample.domain.Area.AreaService;
import com.ensys.sample.domain.Order.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.io.File;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/Order")
public class OrderController extends BaseController {

    @Inject
    private OrderService service;

    @RequestMapping(value = "selectH", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectH(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectH(param));
    }

    @RequestMapping(value = "selectD", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse selectD(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.selectD(param));
    }

    @RequestMapping(value = "excel", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse excel(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.excel(param));
    }

    @RequestMapping(value = "success", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse success(@RequestBody HashMap<String, Object> param) {
        service.success(param);
        return ok();
    }
    @RequestMapping(value = "success3", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse success3(@RequestBody HashMap<String, Object> param) {
        service.success3(param);
        return ok();
    }
    
    @RequestMapping(value = "pdf", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse pdf(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.pdf(param));
    }

    @RequestMapping(value = "orderCancel", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse orderCancel(@RequestBody HashMap<String, Object> param) {
        service.orderCancel(param);
        return ok();
    }

    @RequestMapping(value = "DEL_DT_SAVE", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse DEL_DT_SAVE(@RequestBody HashMap<String, Object> param) {
        service.DEL_DT_SAVE(param);
        return ok();
    }

    @RequestMapping(value = "REMARK_SAVE", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse REMARK_SAVE(@RequestBody HashMap<String, Object> param) {
        service.REMARK_SAVE(param);
        return ok();
    }
}

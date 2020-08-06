package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.api.response.Responses;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.Area.AreaService;
import com.ensys.sample.domain.Mapartnerm.MapartnermService;
import com.ensys.sample.diewald_shapeFile.files.dbf.DBF_Field;
import com.ensys.sample.diewald_shapeFile.files.dbf.DBF_File;
import com.ensys.sample.diewald_shapeFile.files.shp.SHP_File;
import com.ensys.sample.diewald_shapeFile.files.shp.shapeTypes.ShpPolygon;
import com.ensys.sample.diewald_shapeFile.files.shp.shapeTypes.ShpShape;
import com.ensys.sample.diewald_shapeFile.files.shx.SHX_File;
import com.ensys.sample.diewald_shapeFile.shapeFile.ShapeFile;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.io.File;
import java.util.HashMap;

@Controller
@RequestMapping(value = "/api/Area")
public class AreaController extends BaseController {

    @Inject
    private AreaService service;

    @RequestMapping(value = "select1", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse select(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.select1(param));
    }

    @RequestMapping(value = "select2", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse select2(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.select2(param));
    }

    @RequestMapping(value = "select3", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public Responses.ListResponse select3(@RequestBody HashMap<String, Object> param) {
        return Responses.ListResponse.of(service.select3(param));
    }

    @RequestMapping(value = "save", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse save(@RequestBody HashMap<String, Object> param) throws Exception {
        service.saveAll(param);
        return ok();
    }
    @RequestMapping(value = "test", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public void TEST(@RequestBody HashMap<String, Object> param) throws Exception {
        DBF_File.LOG_INFO           = !false;
        DBF_File.LOG_ONLOAD_HEADER  = false;
        DBF_File.LOG_ONLOAD_CONTENT = false;

        SHX_File.LOG_INFO           = !false;
        SHX_File.LOG_ONLOAD_HEADER  = false;
        SHX_File.LOG_ONLOAD_CONTENT = false;

        SHP_File.LOG_INFO           = !false;
        SHP_File.LOG_ONLOAD_HEADER  = false;
        SHP_File.LOG_ONLOAD_CONTENT = false;


        try {
            // GET DIRECTORY
            String curDir = System.getProperty("user.dir");
            String folder = "/data/Gis Steiermark 2010/Bezirke/BezirkeUTM33N/";

            // LOAD SHAPE FILE (.shp, .shx, .dbf)
            String fixPath = this.getClass().getResource("/FILE/Area/").toString();
            File temp = new File(fixPath, "TL_SCCO_SIG" + ".shx");
            ShapeFile shapefile = new ShapeFile(fixPath, "TL_SCCO_SIG").READ();

            // TEST: printing some content
            ShpShape.Type shape_type = shapefile.getSHP_shapeType();
            System.out.println("\nshape_type = " +shape_type);

            int number_of_shapes = shapefile.getSHP_shapeCount();
            int number_of_fields = shapefile.getDBF_fieldCount();

            for(int i = 0; i < number_of_shapes; i++){
                ShpPolygon shape    = shapefile.getSHP_shape(i);
                String[] shape_info = shapefile.getDBF_record(i);

                ShpShape.Type type     = shape.getShapeType();
                int number_of_vertices = shape.getNumberOfPoints();
                int number_of_polygons = shape.getNumberOfParts();
                int record_number      = shape.getRecordNumber();

                System.out.printf("\nSHAPE[%2d] - %s\n", i, type);
                System.out.printf("  (shape-info) record_number = %3d; vertices = %6d; polygons = %2d\n", record_number, number_of_vertices, number_of_polygons);

                for(int j = 0; j < number_of_fields; j++){
                    String data = shape_info[j].trim();
                    DBF_Field field = shapefile.getDBF_field(j);
                    String field_name = field.getName();
                    System.out.printf("  (dbase-info) [%d] %s = %s", j, field_name, data);
                }
                System.out.printf("\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

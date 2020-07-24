package com.ensys.sample.domain.file;

import com.chequer.axboot.core.mybatis.MyBatisMapper;

import java.util.HashMap;
import java.util.List;

public interface fileMapper extends MyBatisMapper {

    List<HashMap<String, Object>> BbsFileSearch(HashMap<String, Object> param);

    List<HashMap<String, Object>> getFiDocuFile(HashMap<String, Object> param);

    HashMap<String, Object> BbsFileDelete(HashMap<String, Object> param);

    int BbsFileInsert(HashMap<String, Object> param);

    int MaFileInfoInsert(HashMap<String, Object> param);

    int MaFileInfoDelete(HashMap<String, Object> param);



    int insertFsFile(HashMap<String, Object> param);

    List<HashMap<String, Object>> getFileData(HashMap<String, Object> param);

}

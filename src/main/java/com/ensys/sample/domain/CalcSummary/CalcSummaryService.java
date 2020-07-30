package com.ensys.sample.domain.CalcSummary;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

@Service
public class CalcSummaryService {

    @Inject
    private CalcSummaryMapper mapper;

    public List<HashMap<String, Object>> selectH(HashMap<String, Object> param) {
        SessionUser user = SessionUtils.getCurrentUser();
        param.put("COMPANY_CD",user.getCdCompany());
        param.put("LOGIN_ID",user.getIdUser());
        return mapper.selectH(param);
    }

}

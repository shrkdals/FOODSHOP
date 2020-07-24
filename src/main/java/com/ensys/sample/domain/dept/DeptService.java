package com.ensys.sample.domain.dept;

import com.chequer.axboot.core.parameter.RequestParams;
import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.List;

@Service
public class DeptService extends BaseService<Dept, Dept.DeptId> {
    private DeptRepository deptRepository;

    @Inject
    public DeptService(DeptRepository deptRepository) {
        super(deptRepository);
        this.deptRepository = deptRepository;
    }

    public List<Dept> gets(RequestParams<Dept> requestParams) {
        SessionUser user = SessionUtils.getCurrentUser();
        String nmDept = requestParams.getString("nmDept", "");
        if(nmDept.length() > 0) {
            return deptRepository.findTop50ByCdCompanyAndNmDeptLike(user.getCdCompany(), "%"+nmDept+"%");
        }
        return deptRepository.findTop50ByCdCompany(user.getCdCompany());
    }
}
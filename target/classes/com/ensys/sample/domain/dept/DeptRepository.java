package com.ensys.sample.domain.dept;

import com.chequer.axboot.core.domain.base.AXBootJPAQueryDSLRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DeptRepository extends AXBootJPAQueryDSLRepository<Dept, Dept.DeptId> {
    List<Dept> findTop50ByCdCompany(String cdCompany);
    List<Dept> findTop50ByCdCompanyAndNmDeptLike(String cdCompany, String nmDept);
}

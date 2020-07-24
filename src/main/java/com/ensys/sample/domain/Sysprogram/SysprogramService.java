package com.ensys.sample.domain.Sysprogram;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.List;


@Service
public class SysprogramService extends BaseService {

    @Inject
    private SysprogramMapper mapper;


    public List<Sysprogram> progSelect(Sysprogram menu) {
        SessionUser user = SessionUtils.getCurrentUser();
        menu.setCdCompany(user.getCdCompany());
        return mapper.progSelect(menu);
    }


    @Transactional
    public void saveProg(List<Sysprogram> menu) {

        for (Sysprogram data : menu) {
            SessionUser user = SessionUtils.getCurrentUser();
            data.setCdCompany(user.getCdCompany());
            if (data.isDeleted()) {
                mapper.progDelete(data);
            } else if (data.isCreated()) {
                mapper.progInsert(data);

            } else if (data.isModified()) {
                mapper.progUpdate(data);
            }
        }


    }

}
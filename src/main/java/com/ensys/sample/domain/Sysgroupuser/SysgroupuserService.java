package com.ensys.sample.domain.Sysgroupuser;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.List;


@Service
public class SysgroupuserService extends BaseService {

    @Inject
    private SysgroupuserMapper authGroupMapper;


    public List<Sysgroupuser> groupMselect(Sysgroupuser authGroup) {
        SessionUser user = SessionUtils.getCurrentUser();
        authGroup.setCdCompany(user.getCdCompany());
        return authGroupMapper.groupMselect(authGroup);
    }

    public List<Sysgroupuser> groupDselect(Sysgroupuser authGroup) {
        SessionUser user = SessionUtils.getCurrentUser();
        authGroup.setCdCompany(user.getCdCompany());
        return authGroupMapper.groupDselect(authGroup);
    }


    @Transactional
    public void saveAuthGroup(List<Sysgroupuser> authGroupM, List<Sysgroupuser> authGroupD) {
        SessionUser user = SessionUtils.getCurrentUser();

        for (Sysgroupuser data : authGroupM) {
            data.setCdCompany(user.getCdCompany());

            if (data.isDeleted()) {
                authGroupMapper.groupMdelete(data);
            } else if (data.isCreated()) {
                authGroupMapper.groupMinsert(data);

            } else if (data.isModified()) {
                authGroupMapper.groupMupdate(data);
            }
        }
        if (authGroupD.size() > 0) {
            authGroupD.get(0).setCdCompany(user.getCdCompany());
            authGroupMapper.groupDdelete(authGroupD.get(0));
            for (Sysgroupuser data : authGroupD) {
                data.setCdCompany(user.getCdCompany());
                authGroupMapper.groupDinsert(data);
            }
        }

    }

}
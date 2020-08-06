package com.ensys.sample.domain.authGroup;

import com.ensys.sample.domain.BaseService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.List;


@Service
public class authGroupService extends BaseService{

    @Inject
    private authGroupMapper authGroupMapper;



    public List<authGroup> groupMselect(authGroup authGroup)
    {
        return authGroupMapper.groupMselect(authGroup);
    }

    public List<authGroup> groupDselect(authGroup authGroup)
    {
        return authGroupMapper.groupDselect(authGroup);
    }

    public List<authGroup> deptUserSelect(authGroup authGroup)
    {
        return authGroupMapper.deptUserSelect(authGroup);
    }




    @Transactional
    public void saveAuthGroup(List<authGroup> authGroupM  , List<authGroup>  authGroupD ) {

        for (authGroup data : authGroupM)
        {
            if(data.isDeleted())
            {
                authGroupMapper.groupMdelete(data);
            }
            else if(data.isCreated())
            {
                authGroupMapper.groupMinsert(data);

            }else if(data.isModified())
            {
                authGroupMapper.groupMupdate(data);
            }
        }

        for (authGroup data : authGroupD)
        {
            if(data.isDeleted())
            {
                authGroupMapper.groupDdelete(data);
            }
            else if(data.isCreated())
            {
                authGroupMapper.groupDinsert(data);

            }
        }
    }


    @Transactional
    public void saveGroupD(List<authGroup> authGroupD ) {


        for (authGroup data : authGroupD)
        {
            if(data.isDeleted())
            {
                authGroupMapper.groupDdelete(data);
            }
            else if(data.isCreated())
            {
                authGroupMapper.groupDinsert(data);

            }
        }


    }


    @Transactional
    public void saveDeptUser(List<authGroup> authGroupD ) {


        for (authGroup data : authGroupD)
        {
            if(data.isDeleted())
            {
                authGroupMapper.deptUserDelete(data);
            }
            else if(data.isCreated())
            {
                authGroupMapper.deptUserInsert(data);

            }
        }


    }

}
package com.ensys.sample.domain.newMenu;

import com.ensys.sample.domain.BaseService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.List;


@Service
public class newMenuService extends BaseService{

    @Inject
    private newMenuMapper newMemuMapper;



    public List<newMenu> menuSelect(newMenu menu)
    {
        return newMemuMapper.menuSelect(menu);
    }

    public List<newMenu> progSelect(newMenu menu)
    {
        return newMemuMapper.progSelect(menu);
    }




    @Transactional
    public void saveMenu(List<newMenu> menuH  , List<newMenu>  menuD ) {

        for (newMenu data : menuH)
        {
            if(data.isDeleted())
            {
                newMemuMapper.menuDelete(data);
            }
            else if(data.isCreated())
            {
                newMemuMapper.menuInsert(data);

            }else if(data.isModified())
            {
                newMemuMapper.menuUpdate(data);
            }
        }

        for (newMenu data : menuD)
        {
            if(data.isDeleted())
            {
                newMemuMapper.menuDelete(data);
            }
            else if(data.isCreated())
            {
                newMemuMapper.menuInsert(data);

            }else if(data.isModified())
            {
                newMemuMapper.menuUpdate(data);
            }
        }
    }


    @Transactional
    public void saveProg(List<newMenu> menu ) {

        for (newMenu data : menu)
        {
            if(data.isDeleted())
            {
                newMemuMapper.progDelete(data);
            }
            else if(data.isCreated())
            {
                newMemuMapper.progInsert(data);

            }else if(data.isModified())
            {
                newMemuMapper.progUpdate(data);
            }
        }


    }

}
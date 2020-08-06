package com.ensys.sample.security;

import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.domain.user.User;
import com.ensys.sample.domain.user.UserService;
import com.ensys.sample.domain.user.auth.UserAuth;
import com.ensys.sample.domain.user.auth.UserAuthService;
import com.ensys.sample.domain.user.role.UserRole;
import com.ensys.sample.domain.user.role.UserRoleService;
import com.chequer.axboot.core.code.AXBootTypes;
import com.chequer.axboot.core.utils.DateTimeUtils;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

@Service
public class AXBootUserDetailsService implements UserDetailsService {

    @Inject
    private UserService userService;

    @Inject
    private UserRoleService userRoleService;

    @Inject
    private UserAuthService userAuthService;

    @Override
    public final SessionUser loadUserByUsername(String userParam) throws UsernameNotFoundException {
        User user = userService.findOne(userParam);

        if (user == null) {
            throw new UsernameNotFoundException("사용자 정보를 확인하세요.");
        }
//
//        if (user.getUseYn() == AXBootTypes.Used.NO) {
//            throw new UsernameNotFoundException("존재하지 않는 사용자 입니다.");
//        }
//
//        if (user.getDelYn() == AXBootTypes.Deleted.YES) {
//            throw new UsernameNotFoundException("존재하지 않는 사용자 입니다.");
//        }
//
//        List<UserRole> userRoleList = userRoleService.findByUserCd(userCd);
//
//        List<UserAuth> userAuthList = userAuthService.findByUserCd(userCd);

        SessionUser sessionUser = new SessionUser();

        sessionUser.setCdCompany(user.getCdCompany());
        sessionUser.setCdGroup(user.getCdGroup());
        sessionUser.setIdUser(user.getId());
        sessionUser.setNmUser(user.getNmUser());
        sessionUser.setNmEmp(user.getNmEmp());
        sessionUser.setPassWord(user.getPassWord());
        sessionUser.setNoEmp(user.getNoEmp());
        sessionUser.setCdDept(user.getCdDept());
        sessionUser.setNmDept(user.getNmDept());
        sessionUser.setCdBizarea(user.getCdBizarea());
        sessionUser.setNmBizarea(user.getNmBIZRAREA());
        sessionUser.setCdPc(user.getCdPc());
        sessionUser.setNmPc(user.getNmPc());
        sessionUser.setCdCc(user.getCdCc());
        sessionUser.setNmCc(user.getNmCc());
        sessionUser.setCdDutyRank(user.getCdDutyRank());
        sessionUser.setNmDutyRank(user.getNmDutyRank());

        sessionUser.addAuthority("ASP_ACCESS");
        sessionUser.addAuthority("SYSTEM_MANAGER");

//        sessionUser.setUserCd(user.getUserCd());
//        sessionUser.setUserNm(user.getUserNm());
//        sessionUser.setUserPs(user.getUserPs());
//        sessionUser.setMenuGrpCd(user.getMenuGrpCd());
//
//        userRoleList.forEach(r -> sessionUser.addAuthority(r.getRoleCd()));
//        userAuthList.forEach(a -> sessionUser.addAuthGroup(a.getGrpAuthCd()));
//
//        String[] localeString = user.getLocale().split("_");
//
//        Locale locale = new Locale(localeString[0], localeString[1]);
//
//        final Calendar cal = Calendar.getInstance();
//        final TimeZone timeZone = cal.getTimeZone();
//
//        sessionUser.setTimeZone(timeZone.getID());
//        sessionUser.setDateFormat(DateTimeUtils.dateFormatFromLocale(locale));
//        sessionUser.setTimeFormat(DateTimeUtils.timeFormatFromLocale(locale));
//        sessionUser.setLocale(locale);

        return sessionUser;
    }
}

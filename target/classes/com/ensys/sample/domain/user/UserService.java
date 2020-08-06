package com.ensys.sample.domain.user;

import com.ensys.sample.controllers.MailSenderService;
import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.user.auth.UserAuthService;
import com.ensys.sample.domain.user.role.UserRoleService;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Service
public class UserService extends BaseService<User, String> {

    private UserRepository userRepository;

    @Inject
    private UserAuthService userAuthService;

    @Inject
    private UserRoleService userRoleService;

    @Inject
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Inject
    private UserMapper userMapper;


    @Inject
    public UserService(UserRepository userRepository) {
        super(userRepository);
        this.userRepository = userRepository;
    }


    public HashMap<String, Object> chkPw(HashMap<String, Object> parameterMap) {
        return userMapper.chkPw(parameterMap);
    }

    public HashMap<String, Object> getYnPwClear() {
        SessionUser user = SessionUtils.getCurrentUser();

        HashMap<String, Object> parameterMap = new HashMap<String, Object>();

        parameterMap.put("CD_COMPANY", user.getCdCompany());
        parameterMap.put("ID_USER", user.getIdUser());

        return userMapper.getYnPwClear(parameterMap);
    }

    @Transactional
    public HashMap<String, Object> passwordModify(HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        userMapper.passwordModify(param);
        return result;
    }

    public List<HashMap<String, Object>> findId(HashMap<String, Object> param) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        result = userMapper.findId(param);
        return result;
    }

    public List<HashMap<String, Object>> ensysLoginChk(String param) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();

        result = userMapper.ensysLoginChk(param);

        // 로그인하는 로직

        return result;
    }


    @Transactional
    public HashMap<String, Object> findPw(HashMap<String, Object> param) {
        HashMap<String, Object> result = new HashMap<String, Object>();

        result = userMapper.findPw(param);

        if (result.get("ID_USER") != null && !result.get("ID_USER").equals("")
                && result.get("NO_EMAIL") != null && !result.get("NO_EMAIL").equals("")) {
            result.put("MSG", "해당 이메일에 변경된 비밀번호를 전송하였습니다.");
            result.put("CHKVAL", 'Y');
            MailSenderService mailSender = new MailSenderService();
            String TITLE = "Q-RAY 비밀번호 초기화";

            String HTML = "<html>\n" +
                    " <body>\n" +
                    "  <div style='width:100%;font-size:12px;color:#a8a8a8;;min-height:50px;height:50px;'>\n" +
                    "\t이 메일은 웹지출결의에서 보내드리는 임시비밀번호 메일입니다.\n" +
                    "  </div>\n" +
                    "  <div style='width:100%;font-size:14px;color:#00c8e4;font-weight:700;min-height:50px;height:50px;margin-top:50px;'>\n" +
                    "\t임시비밀번호안내\n" +
                    "  </div>\n" +
                    "  <div style='width:500px;background:#eaf9fe;font-size:18px;padding-left:30px;font-weight:900;min-height:120px;height:120px;line-height:120px;color:#494b4c'>\n" +
                    "\t임시 비밀번호는 " + param.get("PASSWORD") + " 입니다\n" +
                    "  </div>\n" +
                    "  <div style='width:100%;font-size:12px;margin-top:20px;margin-bottom:20px;'>\n" +
                    "\t임시비밀번호는 로그인후 꼭 변경하셔서 사용하셔야 합니다\n" +
                    "  </div>\n" +
                    " </body>\n" +
                    "</html>";

            MailSenderService.sendMail(TITLE, HTML, (String) result.get("NO_EMAIL"), null, null);
        } else {
            result.put("MSG", "해당 정보가 일치하지않습니다.");
            result.put("CHKVAL", 'N');
        }
        return result;
    }

    @Transactional
    public void saveUser(List<User> users) throws Exception {
//        if (isNotEmpty(users)) {
//            for (User user : users) {
//                delete(qUserRole).where(qUserRole.userCd.eq(user.getUserCd())).execute();
//                delete(qUserAuth).where(qUserAuth.userCd.eq(user.getUserCd())).execute();
//
//                String password = bCryptPasswordEncoder.encode(user.getUserPs());
//                User originalUser = userRepository.findOne(user.getUserCd());
//
//                if (originalUser != null) {
//                    if (isNotEmpty(user.getUserPs())) {
//                        user.setPasswordUpdateDate(Instant.now(Clock.systemUTC()));
//                        user.setUserPs(password);
//                    } else {
//                        user.setUserPs(originalUser.getUserPs());
//                    }
//                } else {
//                    user.setPasswordUpdateDate(Instant.now(Clock.systemUTC()));
//                    user.setUserPs(password);
//                }
//
//                save(user);
//
//                for (UserAuth userAuth : user.getAuthList()) {
//                    userAuth.setUserCd(user.getUserCd());
//                }
//
//                for (UserRole userRole : user.getRoleList()) {
//                    userRole.setUserCd(user.getUserCd());
//                }
//
//                userAuthService.save(user.getAuthList());
//                userRoleService.save(user.getRoleList());
//            }
//        }
    }

//    public User getUser(RequestParams requestParams) {
//        User user = get(requestParams).stream().findAny().orElse(null);
//
//        if (user != null) {
//            user.setAuthList(userAuthService.get(requestParams));
//            user.setRoleList(userRoleService.get(requestParams));
//        }
//
//        return user;
//    }

//    public List<User> get(RequestParams requestParams) {
//        String userCd = requestParams.getString("userCd");
//        String filter = requestParams.getString("filter");
//
//        BooleanBuilder builder = new BooleanBuilder();
//
//        if (isNotEmpty(userCd)) {
//            builder.and(qUser.userCd.eq(userCd));
//        }
//
//        List<User> list = select().from(qUser).where(builder).orderBy(qUser.userNm.asc()).fetch();
//
//        if (isNotEmpty(filter)) {
//            list = filter(list, filter);
//        }
//
//        return list;
//    }

    @Override
    @Transactional
    public User findOne(String userParam) {
        String[] param = userParam.split("\\|");
        User user = new User();
        if (param.length > 0) {
            user.setCdCompany(param[0]);
            user.setCdGroup(param[1]);
            user.setIdUser(param[2]);
        }
        return userMapper.findByIdUserAndCdCompanyAndCdGroup(user);
    }

    public void join(HashMap<String, Object> param) {
        userMapper.join(param);
    }
}

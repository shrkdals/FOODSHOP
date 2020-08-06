package com.ensys.sample.security;

import com.ensys.sample.code.GlobalConstants;
import com.ensys.sample.domain.program.Program;
import com.ensys.sample.domain.program.ProgramService;
import com.ensys.sample.domain.program.menu.Menu;
import com.ensys.sample.domain.program.menu.MenuService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.domain.user.auth.menu.AuthGroupMenu;
import com.ensys.sample.domain.user.auth.menu.AuthGroupMenuService;
import com.ensys.sample.utils.JWTSessionHandler;
import com.chequer.axboot.core.code.AXBootTypes;
import com.chequer.axboot.core.utils.*;
import com.chequer.axboot.core.vo.ScriptSessionVO;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;
import java.io.IOException;
import java.util.List;

@Service
public class AXBootTokenAuthenticationService {

    private final JWTSessionHandler jwtSessionHandler;

    @Inject
    private ProgramService programService;

    @Inject
    private AuthGroupMenuService authGroupMenuService;

    @Inject
    private MenuService menuService;

    public AXBootTokenAuthenticationService() {
        jwtSessionHandler = new JWTSessionHandler(DatatypeConverter.parseBase64Binary("YXhib290"));
    }

    public int tokenExpiry() {
        if (PhaseUtils.isProduction()) {
            return 60 * 50;
        } else {
            return 60 * 10 * 10 * 10 * 10;
        }
    }

    public void addAuthentication(HttpServletResponse response, AXBootUserAuthentication authentication, HttpServletRequest request) throws IOException {
        final SessionUser user = authentication.getDetails();
        setUserEnvironments(user, response, request);
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    public void setUserEnvironments(SessionUser user, HttpServletResponse response, HttpServletRequest request) throws IOException {
        String token = jwtSessionHandler.createTokenForUser(user);
        request.getSession().setAttribute("token", token);
    }

    public Authentication getAuthentication(HttpServletRequest request, HttpServletResponse response) throws IOException {
        RequestUtils requestUtils = RequestUtils.of(request);
        final String token = (String) request.getSession().getAttribute("token");
        final String progCd = FilenameUtils.getBaseName(request.getServletPath());
        final Long menuId = requestUtils.getLong("menuId");
        final String requestUri = request.getRequestURI();
        final String language = requestUtils.getString(GlobalConstants.LANGUAGE_PARAMETER_KEY, "");

        if (StringUtils.isNotEmpty(language)) {
            CookieUtils.addCookie(response, GlobalConstants.LANGUAGE_PARAMETER_KEY, language);
        }

        if (token == null) {
            return deleteCookieAndReturnNullAuthentication(request, response);
        }

        SessionUser user = jwtSessionHandler.parseUserFromToken(token);

        if (user == null) {
            return deleteCookieAndReturnNullAuthentication(request, response);
        }

        if (requestUri.equals("/api/v1/users/system")) {
            CookieUtils.deleteCookie(GlobalConstants.ADMIN_AUTH_TOKEN_KEY);
            CookieUtils.deleteCookie(GlobalConstants.LAST_NAVIGATED_PAGE);
            return deleteCookieAndReturnNullAuthentication(request, response);
        }

        if (!requestUri.startsWith(ContextUtil.getBaseApiPath())) {
            requestUtils.setAttribute("loginUser", JsonUtils.toJson(user));
        }

        setUserEnvironments(user, response, request);

        return new AXBootUserAuthentication(user);
    }

    private Authentication deleteCookieAndReturnNullAuthentication(HttpServletRequest request, HttpServletResponse response) {
        CookieUtils.deleteCookie(request, response, GlobalConstants.ADMIN_AUTH_TOKEN_KEY);
        ScriptSessionVO scriptSessionVO = ScriptSessionVO.noLoginSession();
        request.setAttribute("scriptSession", JsonUtils.toJson(scriptSessionVO));
        return null;
    }
}

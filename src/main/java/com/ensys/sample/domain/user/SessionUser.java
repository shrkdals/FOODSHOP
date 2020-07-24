package com.ensys.sample.domain.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.*;

@Data
public class SessionUser implements UserDetails {

    private String cdCompany;

    private String cdGroup;

    private String idUser;

    private String nmUser;

    private String passWord;

    private String nmEmp;

    private String noEmp;

    private String cdDept;

    private String nmDept;

    private String cdBizarea;

    private String nmBizarea;

    private String cdCc;

    private String nmCc;

    private String cdPc;

    private String nmPc;

    private String cdDutyRank;

    private String nmDutyRank;
//    private String timeZone;
//
//    private String menuGrpCd;
//
//    private String dateFormat;
//
//    private String dateTimeFormat;
//
//    private String timeFormat;
//
//    private String menuHash;
//
//    private long expires;

    private Map<String, Object> details = new HashMap<>();

    public String getDetailByString(String key) {
        return getDetail(key) == null ? "" : (String) getDetail(key);
    }

    public Object getDetail(String key) {
        if (details.containsKey(key)) {
            return details.get(key);
        }
        return null;
    }

    public void addDetails(String key, String value) {
        details.put(key, value);
    }

    private List<String> authorityList = new ArrayList<>();

    private List<String> authGroupList = new ArrayList<>();

    @Override
    @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<SimpleGrantedAuthority> simpleGrantedAuthorities = new ArrayList<>();
        authorityList.forEach(role -> simpleGrantedAuthorities.add(new SimpleGrantedAuthority(role)));
        return simpleGrantedAuthorities;
    }

    public void addAuthority(String role) {
        authorityList.add("ROLE_" + role);
    }

    public boolean hasRole(String role) {
        return authorityList.stream().filter(a -> a.equals("ROLE_" + role)).findAny().isPresent();
    }

    @Override
    @JsonIgnore
    public String getPassword() {
        return passWord;
    }

    @Override
    @JsonIgnore
    public String getUsername() {
        return cdCompany + "|" + cdGroup + "|" + idUser;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    @JsonIgnore
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    @JsonIgnore
    public boolean isEnabled() {
        return true;
    }

//    public void setExpires(long expires) {
//        this.expires = expires;
//    }

    public void addAuthGroup(String grpAuthCd) {
        authGroupList.add(grpAuthCd);
    }
}

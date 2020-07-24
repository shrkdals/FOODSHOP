package com.ensys.sample.domain.user.auth.menu;

import com.ensys.sample.domain.program.Program;
import lombok.Data;

import java.util.List;

@Data
public class AuthGroupMenuVO {

    private List<AuthGroupMenu> list;

    private Program program;
}

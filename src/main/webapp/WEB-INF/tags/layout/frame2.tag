<%@ tag import="com.ensys.sample.utils.CommonCodeUtils" %>
<%@ tag import="com.chequer.axboot.core.utils.ContextUtil" %>
<%@ tag import="com.chequer.axboot.core.utils.PhaseUtils" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless" %>
<%
//    String commonCodeJson = CommonCodeUtils.getAllByJson();
//    boolean isDevelopmentMode = PhaseUtils.isDevelopmentMode();
//    request.setAttribute("isDevelopmentMode", isDevelopmentMode);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1"/>
    <meta name="apple-mobile-web-app-capable" content="yes">
    <title>${config.title}</title>
    <link rel="shortcut icon" href="<c:url value='/assets/favicon.ico'/>" type="image/x-icon"/>
    <link rel="icon" href="<c:url value='/assets/favicon.ico'/>" type="image/x-icon"/>









    <c:forEach var="css" items="${config.extendedCss}">
        <link rel="stylesheet" type="text/css" href="<c:url value='${css}'/>"/>
    </c:forEach>
    <!--[if lt IE 10]>
    <c:forEach var="css" items="${config.extendedCssforIE9}">
        <link rel="stylesheet" type="text/css" href="<c:url value='${css}'/>"/>
    </c:forEach>
    <![endif]-->

    <script type="text/javascript">
        var CONTEXT_PATH = "<%=ContextUtil.getContext()%>";
        var TOP_MENU_DATA = (function (json) {
            return json;
        })([{"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null
    ,"menuId":10,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"전표관리","multiLanguageJson":{"ko":"전표관리","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

                ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":20,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"적요별계정매핑","multiLanguageJson":{"ko":
    "적요별계정매핑","en":"CommonCode Mgmt"}
    ,"parentId":1,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"적요별계정매핑"
    ,"progPh":"/jsp/ensys/ma/p_cz_q_ma_acctmapping_m.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"적요별계정매핑"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":30,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"법인카드전표등록","multiLanguageJson":{"ko":
    "법인카드전표등록","en":"CommonCode Mgmt"}
    ,"parentId":1,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"법인카드전표등록"
    ,"progPh":"/jsp/ensys/ap/p_cz_q_ap_bucard_m.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"법인카드전표등록"},


    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":40,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"비용전표등록","multiLanguageJson":{"ko":
    "비용전표등록","en":"CommonCode Mgmt"}
    ,"parentId":1,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"비용전표등록"
    ,"progPh":"/jsp/ensys/gl/p_cz_q_gl_docu_m.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":3,"name":"비용전표등록"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":50,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"전표조회","multiLanguageJson":{"ko":
    "전표조회","en":"CommonCode Mgmt"}
    ,"parentId":1,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"전표조회"
    ,"progPh":"/jsp/ensys/gl/p_cz_q_gl_docu_s.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":4,"name":"전표조회"}


                            ]
                              ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":1,"name":"전표관리"},


    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":60
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"예산관리","multiLanguageJson":{"ko":"예산관리","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":70,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"예실대비현황","multiLanguageJson":{"ko":
    "예실대비현황","en":"CommonCode Mgmt"},"parentId":2,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"예실대비현황"
    ,"progPh":"/jsp/ensys/bg/p_cz_q_bg_report1_s.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"예실대비현황"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":80,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"예산추가품의등록","multiLanguageJson":{"ko":
    "예산추가품의등록","en":"CommonCode Mgmt"},"parentId":2,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"예산추가품의등록"
    ,"progPh":"/jsp/ensys/FI/XX.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"예산추가품의등록"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":2,"name":"예산관리"},


    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":90
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"거래처관리","multiLanguageJson":{"ko":"거래처관리","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":100,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"거래처정보관리","multiLanguageJson":{"ko":
    "거래처정보관리","en":"CommonCode Mgmt"},"parentId":3,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"거래처정보관리"
    ,"progPh":"/jsp/ensys/ma/p_cz_q_ma_partner_m.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"거래처정보관리"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":110,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"신규/변경 품의신청","multiLanguageJson":{"ko":
    "신규/변경 품의신청","en":"CommonCode Mgmt"},"parentId":3,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"신규/변경 품의신청"
    ,"progPh":"/jsp/ensys/FI/XX.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"신규/변경 품의신청"},


    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":120,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"거래처조회","multiLanguageJson":{"ko":
    "거래처조회","en":"CommonCode Mgmt"},"parentId":3,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"거래처조회"
    ,"progPh":"/jsp/ma/p_cz_q_ma_partner_s.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":3,"name":"거래처조회"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":3,"name":"거래처관리"},


    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":130
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"결재라인관리","multiLanguageJson":{"ko":"결재라인관리","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":140,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"결재위임관리","multiLanguageJson":{"ko":
    "결재위임관리","en":"CommonCode Mgmt"},"parentId":4,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"결재위임관리"
    ,"progPh":"/jsp/ensys/FI/XX.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"결재위임관리"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":150,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"결재라인관리(사업부)","multiLanguageJson":{"ko":
    "결재라인관리(사업부)","en":"CommonCode Mgmt"},"parentId":4,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"결재라인관리(사업부)"
    ,"progPh":"/jsp/ensys/ma/p_cz_q_ma_bizapprline_m.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"결재라인관리(사업부)"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":151,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"결재라인관리(회계팀)","multiLanguageJson":{"ko":
    "결재라인관리(회계팀)","en":"CommonCode Mgmt"},"parentId":4,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"결재라인관리(회계팀)"
    ,"progPh":"/jsp/ensys/ma/p_cz_q_ma_finapprline_m.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":3,"name":"결재라인관리(회계팀)"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":4,"name":"결재라인관리"},



    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":160
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"내문서함","multiLanguageJson":{"ko":"내문서함","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":170,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"결재요청함","multiLanguageJson":{"ko":
    "결재요청함","en":"CommonCode Mgmt"},"parentId":5,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"결재요청함"
    ,"progPh":"/jsp/ensys/FI/P_FI_Z_APPROVEBOX_REQUEST.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"결재요청함"},
    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":180,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"반려문서함","multiLanguageJson":{"ko":
    "반려문서함","en":"CommonCode Mgmt"},"parentId":5,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"반려문서함"
    ,"progPh":"/jsp/ensys/FI/P_FI_Z_APPROVEBOX_RETURN.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"반려문서함"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":5,"name":"내문서함"},




    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":190
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"결재함","multiLanguageJson":{"ko":"결재함","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":200,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"결재대기함","multiLanguageJson":{"ko":
    "결재대기함","en":"CommonCode Mgmt"},"parentId":6,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"결재대기함"
    ,"progPh":"/jsp/ensys/FI/P_FI_Z_APPROVEBOX_STANDBY.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"결재대기함"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":210,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"결재진행함","multiLanguageJson":{"ko":
    "결재진행함","en":"CommonCode Mgmt"},"parentId":6,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"결재진행함"
    ,"progPh":"/jsp/ensys/FI/P_FI_Z_APPROVEBOX_PROGRESS.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"결재진행함"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":220,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"완료문서함","multiLanguageJson":{"ko":
    "완료문서함","en":"CommonCode Mgmt"},"parentId":6,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"완료문서함"
    ,"progPh":"/jsp/ensys/FI/P_FI_Z_APPROVEBOX_END.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":3,"name":"완료문서함"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":230,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"참조문서함","multiLanguageJson":{"ko":
    "참조문서함","en":"CommonCode Mgmt"},"parentId":6,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"참조문서함"
    ,"progPh":"/jsp/ensys/FI/P_FI_Z_APPROVEBOX_REF.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":4,"name":"참조문서함"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":6,"name":"결재함"},





    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":240
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"원장조회","multiLanguageJson":{"ko":"원장조회","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":250,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"계정별원장조회","multiLanguageJson":{"ko":
    "계정별원장조회","en":"CommonCode Mgmt"},"parentId":7,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"계정별원장조회"
    ,"progPh":"/jsp/ensys/acct/pacctList_H.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"계정별원장조회"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":260,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"손익현황","multiLanguageJson":{"ko":
    "손익현황","en":"CommonCode Mgmt"},"parentId":7,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"손익현황"
    ,"progPh":"/jsp/ensys/FI/xx.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"손익현황"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":270,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"감가상각비명세서","multiLanguageJson":{"ko":
    "감가상각비명세서","en":"CommonCode Mgmt"},"parentId":7,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"감가상각비명세서"
    ,"progPh":"/jsp/ensys/FI/XX.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":3,"name":"감가상각비명세서"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":7,"name":"원장조회"},



    {"createdAt":1538704623.101000000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":280
    ,"menuGrpCd":"SYSTEM_MANAGER","menuNm":"출장관리","multiLanguageJson":{"ko":"출장관리","en":"System Management"},"parentId":null,"level":0,"sort":0,"progCd":null

    ,"children":[

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":290,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"출장신청관리","multiLanguageJson":{"ko":
    "출장신청관리","en":"CommonCode Mgmt"},"parentId":8,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"출장신청관리"
    ,"progPh":"/jsp/ensys/FI/XX.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":1,"name":"출장신청관리"},

    {"createdAt":1538704623.125000,"createdBy":"system","updatedAt":1539567944.457000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"menuId":300,"menuGrpCd":"SYSTEM_MANAGER","menuNm"
    :"출장신청조회","multiLanguageJson":{"ko":
    "출장신청조회","en":"CommonCode Mgmt"},"parentId":8,"level":1,"sort":0,"progCd":"system-config-common-code","children":[]
    ,"program":{"createdAt":1538704622.988000000,"createdBy":"system","updatedAt":1538704622.988000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"progCd":"system-config-common-code"
    ,"progNm":"출장신청조회"
    ,"progPh":"/jsp/ensys/FI/XX.jsp","target":"_self","authCheck":"Y","schAh":"Y","savAh":"Y","exlAh":"Y","delAh":"N","fn1Ah":"N","fn2Ah":"N","fn3Ah":"N"
    ,"fn4Ah":"N","fn5Ah":"N","remark":null,"id":"system-config-common-code","dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}
    ,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false
    ,"id":2,"name":"출장신청조회"}

    ]
    ,"program":null,"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false,"open":false,"id":8,"name":"출장관리"}


                 ]);
        var COMMON_CODE = (function (json) {
            return json;
        })({"DEL_YN":[{"createdAt":1538704623.621000000,"createdBy":"system","updatedAt":1538704623.621000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"DEL_YN","groupNm":"삭제여부","code":"N","name":"미삭제","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"DEL_YN","code":"N"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.797000000,"createdBy":"system","updatedAt":1538704623.797000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"DEL_YN","groupNm":"삭제여부","code":"Y","name":"삭제","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"DEL_YN","code":"Y"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}],"USE_YN":[{"createdAt":1538704623.814000000,"createdBy":"system","updatedAt":1538704623.814000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USE_YN","groupNm":"사용여부","code":"Y","name":"사용","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USE_YN","code":"Y"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.640000000,"createdBy":"system","updatedAt":1538704623.640000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USE_YN","groupNm":"사용여부","code":"N","name":"사용안함","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USE_YN","code":"N"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}],"LOCALE":[{"createdAt":1538704623.600000000,"createdBy":"system","updatedAt":1538704623.600000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"LOCALE","groupNm":"로케일","code":"ko_KR","name":"대한민국","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"LOCALE","code":"ko_KR"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.580000000,"createdBy":"system","updatedAt":1538704623.580000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"LOCALE","groupNm":"로케일","code":"en_US","name":"미국","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"LOCALE","code":"en_US"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}],"USER_STATUS":[{"createdAt":1538704623.660000000,"createdBy":"system","updatedAt":1538704623.660000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USER_STATUS","groupNm":"계정상태","code":"NORMAL","name":"활성","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USER_STATUS","code":"NORMAL"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.418000000,"createdBy":"system","updatedAt":1538704623.418000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USER_STATUS","groupNm":"계정상태","code":"ACCOUNT_LOCK","name":"잠김","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USER_STATUS","code":"ACCOUNT_LOCK"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}],"AUTH_GROUP":[{"createdAt":1538704623.680000000,"createdBy":"system","updatedAt":1538704623.680000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"AUTH_GROUP","groupNm":"권한그룹","code":"S0001","name":"시스템관리자 그룹","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"AUTH_GROUP","code":"S0001"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.701000000,"createdBy":"system","updatedAt":1538704623.701000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"AUTH_GROUP","groupNm":"권한그룹","code":"S0002","name":"사용자 권한그룹","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"AUTH_GROUP","code":"S0002"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}],"USER_ROLE":[{"createdAt":1538704623.537000000,"createdBy":"system","updatedAt":1538704623.537000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USER_ROLE","groupNm":"사용자 롤","code":"ASP_ACCESS","name":"관리시스템 접근 롤","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USER_ROLE","code":"ASP_ACCESS"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.750000000,"createdBy":"system","updatedAt":1538704623.750000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USER_ROLE","groupNm":"사용자 롤","code":"SYSTEM_MANAGER","name":"시스템 관리자 롤","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USER_ROLE","code":"SYSTEM_MANAGER"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.560000000,"createdBy":"system","updatedAt":1538704623.560000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USER_ROLE","groupNm":"사용자 롤","code":"ASP_MANAGER","name":"일반괸리자 롤","sort":3,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USER_ROLE","code":"ASP_MANAGER"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.480000000,"createdBy":"system","updatedAt":1538704623.480000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"USER_ROLE","groupNm":"사용자 롤","code":"API","name":"API 접근 롤","sort":6,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"USER_ROLE","code":"API"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}],"MENU_GROUP":[{"createdAt":1538704623.727000000,"createdBy":"system","updatedAt":1538704623.727000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"MENU_GROUP","groupNm":"메뉴그룹","code":"SYSTEM_MANAGER","name":"시스템 관리자 그룹","sort":1,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"MENU_GROUP","code":"SYSTEM_MANAGER"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false},{"createdAt":1538704623.776000000,"createdBy":"system","updatedAt":1538704623.776000000,"updatedBy":"system","createdUser":null,"modifiedUser":null,"groupCd":"MENU_GROUP","groupNm":"메뉴그룹","code":"USER","name":"사용자 그룹","sort":2,"data1":null,"data2":null,"data3":null,"data4":null,"data5":null,"remark":null,"useYn":"Y","id":{"groupCd":"MENU_GROUP","code":"USER"},"dataStatus":"ORIGIN","__deleted__":false,"__created__":false,"__modified__":false}]});
        var SCRIPT_SESSION = (function (json) {
            return json;
        })({"userCd":"050010","userNm":"이재옥" ,"deptCd":"100401060200", "deptNm":"SK네트웍스 워커힐점","locale":"ko_KR","timeZone":"Asia/Seoul","dateFormat":"YYYY-MM-DD","login":true,"details":{"language":"ko"},"dateTimeFormat":"YYYY-MM-DD HH:mm:ss","timeFormat":"HH:mm:ss"});
    </script>

    <script type="text/javascript" src="<c:url value='/assets/js/plugins.min.js' />"></script>
    <script type="text/javascript" src="<c:url value='/assets/js/axboot/dist/axboot.js' />"></script>
    <script type="text/javascript" src="<c:url value='/axboot.config.js' />"></script>
    <jsp:invoke fragment="css"/>
    <jsp:invoke fragment="js"/>
</head>
<body class="ax-body ${axbody_class}" onselectstart="return false;">
<div id="ax-frame-root" class="<c:if test="${config.layout.leftSideMenu eq 'visible'}">show-aside</c:if>" data-root-container="true">
    <jsp:doBody/>

    <div class="ax-frame-header-tool">
        <div class="ax-split-col" style="height: 100%;">
            <div class="ax-split-panel text-align-left">

            </div>
            <div class="ax-split-panel text-align-right">



            </div>
        </div>
    </div>



    <c:if test="${config.layout.leftSideMenu eq 'visible'}">
        <div class="ax-frame-aside" id="ax-frame-aside"></div>
        <script type="text/html" data-tmpl="ax-frame-aside">
            <div class="ax-frame-aside-menu-holder">
                <div style="height: 10px;"></div>
                {{#items}}
                <a class="aside-menu-item aside-menu-item-label{{#hasChildren}} {{#open}}opend{{/open}}{{/hasChildren}}" data-label-index="{{@i}}">{{{name}}}</a>
                {{#hasChildren}}
                <div class="aside-menu-item aside-menu-item-tree-body {{#open}}opend{{/open}}" data-tree-body-index="{{@i}}">
                    <div class="tree-holder ztree" id="aside-menu-{{@i}}" data-tree-holder-index="{{@i}}"></div>
                </div>
                {{/hasChildren}}
                {{/items}}
            </div>
        </script>
    </c:if>

    <div class="ax-frame-foot">
        <div class="ax-split-col" style="height: 100%;">
            <div class="ax-split-panel text-align-left"> ${config.copyrights} </div>
            <div class="ax-split-panel text-align-right">
                Last account activity <b id="account-activity-timer">00</b> ago.
            </div>
        </div>
    </div>

</div>
<jsp:invoke fragment="script"/>
</body>
</html>
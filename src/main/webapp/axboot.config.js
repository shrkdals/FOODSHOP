(function () {
    if (axboot && axboot.def) {

        axboot.def["DEFAULT_TAB_LIST"] = [
            {
                menuId: "00-dashboard",
                id: "dashboard",
                progNm: '홈',
                menuNm: '홈',
                progPh: '/jsp/dashboard.jsp',
                url: '/jsp/dashboard.jsp?progCd=dashboard',
                status: "on",
                fixed: true
            }
        ];

        axboot.def["API"] = {
            // 노강민추가 //
            "defaultQna": "/api/defaultQna",
            "commonfile": "/api/file",
            "itemM" : "/api/itemM",
            "event" : "/api/event",
            "FcOrder" : "/api/FcOrder",
            // 노강민추가 //

            "sysprogram": "/api/v1/Sysprogram",         // 프로그램목록
            "sysmenu": "/api/v1/Sysmenu",                // 메뉴등록
            "sysgroupuser": "/api/v1/Sysgroupuser",    // 그룹사용자관리
            "gldocum2": "/api/v1/Gldocum2",                // 전표등록
            "gldocum": "/api/v1/Gldocum",                // 전표등록
            "apBnft": "/api/apBnft",                      // 고객편익사용조회
            "maMandate": "/api/maMandate",               // 결재위임관리
            "BiztripDocu": "/api/BiztripDocu",          // 출장전표조회
            "BiztripM": "/api/BiztripM",                 // 출장신청관리
            "mbiztripsettle": "/api/mbiztripsettle",   // 출장정산관리
            "predocu": "/api/Predocu",                   //  매출선발행
            "apArnetting": "/api/apArnetting",          // 채권채무상계처리
            "mabizapprline": "/api/v1/Mabizapprline",  // 사업부결재라인관리
            "mafinapprline": "/api/v1/Mafinapprline",  // 회계팀결재라인관리
            "maacctmapping": "/api/v1/Maacctmapping",
            "apbucard": "/api/Apbucard",
            "apbucardLv1": "/api/ApbucardLv1",
            "apbucardLv2": "/api/ApbucardLv2",
            "bgreport1": "/api/v1/Bgreport1",
            "mapartnerm": "/api/v1/Mapartnerm",
            "mapartners": "/api/v1/Mapartners",
            "dmrequest": "/api/v1/Dmrequest",
            "dmwaiting": "/api/v1/Dmwaiting",
            "dmreject": "/api/v1/Dmreject",
            "dmrejecthistory": "/api/v1/Dmrejecthistory",
            "dmreference": "/api/v1/Dmreference",

            "sysusermenu": "/api/v1/Sysusermenu",
            "sysuserauth": "/api/v1/Sysuserauth",
            "macode": "/api/v1/Macode",
            "dept": "/api/v1/dept",
            "newMenu": "/api/newMenu",
            "authGroup": "/api/authGroup",
            "auth": "/api/auth",
            "Bbs": "/api/Bbs",
            "schedule": "/api/schedule",
            "commonutility": "/api/commonutility",
            "cardacct": "/api/cardAcct",
            "apTaxBill": "/api/apTaxBill",
            "arTaxBill": "/api/arTaxBill",
            "cardUser": "/api/cardUser",
            "customHelp": "/api/customHelp",
            "commonHelp": "/api/commonHelp",
            "glDocuS": "/api/glDocuS",

            "errorLogs": "/api/v1/errorLogs",           //  프레임워크에서 사용
            "files": "/api/v1/files",                    //  프레임워크에서 사용
            "samples": "/api/v1/samples",               //  프레임워크에서 사용
            "users": "/api/v1/users",                    //  프레임워크에서 사용
            "common": "/api/v1/common",                  //  프레임워크에서 사용
            "programs": "/api/v1/programs",             //  프레임워크에서 사용
            "menu": "/api/v2/menu",                      //  프레임워크에서 사용
            "manual": "/api/v1/manual",                  //  프레임워크에서 사용
            "transLang": "/api/transLang",               //  프레임워크에서 사용

            // FS MODULE
            "commition": "/api/commition"         // 프로그램목록
            , "area" : "/api/Area"
            , "order" : "/api/Order"
            , "request" : "/api/Reuqest"
            ,"Brandm":"/api/Brandm"                 //브랜드마스터
            ,"Categorym":"/api/Categorym"           //카테고리관리
            , "DeliverPartner" : "/api/DeliverPartner"
            , "calcSummary" : "/api/CalcSummary"
            ,"BrandContract" : "/api/BrandContract"
        };

        axboot.def["MODAL"] = {
            "ZIPCODE": {
                width: 500,
                height: 500,
                iframe: {
                    url: "/jsp/common/zipcode.jsp"
                }
            },
            "SAMPLE-MODAL": {
                width: 500,
                height: 500,
                iframe: {
                    url: "/jsp/_samples/modal.jsp"
                },
                header: false
            },
            "COMMON_CODE_MODAL": {
                width: 600,
                height: 400,
                iframe: {
                    url: "/jsp/system/system-config-common-code-modal.jsp"
                },
                header: false
            },
            "DEPT-MODAL": {
                width: 500,
                height: 500,
                iframe: {
                    url: "/jsp/ensys/modal.jsp"
                },
                header: false
            }
        };
    }


    var preDefineUrls = {
        "manual_downloadForm": "/api/v1/manual/excel/downloadForm",
        "manual_viewer": "/jsp/system/system-help-manual-view.jsp"
    };
    axboot.getURL = function (url) {
        if (ax5.util.isArray(url)) {
            if (url[0] in preDefineUrls) {
                url[0] = preDefineUrls[url[0]];
            }
            return url.join('/');

        } else {
            return url;
        }
    };

    axboot.getfileRoot = function () {
        if (window.location.hostname == 'localhost') {
            return "http://localhost:" + window.location.port + "/file";
        } else {
            return "http://" + window.location.hostname + ":" + window.location.port + "/file";
        }
    }


})();

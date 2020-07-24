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
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1,
        minimum-scale=1"/>
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


        <script type="text/javascript" src="<c:url value='/assets/js/plugins.min.js'/>"></script>
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/dist/axboot.js'/>"></script>
        <script type="text/javascript" src="<c:url value='/axboot.config.js'/>"></script>
        <script type="text/javascript" src="<c:url value='/assets/js/common/common.js'/>"></script>
        <script type="text/javascript">
        var CONTEXT_PATH = "<%=ContextUtil.getContext()%>";


        var COMMON_CODE = (function (json) {
        return json;
        })();

        var SCRIPT_SESSION = (function (json) {
        return json;
        })(${loginUser});


        var jasonData ;

        axboot.ajax({
        type: "GET",
        url: ["common","getMenuList"],
        async:false,
        callback: function (res) {
            console.log("getMenuList : ", res);
        jasonData = $(res.list[0].menu).filter(function(i,n ){ return n.level === 0 ;});
        $(jasonData).each(function(idx){
        var _id = this.id;
        var _childeren = $(res.list[0].menu).filter(function(i, n){
        return n.level === 1 && _id === n.parentId;});
        $(_childeren ).each(function(idx){
        var _progCd = this.progCd;
        var program = $(res.list[0].prog).filter(function(i,n){
        return n.progCd ===_progCd ;
        });
        this.program = program[0];
        });

        this.children = [_childeren];
        });
        }
        });
        var TOP_MENU_DATA = (function (json) {
        return json;
        })([jasonData.toString()]);

            var modal = new ax5.ui.modal();

            axboot.ajax({
            method: "GET",
            url: ["users", "getYnPwClear"],
            callback: function (res) {
            console.log(res);
            if (res.map != null){
            if (res.map.DC_RMK != null){
            if (res.map.DC_RMK != ''){
            modal.open({
            width: 450,
            height: 300,
            position: {
            left: "center",
            top: 0
            },
            iframe: {
            method: "get",
            url: "/jsp/pwModify.jsp",
            },
            onStateChanged: function () {

            }
            }, function () {

            });
            }
            }
            }
            }
            });

        </script>


        <jsp:invoke fragment="css"/>
        <jsp:invoke fragment="js"/>
        </head>
        <body class="ax-body frame-set">
        <div class="es_wrap" id="ax-frame-root">
        <!-- 상단 gnb -->
        <div class="header_wrap">
        <div class="header">


        <h1 class="logo"><a maunPath = '/jsp/dashboard.jsp' menuId="00-dashboard" progNm="홈" id="dashboard" menuNm="홈"
        progPh="/jsp/dashboard.jsp" >logo <span>|</span></a></h1>
        <div class="gnb_wrap"> <span><label id="LoginUserNm"></label><span style="display: none;" id="LoginUserId"> 안녕하세요 </span>
        <!--<button type="button" onclick="" class="btn_user">정보수정</button>-->
        <a href ="/api/logout" class="btn_user">로그아웃</a>


        <ul>
        <%--<li class="lang_ko" title="한국어"><a href="">다국어선택</a></li>--%>
        <%-- <li class="noti"><a href="">결재문서<em class="new"></em></a></li>--%>
        <li class="full_menu"><%--<a href="">--%>전체메뉴<%--</a>--%></li>
        <li class="default" title="전체화면" id="expand" status="default">전체화면</li>
        </ul>
        </div>
        </div>

        <div class="ax-frame-header-tab" >
        <div id="ax-frame-header-tab-container">nav
        <div class="tab-item-holder">
        <div class="tab-item-menu" data-tab-id=""></div>
        <div class="tab-item on" data-tab-id="00-dashboard">
        <span title="" data-original-title="홈" data-toggle="tooltip" data-placement="bottom">홈</span>
        </div>
        <div class="tab-item-addon" data-tab-id=""></div>
        </div>
        </div>
        </div>
        <!-- 상단 전체메뉴 -->
        <div class="all_menu">
        <ul class="sub_depth_wrap" id="sub_depth_wrap">


        </ul>
        </div>


        </div>

        <%--<div class="navi">
        <span>홈</span>
        <span  id="step1"></span>
        <span id="step2">  </span>
        </div>--%>

        <div class="lnb_wrap">
            <div class="lnb">
            <div class="lnb_arrowtop">
            </div>
            <div class="nav_wrap" style="overflow:hidden;">
                <ul class="nav">
                </ul>
            </div>
            <div class="lnb_arrowbottom">
            </div>
            </div>
        </div>
        <div class="sub_menu" id="sub_menu" style="display:none" >
        <p><label id="subMenuTitle"> 전표관리</label><span><a hef="#n" id="btnMenuClose" title="닫기">서브메뉴닫기</a></span></p>
        </div>

        <!-- 컨텐츠 -->
        <div class="content ax-frame-contents" style="width:100%; height:100% ; padding-left: 80px; overflow-x: hidden;
        overflow-y: hidden ; padding-top: 75px" id="content-frame-container" >

        </div>
        </div>

        <jsp:invoke fragment="script"/>
        </body>


        <script type="text/javascript">

        $(document).ready(function(){

                var _menucnt = 0;
                var _menuheight = 0;

                $(jasonData).each(function(idx){

                $(".nav").append("<li class='menu_"+ this.menuId +"' menuId=\'" + this.menuId +"\' ><a href=\"#\"><span>"+this.menuNm+"</span></a></li>");

                var menuList = this.children[0];
                var subMenuHtml = " <ul taget='menu_"+ this.menuId+"' >";

                var liWithe = 100 / jasonData.length;

                var topAllmemuHtml = " <li style='width:"+ liWithe +"%' > <dl class=\"sub_depth\"><dt><strong>"+ this.menuNm+
                "</strong></dt> <dd> <ul> ";
                var name = this.menuNm;
                $(menuList).each(function(idx){
                var config = " menuId = '" + this.menuId
                + "' parentId = '" + this.parentId
                + "' id = '" + this.id
                + "' progNm = '" + this.program.progNm
                + "' menuNm = '" + this.menuNm
                + "' progPh = '" + this.program.progPh + "'"
                + "' name = '" + name + "'";

                subMenuHtml += " <li><a href='#' maunPath='" + this.program.progPh+ "' " + config + " >"+this.menuNm+"</a></li>";
                topAllmemuHtml += " <li id='#'><a href='#' maunPath='" + this.program.progPh+ "' "+ config +" >"+
                this.menuNm+"</a></li>"
                });

                $("#sub_menu").append(subMenuHtml + "<ul>");
                $("#sub_depth_wrap").append(topAllmemuHtml + "</ul> </dd> </dl> </li>");

                _menucnt ++;
                _menuheight = _menucnt*70;

                });

                $("#LoginUserNm").text(SCRIPT_SESSION.nmUser);
                $("#LoginUserId").text(SCRIPT_SESSION.idUser);
                $(".nav_wrap").css("height",($(".es_wrap").height() -70)+"px");
                if(_menuheight > $(".es_wrap").height() -70){ // 여기서 70은 아래위화살표높이30씩 + 위화살표마진탑 10
                        $(".lnb_arrowtop").css("display","");
                        $(".lnb_arrowbottom").css("display","");
                        $(".nav").css("height",$(".es_wrap").height()-70 + "px");
                }
                else{
                        $(".lnb_arrowtop").css("display","none");
                        $(".lnb_arrowbottom").css("display","none");
                }

                $('.lnb_arrowtop').mouseenter(function(){
                    $('.lnb_arrowtop').css("opacity","0.7");
                });
                $('.lnb_arrowtop').mouseleave(function(){
                    $('.lnb_arrowtop').css("opacity","1");
                });
                $('.lnb_arrowtop').click(function(){
                    if($(".nav").css("marginTop").replace("px","") < 0){
                        var currmargintop = $(".nav").css("marginTop").replace("px","");
                        if (Number(currmargintop) +70 > 0 ){
                            currmargintop = "0";
                        }
                        $(".nav").stop().animate({
                            marginTop:(Number(currmargintop)+70)+"px"
                        }, 100,function(){
                            if($(".nav").css("marginTop").replace("px","") > 0){
                                $(".nav").css("marginTop","0px");
                            }
                        });
                    }
                });


                $('.lnb_arrowbottom').mouseenter(function(){
                    $('.lnb_arrowbottom').css("opacity","0.7");
                });
                $('.lnb_arrowbottom').mouseleave(function(){
                    $('.lnb_arrowbottom').css("opacity","1");
                });

                $('.lnb_arrowbottom').click(function(){
                    //$(".es_wrap").height() - (_menuheight -70) // 최대 - 될수있는 마진 : 전체높이 - (메뉴높이-아래위화살표,공백)
                    if($(".nav").css("marginTop").replace("px","") > $(".es_wrap").height() - (_menuheight +70)){
                        var currmargintop = $(".nav").css("marginTop").replace("px","");
                        $(".nav").stop().animate({
                            marginTop:(Number(currmargintop)-70)+"px"
                        }, 100);
                    }
                });

                $(".nav").css("height",_menuheight+"px");



                $(".nav").on('mousewheel',function(e){
                    var wheel = e.originalEvent.wheelDelta;

                    //스크롤값을 가져온다.
                    if(wheel>0){
                        //스크롤 올릴때
                        var currmargintop = $(".nav").css("marginTop").replace("px","");
                        if (Number(currmargintop) +70 > 0 ){
                            currmargintop = "0";
                        }
                        $(".nav").stop().animate({
                            marginTop:(Number(currmargintop)+70)+"px"
                            }, 100,function(){
                            if($(".nav").css("marginTop").replace("px","") > 0){
                                $(".nav").css("marginTop","0px");
                            }
                        });
                    } else {
                        //스크롤 내릴때
                        //$(".es_wrap").height() - (_menuheight -70) // 최대 - 될수있는 마진 : 전체높이 - (메뉴높이-아래위화살표,공백)
                        if($(".nav").css("marginTop").replace("px","") > $(".es_wrap").height() - (_menuheight +70)){
                            var currmargintop = $(".nav").css("marginTop").replace("px","");
                            $(".nav").stop().animate({
                                marginTop:(Number(currmargintop)-70)+"px"
                            }, 100);
                        }
                    }
                });

                //alert(_menuheight);
                //alert($(".es_wrap").height()-70);
                //alert(_menuheight); //메뉴전체높이
                //alert($(".es_wrap").height()); //현재화면높이






            $("#btnMenuClose").on("click", function () {

            $("#sub_menu").hide("side");
            $(".content").css("padding-left", "80px");
            $(".ax-frame-header-tab").css("padding-left", "0px");

            });

            $(".nav>li>a").on("click", function () {

            $(".nav>li>a").removeClass("on");
            $(this).addClass("on");
            var parent = $(this).parent().attr("class");
            $("#sub_menu > ul").hide();
            $("#sub_menu > ul[taget='" + parent + "']").show();
            $(".content").css("padding-left", "260px");
            $(".ax-frame-header-tab").css("padding-left", "180px");
            $("#sub_menu").show("drop");

            var subTitle = $(this).text();
            $("#subMenuTitle").text(subTitle);

            });

            $("#expand").on("click", function () {

            var classEx = $(this).attr("status");

            $(this).attr({
            "class": (classEx == 'expand') ? "default" : "expand"
            , "title": (classEx == 'expand') ? "기본화면" : "전체화면"
            , "status": (classEx == 'expand') ? "default" : "expand"
            }
            );


            $("#sub_menu").hide();
            $(".lnb").toggle("slide", function () {
            if ($(this).css("display") == "none") {
            $(".content").css("padding-left", "0px");
            $(".header_wrap").css("left", "0px");
            $(".ax-frame-header-tab").css("padding-left", "0px");
            } else {
            $(".content").css("padding-left", "80px");
            $(".header_wrap").css("left", "80px");
            }

            });

            });


            $("a[maunPath]").on("click", function () {

            $(".sub_menu").find(".on").removeClass("on");
            var item = {
            menuId: $(this).attr("menuId")
            , id: $(this).attr("id")
            , progNm: $(this).attr("progNm")
            , menuNm: $(this).attr("menuNm")
            , progPh: $(this).attr("progPh")
            , name: $(this).attr("name")
            , parentId: $(this).attr("parentId")
            };
            $(this).attr("class", "on");


            fnObj.tabView.open(item);

            });


            // 전체메뉴
            $(".full_menu").mouseover(function () {
            $(".all_menu").addClass("active");
            $(this).addClass("on");
            });
            $(".full_menu").mouseout(function () {
            $(".all_menu").removeClass("active");
            $(this).removeClass("on");
            });
            $(".all_menu").mouseover(function () {
            $(this).css('display', 'block');
            $(".full_menu").addClass("on");
            });
            $(".all_menu").mouseout(function () {
            $(this).css('display', 'none');
            $(".full_menu").removeClass("on");
            });


            // 다국어 선택
            $(".lang_ko").mouseover(function () {
            //   $(this).toggleClass("lang_en");
            var title = ($(this).attr("title") === "한국어") ? "한국어" : "영문";
            $(this).attr("title", title);
            });

            //확대/축소
            //  $(".expand").mouseover(function () {
            //      $(this).toggleClass("default");
            //      var title2 = ($(this).attr("title") === "전체화면") ? "전체화면" : "기본화면";
            //      $(this).attr("title", title2);
            //  });

            // 다국어 선택
            $(".lang_en").mouseover(function () {
            // $(this).toggleClass("lang_ko");
            var title = ($(this).attr("title") === "한국어") ? "한국어" : "영문";
            $(this).attr("title", title);
            });

            //확대/축소
            //  $(".default").mouseover(function() {
            //      $(this).toggleClass("expand");
            //      var title2 = ($(this).attr("title") === "전체화면") ? "전체화면" : "기본화면";
            //      $(this).attr("title", title2);
            //  });


            $("#expand").hover(
            function () {
            var classEx = $(this).attr("status");
            $(this).attr("class", (classEx == 'expand') ? "default" : "expand");
            $(this).attr("title", (classEx == 'expand') ? "기본화면" : "전체화면");
            },
            function () {
            var classEx = $(this).attr("status");
            $(this).attr("class", (classEx == 'expand') ? "expand" : "default");
            $(this).attr("title", (classEx == 'expand') ? "전체화면" : "기본화면");
            }
            );


            $("input[popup='ok']").change(function () {
            if ($(this).val() == "") {
            $(this).attr("code", "");
            $(this).attr("name", "");

            } else {

            $(this).val($(this).attr("name"))
            }

            })

            });


        $(window).resize(function () {
            $(".nav_wrap").css("height",($(".es_wrap").height() -70)+"px");
        });


        </script>
        </html>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="사용자 정보 변경 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">

        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var initData;
            if (param.modalName) {
                initData = eval("parent." + param.modalName + ".modalConfig.sendData()");  // 부모로 부터 받은 Parameter Object
            } else {
                initData = parent.modal.modalConfig.sendData();  // 부모로 부터 받은 Parameter Object
            }
            if(typeof initData.initData == 'object'){
                var sendData = initData.initData;
            }else{
                var sendData = JSON.parse(initData.initData);
            }


            if (sendData != null) {
                initData.CD_DEPT = sendData.CD_DEPT
            } else {
                initData.CD_DEPT = ''
            }
            initData.P_KEYWORD = $("#KEYWORD").val();

            var fnObj = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                },
                PAGE_SEARCH: function (caller, act, data) {
                    var info = $.DATA_SEARCH('users','USER_SEARCH').list;
                    console.log(info)
                    var user = info[0]
                    $('#name').val(user.nmUser)
                    $('#id_user').val(user.idUser)
                    $('#tel').val(user.HP_NO)
                    $('#pwd').val(user.passWord)



                }
                ,INFO_SAVE: function (caller, act, data) {

                    if (nvl($("#name").val()) == ''){
                        qray.alert('이름을 입력해주십시오.');
                        return false;
                    }

                    if (nvl($("#pwd").val()) == ''){
                        qray.alert('비밀번호를 입력해주십시오.');
                        return false;
                    }
                    if($('#pwd2').val() != $('#pwd').val()){
                        qray.alert('비밀번호가 동일하지 않습니다.');
                        return false;
                    }
                    qray.confirm({
                        msg: "변경하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {

                            qray.loading.show('저장 중입니다.').then(function () {
                                axboot.ajax({
                                    type: "POST",
                                    url: ["users", "USER_SAVE"],
                                    data: JSON.stringify({
                                        USER_NAME : $('#name').val()
                                        ,PASS_WORD : $('#pwd').val()
                                        ,HP_NO :$('#tel').val()
                                    }),
                                    callback: function (res) {
                                        qray.loading.hide();

                                        qray.alert("저장 되었습니다.").then(function(){
                                            parent.modal.close();
                                        });
                                    }
                                });
                            })
                        }
                    });

                }

            });

            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                $('[data-ax-td-label="pwdCheck"]').css("background","white");
                $('[data-ax-td-label="pwdCheck"]').css("text-align","left");
                $('[data-ax-td-label="pwdCheck"]').css("width","500px")


                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageResize = function () {

            };


            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.INFO_SAVE);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "close": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_CLOSE);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                }
            });

            //== view 시작
            /**
             * searchView
             */
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    // this.KEYWORD = $("#KEYWORD");
                },
                getData: function () {
                    var components = document.getElementById('searchView0');
                    var columns = {};
                    for (var i = 0; i < components.length; i++) {
                        var columnName = components[i].getAttribute("name");
                        if (columnName != null) {
                            if (columnName.substring(0, 2) == 'P_') {       //  조회조건 중 ID값들에 'P_' 가 붙은 것이 있다면
                                columns[columnName] = components[i].value
                            } else {                                        //  조회조건 중 ID값들에 'P_' 가 안붙은 것이 있다면
                                columns["P_" + columnName] = components[i].value
                            }
                            console.log(JSON.stringify(columns));
                        }
                    }
                    return {
                        data: columns
                    }
                }
            });

            $('#pwd2 , #pwd').keyup(function(){
                if($('#pwd2').val() != $('#pwd').val() || ($('#pwd').val() == '' || $('#pwd2').val() == '')){
                    $('[data-ax-td-label="pwdCheck"]').find('span').remove();
                    $('[data-ax-td-label="pwdCheck"]').append('<span style="color:red">비밀번호가 동일하지 않습니다.</span>')
                }else{
                    $('[data-ax-td-label="pwdCheck"]').find('span').remove();
                    $('[data-ax-td-label="pwdCheck"]').append('<span style="color:limegreen">비밀번호가 동일합니다.</span>')
                }
            });

        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-popup-default" data-page-btn="save"><i class="icon_ok"></i>저장
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>


        <ax:split-layout name="ax1" orientation="horizontal">
            <ax:split-panel width="*" style="">

                <ax:tbl clazz="ax-search-tb2" minWidth="800px">
                    <ax:tr>
                        <ax:td label='<span style="color:red">*</span> 아이디' width="330px">

                            <input type="text"
                                   class="form-control"
                                   data-ax-path="id_user"
                                   name="id_user"
                                   id="id_user"
                                   readonly="readonly">
                        </ax:td>
                    </ax:tr>
                    <ax:tr>
                        <ax:td label='<span style="color:red">*</span> 이름' width="330px">
                            <input type="text"
                                   class="form-control"
                                   data-ax-path="name"
                                   name="name"
                                   id="name"
                                   placeholder="이름을 입력해주세요."/>
                        </ax:td>
                    </ax:tr>
                    <ax:tr>
                        <ax:td label='<span style="color:red">*</span> 비밀번호' width="330px">
                            <input type="password"
                                   class="form-control"
                                   data-ax-path="pwd"
                                   name="pwd"
                                   id="pwd"
                                   placeholder="비밀번호를 입력해주세요."/>
                        </ax:td>
                    </ax:tr>
                    <ax:tr>
                        <ax:td label='<span style="color:red">*</span> 비밀번호 확인' width="330px">
                            <input type="password"
                                   class="form-control"
                                   data-ax-path="pwd2"
                                   name="pwd2"
                                   id="pwd2"
                                   placeholder="동일한 비밀번호를 입력해주세요."/>
                        </ax:td>

                        <ax:td id = 'pwdCheck' label=' ' style="backgroun-color:white; text-align: left;" width="400px">
                        </ax:td>

                    </ax:tr>
                    <ax:tr>
                        <ax:td label='휴대폰번호' width="400px">
                            <input type="text"
                                   class="form-control"
                                   data-ax-path="tel"
                                   name="tel"
                                   id="tel"
                                   formatter="tel"
                                   placeholder="휴대폰 번호를 입력해주세요."/>
                        </ax:td>
                    </ax:tr>

                </ax:tbl>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>
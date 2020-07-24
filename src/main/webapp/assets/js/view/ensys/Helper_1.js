$(this.parent.document).keydown(function (e) {
    var cdkey;
    if (window.event)
        cdkey = window.event.keyCode; //IE
    else
        cdkey = e.which; //firefox

    if (cdkey == '9') {
        return false;
    }
});


console.log(this.parent);

var param = ax5.util.param(ax5.info.urlUtil().param);

var ACTION = param.ACTION;

var URLS = ACTION.split('_');
var URL = '';

if (URLS[0] == 'HELP') {
    URL = "common" + URLS[0].substring(0, 1).toUpperCase() + URLS[0].substring(1, URLS[0].length).toLowerCase();
    // URL : commonHelp
}
if (URLS[0] == 'CUSTOM') {
    URL = URLS[0].toString().toLowerCase();
    URL += URLS[1].substring(0, 1).toUpperCase();
    URL += URLS[1].substring(1, URLS[1].length).toLowerCase();
    // URL : customHelp
}
// console.log("URL : " + URL);
// console.log("ACTION : " + ACTION);

var initData;
if (param.modalName) {
    initData = eval("parent." + param.modalName + ".modalConfig.sendData()");  // 부모로 부터 받은 Parameter Object
} else {
    initData = parent.modal.modalConfig.sendData();  // 부모로 부터 받은 Parameter Object
}

var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_CLOSE: function (caller, act, data) {
        var callback = param.callBack;
        callback = callback.replace(/%5B/g, '[').replace(/%5D/g, ']');
        if (param.modalName) {
            parent.document.getElementsByName(param.viewName)[0].contentWindow[callback]([]);
            eval("parent." + param.modalName + ".close()");
            return;
        }
        parent[callback]([]);
        parent.modal.close();
    },
    PAGE_SEARCH: function (caller, act, data) {
        var ParameterData = $.extend(initData.initData, caller.searchView.getData().data);
        // console.log(ParameterData);
        axboot.ajax({
            type: "POST",
            url: [URL, ACTION],
            data: JSON.stringify(ParameterData),
            callback: function (res) {
                caller.gridView01.setData(res);
            },
            options: {
                // axboot.ajax 함수에 2번째 인자는 필수가 아닙니다. ajax의 옵션을 전달하고자 할때 사용합니다.
                onError: function (err) {
                    // console.log(err);
                }
            }
        });
        return false;
    },

    ITEM_SELECT: function (caller, act, data) {
        var callback = param.callBack;
        callback = callback.replace(/%5B/g, '[').replace(/%5D/g, ']');
        console.log("ITEM_SELECT");
        if (param.viewName) {
            qray.loading.show("데이터 선택 중입니다.", 200).then(function () {
                parent.document.getElementsByName(param.viewName)[0].contentWindow[callback](caller.gridView01.getData('selected'));
                qray.loading.hide();
                eval("parent." + param.modalName + ".close()");

            });
        }else{
            qray.loading.show("데이터 선택 중입니다.", 200).then(function () {
                parent[callback](caller.gridView01.getData('selected'));
                qray.loading.hide();
                parent.modal.close();
            });

        }
    }
});

// fnObj 기본 함수 스타트와 리사이즈
fnObj.pageStart = function () {
    if (initData["KEYWORD"] != null || initData["KEYWORD"] != undefined) {
        if ($("#KEYWORD").length > 0) {
            $("#KEYWORD").val(initData.KEYWORD);
        }
        if ($("#P_KEYWORD").length > 0) {
            $("#P_KEYWORD").val(initData.KEYWORD);
        }
    }
    this.pageButtonView.initView();
    this.searchView.initView();
    this.gridView01.initView();


    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
};

fnObj.pageResize = function () {

};


fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "select": function () {
                ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
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
        if (nvl(components) != '') {

            for (var i = 0; i < components.length; i++) {
                var columnName = components[i].getAttribute("name");
                if (columnName != null) {
                    if (components[i].getAttribute("codepicker") != null){
                        if (columnName.substring(0, 2) == 'P_') {       //  조회조건 중 ID값들에 'P_' 가 붙은 것이 있다면
                            columns[columnName] = components[i].getAttribute('code');
                            columns[columnName.replace('P_', '')] = components[i].getAttribute('code');
                        } else {                                        //  조회조건 중 ID값들에 'P_' 가 안붙은 것이 있다면
                            columns["P_" + columnName] = components[i].getAttribute('code');
                            columns[columnName] = components[i].getAttribute('code');
                        }
                    }else{
                        if (columnName.substring(0, 2) == 'P_') {       //  조회조건 중 ID값들에 'P_' 가 붙은 것이 있다면
                            columns[columnName] = components[i].value
                            columns[columnName.replace('P_', '')] = components[i].value
                        } else {                                        //  조회조건 중 ID값들에 'P_' 가 안붙은 것이 있다면
                            columns["P_" + columnName] = components[i].value
                            columns[columnName] = components[i].value
                        }
                    }

                    // console.log(JSON.stringify(columns));
                }
            }
        }
        return {
            data: columns
        }
    }
});


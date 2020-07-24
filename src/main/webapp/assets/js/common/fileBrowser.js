var param = ax5.util.param(ax5.info.urlUtil().param);
var deleteArr = [];
var initData;
if (param.modalName) {
    initData = eval("parent." + param.modalName + ".modalConfig.sendData");  // 부모로 부터 받은 Parameter Object
} else {
    initData = parent.modal.modalConfig.sendData;  // 부모로 부터 받은 Parameter Object
}
if (initData["disabled"] == 'true') {
    $("#save").remove();
    $("#delete").remove();
}

var myModel = new ax5.ui.binder();
var dialog = new ax5.ui.dialog();

var fnObj = {}, CODE = {};
var ACTIONS = axboot.actionExtend(fnObj, {
        PAGE_SEARCH: function (caller, act, data) {
            var DATA = {
                "BOARD_TYPE": initData.P_BOARD_TYPE,
                "SEQ": initData.P_SEQ
            };
            console.log(DATA);

            axboot.ajax({
                type: "POST",
                url: ["commonutility", "BbsFileSearch"],
                data: JSON.stringify(DATA),
                callback: function (res) {
                    console.log(res);
                    caller.gridView01.setData(res);
                    caller.gridView01.target.select(0);

                    if (res.list.length > 0) {
                        ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                    }
                }
            });
            return false;
        },
        ITEM_ADD: function (caller, act, data) {
            if (nvl(data, '') == '') {
                qray.alert('파일을 선택해주세요.');
                return false;
            }
            fnObj.gridView01.addRow();
            $("#files").val('');

            var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());

            fnObj.gridView01.target.select(lastIdx - 1);


            caller.gridView01.target.setValue(lastIdx - 1, "BOARD_TYPE", initData.P_BOARD_TYPE);
            caller.gridView01.target.setValue(lastIdx - 1, "SEQ", initData.P_SEQ);
            if (caller.gridView01.getData().length == 1) {
                caller.gridView01.target.setValue(lastIdx - 1, "SEQ_FILE", '1');
            } else {
                caller.gridView01.target.setValue(lastIdx - 1, "SEQ_FILE", Number(nvl(caller.gridView01.getData()[lastIdx - 2].SEQ_FILE, 0)) + 1);
            }
            fnObj.gridView01.target.setValue(lastIdx - 1, 'FILE_BYTE', data.FILE_SIZE);
            fnObj.gridView01.target.setValue(lastIdx - 1, 'FILE_EXT', data.FILE_EXT);
            fnObj.gridView01.target.setValue(lastIdx - 1, 'FILE_NAME', data.FILE_NAME);
            fnObj.gridView01.target.setValue(lastIdx - 1, 'ORGN_FILE_NAME', data.ORGN_FILE_NAME);
            fnObj.gridView01.target.setValue(lastIdx - 1, 'FILE_SIZE', ax5.util.number(data.FILE_SIZE, {"byte": true}));
            fnObj.gridView01.target.setValue(lastIdx - 1, 'FILE_PATH', data.FILE_PATH);
            fnObj.gridView01.target.setValue(lastIdx - 1, 'YN_UPLOAD', 'N');

            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
        },
        ITEM_DELETE: function (caller, act, data) {
            if (nvl(files[Number(caller.gridView01.getData('selected')[0].SEQ_FILE)], '') != '') {
                files.splice(Number(caller.gridView01.getData('selected')[0].SEQ_FILE), 1);
            }
            caller.gridView01.delRow("selected");
        },
        ITEM_CLICK: function (caller, act, data) {
            if (nvl($('.preview-box'), '') != '') {
                $('.preview-box').remove();
            }

            var item = caller.gridView01.getData('selected')[0];

            if (nvl(item) != '') {
                myModel.setModel({
                    ORGN_FILE_NAME: item.ORGN_FILE_NAME,
                    FILE_EXT: item.FILE_EXT,
                    FILE_BYTE: item.FILE_BYTE,
                    FILE_SIZE: item.FILE_SIZE
                }, $(document["formView01"]));

                var chkVal = true;

                var FILEPATH;

                if (item.YN_UPLOAD == 'N') {
                    FILEPATH = item.FILE_PATH;

                    if (window.navigator.msSaveBlob) { // IE
                        var html = "";
                        if (item.YN_UPLOAD == 'N') {
                            html = "";
                        } else {
                            html = '<button type="button" id="DownloadBtn" class="btn btn-default"><i class="cqc-download"></i> 다운로드</button></a></div>';
                        }

                        $("#preview")
                            .append(
                                '<div class=\'preview-box\'>'
                                + '<div class="H10"></div>'
                                + '<div>'
                                + html
                                + '<div class="imgBox"><img src="' + FILEPATH + '" class="img-responsive"/></div>'
                            );
                        console.log("append");
                    } else { // Chrome

                        $("#preview")
                            .append(
                                '<div class=\'preview-box\'>'
                                + '<div class="H10"></div>'
                                + '<div>'
                                + "<a href=\"" + FILEPATH + "\" download=\"" + item.ORGN_FILE_NAME + "\">"
                                + '<button type="button" class="btn btn-default"><i class="cqc-download"></i> 다운로드</button></a></div>'
                                + '<div class="imgBox"><img src="' + FILEPATH + '" class="img-responsive"/></div>'
                            );
                        console.log("append");
                    }
                    if (item.FILE_EXT != 'jpg' && item.FILE_EXT != 'png' && item.FILE_EXT != 'gif') {
                        chkVal = false;
                    }



                    if (!chkVal) {
                        $(".imgBox").remove();
                    }else{
                        $('img').error(function(){
                            $(".imgBox").html('이미지가 경로에 없습니다.');
                            $(".imgBox").attr('style', 'padding: 10%;');
                        });
                    }

                    $("#DownloadBtn").click(function () {
                        var xhr = getXmlHttpRequest();
                        // window.location.assign(FILEPATH);
                        xhr.open('POST', "/api/commonutility/downloadFile");
                        xhr.responseType = 'blob';
                        xhr.setRequestHeader('Content-type', 'application/json');
                        xhr.onreadystatechange = function () {
                            if (this.readyState == 4 && this.status == 200) {
                                console.log(this.response);
                                var _data = this.response;
                                var _blob = new Blob([_data], {type: this.response.type});

                                window.navigator.msSaveOrOpenBlob(_blob, item.ORGN_FILE_NAME)
                            }
                        };
                        xhr.send(JSON.stringify(item));
                    })

                } else {
                    FILEPATH = axboot.getfileRoot() + "\\" + item.FILE_NAME + "." + item.FILE_EXT;

                    qray.loading.show("조회 중입니다");
                    axboot.call({
                        type: "POST",
                        url: ["commonutility", "FileRead"],
                        async: false,
                        data: JSON.stringify({
                            file: item
                        }),
                        callback: function (res) {
                            console.log("callback");
                        }
                    }).done(function () {
                        qray.loading.hide();
                        console.log("done");
                        if (window.navigator.msSaveBlob) { // IE
                            var html = "";
                            if (item.YN_UPLOAD == 'N') {
                                html = "";
                            } else {
                                html = '<button type="button" id="DownloadBtn" class="btn btn-default"><i class="cqc-download"></i> 다운로드</button></a></div>';
                            }

                            $("#preview")
                                .append(
                                    '<div class=\'preview-box\'>'
                                    + '<div class="H10"></div>'
                                    + '<div>'
                                    + html
                                    + '<div class="imgBox"><img src="' + FILEPATH + '" class="img-responsive"/></div>'
                                );
                            console.log("append");
                        } else { // Chrome

                            $("#preview")
                                .append(
                                    '<div class=\'preview-box\'>'
                                    + '<div class="H10"></div>'
                                    + '<div>'
                                    + "<a href=\"" + FILEPATH + "\" download=\"" + item.ORGN_FILE_NAME + "\">"
                                    + '<button type="button" class="btn btn-default"><i class="cqc-download"></i> 다운로드</button></a></div>'
                                    + '<div class="imgBox"><img src="' + FILEPATH + '" class="img-responsive"/></div>'
                                );
                            console.log("append");
                        }
                        if (item.FILE_EXT != 'jpg' && item.FILE_EXT != 'png' && item.FILE_EXT != 'gif') {
                            chkVal = false;
                        }



                        if (!chkVal) {
                            $(".imgBox").remove();
                        }else{
                            $('img').error(function(){
                                $(".imgBox").html('이미지가 경로에 없습니다.');
                                $(".imgBox").attr('style', 'padding: 10%;');
                            });
                        }

                        $("#DownloadBtn").click(function () {
                            var xhr = getXmlHttpRequest();
                            // window.location.assign(FILEPATH);
                            xhr.open('POST', "/api/commonutility/downloadFile");
                            xhr.responseType = 'blob';
                            xhr.setRequestHeader('Content-type', 'application/json');
                            xhr.onreadystatechange = function () {
                                if (this.readyState == 4 && this.status == 200) {
                                    console.log(this.response);
                                    var _data = this.response;
                                    var _blob = new Blob([_data], {type: this.response.type});

                                    window.navigator.msSaveOrOpenBlob(_blob, item.ORGN_FILE_NAME)
                                }
                            };
                            xhr.send(JSON.stringify(item));
                        })
                    });
                }




            } else {
                $("#ORGN_FILE_NAME").val('');
                $("#FILE_EXT").val('');
                $("#FILE_BYTE").val('');
                $("#FILE_SIZE").val('');
            }

        },
        PAGE_SAVE:
            function (caller, act, data) {

                for (var i = 0; i < caller.gridView01.target.list.length; i++) {
                    for (var i2 = 0; i2 < caller.gridView01.target.list.length; i2++) {
                        if (i == i2) continue;

                        if (caller.gridView01.target.list[i].ORGN_FILE_NAME == caller.gridView01.target.list[i2].ORGN_FILE_NAME) {
                            qray.alert('같은 파일명을 저장하실 수 없습니다.');
                            return false;
                        }
                    }
                }

                deleteArr = deleteArr.concat(caller.gridView01.getData("deleted"));

                if (nvl(deleteArr) == '' && Object.keys(files).length == 0) {
                    qray.alert('변경된 내용이 없습니다.');
                    return false;
                }

                var arr = [];
                for (var i = 0; i < deleteArr.length; i++) {
                    if (!deleteArr[i].__created__) {
                        arr.push(deleteArr[i]);
                    }
                }

                /*   var fileDel = [];
                   for (var i = 0; i < caller.gridView01.getData("deleted").length; i++) {
                       if (caller.gridView01.getData("deleted")[i].YN_UPLOAD != 'N') {
                           fileDel.push(caller.gridView01.getData("deleted")[i]);
                       }
                   }*/

                var formData = new FormData();
                var FILE_ARR = [];
                for (var i = 0; i < Object.keys(files).length; i++) {
                    FILE_OBJ = {};
                    for (var j = 0; j < caller.gridView01.target.list.length; j++) {
                        if (Object.keys(files)[i] == caller.gridView01.target.list[j].SEQ_FILE) {
                            FILE_OBJ.FILE_NAME = caller.gridView01.target.list[j].FILE_NAME;
                            FILE_ARR.push(FILE_OBJ);
                        }
                    }
                    formData.append('files', files[Object.keys(files)[i]]);
                }
                formData.append("fileName", new Blob([JSON.stringify(FILE_ARR)], {type: "application/json"}));
                // formData.append('fileDel', new Blob([JSON.stringify(fileDel)], {type: "application/json"}));

                $.ajax({
                    type: 'POST',
                    async: false,
                    enctype: 'multipart/form-data',
                    processData: false,
                    contentType: false,
                    cache: false,
                    timeout: 600000,
                    url: '/api/commonutility/save',
                    data: formData,
                    success: function (result) {
                        for (var i = 0; i < caller.gridView01.target.list.length; i++) {
                            caller.gridView01.target.setValue(i, 'YN_UPLOAD', 'Y');
                            caller.gridView01.target.setValue(i, 'FILE_PATH', result.map.FILE_PATH);
                        }

                        files = []; //  초기화

                        var imsi = {};
                        imsi.gridData = fnObj.gridView01.target.list;
                        imsi.delete = arr;

                        if (param.viewName) {
                            parent.document.getElementsByName(param.viewName)[0].contentWindow[param.callBack](imsi);
                            return;
                        }
                        parent[param.callBack](imsi);
                    }
                });
            }
    }
);

myModel.onChange("*", function (n) {
    var selectIdx = fnObj.gridView01.getData('selected')[0].__index;
    fnObj.gridView01.target.setValue(selectIdx, n.el.name, n.value);
});

var getXmlHttpRequest = function () {
    if (window.ActiveXObject) {
        try {
            return new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e1) {
                qray.alert('에러에러');
            }
        }
    } else if (window.XMLHttpRequest) {
        return new XMLHttpRequest();
    } else {
        qray.alert('에러에러');
    }
};

fnObj.pageStart = function () {
    this.pageButtonView.initView();
    this.gridView01.initView();


    if (nvl(initData["imsiFile"], '') == '') {
        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
    } else {
        if (nvl(initData["imsiFile"]["gridData"]) != '') {
            fnObj.gridView01.setData({
                list: initData["imsiFile"]["gridData"],
                page: fnObj.gridView01.getPageData()
            });
            fnObj.gridView01.target.select(0);
        }

        if (nvl(initData["imsiFile"]["files"]) != '') {
            files = initData["imsiFile"]["files"];
        }

        if (nvl(initData["imsiFile"]["delete"]) != '') {
            deleteArr = initData["imsiFile"]["delete"];
        }

        if (fnObj.gridView01.target.list.length > 0) {
            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
        }

    }


};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "search": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            },
            "save": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
            },
            "delete": function () {
                var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                var dataLen = fnObj.gridView01.target.getList().length;

                if ((beforeIdx + 1) == dataLen) {
                    beforeIdx = beforeIdx - 1;
                }

                ACTIONS.dispatch(ACTIONS.ITEM_DELETE);
                if (beforeIdx > 0 || beforeIdx == 0) {
                    fnObj.gridView01.target.select(beforeIdx);
                }
                ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
            },
            "close": function () {
                if (param.modalName) {
                    eval("parent." + param.modalName + ".close()");
                    return;
                }
                parent.modal.close();
            }
        });
    }
});

fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
    page: {
        pageNumber: 0,
        pageSize: 10
    },
    initView: function () {
        var _this = this;

        this.target = axboot.gridBuilder({
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-01"]'),
            columns: [
                {key: "CD_COMPANY", label: "회사코드", width: 90, align: "center", editor: false, hidden: true},
                {
                    key: "BOARD_TYPE",
                    label: "보드타입[모듈_메뉴명_해당ID]",
                    width: 90,
                    align: "center",
                    editor: false, hidden: true
                },
                {key: "SEQ", label: "해당ID의 순번", width: 90, align: "center", editor: false, hidden: true},
                {key: "SEQ_FILE", label: "파일의 순번", width: 90, align: "center", editor: false, hidden: true},
                {key: "FILE_PATH", label: "파일경로", width: 90, align: "center", editor: false, hidden: true},
                {
                    key: "FILE_NAME",
                    label: "UUID파일명",
                    width: 150,
                    align: "center",
                    editor: false, hidden: true
                },
                {key: "ORGN_FILE_NAME", label: "파일명", width: 150, align: "center", editor: false},
                {key: "FILE_EXT", label: "파일확장자", width: 90, align: "center", editor: false},
                {key: "FILE_BYTE", label: "파일바이트", width: 90, align: "center", editor: false},
                {key: "FILE_SIZE", label: "파일사이즈", width: 90, align: "center", editor: false},
                {
                    key: "YN_UPLOAD",
                    label: "파일업로드여부",
                    width: 90,
                    align: "center",
                    editor: false,
                    hidden: true
                }

            ],
            body: {
                onClick: function () {
                    var Col = this.colIndex;
                    var data = this.item;
                    var column = this.column.key;
                    var idx = this.dindex;

                    this.self.select(idx);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                }
            },
            onPageChange: function (pageNumber) {
                _this.setPageData({pageNumber: pageNumber});
            }
        });
        axboot.buttonClick(this, "data-grid-view-01-btn", {
            "add": function () {
                ACTIONS.dispatch(ACTIONS.ITEM_ADD);
            }
        });
    },
    getData: function (_type) {
        var list = [];
        var _list = this.target.getList(_type);
        list = _list;

        return list;
    },
    addRow: function () {
        this.target.addRow({__created__: true}, "last");
    },
    lastRow: function () {
        return ($("div [data-ax5grid='grid-view-01']").find("div [data-ax5grid-panel='body'] table tr").length)
    }, sort: function () {

    }
});

var openPopup = function (obj) {
    addPreview(obj);
};

var files = [];

function addPreview(input) {
    if (input.files.length > 0) {
        //파일 선택이 여러개였을 시의 대응
        for (var fileIndex = 0; fileIndex < input.files.length; fileIndex++) {
            var file = input.files[fileIndex];

            var reader = new FileReader();
            reader.onload = function (img) {

                var data = {};
                var uuid_file_name = guid();

                data.FILE_NAME = uuid_file_name;
                data.ORGN_FILE_NAME = file.name;
                data.FILE_EXT = validation(file.name);
                data.FILE_SIZE = file.size;
                data.FILE_PATH = img.target.result;

                ACTIONS.dispatch(ACTIONS.ITEM_ADD, data);

                var imgNum = Number(fnObj.gridView01.getData('selected')[0].SEQ_FILE);
                files[imgNum] = file;
            };
            reader.readAsDataURL(file);
        }
    } else {
        qray.alert('파일을 선택해주세요.');
        return false;
    }

}


function validation(fileName) {
    fileName = fileName + "";
    var fileNameExtensionIndex = fileName.lastIndexOf('.') + 1;
    var fileNameExtension = fileName.toLowerCase().substring(
        fileNameExtensionIndex, fileName.length);

    /*
    // 확장자 지정해주고 싶을 때
    if (!((fileNameExtension === 'jpg')
        || (fileNameExtension === 'gif') || (fileNameExtension === 'png'))) {
        alert('jpg, gif, png 확장자만 업로드 가능합니다.');
        return true;
    }

    */

    return fileNameExtension;
}

function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }

    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
        s4() + '-' + s4() + s4() + s4();
}

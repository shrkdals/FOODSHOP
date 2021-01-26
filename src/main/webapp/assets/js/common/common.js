var thisName = this.name;
var modal = new ax5.ui.modal();
var mask = new ax5.ui.mask();
var messageDialog = new ax5.ui.dialog();
var CommonCallback;
var self_ = this;

(function () {
    if (typeof window.CustomEvent === "function") return false;

    function CustomEvent(event, params) {
        params = params || {bubbles: false, cancelable: false, detail: undefined};
        var evt = document.createEvent('CustomEvent');
        evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
        return evt;
    }

    CustomEvent.prototype = window.Event.prototype;

    window.CustomEvent = CustomEvent;
})();

// 그리드 텍스트 입력시 바로 에디터 활성화

$(document).on('mousedown', '.hasBorder', function (e) {
    for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
        if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
            continue;
        }

        if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
            continue;
        }

        if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $(this).parents('[data-ax5grid]').attr('data-ax5grid')) {

            var div = $(this).parents('div');
            for (var d = 0; d < div.length; d++) {
                if ($(div[d]).attr('data-ax5grid-panel') == 'body') {
                    $(this).parent().css('background', '#fffae6');
                    for (var n = 0; n < $(this).parent().nextAll().length; n++) {
                        $($(this).parent().nextAll()[n])[0].removeAttribute('style');
                    }
                    for (var p = 0; p < $(this).parent().prevAll().length; p++) {
                        $($(this).parent().prevAll()[p])[0].removeAttribute('style');
                    }
                    break;
                }
            }
        }
    }
});

$(document).on('mouseover', '.hasBorder', function (e) {
    for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
        if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
            continue;
        }

        if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
            continue;
        }

        if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $(this).parents('[data-ax5grid]').attr('data-ax5grid')) {

            var div = $(this).parents('div');
            for (var d = 0; d < div.length; d++) {
                if ($(div[d]).attr('data-ax5grid-panel') == 'body') {
                    if ($(this).parent().attr('data-ax5grid-selected') == 'true') {
                        continue;
                    }
                    $(this).parent().css('background', '#fcfaf0');
                    break;
                }
            }
        }
    }
});
$(document).on('mouseout', '.hasBorder', function (e) {
    for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
        if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
            continue;
        }

        if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
            continue;
        }

        if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $(this).parents('[data-ax5grid]').attr('data-ax5grid')) {

            var div = $(this).parents('div');
            for (var d = 0; d < div.length; d++) {
                if ($(div[d]).attr('data-ax5grid-panel') == 'body') {
                    if ($(this).parent().attr('data-ax5grid-selected') == 'true') {
                        continue;
                    }
                    $(this).parent()[0].removeAttribute('style');
                    break;
                }
            }
        }
    }
});


$(document).on('dblclick', '.hasBorder', function (e) {

    if (!$(this).attr('data-ax5grid-column-focused')) {
        return;
    }

    if($(this.parentNode)[0].getAttribute('data-ax5grid-grouping-tr')){
        return
    }

    for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
        if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
            continue;
        }
        if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
            continue;
        }
        if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $(this).parents('[data-ax5grid]').attr('data-ax5grid')) {
            var this_, selectIndex, colIndex, colKey, preValue, thisValue;
            if ($(this)[0].innerHTML.indexOf('input') > -1) {
                this_ = self_.fnObj[Object.keys(self_.fnObj)[i]].target;
                selectIndex = (nvl($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(document.activeElement).parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                colIndex = (nvl($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(document.activeElement).parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                if (nvl(this_.list[selectIndex]) == '') {
                    return;
                }
                preValue = this_.list[selectIndex][colKey];
                if (nvl(this_.inlineEditing[selectIndex + "_" + colIndex + "_" + "0"]) == '') {
                    return;
                }
                thisValue = this_.inlineEditing[selectIndex + "_" + colIndex + "_" + "0"].$inlineEditor[0].value;
            } else {
                this_ = self_.fnObj[Object.keys(self_.fnObj)[i]].target;
                selectIndex = (nvl($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(document.activeElement).parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                colIndex = (nvl($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(document.activeElement).parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(document.activeElement).find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                if (nvl(this_.list[selectIndex]) == '') {
                    return;
                }
                preValue = this_.list[selectIndex][colKey];
                thisValue = this_.list[selectIndex][colKey];
            }


            var that = {
                self: this_,
                column: this_.colGroup[colIndex],
                list: this_.list,
                item: this_.list[selectIndex],
                value: thisValue,
                dindex: selectIndex
            };


            if (nvl(this_.colGroup[colIndex].picker) == '') {
                if (ax5.util.isObject(this_.colGroup[colIndex].editor)) {
                    if (nvl(this_.config.body.onDBLClick) != '') {
                        this_.config.body.onDBLClick.call(that);
                    }
                }

                return false;
            }

            var picker = (typeof (this_.colGroup[colIndex].picker) == 'function') ? this_.colGroup[colIndex].picker() : this_.colGroup[colIndex].picker;

            this_.setValue(selectIndex, colKey, thisValue);

            var url = picker.url;
            var callback = picker.callback;
            var action = picker.action;
            var param = (nvl(picker.param) == '') ? '' : nvl(picker.param.call(that));
            var width = nvl(picker.width, 600);
            var height = nvl(picker.height, 600);
            var top = nvl(picker.top, 25);
            var disabled;
            if (nvl(picker['disabled']) != '') {
                disabled = picker.disabled.call({
                    list: this_.list,
                    dindex: selectIndex,
                    item: this_.list[selectIndex],
                    key: colKey,
                    value: this_.list[selectIndex][colKey]
                }, this_.list[selectIndex]);
            } else {
                disabled = false;
            }

            ax5.ui.grid.body.inlineEdit.deActive.call(this_, "CANCEL", selectIndex + "_" + colIndex + "_" + "0");

            if (!disabled) {
                CommonCallback = function (e) {
                    console.log('commonCallBack ', e);
                    if (e.length > 0) {
                        picker.callback.call({
                            list: this_.list,
                            dindex: selectIndex,
                            item: this_.list[selectIndex],
                            key: colKey,
                            value: this_.list[selectIndex][colKey]
                        }, e);
                    } else {  //  취소한 건
                        if (thisValue == '') {
                            this_.setValue(selectIndex, colKey, thisValue);
                        } else {
                            this_.setValue(selectIndex, colKey, preValue);
                        }
                    }
                    parent.modal.close();
                };
                if (action[0] == 'commonHelp') {
                    if (param == '') {
                        $.openCommonPopup(url, "CommonCallback", action[1], thisValue, null, width, height, top);
                    } else {
                        $.openCommonPopup(url, "CommonCallback", action[1], thisValue, param, width, height, top);
                    }
                } else if (action[0] == 'customHelp') {
                    if (param == '') {
                        $.openCustomPopup(url, "CommonCallback", action[1], null, thisValue, width, height, top);
                    } else {
                        $.openCustomPopup(url, "CommonCallback", action[1], param, thisValue, width, height, top);
                    }
                } else {
                    throw "ACTION 명 불일치, 확인필요";
                }
            }
        }
    }
});

$(document).on('keyup', '.ax-body', function (e) {
    //방향키
    if ($(document).find('[data-ax5grid-column-focused="true"]').length == 0) {
        return;
    }
    if (e.keyCode >= '37' && e.keyCode <= '40' || e.keyCode == '13' || e.keyCode == '9') {
        for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
            if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
                continue;
            }
            if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
                continue;
            }
            if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').attr('data-ax5grid')) {
                if ($(document).find('[data-ax5grid-column-focused="true"] input').length > 0) {
                    return;
                }
                var this_ = self_.fnObj[Object.keys(self_.fnObj)[i]].target;
                var selectIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                var colIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                var colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                if (nvl(this_.list[selectIndex]) == '') {
                    return;
                }
                var thisValue = this_.list[selectIndex][colKey];

                var that = {
                    self: this_,
                    column: this_.colGroup[colIndex],
                    list: this_.list,
                    item: this_.list[selectIndex],
                    value: thisValue,
                    dindex: selectIndex
                };

                var div = $(".ax-body").find('[data-ax5grid-column-focused="true"]').parents('div');
                for (var d = 0; d < div.length; d++) {
                    if ($(div[d]).attr('data-ax5grid-panel') == 'body') {
                        $(".ax-body").find('[data-ax5grid-column-focused="true"]').parent().css('background', '#fffae6');
                        for (var n = 0; n < $(".ax-body").find('[data-ax5grid-column-focused="true"]').parent().nextAll().length; n++) {
                            $($(".ax-body").find('[data-ax5grid-column-focused="true"]').parent().nextAll()[n])[0].removeAttribute('style');
                        }
                        for (var p = 0; p < $(".ax-body").find('[data-ax5grid-column-focused="true"]').parent().prevAll().length; p++) {
                            $($(".ax-body").find('[data-ax5grid-column-focused="true"]').parent().prevAll()[p])[0].removeAttribute('style');
                        }
                        break;
                    }
                }

                if (e.keyCode != 37 && e.keyCode != 39) {
                    this_.select(that);
                }
                this_.config.body.onClick.call(that);
            }
        }
    }
});


$(document).on('keydown', '.ax-body ', function (e) {
    var U = ax5.util;
    if ($(document).find('[data-ax5grid-column-focused="true"]').length == 0) {
        return;
    }

    if (e.keyCode == '39' || e.keyCode == '37' ) {
        for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
            if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
                continue;
            }
            if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
                continue;
            }
            if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').attr('data-ax5grid')) {
                if ($(document).find('[data-ax5grid-column-focused="true"] input').length > 0) {
                    return;
                }
                var this_ = self_.fnObj[Object.keys(self_.fnObj)[i]].target;
                var selectIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                var colIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                var colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                if (nvl(this_.list[selectIndex]) == '') {
                    return;
                }
                var thisValue = this_.list[selectIndex][colKey];

                var that = {
                    self: this_,
                    column: this_.colGroup[colIndex],
                    list: this_.list,
                    item: this_.list[selectIndex],
                    value: thisValue,
                    dindex: selectIndex
                };

                this_.select(that);
                this_.config.body.onClick.call(that);
            }
        }
    }

    // 숫자와 문자
    if (((e.keyCode >= '48' && e.keyCode <= '57') || (e.keyCode >= '65' && e.keyCode <= '90') || (e.keyCode >= '96' && e.keyCode <= '122') || e.keyCode == '8')) {
        for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
            if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
                continue;
            }
            if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
                continue;
            }
            if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').attr('data-ax5grid')) {
                if ($(document).find('[data-ax5grid-column-focused="true"] input').length > 0) {    //  만약 editor가 열려있다면 돌아가라.
                    return;
                }
                var gridName = Object.keys(self_.fnObj)[i];
                var this_ = self_.fnObj[gridName].target;
                var selectIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                var colIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                var colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                if (nvl(this_.list[selectIndex]) == '') {
                    return;
                }
                var preValue = this_.list[selectIndex][colKey];
                var editor = this_.colGroup[colIndex].editor;

                if (ax5.util.isObject(editor)) {
                    ax5.ui.grid.body.inlineEdit.active.call(this_, this_.focusedColumn, undefined, preValue);
                }

                // 포커스 아웃
                $(document).find('[data-ax5grid-column-focused="true"] input').on('focusout', function () {
                    var thisValue = this.value;

                    if (nvl(this_.colGroup[colIndex].picker) == '') {
                        return;
                    }

                    var picker = (typeof (this_.colGroup[colIndex].picker) == 'function') ? this_.colGroup[colIndex].picker() : this_.colGroup[colIndex].picker;

                    if (preValue != thisValue) {
                        ax5.ui.grid.body.inlineEdit.deActive.call(this_, "ESC", selectIndex + "_" + colIndex + "_" + "0");
                        var url = picker.url;
                        var callback = "fnObj." + gridName + ".target.colGroup[" + colIndex + "].picker.callback";
                        var action = picker.action;
                        var param = (nvl(picker.param) == '') ? '' : nvl(picker.param.call({
                            list: this_.list,
                            dindex: selectIndex,
                            item: this_.list[selectIndex],
                            key: colKey,
                            value: this_.list[selectIndex][colKey]
                        }));
                        var width = nvl(picker.width, 600);
                        var height = nvl(picker.height, 600);
                        var top = nvl(picker.top, 25);
                        var disabled;
                        if (nvl(picker['disabled']) != '') {
                            //disabled = picker.disabled(this_.list[selectIndex]);
                            disabled = picker.disabled.call({
                                list: this_.list,
                                dindex: selectIndex,
                                item: this_.list[selectIndex],
                                key: colKey,
                                value: this_.list[selectIndex][colKey]
                            }, this_.list[selectIndex]);

                        } else {
                            disabled = false;
                        }

                        this_.setValue(selectIndex, colKey, thisValue);
                        if (thisValue == '') {
                            return;
                        }

                        if (!disabled) {
                            CommonCallback = function (e) {
                                if (e.length > 0) {
                                    picker.callback.call({
                                        list: this_.list,
                                        dindex: selectIndex,
                                        item: this_.list[selectIndex],
                                        key: colKey,
                                        value: this_.list[selectIndex][colKey]
                                    }, e);
                                } else {  //  취소한 건
                                    if (thisValue == '') {
                                        this_.setValue(selectIndex, colKey, thisValue);
                                    } else {
                                        this_.setValue(selectIndex, colKey, preValue);
                                    }
                                }
                                parent.modal.close();
                            };
                            var parameter = {};
                            if (param != '') {
                                for (var z = 0; z < Object.keys(param).length; z++) {
                                    var obj = {};
                                    obj["USERDEF" + Number(z + 2)] = param[Object.keys(param)[z]];
                                    parameter = $.extend(parameter, obj);
                                }
                            }
                            parameter = $.extend(parameter, {ID_ACTION: action[1], USERDEF1: thisValue});
                            var result = $.DATA_SEARCH('common', "HELP_CHECK_SEARCH", parameter);
                            if (result.list.length == 1) {
                                picker.callback.call({
                                    list: this_.list,
                                    dindex: selectIndex,
                                    item: this_.list[selectIndex],
                                    key: colKey,
                                    value: this_.list[selectIndex][colKey]
                                }, result.list);
                                return false;
                            }
                            if (action[0] == 'commonHelp') {
                                if (param == '') {
                                    $.openCommonPopup(url, "CommonCallback", action[1], thisValue, null, width, height, top);
                                } else {
                                    $.openCommonPopup(url, "CommonCallback", action[1], thisValue, param, width, height, top);
                                }
                            } else if (action[0] == 'customHelp') {
                                if (param == '') {
                                    $.openCustomPopup(url, "CommonCallback", action[1], null, thisValue, width, height, top);
                                } else {
                                    $.openCustomPopup(url, "CommonCallback", action[1], param, thisValue, width, height, top);
                                }
                            } else {
                                throw "ACTION 명 불일치, 확인필요";
                            }
                        }
                    }
                })
            }
        }
    }

    // 방향키 탭, 엔터를 눌렀을 경우
    if (e.keyCode == '13' || e.keyCode == '9' || (e.keyCode >= '37' && e.keyCode <= '40')) {
        for (var i = 0; i < Object.keys(self_.fnObj).length; i++) {
            if (Object.keys(self_.fnObj)[i].toUpperCase().indexOf('GRID') < 0) {
                continue;
            }
            if (nvl(self_.fnObj[Object.keys(self_.fnObj)[i]].target) == '') {    //  pagestart 에서 .initView(); 선언 안해준 부분이 있을 경우 넘겨라
                continue;
            }
            if ($(self_.fnObj[Object.keys(self_.fnObj)[i]].target.$target)[0].getAttribute('data-ax5grid') == $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').attr('data-ax5grid')) {
                var this_, selectIndex, colIndex, colKey, thisValue, preValue;
                if ($('[data-ax5grid-column-focused="true"]')[0].innerHTML.indexOf('input') > -1) {
                    this_ = self_.fnObj[Object.keys(self_.fnObj)[i]].target;
                    selectIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                    colIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                    colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                    preValue = this_.list[selectIndex][colKey];
                    thisValue = this_.inlineEditing[selectIndex + "_" + colIndex + "_" + "0"].$inlineEditor[0].value;
                    this_.setValue(selectIndex, colKey, thisValue);
                    ax5.ui.grid.body.inlineEdit.deActive.call(this_, "ESC", selectIndex + "_" + colIndex + "_" + "0");
                } else {
                    this_ = self_.fnObj[Object.keys(self_.fnObj)[i]].target;
                    selectIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-data-o-index'));
                    colIndex = (nvl($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) == '') ? Number($(".ax-body").parents('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex')) : Number($(".ax-body").find('[data-ax5grid-column-focused="true"]').attr('data-ax5grid-column-colindex'));
                    colKey = $('[data-ax5grid-column-focused="true"]').parents('[data-ax5grid]').find('[data-ax5grid-column-colindex=' + colIndex + ']').attr('data-ax5grid-column-key');
                    preValue = this_.list[selectIndex][colKey];
                    thisValue = this_.list[selectIndex][colKey];
                    this_.setValue(selectIndex, colKey, thisValue);
                }


                if (e.keyCode == '9') {
                    if (this_.colGroup[colIndex + 1] != null) {
                        if (this_.colGroup[colIndex + 1].editor != null && this_.colGroup[colIndex + 1].editor["type"] != "select") {
                            this_.focus("RIGHT");
                        }
                    }
                } else if (e.keyCode == '13') {
                    if (this_.colGroup[colIndex + 1] != null) {
                        if (this_.colGroup[colIndex + 1].editor == null || this_.colGroup[colIndex + 1].editor["type"] == "text" || this_.colGroup[colIndex + 1].editor == false || this_.colGroup[colIndex + 1].editor["type"] == "number") {
                            this_.focus("RIGHT");
                        }
                    }
                }
                if (thisValue != preValue) {

                    if (nvl(this_.colGroup[colIndex].picker) == '') {
                        return;
                    }

                    var picker = (typeof (this_.colGroup[colIndex].picker) == 'function') ? this_.colGroup[colIndex].picker() : this_.colGroup[colIndex].picker;


                    var url = picker.url;
                    var callback = "fnObj." + Object.keys(self_.fnObj)[i] + ".target.colGroup[" + colIndex + "].picker.callback";
                    var action = picker.action;
                    var param = (nvl(picker.param) == '') ? '' : nvl(picker.param.call({
                        list: this_.list,
                        dindex: selectIndex,
                        item: this_.list[selectIndex],
                        key: colKey,
                        value: this_.list[selectIndex][colKey]
                    }));
                    var width = nvl(picker.width, 600);
                    var height = nvl(picker.height, 600);
                    var top = nvl(picker.top, 25);
                    var disabled;
                    if (nvl(picker['disabled']) != '') {
                        disabled = picker.disabled.call({
                            list: this_.list,
                            dindex: selectIndex,
                            item: this_.list[selectIndex],
                            key: colKey,
                            value: this_.list[selectIndex][colKey]
                        }, this_.list[selectIndex]);

                        //disabled = picker.disabled(this_.list[selectIndex]);
                    } else {
                        disabled = false;
                    }

                    if (thisValue == '') {
                        this_.setValue(selectIndex, colKey, thisValue);
                        this_.focus("RIGHT");
                        return;
                    }

                    if (!disabled) {
                        CommonCallback = function (e) {
                            if (e.length > 0) {
                                picker.callback.call({
                                    list: this_.list,
                                    dindex: selectIndex,
                                    item: this_.list[selectIndex],
                                    key: colKey,
                                    value: this_.list[selectIndex][colKey]
                                }, e);
                            } else {  //  취소한 건
                                if (thisValue == '') {
                                    this_.setValue(selectIndex, colKey, thisValue);
                                } else {
                                    this_.setValue(selectIndex, colKey, preValue);
                                }
                            }
                            parent.modal.close();
                        };

                        var parameter = {};
                        if (param != '') {
                            for (var z = 0; z < Object.keys(param).length; z++) {
                                var obj = {};
                                obj["USERDEF" + Number(z + 2)] = param[Object.keys(param)[z]];
                                parameter = $.extend(parameter, obj);
                            }
                        }
                        parameter = $.extend(parameter, {ID_ACTION: action[1], USERDEF1: thisValue});
                        var result = $.DATA_SEARCH('common', "HELP_CHECK_SEARCH", parameter);
                        if (result.list.length == 1) {
                            picker.callback.call({
                                list: this_.list,
                                dindex: selectIndex,
                                item: this_.list[selectIndex],
                                key: colKey,
                                value: this_.list[selectIndex][colKey]
                            }, result.list);
                            return false;
                        }

                        if (action[0] == 'commonHelp') {
                            if (param == '') {
                                $.openCommonPopup(url, "CommonCallback", action[1], thisValue, null, width, height, top);
                            } else {
                                $.openCommonPopup(url, "CommonCallback", action[1], thisValue, param, width, height, top);
                            }
                        } else if (action[0] == 'customHelp') {
                            if (param == '') {
                                $.openCustomPopup(url, "CommonCallback", action[1], null, thisValue, width, height, top);
                            } else {
                                $.openCustomPopup(url, "CommonCallback", action[1], param, thisValue, width, height, top);
                            }
                        } else {
                            throw "ACTION 명 불일치, 확인필요";
                        }
                    }
                }
            }
        }
    }
});

document.onkeydown = function () {
    var backspace = 8;
    var t = document.activeElement;
    if (event.keyCode == backspace) {
        if (t.tagName == "SELECT") return false;
        //if (t.tagName == "INPUT" && t.getAttribute("readonly") == true) return false;
        if (t.tagName == "INPUT" && t.value == "") return false;
    }
};

var GET_NO = function(MODULE_CD, CLASS_CD){
    var no = '';
    axboot.ajax({
        type: "POST",
        url: ['commonutility','GETNO'],
        data: JSON.stringify({COMPANY_CD : SCRIPT_SESSION.cdCompany, MODULE_CD : MODULE_CD, CLASS_CD : CLASS_CD}),
        async: false,
        callback: function (res) {
            no =  res.map.RE_NO
        },
        options: {
            onError: function (err) {
                qray.alert(err.message)
            }
        }
    });
    return no
};

var getLoginPartner = function(){
    var pt_cd = [];
    axboot.ajax({
        type: "POST",
        url: ['commonutility','getLoginPartner'],
        data: JSON.stringify({COMPANY_CD : SCRIPT_SESSION.cdCompany}),
        async: false,
        callback: function (res) {
        	if (nvl(res) != ''){
        		if (nvl(res.list) != ''){
        			if (res.list.length > 0){
		           		pt_cd =  res.list;
		            }
	            }
            }
        },
        options: {
            onError: function (err) {
                qray.alert(err.message)
            }
        }
    });
    return pt_cd
};

$.extend({
    DATA_SEARCH_GET: function (Url, Url2, paramData, grid) {
        var result;
        axboot.ajax({
            type: "GET",
            url: [Url, Url2],
            data: paramData,
            async: false,
            callback: function (res) {
                if (nvl(res) != '') {
                    if (nvl(res.list) != '') {
                        if (grid) {
                            grid.setData(res);
                            grid.target.select(0);
                        }
                    }
                }
                result = res;
            }
        });
        return result;
    },

    /**
     * 조회용
     * @PARAM : URL , URL2 , PARAMDATA
     * @설명 : 별칭 , 맵핑URL , 조회조건
     * */
    DATA_SEARCH: function (Url, Url2, paramData, grid) {
        // console.log(" [ *** DATA_SEARCH - URL PARAM  :  ", Url, Url2, " *** ] ")
        // console.log(" [ *** DATA_SEARCH - DATA PARAM :  ", paramData, " *** ] ")
        var list = [];
        axboot.ajax({
            type: "POST",
            url: [Url, Url2],
            data: JSON.stringify(nvl(paramData,{})),
            async: false,
            callback: function (res) {
                // console.log(" [ DATA_SEARCH - RETURN DATA :  ", res, " ] ")
                if (grid) {
                    grid.setData(res);
                    // grid.target.select(0);
                }
                list = res;
            },
            options: {
                onError: function (err) {
                    qray.alert(err.message)
                }
            }
        });
        return list;
    },
    /**
     * 저장용
     * @PARAM : URL , URL2 , PARAMDATA
     * @설명 : 별칭 , 맵핑URL , 데이터
     * */
    DATA_SAVE: function (Url, Url2, paramData) {
        // console.log(" [ *** DATA_SAVE - URL PARAM  :  ", Url, Url2, " *** ] ")
        // console.log(" [ *** DATA_SAVE - DATA PARAM :  ", paramData, " *** ] ")
        var list = [];
        axboot.ajax({
            type: "POST",
            url: [Url, Url2],
            data: JSON.stringify(paramData),
            async: false,
            callback: function (res) {
                // console.log(" [ DATA_SEARCH - RETURN DATA :  ", res, " ] ")
                list = res;
            }
        });
        return list;
    },
    /**
     * 공통코드 조회용
     * @PARAM : CD_COMPANY , CD_FIELD , ALL , FLAG
     * @설명 : 회사코드 , 필드코드 , 전체사용유무 , 참조값
     * */
    SELECT_COMMON_CODE: function (CD_COMPANY, CD_FIELD, ALL, FLAG1, FLAG2, FLAG3, CD_SYSDEF_ARRAY) {
        var codeInfo = [];
        axboot.ajax({
            type: "POST",
            url: ["commonutility", "getCodeDataList"],
            data: JSON.stringify({CD_COMPANY: CD_COMPANY, CD_FIELD: CD_FIELD}),
            async: false,
            callback: function (res) {
                if (res.list.length == 0) {
                    return false;
                }
                if (nvl(ALL, '') == '' || ALL == false || ALL == 'false' || ALL == 'FALSE') {  //  ALL 파라메터가 없거나 false이면 전체가 추가된다.
                    codeInfo.push({
                        CODE: '', VALUE: '', code: '', value: '', text: '', TEXT: ''
                    });
                }
                // console.log(" [ SELECT_COMMON_CODE - DATA :  ", res, " ] ")
                res.list.forEach(function (n) {
                        if (nvl(FLAG1, '') != '' || nvl(FLAG2, '') != '' || nvl(FLAG3, '') != '') {
                            if ((nvl(n.CD_FLAG1) != '' && n.CD_FLAG1 == FLAG1) ||
                                (nvl(n.CD_FLAG2) != '' && n.CD_FLAG2 == FLAG2) ||
                                (nvl(n.CD_FLAG3) != '' && n.CD_FLAG3 == FLAG3)) {

                                if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                    for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                        if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                            codeInfo.push({
                                                CODE: n.CD_SYSDEF,
                                                code: n.CD_SYSDEF,
                                                value: n.CD_SYSDEF,
                                                VALUE: n.CD_SYSDEF,
                                                text: n.NM_SYSDEF,
                                                TEXT: n.NM_SYSDEF,
                                                CD_FLAG1: n.CD_FLAG1,
                                                CD_FLAG2: n.CD_FLAG2,
                                                CD_FLAG3: n.CD_FLAG3
                                            });
                                        }
                                    }
                                } else {
                                    codeInfo.push({
                                        CODE: n.CD_SYSDEF,
                                        code: n.CD_SYSDEF,
                                        value: n.CD_SYSDEF,
                                        VALUE: n.CD_SYSDEF,
                                        text: n.NM_SYSDEF,
                                        TEXT: n.NM_SYSDEF,
                                        CD_FLAG1: n.CD_FLAG1,
                                        CD_FLAG2: n.CD_FLAG2,
                                        CD_FLAG3: n.CD_FLAG3
                                    });
                                }
                            }
                        } else {
                            if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                    if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                        codeInfo.push({
                                            CODE: n.CD_SYSDEF,
                                            code: n.CD_SYSDEF,
                                            value: n.CD_SYSDEF,
                                            VALUE: n.CD_SYSDEF,
                                            text: n.NM_SYSDEF,
                                            TEXT: n.NM_SYSDEF,
                                            CD_FLAG1: n.CD_FLAG1,
                                            CD_FLAG2: n.CD_FLAG2,
                                            CD_FLAG3: n.CD_FLAG3
                                        });
                                    }
                                }
                            } else {
                                codeInfo.push({
                                    CODE: n.CD_SYSDEF,
                                    code: n.CD_SYSDEF,
                                    value: n.CD_SYSDEF,
                                    VALUE: n.CD_SYSDEF,
                                    text: n.NM_SYSDEF,
                                    TEXT: n.NM_SYSDEF,
                                    CD_FLAG1: n.CD_FLAG1,
                                    CD_FLAG2: n.CD_FLAG2,
                                    CD_FLAG3: n.CD_FLAG3
                                });
                            }
                        }
                    }
                );
                // console.log(" [ SELECT_COMMON_CODE - RETURN :  ", codeInfo, " ] ")
            }

        });
        return codeInfo;
    },
    changeTextValue: function (list, code) {
        var retrunVal;
        $(list).each(function (i, e) {

            if (this.value == code || this.code == code || this.VALUE == code || this.CODE == code) {
                retrunVal = this.text;
            }
        });
        return retrunVal;
    }
    ,
    changeDataFormat: function (value, type) {
        if (nvl(value, '') != '' && typeof value != "boolean") {
            value = value + "";
            if (value.indexOf('-') > -1 || value.indexOf(':') > -1) {
                return value;
            }
            if (nvl(type, '') == '' || type == 'YYYYMMDD') {
                return value.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            }
            if (type == 'res') { //  주민번호
                return value.replace(/(\d{6})(\d{7})/, '$1-$2')
            }
            if (type == 'company') { //  사업자번호
                return value.replace(/(\d{3})(\d{2})(\d{4})/, '$1-$2-$3')
            }
            if (type == 'time') {  //시간
                return value.replace(/(\d{2})(\d{2})(\d{2})/, '$1:$2:$3')
            }
            if (type == 'card') {  //카드번호
                return value.replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, '$1-$2-$3-$4')
            }
            if (type == 'yyyyMMddhhmmss') {
                return value.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6')
            }
            if (type == 'rt_exch'){
                if (nvl(value) == '' || value == '0') {
                    return 0.00;
                } else {
                    return value.replace(/[^-\.0-9]/g, '').toFixed(2);
                }
                return
            }
            if (type == 'tel') {
                if (value.length == 11) {
                    return value.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
                } else if (value.length == 8) {
                    return value.replace(/(\d{4})(\d{4})/, '$1-$2');
                } else {
                    if (value.indexOf('02') == 0) {
                        return value.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
                    } else {
                        return value.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                    }
                }
            }
            if (type == 'money'){
                return comma(value);
            }
            if(type == 'text'){
                return value
            }
        } else {
            return '';
        }
    },
    gridValidation: function (list, keyItem) {
        var flag = false;
        var column = "";
        list.forEach(function (item, index) {
            for (var key in keyItem) {
                if (nvl(item[key]).replace(/ /gi, "") == '' || item[key] == null) {
                    column = keyItem[key];
                    flag = true;
                }
            }
        });
        if (flag) {
            qray.alert(column + " 는(은) 필수 항목입니다.")
        }
        return flag;
    }
});

mask.setConfig({
    target: document.body, // 미리 선언했지만
    content: "<h1><i class='fa fa-spinner fa-spin'></i> Loading</h1>",
    onStateChanged: function () {
    }
});

$.extend({
    getCommonCodeList: function (Company, Code) {
        var param = "cdCompany=" + Company + "&cdField=" + Code;
        var codes;
        axboot.ajax({
            type: "GET",
            url: ["common", "getCodeList"],
            data: param,
            async: false,
            callback: function (res) {
                codes = res.listResponse.list;
            }
        });

        return codes;
    },

    getComboText: function (list, code) {
        var retrunVal;
        $(list).each(function (i, e) {

            if (this.CODE == code) {
                retrunVal = this.NAME;
            }
        });
        return retrunVal;
    },

    /******************************/
    /*  공통팝업API
    /*  name     : jsp페이지명
    /*  CallBack : 부모창의 CallBack 함수
    /*  KEYWORD  : 검색어
    /*  initData : 부모로부터 받는 PARAMETER   [   Object 형식으로 넣어줘야함. Array(x)     ]
    /*  width    : 넓이
    /*  height   : 높이
    /*  top      : 팝업위치
    /******************************/
    openCommonPopup: function (name, CallBack, ACTION, KEYWORD, initData, width, height, top) {

        if (!width) {
            width = 600;
        }
        if (!height) {
            height = 600;
        }

        modal.open({
            width: Number(width),
            height: Number(height),
            position: {
                left: "center",
                top: Number(nvl(top, 25))
            },
            iframe: {
                method: "get",
                url: "/jsp/ensys/help/" + name + "Helper.jsp",
                param: "callBack=" + CallBack + "&ACTION=" + ACTION
            },
            closeToEsc: true,
            sendData: function () {
                return {
                    "initData": initData,
                    KEYWORD: KEYWORD
                }
            },
            onStateChanged: function () {
                // mask
                if (this.state === "open") {
                    mask.open();
                } else if (this.state === "close") {
                    mask.close();
                }
            }
        }, function () {

        });
    }
    //도움창 파일명, 콜백메소드명, 맵핑 밸류, 넘겨줄데이터, 검색어, 가로 , 세로
    , openCustomPopup: function (name, CallBack, ACTION, initData, KEYWORD, width, height, top) {
        // console.log(" [ openCustomPopup - PARAM :  ", name, " | ", CallBack, " | ", ACTION, " | ", initData, " | ", KEYWORD, width, " | ", height, " ] ")
        if (!width) {
            width = 600;
        }
        if (!height) {
            height = 600;
        }
        modal.open({
            width: width,
            height: height,
            position: {
                left: "center",
                top: nvl(top, 25)
            },
            iframe: {
                method: "get",
                url: "/jsp/custom/" + name + "Helper.jsp",
                param: "callBack=" + CallBack + "&ACTION=" + ACTION
            },
            closeToEsc: false,
            sendData: function () {
                return {
                    "initData": initData,
                    KEYWORD: KEYWORD
                }
            },
            onStateChanged: function () {
                // mask
                if (this.state === "open") {
                    mask.open();
                } else if (this.state === "close") {
                    mask.close();
                }
            }
        }, function () {
        });

    }, openMuiltiPopup: function (name, userCallBack, map, width, height, top) {
        map.get("modal").open({
            width: nvl(width, 600),
            height: nvl(height, 600),
            position: {
                left: "center",
                top: nvl(top, 25)
            },
            closeToEsc: false,
            iframe: {
                method: "get",
                url: "/jsp/ensys/help/" + name + "Helper.jsp",
                param: "modalName=" + map.get("modalText") + "&viewName=" + map.get("viewName") + "&callBack=" + userCallBack + "&ACTION=" + map.get("action")
            },
            sendData: function () {
                return {
                    "initData": map.get("initData"),
                    KEYWORD: map.get("keyword")
                }
            }
        }, function () {

        });
    },
    openCommonUtils: function (userCallBack, map, mode, width, height, top) {
        //var width, height, top;
        var html = "";
        if (map.get("viewName")) {
            html = "&viewName=" + map.get("viewName")
        }
        if (mode == 'fileBrowser') {
            width = nvl(width, 1000);
            height = nvl(height, 600);
            top = nvl(top, 25);
        } else if (mode == 'calender') {
            width = nvl(width, 340);
            height = nvl(height, 450);
            top = nvl(top, 130);
        } else if (mode == 'periodCalender') {
            width = nvl(width, 680);
            height = nvl(height, 450);
            top = nvl(top, 130);
        } else {
            width = nvl(width, 600);
            height = nvl(height, 600);
            top = nvl(top, 25);
        }
        map.get("modal").open({
            width: Number(width),
            height: Number(height),
            position: {
                left: "center",
                top: Number(top)
            },
            closeToEsc: false,
            iframe: {
                method: "get",
                url: "/jsp/common/" + mode + ".jsp",
                param: "modalName=" + map.get("modalText") + html + "&callBack=" + userCallBack
            },
            sendData: map.get("initData"),
            onStateChanged: function () {
                // mask
                if (this.state === "open") {
                    mask.open({
                        content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
                    });
                } else if (this.state === "close") {
                    mask.close();
                }
            }
        }, function () {

        });
    },
    /******************************
     *  공통파일팝업API
     *  CallBack : 부모창의 CallBack 함수
     *  initData : 부모로부터 받는 PARAMETER   [   Object 형식으로 넣어줘야함. Array(x)     ]
     *       1. P_BOARD_TYPE
     *       2. P_SEQ
     ******************************/
    openFileBrowser: function (CallBack, initData, modal) {
        modal.open({
            width: 1000,
            height: 600,
            position: {
                left: "center",
                top: 25
            },
            iframe: {
                method: "get",
                url: "/jsp/common/fileBrowser.jsp",
                param: "callBack=" + CallBack
            },
            closeToEsc: false,
            sendData: initData,
            onStateChanged: function () {
                // mask
                if (this.state === "open") {
                    mask.open();
                } else if (this.state === "close") {
                    mask.close();
                }
            }
        }, function () {

        });
    }

});

var isNull = function (value) {
    var _chkStr = value + "";
    if (_chkStr == "" || _chkStr == null || _chkStr == "null") {
        return true;
    }
    return false;
};

var isUndefined = function (value) {
    if (typeof (value) == "undefined" || typeof (value) == undefined || value == "undefined" || value == undefined) {
        return true;
    }
    return false;
};

var nvl = function (A, B) {
    var type;
    var temp;
    if( typeof A == 'string'){
        temp = A.trim();
        type = 'string';
    }else if (typeof A == 'number'){
        temp = A.toString();
        type = 'number';
    }else{
        temp = A;
    }
    if (!isNull(temp) && !isUndefined(temp)) {

        if (type == 'number'){
            A = Number(A);
        }
        return A;
    } else {
        if (isUndefined(B) || isNull(B)) {
            B = "";
        }
        return B;
    }
};

var today = new Date(), dd = today.getDate().toString(), dd = dd < 10 ? "0" + dd : dd, mm = (today.getMonth() + 1), mm = mm < 10 ? "0" + mm : mm, yyyy = today.getFullYear().toString();
var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"}), dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
var nowDate = ax5.util.date(today, {"return": "yyyy-MM-dd"});

// object를 키 이름으로 정렬하여 반환
function sortObject(o) {
    var sorted = {},
        key, a = [];


    // 키이름을 추출하여 배열에 집어넣음
    for (key in o) {
        if (o.hasOwnProperty(key)) a.push(key);
    }

    // 키이름 배열을 정렬
    a.sort();

    // 정렬된 키이름 배열을 이용하여 object 재구성
    for (key=0; key<a.length; key++) {
        sorted[a[key]] = o[a[key]];
    }
    return sorted;
}

$.fn.datePicker = function(){
    var id = this[0].id;
    new ax5.ui.picker().bind({
        target: $('[data-ax5picker="' + id + '"]'),
        direction: "auto",
        content: {
            width: 270,
            margin: 10,
            type: 'date',
            config: {
                control: {
                    left: '<i class="cqc-chevron-left"></i>',
                    yearTmpl: '%s',
                    monthTmpl: '%s',
                    right: '<i class="cqc-chevron-right"></i>'
                },
                lang: {
                    yearTmpl: "%s년",
                    months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
                    dayTmpl: "%s"
                }
            }
        },
        onStateChanged: function () {

        },
        btns: {
            today: {
                label: "오늘", onClick: function () {

                    $("#" + id).val(nowDate);
                    this.self.close();
                }
            },
            ok: {label: "확인", theme: "default"}
        }
    });
};

function comma(num) {
    if (nvl(num) == '') return num;
    num = num.toString().replace(/,/g, "");

    var len, point, str;
    if (num.substring(0, 1) == "-") {
        num = num.replace("-", "");
        num = num + "";
        point = num.length % 3;
        len = num.length;

        str = num.substring(0, point);
        while (point < len) {
            if (str != "") str += ",";
            str += num.substring(point, point + 3);
            point += 3;
        }
        return "-" + str;
    } else {
        point = num.length % 3;
        len = num.length;

        str = num.substring(0, point);
        while (point < len) {
            if (str != "") str += ",";
            str += num.substring(point, point + 3);
            point += 3;
        }
        return str;
    }
}

function uncomma(str) {
    if (nvl(str) == '') return 0;
    str = str.toString().replace(/,/g, "");

    return Number(str);
}

var qray = {
    textStyle: null,
    buttonStyle: null,
    boxStyle: null,
    style: null,
    loading: {
        show: function (message, top, width, height) {
            return new Promise(function (resolve, reject) {
                var messageHtml = "<div class=\"layer_wrap\">\n" +
                    "            <div class=\"layer_alert\" style='height:150px;'>\n" +
                    "<div style='margin-top: 20px;'><img id=\"qray_loading-image\" src=\"/assets/css/images/common/loadingSpinner.gif\"/><h3 style='margin-top: 20px;margin-left:10px;margin-right:10px;'>" + nvl(message, '데이터를 조회중입니다.') + "</h3></div>" +
                    "            </div>\n" +
                    "        </div>";

                $("body").append(messageHtml);

                setTimeout(function () {
                    resolve();
                }, 100);
            });
        },
        hide: function () {
            $(".layer_wrap").remove();
        },
    },
    alert: function (message, width, height, top, left) {

        if ($('.layer_wrap').length == 0) {
            return new Promise(function (resolve, reject) {
                var messageHtml = "<div class=\"layer_wrap\">\n" +
                    "            <div style='" + this.boxStyle + " width: " + width + "; height: " + height + " top: " + top + " left: " + left + "' class=\"layer_alert\">\n" +
                    "<div class='layer_alertBar'>알림</div>" +
                    "                <p style='margin-top:25px;'>" + message + "</p>\n" +
                    "                <div style='" + this.buttonStyle + "' class=\"layer_btn\"><button type=\"button\" class=\"ok\">확인</button></div>\n" +
                    "            </div>\n" +
                    "        </div>";

                $("body").append(messageHtml);

                $(".ok").click(function () {
                    $(".layer_wrap").remove();
                    resolve();
                })
            })
        } else {
            return new Promise(function (resolve, reject) {
                var f = setInterval(function () {

                    if ($('.layer_wrap').length == 0) {
                        var messageHtml = "<div class=\"layer_wrap\">\n" +
                            "<div style='" + this.boxStyle + " width: " + width + "; height: " + height + " top: " + top + " left: " + left + "' class=\"layer_alert\">\n" +
                            "<div class='layer_alertBar'>알림</div>" +
                            "                <p style='margin-top:25px;'>" + message + "</p>\n" +
                            "                <div style='" + this.buttonStyle + "' class=\"layer_btn\"><button type=\"button\" class=\"ok\">확인</button></div>\n" +
                            "            </div>\n" +
                            "        </div>";

                        $("body").append(messageHtml);
                        $(".ok").click(function () {
                            $(".layer_wrap").remove();
                            resolve();
                        });
                        clearInterval(f);
                    }
                }, 100)
            })
        }
    },
    setStyle: function (v) {
        if (typeof (v) == 'object') {
            var style = "";
            for (var i = 0; i < Object.keys(v).length; i++) {
                style += eval("Object.keys(v)[i]") + ":" + eval("v[Object.keys(v)[i]];");
            }
            this.style = style;
            return this;
        }
        return this;
    },
    setBoxStyle: function (v) {
        if (typeof (v) == 'object') {
            var style = "";
            for (var i = 0; i < Object.keys(v).length; i++) {
                style += eval("Object.keys(v)[i]") + ":" + eval("v[Object.keys(v)[i]]") + ";";
            }
            this.boxStyle = style;
            return this;
        }
        return this;
    },
    setTextAreaStyle: function (v) {
        if (typeof (v) == 'object') {
            var style = "";
            for (var i = 0; i < Object.keys(v).length; i++) {
                style += eval("Object.keys(v)[i]") + ":" + eval("v[Object.keys(v)[i]]") + ";";
            }
            this.textStyle = style;
            return this;
        }
        return this;
    },
    setButtonAreaStyle: function (v) {
        if (typeof (v) == 'object') {
            var style = "";
            for (var i = 0; i < Object.keys(v).length; i++) {
                style += eval("Object.keys(v)[i]") + ":" + eval("v[Object.keys(v)[i]]") + ";";
            }
            this.buttonStyle = style;
            return this;
        }
        return this;
    },
    confirm: function (init, fn) {
        var message, btnHtml = "", _this = this;
        if (nvl(init) != '') {
            if (nvl(init.msg) != '') {
                message = init.msg;
            }
            if (nvl(init.btns) != '') {
                var obj = {};
                for (var i = 0; i < Object.keys(init.btns).length; i++) {
                    var btnKey = Object.keys(init.btns)[i];
                    var btnStyle = nvl(init.btns[Object.keys(init.btns)[i]].style, {});
                    var styleHtml = "";
                    for (var s = 0; s < Object.keys(btnStyle).length; s++) {
                        styleHtml += Object.keys(btnStyle)[s] + ":" + btnStyle[Object.keys(btnStyle)[s]] + ";";
                    }
                    var btnLabel = nvl(init.btns[Object.keys(init.btns)[i]].label, '');
                    var btnEvent = nvl(init.btns[Object.keys(init.btns)[i]].onClick, new function () {
                    });
                    btnHtml += "<button type='button' style='" + styleHtml + "' class='cancel' id='" + Object.keys(init.btns)[i] + "'><span>" + btnLabel + "</span></button>";

                    obj[btnKey] = btnEvent;
                }

                var messageHtml = "<div class=\"layer_wrap\">\n" +
                    "            <div  style='" + this.boxStyle + "' class=\"layer_alert\">\n" +
                    "<div class='layer_alertBar'>알림</div>" +
                    "                <p  style='margin-top:25px; " + this.textStyle + "'>" + message + "</p>\n" +
                    "                <div  style='" + this.buttonStyle + "' class=\"layer_btn\">" + btnHtml + "</div>\n" +
                    "            </div>\n" +
                    "        </div>";
                $("body").append(messageHtml);

                for (var i = 0; i < Object.keys(obj).length; i++) {
                    document.getElementById(Object.keys(obj)[i]).onclick = obj[Object.keys(obj)[i]];
                }
            } else {
                var messageHtml = "<div class=\"layer_wrap\">\n" +
                    "            <div class=\"layer_alert\">\n" +
                    "<div class='layer_alertBar'>알림</div>" +
                    "                <p style='margin-top:25px;'>" + message + "</p>\n" +
                    "                <div class=\"layer_btn\">" +
                    "<button type=\"button\" id='ok' class=\"ok\">확인</button>" +
                    "<button type=\"button\" id='cancel' class=\"cancel\">취소</button>" +
                    "                </div>\n" +
                    "            </div>\n" +
                    "        </div>";

                $("body").append(messageHtml);

                $(".cancel").click(function () {
                    $(".layer_wrap").remove();
                    var callback = {};
                    callback.key = 'cancel';
                    fn.call(callback);
                });

                $(".ok").click(function () {
                    $(".layer_wrap").remove();
                    var callback = {};
                    callback.key = 'ok';
                    fn.call(callback);

                })
            }
        }
    },
    close: function () {
        if (nvl($('.layer_wrap')) != '') {
            $('.layer_wrap').remove();
        }
    }
};
var message2 = function (message, theme) {
    /*modal.open(
        {
            width: 300,
            height: 150,
            position: {
                left: "center",
                top: 300
            },
            closeToEsc: false
            , onStateChanged: function () {
                // mask
                if (this.state === "open") {
                    mask.open();
                } else if (this.state === "close") {
                    mask.close();
                }
            }
        }, function () {
            var html = jQuery("<div class=\"layer_wrap\">\n" +
                "            <div class=\"layer_alert\">\n" +
                "                <p>전표유형이 편익일때는 편익제공 내용을 입력해주셔야 합니다.</p>\n" +
                "                <div class=\"layer_btn\"><button type=\"button\" class=\"cancel\">취소</button><button type=\"button\" class=\"ok\">확인</button></div>\n" +
                "            </div>\n" +
                "        </div>");
            // var html = jQuery("<div style='margin-top: 20px;'><img id=\"qray_loading-image\" src=\"/assets/css/images/common/loadingSpinner.gif\"/><h3 style='margin-top: 20px;margin-left:10px;margin-right:10px;'>" + nvl(message, '데이터를 조회중입니다.') + "</h3></div>");
            this.$["body-frame"].append(html);
        });*/

    messageDialog.alert({
        title: "알림",
        msg: message,
        onStateChanged: function () {
            if (this.state === "open") {
                // $(".ax-mask").css("display","none");
                // $(".ax-mask").css("opacity","0");
                // $(".ax-mask").css("visible",false);
                // mask.open();
                $("#waitdiv").css("display", "");
                $("#waitdiv").css("opacity", "0.3");
                $("#waitdiv").css("width", "100%");
                $("#waitdiv").css("height", "100%");
            } else if (this.state === "close") {
                // mask.close();
                $("#waitdiv").css("display", "none");
                $("#waitdiv").css("opacity", "0");
                $("#waitdiv").css("width", "1px");
                $("#waitdiv").css("height", "1px");
                $("#waitdiv").css("visible", false);
            }
        }
    });
};


var Qcss = function () {
    if ($('[data-ax5grid-scroller=vertical-bar]').length > 0) {
        $('[data-ax5grid-scroller=vertical]').css('width', '20px');
        $('[data-ax5grid-scroller=vertical-bar]').css('width', '15px')
    }
    if ($('[data-ax5grid-scroller=horizontal-bar]').length > 0) {
        $('[data-ax5grid-scroller=horizontal]').css('height', '20px');
        $('[data-ax5grid-scroller=horizontal-bar]').css('height', '15px')
    }
};

$(document).ready(function () {

    if ($('button').length > 0) {
        $('button')[0].focus();
    }


    var target = $("filemodal");
    if (target.length > 0) {
        var self;
        var filemodal;
        var Front = '<div class=\"input-group\" id ="filemodal">';
        var Back = '<input type="text" class="form-control"/><span class=\"input-group-addon"\><i class=\"cqc-magnifier"\ id="filemodalBtn" style=\"cursor: pointer"\></i></span></div>';
        target.wrap(Front);
        target.after(Back);

        for (var i = 0; i < target.length; i++) {
            var input = target[i].nextElementSibling;
            var readonlyYN = target[i].getAttribute('READONLY');
            var seq = target[i].getAttribute('SEQ');
            var board_type = target[i].getAttribute('BOARD_TYPE');
            var WIDTH = target[i].getAttribute('WIDTH');
            var HEIGHT = target[i].getAttribute('HEIGHT');
            var STYLE = target[i].getAttribute('STYLE');
            target[i].nextElementSibling.setAttribute('SEQ', seq);
            target[i].nextElementSibling.setAttribute('BOARD_TYPE', board_type);
            target[i].nextElementSibling.setAttribute('id', target[i].id);
            target[i].removeAttribute('id');
            var Inputid = input.getAttribute('id');
            if (readonlyYN != null) {
                target[i].nextElementSibling.setAttribute('readonly', "readonly");
            }
            if (STYLE != null) {
                target[i].nextElementSibling.setAttribute('style', STYLE);
            }
            if (WIDTH != null) {
                target[i].nextElementSibling.setAttribute('style', "width:" + WIDTH + ";");
            }
            if (HEIGHT != null) {
                if (nvl(input.getAttribute('style')) == '') {
                    target[i].nextElementSibling.setAttribute('style', "height:" + HEIGHT + ";");
                } else {
                    var style = input.getAttribute('style');
                    target[i].nextElementSibling.setAttribute('style', style + "height:" + HEIGHT + ";");
                }

            }

        }


        $.fn.setSeq = function (seq) {
            this[0].setAttribute('SEQ', seq);
        };
        $.fn.setBoardType = function (BOARD_TYPE) {
            this[0].setAttribute('BOARD_TYPE', BOARD_TYPE);
        };
        $.fn.clear = function () {
            this[0].removeAttribute('delete');
            this[0].removeAttribute('gridData');
            this[0].value = '';
        };

        $.fn.saveData = function (e) {
            window["imsiFile"] = {};
            window["imsiFile"] = {
                delete: JSON.parse(this[0].getAttribute('delete')),
                gridData: JSON.parse(this[0].getAttribute('gridData')),
            };
            if (nvl(JSON.parse(this[0].getAttribute('gridData'))) != '' || nvl(JSON.parse(this[0].getAttribute('delete'))) != '') {
                return window["imsiFile"];
            } else {
                return null;
            }
        };

        $.fn.read = function () {
            var _self = $(this)[0];
            var board_type = _self.getAttribute('BOARD_TYPE');
            var seq = _self.getAttribute('SEQ');

            axboot.ajax({
                type: "POST",
                url: ["commonutility", "BbsFileSearch"],
                data: JSON.stringify({
                    "BOARD_TYPE": board_type,
                    "SEQ": seq
                }),
                callback: function (res) {
                    var html = "";
                    var chkVal;
                    for (var i = 0; i < res.list.length; i++) {
                        var list = res.list[i];
                        if (i == 0) {
                            html += list.ORGN_FILE_NAME
                        } else {
                            chkVal = true;
                            break;
                        }
                    }
                    if (chkVal) {
                        html += ".. 외 " + (res.list.length - 1) + "개";
                    }
                    _self.value = html;
                }
            });
            return false;
        };


        $("#filemodal .cqc-magnifier").click(function () {
            filemodal = this.parentNode.previousSibling.previousSibling;
            self = this.parentNode.previousElementSibling;
            var mode = filemodal.getAttribute('MODE');
            var board_type = nvl(self.getAttribute('BOARD_TYPE'), filemodal.getAttribute('BOARD_TYPE'));
            var seq = nvl(self.getAttribute('SEQ'), filemodal.getAttribute('SEQ'));
            var width = nvl(self.getAttribute('WIDTH'), filemodal.getAttribute('WIDTH'));
            var height = nvl(self.getAttribute('HEIGHT'), filemodal.getAttribute('HEIGHT'));
            var top = nvl(self.getAttribute('TOP'), filemodal.getAttribute('TOP'));
            var disabled = nvl(self.getAttribute('DISABLED'), filemodal.getAttribute('DISABLED'));

            if (mode != null) {
                if (mode == '1') {
                    window["FileBrowserModal"] = new ax5.ui.modal();
                    window["FileCallBack"] = function (e) {
                        qray.alert('임시저장하였습니다.');

                        var html = "";
                        var chkVal;
                        for (var i = 0; i < e.gridData.length; i++) {
                            var list = e.gridData[i];
                            if (i == 0) {
                                html += list.ORGN_FILE_NAME
                            } else {
                                chkVal = true;
                                break;
                            }
                        }
                        if (chkVal) {
                            html += ".. 외 " + (e.gridData.length - 1) + "개";
                        }
                        self.value = html;
                        self.setAttribute('gridData', JSON.stringify(e.gridData));
                        self.setAttribute('delete', JSON.stringify(e.delete));

                        FileBrowserModal.close();
                    };

                    window["openFileModal"] = function (callBack, initData) {
                        var map = new Map();
                        map.set("modal", FileBrowserModal);
                        map.set("modalText", "FileBrowserModal");
                        map.set("initData", initData);

                        $.openCommonUtils(callBack, map, 'fileBrowser', width, height, top);
                    };

                    var CallBack = 'FileCallBack';
                    if (nvl(self.getAttribute('gridData')) != '' || nvl(self.getAttribute('delete')) != '') {
                        var data = {
                            "P_BOARD_TYPE": board_type, // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": seq,
                            "imsiFile": {
                                gridData: JSON.parse(self.getAttribute('gridData')),
                                delete: JSON.parse(self.getAttribute('delete'))
                            },
                            "disabled": disabled
                        }
                    } else {
                        var data = {
                            "P_BOARD_TYPE": board_type, // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": seq,
                            "disabled": disabled
                        }
                    }

                    window.openFileModal(CallBack, data);
                }
                if (mode == '2') {

                    window["FileCallBack"] = function (e) {
                        qray.alert('임시저장하였습니다.');


                        var html = "";
                        var chkVal;
                        for (var i = 0; i < e.gridData.length; i++) {
                            var list = e.gridData[i];
                            if (i == 0) {
                                html += list.ORGN_FILE_NAME
                            } else {
                                chkVal = true;
                                break;
                            }
                        }
                        if (chkVal) {
                            html += ".. 외 " + (e.gridData.length - 1) + "개";
                        }
                        self.value = html;
                        self.setAttribute('gridData', JSON.stringify(e.gridData));
                        self.setAttribute('delete', JSON.stringify(e.delete));

                        parent.FileBrowserModal.close();
                    };

                    parent["openFileModal"] = function (callBack, viewName, initData) {
                        var map = new Map();
                        map.set("modal", parent.FileBrowserModal);
                        map.set("modalText", "FileBrowserModal");
                        map.set("viewName", viewName);
                        map.set("initData", initData);

                        $.openCommonUtils(callBack, map, 'fileBrowser');
                    };

                    var CallBack = 'FileCallBack';
                    if (nvl(self.getAttribute('gridData')) != '' || nvl(self.getAttribute('delete')) != '') {
                        var data = {
                            "P_BOARD_TYPE": board_type, // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": seq,
                            "imsiFile": {
                                gridData: JSON.parse(self.getAttribute('gridData')),
                                delete: JSON.parse(self.getAttribute('delete'))
                            },
                            "disabled": disabled
                        }
                    } else {
                        var data = {
                            "P_BOARD_TYPE": board_type, // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": seq,
                            "disabled": disabled
                        }
                    }
                    parent.openFileModal(CallBack, thisName, data);
                }
            }
        })

    }

    var target = $("codepicker");
    if (target.length > 0) {
        var self;
        var codepicker;
        var Front = '<div class=\"input-group\" id ="codepicker">'
            + '<input type="text" class="form-control"/><span class=\"input-group-addon"\><i class=\"cqc-magnifier"\ style=\"cursor: pointer"\></i></span></div>';
        target.append(Front);

        for (var i = 0; i < target.length; i++) {
            var codepicker = target[i];
            var input = $(codepicker).find('input');
            var input_group = $(codepicker).find('.input-group');
            var sessionYN = codepicker.getAttribute('SESSION');
            var HELP_DISABLED = codepicker.getAttribute('HELP_DISABLED') + "";
            var column = codepicker.getAttribute('HELP_URL');
            if (nvl(column, '') != '') {    //  HELP_URL [ jsp 파일명이 session 값 가져오는 역할을 합니다. ] // SESSION="nmDept" 이런 식으로 바꾸고싶은데 못바꾸겠음..
                column = column.replace(/^./, column[0].toUpperCase());
            }
            var input_style = codepicker.getAttribute('input-style');
            if (nvl(input_style) != ''){
                input.attr('style', nvl(input_style));
                input.removeClass('form-control');
                input.addClass('form-control_02');
            }
            var input_group_style = codepicker.getAttribute('input-group-style');
            input_group.attr('style', nvl(input_group_style));

            for (var j = 0; j < codepicker.attributes.length; j++) {
                input[0].setAttribute(codepicker.attributes[j].name, codepicker.attributes[j].value);
            }
            for (var j = 0; j < codepicker.attributes.length; j++) {
                codepicker.removeAttribute(codepicker.attributes[j].name);
            }


            if (sessionYN != null) {
                var TEXT, CODE;
                if (SCRIPT_SESSION["nm" + column]) {
                    TEXT = SCRIPT_SESSION["nm" + column];
                }
                if (SCRIPT_SESSION["ln" + column]) {
                    TEXT = SCRIPT_SESSION["ln" + column]
                }
                if (SCRIPT_SESSION["cd" + column]) {
                    CODE = SCRIPT_SESSION["cd" + column];
                }
                if (SCRIPT_SESSION["no" + column]) {
                    CODE = SCRIPT_SESSION["no" + column]
                }
                if (SCRIPT_SESSION["id" + column]) {
                    CODE = SCRIPT_SESSION["id" + column]
                }
                input[0].value = nvl(TEXT);
                input[0].setAttribute('CODE', CODE);
                input[0].setAttribute('TEXT', TEXT);
            }
            if (nvl(HELP_DISABLED) != '' && (HELP_DISABLED == 'true' || HELP_DISABLED == true)) {
                input[0].setAttribute('readonly', "readonly");
            }
        }

        var myEvent;

        $.fn.setParam = function (e) {
            this.attr("HELP_PARAM", JSON.stringify(e))
        };

        $.fn.setDisabled = function (e) {
            this.attr("readonly", readonly);
            this.attr("HELP_DISABLED", 'true');
            this.attr('style', 'cursor: no-drop;background-color:#eeeeee;');
        };

        $("#codepicker .cqc-magnifier").click(function () {
            codepicker = this.parentNode.previousSibling.parentNode;
            self = this.parentNode.previousElementSibling;

            var url = self.getAttribute('HELP_URL');
            var action = self.getAttribute('HELP_ACTION');
            var disabled = self.getAttribute('HELP_DISABLED');
            var params = JSON.parse(self.getAttribute('HELP_PARAM'));
            var width = self.getAttribute('WIDTH');
            var height = self.getAttribute('HEIGHT');
            var top = self.getAttribute('TOP');

            if ((nvl(disabled) != '' && disabled == 'false') || nvl(disabled) == '') {
                CommonCallback = function (e) {
                    if (e.length > 0) {
                        var code = self.getAttribute("BIND-CODE");
                        var text = self.getAttribute("BIND-TEXT");
                        self.value = e[0][text];
                        self.setAttribute('CODE', e[0][code]);
                        self.setAttribute('TEXT', e[0][text]);

                        myEvent = new CustomEvent("dataBind", {'detail': e[0]});

                        $(self)[0].dispatchEvent(myEvent);
                    }
                };
                $.openCommonPopup(url, "CommonCallback", action, self.value, params, width, height, top);
            }
        });

        var cdkey;
        $("#codepicker input").keydown(function (e) {
            if (window.event)
                cdkey = window.event.keyCode; //IE
            else
                cdkey = e.which; //firefox


            if (cdkey == '13' || cdkey == '9') {
                var input = this;
                var url = $(input).attr("help_url");
                var action = $(input).attr("help_action");
                var bind_code = $(input).attr("bind-code");
                var bind_text = $(input).attr("bind-text");
                var bind_param = (nvl($(input).attr("help_param")) != '') ? JSON.parse($(input).attr("help_param")) : {};
                var disabled = $(input).attr('help_disabled');
                var width = $(input).attr('WIDTH');
                var height = $(input).attr('HEIGHT');
                var top = $(input).attr('TOP');

                if (nvl(disabled) != '' && (disabled == 'true' || disabled == true)) {
                    return;
                }
                var keyword = $(input).val();

                var parameter = {};
                for (var z = 0; z < Object.keys(bind_param).length; z++) {
                    var obj = {};
                    obj["USERDEF" + Number(z + 2)] = bind_param[Object.keys(bind_param)[z]];
                    parameter = $.extend(parameter, obj);
                }

                parameter = $.extend(parameter, {ID_ACTION: action, USERDEF1: keyword});
                var result = $.DATA_SEARCH('common', "HELP_CHECK_SEARCH", parameter);
                if (result.list.length == 1) {
                    $(input).attr({
                        "code": result.list[0][bind_code],
                        "text": result.list[0][bind_text]
                    });
                    $(input).val(result.list[0][bind_text]);

                    myEvent = new CustomEvent("dataBind", {'detail': result.list[0]});

                    $(input)[0].dispatchEvent(myEvent);
                    return false;
                } else {
                    CommonCallback = function (e) {
                        if (e.length > 0) {
                            $(input).attr({
                                "code": e[0][bind_code],
                                "text": e[0][bind_text]
                            });
                            $(input).val(e[0][bind_text]);

                            myEvent = new CustomEvent("dataBind", {'detail': e[0]});

                            $(input)[0].dispatchEvent(myEvent);
                        } else {
                            $(input).val($(input).attr('text'));
                        }
                    };
                    $.openCommonPopup(url, "CommonCallback", action, keyword, bind_param, width, height, top);
                }
            }
        });

        $("#codepicker input").change(function (e) {
            if (this.value == '') {
                $(this).attr({
                    "code": '',
                    "text": ''
                });
                myEvent = new CustomEvent("dataBind", {'detail': []});
                $(this)[0].dispatchEvent(myEvent);
            }
        });

        var orignValue;
        $("#codepicker input").focus(function (e) {
            orignValue = this.value;
        });

        $("#codepicker input").focusout(function (e) {
            if (orignValue == this.value) return;
            if (cdkey == '13' || cdkey == '9' || this.value == '') {
                e.preventDefault();
            } else {
                var input = this;
                var url = $(input).attr("help_url");
                var action = $(input).attr("help_action");
                var bind_code = $(input).attr("bind-code");
                var bind_text = $(input).attr("bind-text");
                var bind_param = (nvl($(input).attr("help_param")) != '') ? JSON.parse($(input).attr("help_param")) : {};
                var disabled = $(input).attr('help_disabled');
                var width = $(input).attr('WIDTH');
                var height = $(input).attr('HEIGHT');
                var top = $(input).attr('TOP');

                if (nvl(disabled) != '' && (disabled == 'true' || disabled == true)) {
                    return;
                }
                var keyword = $(input).val();

                var parameter = {};
                for (var z = 0; z < Object.keys(bind_param).length; z++) {
                    var obj = {};
                    obj["USERDEF" + Number(z + 2)] = bind_param[Object.keys(bind_param)[z]];
                    parameter = $.extend(parameter, obj);
                }

                parameter = $.extend(parameter, {ID_ACTION: action, USERDEF1: keyword});
                var result = $.DATA_SEARCH('common', "HELP_CHECK_SEARCH", parameter);
                if (result.list.length == 1) {

                    $(input).attr({
                        "code": result.list[0][bind_code],
                        "text": result.list[0][bind_text]
                    });
                    $(input).val(result.list[0][bind_text]);

                    myEvent = new CustomEvent("dataBind", {'detail': result.list[0]});

                    $(input)[0].dispatchEvent(myEvent);
                    return false;
                } else {
                    CommonCallback = function (e) {
                        if (e.length > 0) {
                            $(input).attr({
                                "code": e[0][bind_code],
                                "text": e[0][bind_text]
                            });
                            $(input).val(e[0][bind_text]);

                            myEvent = new CustomEvent("dataBind", {'detail': e[0]});

                            $(input)[0].dispatchEvent(myEvent);
                        } else {
                            $(input).val($(input).attr('text'));
                        }
                    };
                    $.openCommonPopup(url, "CommonCallback", action, keyword, bind_param, width, height, top);
                }
            }

        })

    }


    var multi = $("multipicker");
    if (multi != null) {
        var pickerInfo;
        var Back = '<div class=\"input-group\"><div id = "multi" name = "multi" data-ax5select = "multi" data-ax5select-config="{multiple: true, reset:\'<i class=\\\'cqc-trashcan\\\'></i>\'}"></div><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer"></i></span></div>';
        multi.append(Back);
        for (var i = 0; i < multi.length; i++) {
            $(multi[i]).find("#multi").ax5select({
                options: []
            })
        }
        window["callback2"] = function (e) {
            if (e.length > 0) {
                var option = [];
                var setting = [];
                var self = pickerInfo;
                var code = self.getAttribute("BIND-CODE");
                var text = self.getAttribute("BIND-TEXT");
                for (var i = 0; i < e.length; i++) {
                    option.push({value: e[i][code], text: e[i][text]});
                    setting.push(e[i][code])
                }
                $(pickerInfo).find("#multi").ax5select({
                    options: option
                });
                $(pickerInfo).find("#multi").ax5select("setValue", setting, true);
                $(pickerInfo).attr('DEFALUT_VALUE',JSON.stringify(e))

                myEvent = new CustomEvent("dataBind", {'detail': e});

                $(pickerInfo)[0].dispatchEvent(myEvent);
            }
            modal.close();
        };

        multi.find(".cqc-magnifier").click(function () {
            pickerInfo = this.parentNode.parentNode.parentNode;
            var url = pickerInfo.getAttribute('HELP_URL');
            var action = pickerInfo.getAttribute('HELP_ACTION');
            var disabled = pickerInfo.getAttribute('HELP_DISABLED');
            var width = pickerInfo.getAttribute('WIDTH');
            var height = pickerInfo.getAttribute('HEIGHT');
            var top = pickerInfo.getAttribute('TOP');
            var param = {};
            if(pickerInfo.getAttribute('HELP_PARAM')){
                param = JSON.parse(pickerInfo.getAttribute('HELP_PARAM'));
            }
            if(pickerInfo.getAttribute('DEFALUT_VALUE')){
                param.DEFAULT_VALUE =  JSON.parse(pickerInfo.getAttribute('DEFALUT_VALUE'));
            }

            if (!disabled) {
                $.openCommonPopup(url, "callback2", action, '', nvl(param, '') == '' ? {} : param, width, height, nvl(top,25));
            }
        })
    }
    $.fn.getCodes = function () {
        var self = this;
        var codeArray = [];
        var codes = "";
        if (self.is('multipicker')) {
            var dataList = self.find("[data-ax5select='multi']").ax5select("getValue");
            if (dataList.length > 0) {
                for (var i = 0; i < dataList.length; i++) {
                    codeArray.push(dataList[i].value)
                }
                codes = codeArray.join("|");
                //codes = codes + "|"
            }
            return codes;
        }
    };
    $.fn.getTexts = function () {
        var self = this;
        var textArray = [];
        var texts;
        if (self.is('multipicker')) {
            var dataList = self.find("[data-ax5select='multi']").ax5select("getValue");
            if (dataList.length > 0) {
                for (var i = 0; i < dataList.length; i++) {
                    textArray.push(dataList[i].text)
                }
                texts = textArray.join("|");
                //texts = texts + '|'
            }
            return texts;
        }
    };
    $.fn.setPicker = function (e) {
        var option = [];
        var setting = [];
        var self = this;
        if (self.is('multipicker')) {
            for (var i = 0; i < e.length; i++) {
                option.push({value: e[i].code, text: e[i].text});
                setting.push(e[i].code)
            }
            self.find("[data-ax5select='multi']").ax5select({
                options: option
            });
            self.find("[data-ax5select='multi']").ax5select("setValue", setting, true);
        }
    };

    $.fn.setHelpParam = function (e) {
        var self = this;
        if (self.is('multipicker')) {
            self.attr("HELP_PARAM", e)
        }
    };

    $.fn.setDisabled = function (e) {
        var self = this;
        if (self.is('multipicker')) {
            if (e) {
                self.find("#multi a").attr("disabled", "disabled");
                self.find("#multi i").attr("disabled", "disabled");
            } else {
                self.find("#multi a").removeAttr("disabled");
                self.find("#multi i").removeAttr("disabled");
            }

        }
    };

    $.fn.setClear = function (e) {
        var self = this;
        if (self.is('multipicker')) {
            self.find("[data-ax5select='multi']").ax5select({
                options: []
            })
        }
    };
    $.fn.required = function () {
        // console.log(grid.target.columns)
        var self = this[0];
        var config = self.target.columns;
        var requiredList = [];
        var data = self.target.list;
        config.forEach(function (item, index) {
            if (typeof nvl(item.required) == 'function') {
                if (nvl(item.required(), false)) {
                    requiredList.push(item)
                }
            } else {
                if (nvl(item.required, false)) {
                    requiredList.push(item)
                }
            }

        });
        for (var i = 0; i < data.length; i++) {
            for (var j = 0; j < requiredList.length; j++) {
                if (data[i][requiredList[j].key] == undefined || data[i][requiredList[j].key] == null || data[i][requiredList[j].key] == '') {
                    qray.alert(requiredList[j].label + " 는(은) 필수항목입니다.");
                    return true;
                }
            }
        }
    };
    $.fn.onStatePicker = function (type, fn) {
        var self = this;
        var self2 = this.parent();
        if (self.is('multipicker')) {
            self.find("[data-ax5select='multi']").ax5select({
                onStateChanged: function (e) {
                    switch (type) {
                        case 'set' :
                            type = 'setValue';
                            break;
                        case 'change' :
                            type = 'changeValue';
                            break;
                    }
                    switch (e.state) {
                        case type :
                            fn();
                            break;
                    }
                }
            })
        }
    };

    $.fn.setStartDate = function (date) {
        date = date.trim().replace();
        var today = new Date();
        var dtS = ax5.util.date(today, {"return": "yyyy-MM-01"});
        var dtE = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
        if(nvl(date) != ''){
            this.find('#dateStart').val($.changeDataFormat(date))
        }else{
            this.find('#dateStart').val(dtS)
        }
    };

    $.fn.setEndDate = function (date) {
        date = date.trim().replace(/-/g, "");
        var today = new Date();
        var dtS = ax5.util.date(today, {"return": "yyyy-MM-01"});
        var dtE = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
        if(nvl(date) != ''){
            this.find('#dateEnd').val($.changeDataFormat(date))
        }else{
            this.find('#dateEnd').val(dtE)
        }
    };

    $.fn.getStartDate = function () {
        return $.changeDataFormat(this.find('#dateStart').val())
    };

    $.fn.getEndDate = function () {
        return $.changeDataFormat(this.find('#dateEnd').val())
    };

    $(".cqc-arrow-bold-up").click(function () {
       console.log('up : ',this)
    })
    $(".cqc-arrow-bold-down").click(function () {
        console.log('down : ',this)
    })


    /** <datepicker id="date1"> </datepicker>
     *  getStartDate
     *  getEndDate
     *  setStartDate
     *  setEndDate
     *  default : 현재월
     * @type {*|jQuery.fn.init|jQuery|HTMLElement}
     */

    var dp = $("datepicker");
    if (dp != null && dp.length > 0) {
        console.log(this);
        var pickerInfo;
        var today = new Date();
        var dtS = ax5.util.date(today, {"return": "yyyy-MM-01"});
        var dtE = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
        var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
        for(var i = 0; i < dp.length; i++){
            var Back = '<div class="input-group" data-ax5picker="'+ dp[i].id +'">'
                + '<span class="datepicker" id="next1"><<</span>'
                + '<span class="datepicker" id="next2"><</span>'
                + '<input type="text" class="form-control" placeholder="yyyy-mm-dd" id="dateStart">'
                + '<span class="input-group-addon">~</span>'
                + '<input type="text" class="form-control" placeholder="yyyy-mm-dd" id="dateEnd">'
                + '<span class="input-group-addon"><i class="cqc-calendar"></i> </span>'
                + '<span class="datepicker" id="next3">></span>'
                + '<span class="datepicker" id="next4">>></span>'
                + '</div>';
            $(dp[i]).append(Back);
            $(dp[i]).setStartDate(dtS);
            $(dp[i]).setEndDate(dtE);
            if(nvl($(dp[i]).attr('mode'),'date') == 'date') {
                new ax5.ui.picker().bind({
                    target: $('[data-ax5picker="' + dp[i].id + '"]'),
                    direction: "auto",
                    content: {
                        width: 270,
                        margin: 10,
                        type: 'date',
                        config: {
                            control: {
                                left: '<i class="cqc-chevron-left"></i>',
                                yearTmpl: '%s',
                                monthTmpl: '%s',
                                right: '<i class="cqc-chevron-right"></i>'
                            },
                            lang: {
                                yearTmpl: "%s년",
                                months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
                                dayTmpl: "%s"
                            }
                        }
                    },
                    onStateChanged: function () {

                    }
                    , btns: {
                        today: {
                            label: "오늘", onClick: function () {
                                $('#' + $(this.item.$target.selector).attr('data-ax5picker')).find('#dateStart').val(dtNow);
                                $('#' + $(this.item.$target.selector).attr('data-ax5picker')).find('#dateEnd').val(dtNow);
                                this.self.close();
                            }
                        },
                        thisMonth: {
                            label: "이번달", onClick: function () {
                                $('#' + $(this.item.$target.selector).attr('data-ax5picker')).find('#dateStart').val(dtS);
                                $('#' + $(this.item.$target.selector).attr('data-ax5picker')).find('#dateEnd').val(dtE);
                                this.self.close();
                            }
                        },
                        ok: {label: "확인", theme: "default"}
                    }

                });
            }else if(nvl($(dp[i]).attr('mode'),'date') == 'month'){
                // Select Month
                picker.bind({
                    target: $('[data-ax5picker="' + dp[i].id + '"]'),
                    content: {
                        type: 'date',
                        config: {
                            mode: "year", selectMode: "month"
                        },
                        formatter: {
                            pattern: 'date(month)'
                        }
                    }
                });
            }else{
                // Select Year
                picker.bind({
                    target: $('[data-ax5picker="' + dp[i].id + '"]'),
                    content: {
                        type: 'date',
                        config: {
                            mode: "year", selectMode: "year"
                        },
                        formatter: {
                            pattern: 'date(year)'
                        }
                    }
                });
            }
        }

        dp.find("#next1").click(function(){
            var self = this.parentNode.parentElement;
            var y = $(self).find('#dateStart').val().substring(0,4);
            var m = $(self).find('#dateEnd').val().substring(5,7)-2;
            if(m <= 0){
                y = y-1;
                m = m + 12;
            }
            if(m < 10){
                m = '0'+String(m)
            }
            var ld = String(new Date(y,m,0).getDate());

            var last = y+'-'+m+'-'+ld;

            $(self).find('#dateStart').val(y+'-'+m+'-'+'01');
            $(self).find('#dateEnd').val(last);
        });

        dp.find('#next2').click(function(){
            var self = this.parentNode.parentElement;
            var y = $(self).find('#dateStart').val().substring(0,4);
            var m = $(self).find('#dateEnd').val().substring(5,7)-1;
            if(m <= 0){
                y = y-1;
                m = m + 12;
            }
            if(m < 10){
                m = '0'+String(m)
            }
            var ld = String(new Date(y,m,0).getDate());

            var last = y+'-'+m+'-'+ld;

            $(self).find('#dateStart').val(y+'-'+m+'-'+'01');
            $(self).find('#dateEnd').val(last);
        });
        dp.find('#next3').click(function(){
            var self = this.parentNode.parentElement;
            var y = $(self).find('#dateStart').val().substring(0,4);
            var m = Number($(self).find('#dateEnd').val().substring(5,7))+1;
            if(m > 12){
                y = Number(y)+1;
                m = m - 12;
            }
            if(m < 10){
                m = '0'+String(m)
            }
            var ld = String(new Date(y,m,0).getDate());
            var last = y+'-'+m+'-'+ld;
            $(self).find('#dateStart').val(y+'-'+m+'-'+'01');
            $(self).find('#dateEnd').val(last);
        });

        dp.find('#next4').click(function(){
            var self = this.parentNode.parentElement;
            var y = $(self).find('#dateStart').val().substring(0,4);
            var m = Number($(self).find('#dateEnd').val().substring(5,7))+2;
            if(m > 12){
                y = Number(y)+1;
                m = m - 12;
            }
            if(m < 10){
                m = '0'+String(m)
            }
            var ld = String(new Date(y,m,0).getDate());

            var last = y+'-'+m+'-'+ld;

            $(self).find('#dateStart').val(y+'-'+m+'-'+'01');
            $(self).find('#dateEnd').val(last);
        })


    }


    Object.defineProperties(Object.prototype, {
        read: {
            value: function () {
                // console.log(this)
                // console.log(window)
                // return;
                var grid = this
                    , gridInfo = window.fnObj
                    , parentGrid = []
                    , childGrid = []
                    , gridTemp = []
                    , temp = []
                    , hidden_div = grid.target.$.container.hidden
                    , Url = grid.target.config.url[0]
                    , Url2 = grid.target.config.url[1]
                    , paramData = grid.target.config.param[0][grid.target.config.param[1]]()
                    , uid;

                if (nvl(grid.target.config.parentFlag, false)) {
                    for (var i = 0; i < Object.keys(gridInfo).length; i++) {
                        try {
                            // if(gridInfo[Object.keys(gridInfo)[i]].target.config.childrenGrid[0]){
                            if (gridInfo[Object.keys(gridInfo)[i]].target.id == grid.target.config.parentGrid[0].target.id) {
                                parentGrid = gridInfo[Object.keys(gridInfo)[i]];
                            }
                        } catch (err) {
                        }
                    }
                    for (var i = 0; i < parentGrid.target.list.length; i++) {
                        if (parentGrid.target.list[i].__selected__) {
                            if (nvl(parentGrid.target.list[i].uid) == '') {
                                uid = guid();
                                parentGrid.target.list[i].uid = uid;
                            } else {
                                uid = parentGrid.target.list[i].uid;
                            }
                            break;
                        }
                    }
                    if (grid.target.config.parentUid) {
                        var beforeUid = grid.target.config.parentUid;
                        var beforeData = grid.target.list;
                        beforeData.forEach(function (item, index) {
                            if (nvl(item.uid) == '') {
                                item.uid = guid();
                            }
                            item.Puid = beforeUid;
                        });
                        $(hidden_div).find('#copyData #' + beforeUid).attr('copyData', JSON.stringify(beforeData))
                    }
                    if ($(hidden_div).find('#copyData #' + uid).length > 0) {
                        var data = $(hidden_div).find('#copyData #' + uid).attr('copyData');
                        grid.target.setData(JSON.parse(data));
                        grid.target.config.parentUid = uid;
                    } else {
                        search();
                        // $(hidden_div).append("<div id='copyData' copyData='" + JSON.stringify(temp) + "'> </div>")
                        $(hidden_div).find('#copyData').append("<div id='" + uid + "' copyData='" + JSON.stringify(temp) + "' originalData='" + JSON.stringify(temp) + "'> </div>");
                        grid.target.config.parentUid = uid;
                        grid.target.setData(temp);
                    }

                } else {
                    try {
                        // $(hidden_div).remove('#copyData')
                        childGrid = grid.target.config.childGrid;
                        for (var i = 0; i < childGrid.length; i++) {
                            $(childGrid[i][0].target.$.container.hidden).find('#copyData').remove()
                        }
                        // childGrid.forEach(function (item, index) {
                        //     $(item[index].target.$.container.hidden).find('#copyData').remove()
                        //     console.log($(item[index].target.$.container.hidden).find('#copyData'))
                        // })
                    } catch (err) {
                    }
                    search();
                    window.UidCDataSet = temp;
                    window.UidODataSet = temp;
                    window.UidDataSet = {copyData: temp, originalData: temp};
                    grid.setData(temp);
                }
                // if(nvl(grid.target.config.childFlag,false)){
                //     childGrid = grid.target.config.childGrid;
                //     for( var i = 0 ; i < childGrid.length; i++ ){
                //         $(childGrid[i][0].target.$.container.hidden).find('#copyData').remove()
                //     }
                // }
                function search() {
                    axboot.ajax({
                        type: "POST",
                        url: [Url, Url2],
                        data: JSON.stringify(nvl(paramData, {})),
                        async: false,
                        callback: function (res) {
                            // console.log("1>>", $(hidden_div).find('#copyData'))
                            // console.log("2>>", $(hidden_div).find('#copyData').length)
                            temp = res.list;
                            if ($(hidden_div).find('#copyData').length > 0) {
                                $(hidden_div).find('#copyData').attr('copyData', JSON.stringify(temp));
                                $(hidden_div).find('#copyData').attr('originalData', JSON.stringify(temp))
                            } else {
                                $(hidden_div).append("<div id='copyData' copyData='" + JSON.stringify(temp) + "' originalData='" + JSON.stringify(temp) + "'> </div>")
                            }
                            // grid.setData(res.list);
                        },
                        options: {
                            onError: function (err) {
                                qray.alert(err.message)
                            }
                        }
                    })
                }

                function guid() {
                    function s4() {
                        return Math.floor((1 + Math.random()) * 0x10000)
                            .toString(16)
                            .substring(1);
                    }

                    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                        s4() + '-' + s4() + s4() + s4();
                }
            }
        }, 
        getDirtyData: {
            value: function () {
                var self = this;
                var createList = [];
                var updateList = [];
                var deleteList = [];
                var equalsList = [];
                if (self.target.config.parentFlag) {
                    var hiddenList = nvl($(self.target.$.container.hidden).find('#copyData div'), []);
                    var uidList = [];
                    if (self.target.config.parentUid) {
                        var beforeUid = self.target.config.parentUid;
                        var beforeData = self.target.list;
                        beforeData.forEach(function (item, index) {
                            if (nvl(item.uid) == '') {
                                item.uid = guid();
                            }
                            item.Puid = beforeUid;
                        });
                        $(self.target.$.container.hidden).find('#copyData #' + beforeUid).attr('copyData', JSON.stringify(beforeData))
                    }
                    for (var i = 0; i < hiddenList.length; i++) {
                        uidList.push(hiddenList[i].id);
                        var copyData = JSON.parse($(self.target.$.container.hidden).find('#copyData #' + hiddenList[i].id).attr('copyData'));
                        var originalData = JSON.parse($(self.target.$.container.hidden).find('#copyData #' + hiddenList[i].id).attr('originalData'));
                        a(copyData, originalData)
                    }

                } else {
                    var nowData = self.target.list;
                    var originalData = JSON.parse($(self.target.$.container.hidden).find('#copyData').attr('originalData'));
                    a(nowData, originalData)
                }

                function a(copyData, originalData) {
                    for (var j = 0; j < originalData.length; j++) {
                        for (var k = 0; k < copyData.length; k++) {
                            if (nvl(copyData[k].uid) == originalData[j].uid) {
                                var keys = Object.keys(originalData[j]);
                                for (var value in keys) {
                                    if (originalData[j][keys[value]] != copyData[k][keys[value]]) {
                                        updateList.push(copyData[k]);
                                        break;
                                    }
                                }

                            }
                        }
                    }

                    for (var k = 0; k < copyData.length; k++) {
                        if (nvl(copyData[k].__created__, false)) {
                            createList.push(copyData[k])
                        }
                    }

                    var tempData = originalData;
                    var tempDataLength = originalData.length;
                    var dcnt = 0;
                    for (var j = 0; j < tempDataLength; j++) {
                        for (var k = 0; k < copyData.length; k++) {
                            if (nvl(copyData[k].uid) == nvl(originalData[j - dcnt].uid)) {
                                tempData.splice(j - dcnt, 1);
                                dcnt++;
                                break;
                            }
                        }
                    }
                    if (tempData.length > 0) {
                        deleteList = deleteList.concat(tempData);
                    }
                    for (var j = 0; j < originalData.length; j++) {
                        for (var k = 0; k < copyData.length; k++) {
                            delete copyData[k].__original_index;
                            delete copyData[k].__index;
                            if (nvl(copyData[k].uid) == originalData[j].uid) {
                                if (JSON.stringify(copyData[k]) == JSON.stringify(originalData[j])) {
                                    equalsList.push(originalData[j])
                                }
                            }
                        }
                    }
                }

                function guid() {
                    function s4() {
                        return Math.floor((1 + Math.random()) * 0x10000)
                            .toString(16)
                            .substring(1);
                    }

                    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                        s4() + '-' + s4() + s4() + s4();
                }

                var result = {
                    'created': createList,
                    'updated': updateList,
                    'deleted': deleteList,
                    'equals': equalsList
                };
                return result;
            }
        }, 
        getDirtyDataCount: {
            value: function () {
                var result = this.getDirtyData();
                var cnt = 0;
                cnt += nvl(result.created.length, 0);
                cnt += nvl(result.updated.length, 0);
                cnt += nvl(result.deleted.length, 0);
                return cnt;
            }
        }, 
        getChangeRow: {
            value: function () {

                return cnt;
            }
        }, 
        refresh: {
            value: function () {
                $(this).find('#copyData').remove()
            }
        }, 
        setFormData: {
            value: function (d) {
                //console.log(d,'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
                this.FormClear();
                if(!d){
                    return
                }
                for (var i = 0; i < Object.keys(d).length; i++) {
                    var co = $(this).find('#'+Object.keys(d)[i]);
                    if(co.length > 0){
                        var cot = $(co).attr('form-bind-type');
                        if(cot == 'selectBox'){
                            $('[data-ax5select="'+Object.keys(d)[i]+'"]').ax5select("setValue", d[Object.keys(d)[i]]);
                        }else if(cot == 'checkBox'){
                            //console.log(d[Object.keys(d)[i]],'elseif');
                            if(d[Object.keys(d)[i]] == 'Y' || d[Object.keys(d)[i]] == true){
                                $('#'+Object.keys(d)[i]).prop("checked", true)
                            }else{
                                $('#'+Object.keys(d)[i]).prop("checked", false);
                            }
                        }else if(cot == 'codepicker'){
                            var textKey = $(co).attr('form-bind-text');
                            var codeKey = $(co).attr('form-bind-code');
                            $('#'+Object.keys(d)[i]).attr({code: d[codeKey], text: d[textKey]});
                            $('#'+Object.keys(d)[i]).val(d[textKey])
                        } else if(cot == 'multipicker'){
                            var textKey = $(co).attr('form-bind-text');
                            var codeKey = $(co).attr('form-bind-code');

                            var tempArr = []

                            var tempCode = nvl(d[codeKey],'').split('|')
                            var tempText = nvl(d[textKey],'').split('|')

                            for(var ci = 0; ci < tempCode.length; ci ++){
                                tempArr.push({code: tempCode[ci]})
                            }
                            for(var tj = 0; tj < tempText.length; tj ++){
                                tempArr[tj].text = tempText[tj]
                            }
                            $('#'+Object.keys(d)[i]).setPicker(tempArr)
                        }
                        else if(cot == 'decimal'){
                            var formatter = $(co).attr('decimal-formatter');
                            var temp = String(nvl(formatter,0)).split('.')
                            if(temp.length == 1){
                                $('#'+Object.keys(d)[i]).val( comma( Number( d[Object.keys(d)[i]] ) ) )
                            }else{
                                var val_temp = String(d[Object.keys(d)[i]]).split('.')
                                if(val_temp.length == 1){
                                    var tempZero = ''
                                    for(var k = 0 ; k < nvl(temp[1].length,0); k++){
                                        tempZero += '0'
                                    }
                                    var num = comma(Number(nvl(val_temp,0))) + '.' + tempZero
                                }else{
                                    var num = comma(Number(String(nvl(val_temp[0],0))))+'.'+String(nvl(val_temp[1],0)).substring(0,temp[1].length)
                                }
                                $('#'+Object.keys(d)[i]).val(num)
                            }
                        }
                        else{
                            //console.log(d[Object.keys(d)[i]],'else');
                            var formatter = $(co).attr('formatter');
                            var bt = $.changeDataFormat(d[Object.keys(d)[i]],nvl(formatter,'text'));
                            $(co).val(bt)
                        }
                    }
                }
            }
        }, 
        FormClear : {
            value: function (d) {
                var el = $(this).find('[form-bind-type]');
                for (var i = 0; i < el.length; i++) {
                    var type = $(el[i]).attr('form-bind-type');
                    if (type == 'selectBox') {
                        $('[data-ax5select="' + el[i].id + '"]').ax5select("setValue", '');
                    } else if (type == 'checkBox') {
                        $('#' + el[i].id).prop("checked", false);
                    } else if (type == 'codepicker'){
                    	$('#' + el[i].id).attr({code: '', text: ''});
                        $('#' + el[i].id).val('');
                    } else {
                        $('#' + el[i].id).val('');
                        $('#' + el[i].id).attr({code: '', text: ''});
                    }
                }
            }
        }, 
        requirement: {
            value: function (e) {
                var self = this;
                var config = self.target.columns;
                var requiredList = [];
                var data = this.getData('modified');
                config.forEach(function (item, index) {
                    if (typeof nvl(item.required) == 'function') {
                        if (nvl(item.required(), false) && !nvl(item.hidden,false)) {
                            requiredList.push(item)
                        }
                    } else {
                        if (nvl(item.required, false) && !nvl(item.hidden,false)) {
                            requiredList.push(item)
                        }
                    }

                });
                for (var i = 0; i < data.length; i++) {
                    for (var j = 0; j < requiredList.length; j++) {
                        if (data[i][requiredList[j].key] == undefined || data[i][requiredList[j].key] == null || data[i][requiredList[j].key] == '') {
                            var hcol = this.target.headerColGroup;
                            var cIndex = 0;
                            for(var h = 0; h < hcol.length; h++){
                                if(hcol[h].key == requiredList[j].key){
                                    cIndex = hcol[h].colIndex
                                }
                            }
                            if(!data[i].__Groping_index){
                                var rIndex = data[i].__index
                            }else{
                                var rIndex = data[i].__Groping_index
                            }

                            this.target.focus(rIndex);
                            $(this.target.$.container.body).find('[data-ax5grid-data-index="' + rIndex + '"][data-ax5grid-column-colindex="' + cIndex + '"]').attr('data-ax5grid-column-selected','true');
                            $(this.target.$.container.body).find('[data-ax5grid-data-index="' + rIndex + '"][data-ax5grid-column-colindex="' + cIndex + '"]').attr('data-ax5grid-column-focused','true');
                            //$(this.target.$.container.body).find('[data-ax5grid-data-index="' + rIndex + '"][data-ax5grid-column-colindex="' + cIndex + '"]').attr('requirement-tooltip-text','테스트용도')
                            // $(this.target.$.container.body).find('[data-ax5grid-data-index="' + rIndex + '"][data-ax5grid-column-colindex="' + cIndex + '"]').css('position','relative');
                            qray.alert(requiredList[j].label + " 는(은) 필수항목입니다.");
                            return true;
                        }
                    }
                }
            }
        }
    })


});



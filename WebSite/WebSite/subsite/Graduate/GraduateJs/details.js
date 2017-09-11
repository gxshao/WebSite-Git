var rows = new Array();
var mTime = "";
var isDeg = "";
var comDeg = "";
var keyWords = "";
var value = "";
$(document).ready(function () {
    var rows = new Array();         //数据条目
    mTime = $("#mTimes").val(); //时间
    comDeg = $("#mDegs").val();               //学位

    var code = getQueryString("key");
    if (code == null) {
        document.write("大哥别瞎搞..");
        return;
    }
    value = getQueryString("value");
    var ps = "key=GetSchoolName&value=" + value;
    $.ajax({
        type: "POST",
        url: "../Graduate/GraduateInfo.ashx", data: ps, success: function (data) {
            $("#schoolname").text(data);
            window.document.title = data + "研究生招生专业列表";
        }
    });

    switch ($("#mDegs").val()) {
        case "X":
            isDeg = "degree=X";
            break;
        case "Z":
            isDeg = "degree=Z";
            break;
        case "ALL":
            isDeg = "degree=all";
            break;
        default:
            break;
    }
    var text = "key=GetAllScores&value=" + value + "&time=" + mTime + "-01-01&" + isDeg;

    refreshData(text);
});
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
function refreshData(text, filterWords) {
    $.ajax({
        type: "POST",
        url: "../Graduate/GraduateInfo.ashx", data: text, success: function (data) {
            if (data == "" || data.indexOf("Error,") >= 0) {
                $("#FullScores tr:not(:first)").empty("");
                return;
            }
            rows = JSON.parse(data);
            var items = "";
            for (var obj in rows) {
                items += "<tr><td>" + rows[obj].MCode + "</td><td>" + rows[obj].MName + "</td><td>" + rows[obj].MDire + "</td><td>" + rows[obj].MPlotics + "</td><td>" + rows[obj].MLanguage + "</td><td>" + rows[obj].MPro1 + "</td><td>" + rows[obj].MPro2 + "</td><td>" + rows[obj].MSum + "</td><td>" + rows[obj].MPeople + "</td><td>" + rows[obj].MColName + "</td></tr>";
            }
            if (keyWords != "专业名称或研究方向") {
                filter();
            } else {
                $("#FullScores tr:not(:first)").empty("");
                $("#FullScores").append(items);
            }
        }
    });
}
function filterData() {
    keyWords = $("#keywords").val();
    if (mTime == $("#mTimes").val() && comDeg == $("#mDegs").val() && keyWords != "专业名称或研究方向") {
        filter();
    } else {
        mTime = $("#mTimes").val();
        switch ($("#mDegs").val()) {
            case "X":
                isDeg = "degree=X";
                break;
            case "Z":
                isDeg = "degree=Z";
                break;
            case "ALL":
                isDeg = "degree=all";
                break;
            default:
                break;
        }
        var text = "key=GetAllScores&value=" + value + "&time=" + mTime + "-01-01&" + isDeg;
        refreshData(text);
    }
}
function filter() {
    if (keyWords != "专业名称或研究方向" && rows != null) {
        var items = "";
        for (var obj in rows) {
            if (rows[obj].MName.indexOf(keyWords) >= 0 || rows[obj].MDire.indexOf(keyWords) >= 0) {
                items += "<tr><td>" + rows[obj].MCode + "</td><td>" + rows[obj].MName + "</td><td>" + rows[obj].MDire + "</td><td>" + rows[obj].MPlotics + "</td><td>" + rows[obj].MLanguage + "</td><td>" + rows[obj].MPro1 + "</td><td>" + rows[obj].MPro2 + "</td><td>" + rows[obj].MSum + "</td><td>" + rows[obj].MPeople + "</td><td>" + rows[obj].MColName + "</td></tr>";
            }
        }
        $("#FullScores tr:not(:first)").empty("");
        $("#FullScores").append(items);
    }
}
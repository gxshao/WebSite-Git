var areacode = "";
var schoolcode = "";
var categroy = "";
var year = "";
$(document).ready(function () {
    regEvent("#area");
    regEvent("#school");
    regEvent("#scores");
    regEvent("#major");
    loadArea();
    $("#AddScores").click(function () {
        $("#ScoresField").click();
    });
    $("#AddSchool").click(function () {
        $("#SchoolField").click();
    });
    $("#AddMajor").click(function () {
        $("#MajorField").click();
    });
    $("#SchoolKey").click(function () {
        if ($("#Sel_Area").val() == "") {
            return;
        } else {
            areacode = $("#Sel_Area").val();
            $("#mask-area").show();
            loadSchool();
            loadCateGroy();

        }
    });
    $("#AddAll").click(function () {
        if ($("#Sel_Scho").val() == "" || $("#Sel_Cate").val() == "" || $("#Sel_Year").val() == "") {
            return;
        } else {
            schoolcode = $("#Sel_Scho").val();
            categroy = $("#Sel_Cate").val();
            $("#mask-school").show();
            $("#scores").show();
            $("#major").show();
        }
    });

});
function regEvent(id) {
    var clicked = "Nope.";
    var mausx = "0";
    var mausy = "0";
    var winx = "0";
    var winy = "0";
    var difx = mausx - winx;
    var dify = mausy - winy;
    $(id).mousemove(function (event) {
        mausx = event.pageX;
        mausy = event.pageY;
        winx = $(id).offset().left;
        winy = $(id).offset().top;
        if (clicked == "Nope.") {
            difx = mausx - winx;
            dify = mausy - winy;
        }
        var newx = event.pageX - difx - $(id).css("marginLeft").replace('px', '');
        var newy = event.pageY - dify - $(id).css("marginTop").replace('px', '');
        $(id).css({ top: newy, left: newx });
    });

    $(id).mousedown(function (event) {
        clicked = "Yeah.";

    });

    $(id).mouseup(function (event) {
        clicked = "Nope.";
    });
}

function loadArea() {
    text = "key=GetAllArea";
    $.ajax({
        type: "POST",
        url: "../GraduateInfo.ashx", data: text, success: function (data) {

            if (data == null) {
                return;
            }
            var areas = JSON.parse(data);
            var items = "";
            for (var obj in areas) {
                items += "<option value=\"" + areas[obj].ACode + "\">" + areas[obj].AName + "</option>"
            }
            $("#Sel_Area").append(items);
        }
    });
}

function loadTxt(what, types) {
    var obj = document.getElementById(what);
    $("#what").val(types);
    $("#type").text(types);
    $("#loadtxt").click();

}
function getImgURL(node) {

    var imgURL = "";
    try {
        var file = null;
        if (node.files && node.files[0]) {
            file = node.files[0];
        } else if (node.files && node.files.item(0)) {
            file = node.files.item(0);
        }
        //Firefox 因安全性问题已无法直接通过input[file].value 获取完整的文件路径
        try {
            //Firefox7.0
            imgURL = file.getAsDataURL();
            //alert("//Firefox7.0"+imgRUL);
        } catch (e) {
            //Firefox8.0以上
            imgURL = window.URL.createObjectURL(file);
            //alert("//Firefox8.0以上"+imgRUL);
        }
    } catch (e) {      //这里不知道怎么处理了，如果是遨游的话会报这个异常
        //支持html5的浏览器,比如高版本的firefox、chrome、ie10
        if (node.files && node.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                imgURL = e.target.result;
            };
            reader.readAsDataURL(node.files[0]);
        }
    }
    return imgURL;
}
function loadSchool() {
    $("#school").show();
    text = "key=GetSchoolInfo&value=" + areacode;
    $.ajax({
        type: "POST",
        url: "../GraduateInfo.ashx", data: text, success: function (data) {
            if (data == null) {
                return;
            }
            var schools = JSON.parse(data);
            var items = "";
            for (var obj in schools) {
                items += "<option value=\"" + schools[obj].SCode + "\">" + schools[obj].SName + "</option>"
            }
            $("#Sel_Scho option:not(:first)").remove();
            $("#Sel_Scho").append(items);
        }
    });
}
function loadCateGroy() {

    $("#school").show();
    text = "key=GetCategroy";
    $.ajax({
        type: "POST",
        url: "../GraduateInfo.ashx", data: text, success: function (data) {
            if (data == null) {
                return;
            }
            var cates = JSON.parse(data);
            var items = "";
            for (var obj in cates) {
                items += "<option value=\"" + cates[obj].CoCode + "\">" + cates[obj].CoName + "</option>"
            }
            $("#Sel_Cate option:not(:first)").remove();
            $("#Sel_Cate").append(items);
        }
    });
}
function CloseDIV(id, mid) {
    $(id).children().each(
             function () {
                 $(this).children().each(function () {
                     var cid = $(this).attr("id");
                     if (cid != "Sel_Year") {
                         $("#" + cid + " option:not(:first)").remove();
                     }
                 });
                 $(".txt").val("");
             });
    $(mid).hide();
    $(id).hide();

}
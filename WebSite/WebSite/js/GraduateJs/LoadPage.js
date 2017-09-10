$(document).ready(function () {
   
    var code = getQueryString("code");
    if (code ==null)
    {
        $("#loadtext").text("屏幕保护。。。");
        return;
    }
    $("#loadtext").text("数据正在加载。。");
    var text = "key=GetSchoolInfo&value=" + code;
    $.ajax({
        type: "POST",
        url: "../Graduate/GraduateInfo.ashx", data: text, success: function (data) {
            if (data == null)
                return;
            var schools = JSON.parse(data);
            var items = "";
            var partofattr = "";
            for (var obj in schools) {
                var attr = schools[obj].SAttr.split("|");
                partofattr = "";
                for(var i=0;i<attr.length;i++){
                    partofattr += "<div class=\"TxtBlock\">" + attr[i].toString() + "</div>";
                }
                items += " <tr><td>" + schools[obj].SCode + "</td><td>" + schools[obj].SName + "</td><td>"
                    + partofattr + "</td><td><a style=\"color:white\" href=" + schools[obj].SLink + ">" + schools[obj].SLink +
                    "</a></td><td><input type=\"button\" code=\""+schools[obj].SCode+"\" class=\"btn-detial\" value='详情'></input></td></tr>";
            }
            $("#schoollist").append(items);
            $("#schoollist").on("click", "input", function () {
                var parm = "key=GetAllScores&value=" + $(this).attr("code");
                window.open("../Graduate/Details.aspx?" + parm,"_blank","","");
            });
        }
    });
    setTimeout(function () { $(".MaskLayer").hide() }, 900);
});
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
$(document).ready(function()
{
    //导入地区列表
    loadarea();
    var isOut = true;
    $(".btn-submit").click(function () {
        var wids = "";
        var rate = $("#leftpanel").width() * 0.99;
        wids = "-" + rate + "px";
        $(".divLeftPanel").animate({ marginLeft: wids });
       
        $(".divRightPanel").animate({ marginLeft: "10px" });
        $(".diviFrame").animate({ width: "100%" });
        isOut = false;
        event.stopPropagation();
    });
    $("#leftpanel").click(function () {
        
        if (!isOut) {
            $(".divLeftPanel").animate({ marginLeft: "-10px" });
            $(".divRightPanel").animate({ marginLeft: "18%" });

            $(".diviFrame").animate({ width: "82%" });
            isOut = true;
        } else {
        }
    });
});
function loadarea() {
    text = "key=GetAllArea";
    $.ajax({
        type: "POST",
        url: "../Graduate/GraduateInfo.ashx", data: text, success: function (data) {

            if (data == null)
            {
                return;
            }
            var areas = JSON.parse(data);
            var items = "";
            for (var obj in areas) {
                items += "<div code=\"" + areas[obj].ACode + "\" class=\"btn-areaname\">" + areas[obj].AName + "</div>"
            }
            $("#SchoolContent").html(items);
            $("#SchoolContent ").on("click", "div", function () {
                $(".btn-areaname").animate({ marginLeft: "40px" }, 10);
                $(".btn-areaname").animate({ opacity: '0.8' }, 100);
                    $(this).animate({ marginLeft: "60px" }, 100);
                    $(this).animate({ opacity: '1' }, 100);
                    var code = $(this).attr("code");
                    window.parent.open("../Graduate/SchoolList.aspx?code="+code, "SubPage","","");
                    event.stopPropagation();
            });
        }
    });
   
}
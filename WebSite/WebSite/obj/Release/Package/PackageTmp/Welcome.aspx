<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Welcome.aspx.cs" Inherits="WebSite.Welcome" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="css/div/div_panel.css" rel="stylesheet" />
    <link href="css/btn/btn.css" rel="stylesheet" />
    <link href="css/txt/txt.css" rel="stylesheet" />
    <script src="js/jquery-3.1.0.min.js"></script>
    <script src="js/page.js"></script>
    <meta name="viewport"
        content="width=device-width,minimum-scale=1.0,maximum-scale=1.0" />
    <meta http-equiv="Cache-Control" content="no-transform" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=yes" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Courage and intelligence</title>
    <style>
        .body {
        }
    </style>
    <script type="text/javascript">
        var CurBtn;
        var isExit = false
        function hide() {
            if (CurBtn != null) {
                CurBtn.style.backgroundColor = "transparent";
                CurBtn = null;
            }
        }
        if (/AppleWebKit.*Mobile/i.test(navigator.userAgent) || (/MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/.test(navigator.userAgent))) {
            if (window.location.href.indexOf("?mobile") < 0) {
                try {
                    if (/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
                        window.location.href = "http://mrsgx.cn/others/news.aspx";
                    } else if (/iPad/i.test(navigator.userAgent)) {
                        window.location.href = "http://mrsgx.cn/others/news.aspx";
                    } else {
                        window.location.href = "http://mrsgx.cn"
                    }
                } catch (e) { }
            }
        }
        function hideContentLayer() {
            var lay = document.getElementById("content_layer");
            lay.hidden = true;
            lay.style.opacity = 0;
            if (CurBtn != null) {
                CurBtn.style.backgroundColor = "transparent";
                CurBtn = null;
            }
        }
        function Btn_Event(id) {

            if (CurBtn != null) {
                var right = id.innerText;
                var left = CurBtn.innerText;
                if (left == right && !isExit) {
                    return;
                }
                hide();
            }
            switch (id) {
                case document.getElementById("Btn_Login"):
                    isExit = false;
                    $(".div-subcontent").hide();
                    $(".div-LoginParent").show();
                    $("#about_layer").hide();
                    $("#link_layer").hide();
                    if ($("#Btn_Login").text() == "登录") {
                        $("#Main_Layer").hide();
                        $("#login_layer").show();
                        $("#Txt_tips").text("Please login before you explore the mrsgx.cn.");
                    }
                    else {
                        $(".LoginParent").show();
                        $("#Main_Layer").show();
                    }
                    break;
                case document.getElementById("Btn_SignInfo"):
                    $(".div-subcontent").hide();
                    $(".div-LoginParent").hide();
                    var i = 0;
                    var text = "key=ÝÇÉÀ";
                    postdata(2, text);
                    $("#signinfo_layer").show();
                    $("#about_layer").hide();
                    $("#link_layer").hide();
                    break;
                case document.getElementById("Btn_GetInfo"):
                    $(".div-subcontent").hide();
                    $(".div-LoginParent").hide();
                    $("#about_layer").hide();
                    $("#link_layer").show();
                    break;
                case document.getElementById("Btn_About"):
                    $(".div-subcontent").hide();
                    $(".div-LoginParent").hide();
                    $("#about_layer").show();
                    $("#link_layer").hide();
                    break;
                default: break;
            }
            var lay = document.getElementById("content_layer");
            if (lay.hidden == true)
                layopacity(lay);
            id.style.backgroundColor = "deepskyblue";
            CurBtn = id;
        }
        function Btn_RefreshSign() {
            var text = "key=ÝÇÉÀ";
            postdata(2, text);
        }
        function Btn_Login() {
            Login();
        }
        function Exit() {
            $("#Btn_Login").text("登录");
            isExit = true;
            var text = "key=ÂÁÉÁÛÚ";
            postdata(5, text);
        }

    </script>
</head>
<body class="body">
    <div style="z-index: -50; position: absolute; width: 100%; height: 90%;"></div>
    <div style="z-index: -100; position: absolute; width: 100%; height: 90%">
        <video autoplay="" loop="" id="video" style="width: auto; height: auto; top: -100px; left: 0px; right: 0px">
            <source src="file/chu.mp4" type="video/mp4">
        </video>
    </div>
    <form style="z-index: 200;" id="form1" runat="server">

        <div class="div-content">
            <a class="btn-sky" style="min-width: 150px; float: right" href="javascript:void(0);" runat="server" id="Btn_Login" onclick="Btn_Event(this);">登录</a>
            <a class="btn-sky" style="min-width: 150px; float: right;" href="javascript:void(0);" id="Btn_SignInfo" onclick="Btn_Event(this);">签到</a>
            <a class="btn-sky" style="min-width: 150px; float: right;" href="javascript:void(0);" id="Btn_GetInfo" onclick="Btn_Event(this);">信息入口</a>
            <a class="btn-sky" style="min-width: 150px; float: right;" href="javascript:void(0);" id="Btn_About" onclick="Btn_Event(this);">关于</a>
        </div>
        <div id="content_layer" class="div-layer" style="max-height: 500px; max-width: 800px; width: auto; height: auto; opacity: 0;"
            hidden="hidden">
            <div id="btn_close" class="btn-close" onclick="hideContentLayer();" href="#">x</div>
            <div class="div-LoginParent">
                <div id="login_layer" hidden="hidden" style="position: relative; display: inline-block; width: 100%; height: 100%">

                    <span class="txt-tips" id="Txt_tips"></span>
                    <div class="div-smalllogin" id="smalllgoin">
                        <div class="div-txtborder">
                            <img src="images/smallbutton/usr.png" class="btn-icons" /><input class="txtbox-msg" placeholder="用户名" id="txt_usr" />
                        </div>
                        <br />
                        <br />
                        <div class="div-txtborder">
                            <img src="images/smallbutton/pwd.png" class="btn-icons" /><input type="password" class="txtbox-msg" placeholder="密    码" id="txt_pwd" />
                        </div>
                        <br />
                        <a href="javascript:void(0);" class="btn-submit" style="margin-top: 30px;" id="btn_login" onclick="Btn_Login('btn_login');">登  录</a>
                    </div>
                    <ul class="bg-bubbles">
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                        <li></li>
                    </ul>
                </div>
                <div id="Main_Layer" runat="server" hidden="hidden" class="div-MainLayer">
                    Parper Airplanes-The Candle Thieves<embed src="../air.mp3" hidden="true" autostart="true" loop="false" />
                    <a class="btn-submit" onclick="Exit();">注销</a>
                </div>
            </div>

            <div id="signinfo_layer" class="div-subcontent" hidden="hidden">
                <a class="txt-smalltitle">签到信息查看</a><img src="images/smallbutton/refresh.png" class="btn-refresh" href="javacript:void(0);" onclick="Btn_RefreshSign();" />
                <textarea class="txt-signinfo" readonly="readonly" id="Txt_SignInfo"></textarea>

            </div>


            <div id="link_layer" class="div-linklayer">
                <a href="../subsite/Graduate/Main.aspx" style="text-decoration: none;">进入研究生考试信息通道>></a></br>

                <hr style="width: 70%" />
                <h4>温馨提示:</h4>
                <a>本系统提供2015年部分院校的成绩查询</a></br>
                <a>系统数据来源于网络</a>
            </div>
            <div id="about_layer" class="div-about" hidden="hidden">
                <a style="color: orange; padding-right: 5px; font-size: 60px">☺</a><a style="font-size: 60px">勇敢与智慧</a>
                <br />
                <span style="font-size: 25px; line-height: normal; margin-left: 20px">Courage and intelligence</span>
                <br />
                <br />
                <br />
                <span><a href="http://www.mrsgx.cn" style="text-decoration: none">www.mrsgx.cn</a> ©2017 ShaoGuoXin 备案:晋ICP备16008592</span>
            </div>

        </div>

    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="WebSite.subsite.Graduate.Main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>全国研究生招生院校总览</title>
    <script src="../Graduate/GraduateJs/jquery-3.1.0.min.js"></script>
    <!-- jsfile-->
    <script src="../Graduate/GraduateJs/DomControl.js"></script>
    <!-- cssfile-->
    <link href="../Graduate/GraduateCss/div/divPanel.css" rel="stylesheet" />
    <link href="http://www.mrsgx.cn/css/txt/txt.css" rel="stylesheet" />
    <link href="../Graduate/GraduateCss/btn/btn.css" rel="stylesheet" />
    <link href="http://www.mrsgx.cn/css/btn/btn.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="leftpanel" class="divLeftPanel">
            <div class="LeftPanel-Top"><a class="txt-tips" style="float: left; margin-top: 10px">选择地区>></a><input type="button" class="btn-submit" style="position: relative;" value="隐藏" /></div>
            <div class="LeftPanel-Bottom" dir="rtl" id="SchoolContent">
            </div>
            <a class="smalldir">...</a><br />
            <a style="margin-left: 10%; color: white">www.mrsgx.cn ©2017 ShaoGuoXin </a>


        </div>
        <div class="divRightPanel">
            <iframe src="../Graduate/SchoolList.aspx" name="SubPage" class="diviFrame"></iframe>
        </div>
    </form>
    <script src="../Graduate/GraduateJs/BehindJS.js"></script>
</body>
</html>
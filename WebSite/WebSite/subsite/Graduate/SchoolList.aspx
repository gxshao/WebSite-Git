<%@ Page Language="C#" AutoEventWireup="true" Inherits="WebSite.subsite.Graduate.SchoolList" Codebehind="SchoolList.aspx.cs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="GraduateJs/jquery-3.1.0.min.js"></script>
    <link href="GraduateCss/div/divPanel.css" rel="stylesheet" />
    <script src="GraduateJs/LoadPage.js"></script>
    <link href="../../css/btn/btn.css" rel="stylesheet" />
    <link href="../../css/txt/Txt.css" rel="stylesheet" />
    <link href="../../css/div/LoadPage.css" rel="stylesheet" />
    <link href="../../css/table/table.css" rel="stylesheet" />
    <link href="GraduateCss/btn/btn.css" rel="stylesheet" />
    <link href="GraduateCss/txt/Txt.css" rel="stylesheet" />
</head>
<body style="margin-top: 0px; margin-left: 0px;">
    <form id="form1" runat="server">
        <div class="MaskLayer">
            <div class="ProcessBar">
                <div class="divRect">
                    <div class="div1 div"></div>
                    <div class="div2 div"></div>
                    <div class="div3 div"></div>
                    <div class="div4 div"></div>
                    <div class="div5 div"></div>
                    <div class="div6 div"></div>
                </div>
                <a id="loadtext" style="color: wheat; margin-left: 40px; font-size: 25px;"></a>
            </div>
        </div>

        <div>
            <table class="table" id="schoollist">
                <tr>
                    <th style="width: 15%; border: 1px dashed white;">学校代码</th>
                    <th style="border: 1px dashed white;">学校名称</th>
                    <th style="width: 15%; border: 1px dashed white;">学校性质</th>
                    <th style="border: 1px dashed white;">官方网站</th>
                    <th style="width: 15%; border: 1px dashed white;">详细信息</th>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>

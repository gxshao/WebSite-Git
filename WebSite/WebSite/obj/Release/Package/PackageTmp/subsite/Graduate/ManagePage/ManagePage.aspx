<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManagePage.aspx.cs" Inherits="subsite_Graduate_ManagePage_ManagePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>后台管理页</title>
    <script src="../../js/jquery-3.1.0.min.js"></script>
    <script src="../../js/GraduateJs/ManageJs.js"></script>
    <link href="../../css/GraduateCss/div/managepage.css" rel="stylesheet" />
    <link href="../../css/div/dragdiv.css" rel="stylesheet" />
    <link href="../../css/GraduateCss/btn/btn.css" rel="stylesheet" />
    <link href="../../css/GraduateCss/txt/Txt.css" rel="stylesheet" />
    <link href="../../css/btn/btn.css" rel="stylesheet" />
    <link href="../../css/GraduateCss/txt/style.css" media="screen" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="window noselect" id="area" style="margin: auto; left: 0; right: 0; top: 20px; height: 150px;">
                <div id="mask-area" hidden="hidden" style="background-color: grey; z-index: 999; height: 100%; width: 100%; position: absolute; opacity: 0.3"></div>
                <div class="pew">
                    地区
                </div>
                <div class="container">
                    <select id="Sel_Area" onchange="document.getElementById('areatemp').value=this.value;" class="SelectorTxt">
                        <option value="">---请选择地区---</option>
                    </select>
                    <input type="button" id="SchoolKey" class="btn-Search" style="float: right; margin-right: 30px; margin-top: 5px;" value="选择" />
                </div>
            </div>
            <div class="window noselect" id="school" hidden="hidden" style="margin-left: -250px; top: 200px; left: 50%;">
                <div id="mask-school" hidden="hidden" style="background-color: grey; z-index: 999; height: 100%; width: 100%; position: absolute; opacity: 0.3"></div>
                <div class="pew" style="background-color: #336680">
                    学校
            <div class="btn-close" onclick="CloseDIV('#school','#mask-area');">X</div>
                </div>
                <div class="container">
                    <select id="Sel_Scho" onchange="document.getElementById('schooltemp').value=this.value;" class="SelectorTxt">
                        <option value="">---请选择学校---</option>
                    </select>
                    <select id="Sel_Cate" onchange="document.getElementById('collectivecode').value=this.value;" class="SelectorTxt">
                        <option value="">---请选择大类---</option>
                    </select>
                    <select id="Sel_Year" runat="server" class="SelectorTxt" style="margin-top: 10px; float: left; margin-left: 40px;">
                        <option value="">---请选择年份---</option>
                        <option value="2015">2015</option>
                        <option value="2014">2014</option>
                        <option value="2013">2013</option>
                        <option value="2012">2012</option>
                    </select>
                    <input type="button" id="AddAll" class="btn-Search" style="float: right; margin-right: 50px; margin-top: 20px;" value="选择" />
                    <div style="float: right; margin-right: 50px; margin-top: 10px;">
                        <hr class="hr" />
                        <div style="margin: 0 auto; margin-top: 20px; height: 50px; width: inherit;">
                            <input type="text" name="textfield" id="SchoolPath" class="txt" />
                            <asp:FileUpload CssClass="file" ID="SchoolField" runat="server" onchange="document.getElementById('SchoolPath').value=this.value" />
                            <input type="button" id="AddSchool" class="btn-Search" value="导入" />
                            <input type="button" id="LoadingSchool" class="btn-Search" onclick="loadTxt('SchoolField', 'schoolinfo')" value="上传" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="window noselect" id="scores" hidden="hidden" style="margin-top: 520px; left: 20%;">
                <div class="pew" style="background-color: #336670">
                    分数线
            <div class="btn-close" onclick="CloseDIV('#scores','#mask-school');">X</div>
                </div>
                <div class="container">

                    <hr class="hr" />
                    <div style="margin: 0 auto; margin-right: 20px; margin-top: 30px; height: 50px; width: inherit;">
                        <input type="text" name="textfield" id="ScoresPath" disabled="disabled" class="txt" />
                        <asp:FileUpload runat="server" CssClass="file" ID="ScoresField" onchange="document.getElementById('ScoresPath').value=this.value" />
                        <input type="button" id="AddScores" class="btn-Search" value="导入" />
                        <input type="button" id="LoadingScores" class="btn-Search" onclick="loadTxt('ScoresField', 'scoreinfo')" value="上传" />
                    </div>

                </div>
            </div>
            <div class="window noselect" id="major" hidden="hidden" style="margin-top: 520px; left: 50%;">
                <div class="pew" style="background-color: #336670">
                    专业
            <div class="btn-close" onclick="CloseDIV('#major','#mask-school');">X</div>
                </div>
                <div class="container">
                    <!--<select id="Sel_Major" class="SelectorTxt"><option value="">---请选择专业---</option></select>
           <input type="button" id="AddMajora" class="btn-Search" style="float:right;margin-right:50px;margin-top:50px;"  value="选择"/>
             -->
                    <hr class="hr" />
                    <div style="margin: 0 auto; margin-right: 20px; margin-top: 30px; height: 50px; width: inherit;">
                        <input type="text" name="textfield" disabled="disabled" id="MajorPath" class="txt" />
                        <asp:FileUpload runat="server" type="file" name="fileField" class="file" ID="MajorField" onchange="document.getElementById('MajorPath').value=this.value" />
                        <input type="button" id="AddMajor" class="btn-Search" value="导入" />
                        <input type="button" id="LoadingMajor" class="btn-Search" onclick="loadTxt('MajorField', 'marjorinfo')" value="上传" />
                    </div>
                </div>
            </div>
        </div>
        <div hidden="hidden">
            <asp:Button runat="server" ID="loadtxt" OnClick="LoadTxtClick" />
            <a id="type" runat="server"></a>
            <input id="what" runat="server" />
            <input id="areatemp" runat="server" />
            <input id="schooltemp" runat="server" />
            <input id="collectivecode" runat="server" />
        </div>

    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Details.aspx.cs" Inherits="WebSite.subsite.Graduate.Details" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>


    <script src="GraduateJs/jquery-3.1.0.min.js"></script>
    <script src="GraduateJs/details.js"></script>
    <link href="GraduateCss/div/table.css" rel="stylesheet" />
    <link href="GraduateCss/div/divPanel.css" rel="stylesheet" />
    <link href="GraduateCss/txt/Txt.css" rel="stylesheet" />
    <link href="GraduateCss/btn/btn.css" rel="stylesheet" />
  
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="navgator">
                <div class="BoldLine"></div>
                <a class="TxtTips">学校:</a><a id="schoolname" class="TxtTips"></a>
                <a class="TxtTips">年份:</a>
                <select class="SelectorTxt" id="mTimes">
                    <option value="2015">2015</option>
                    <option value="2014">2014</option>
                    <option value="2013">2013</option>
                    <option value="2012">2012</option>
                </select>
                <a class="TxtTips">学位类型:</a><select class="SelectorTxt" id="mDegs">
                    <option value="ALL">全部</option>
                    <option value="X">学术学位</option>
                    <option value="Z">专业学位</option>
                </select>
                <a class="TxtTips">关键字:</a><input type="text" class="inputContent" value="专业名称或研究方向" id="keywords" onfocus="if(value==defaultValue){value='';this.style.color='#000'}" onblur="if(!value){value=defaultValue;this.style.color='#999'}" /><input type="button" class="btn-Search" onclick="filterData();" value="筛选" />
            </div>
            <table class="table" style="margin-top: 43px; margin-left: -8px" id="FullScores">
                <tr>
                    <th style="min-width: 100px; border: 1px dashed white;">专业代码</th>
                    <th style="min-width: 150px; border: 1px dashed white;">专业名称</th>
                    <th style="min-width: 150px; border: 1px dashed white;">研究方向</th>
                    <th style="min-width: 30px; border: 1px dashed white;">政治</th>
                    <th style="min-width: 30px; border: 1px dashed white;">外语</th>
                    <th style="min-width: 30px; border: 1px dashed white;">业务课1</th>
                    <th style="min-width: 40px; border: 1px dashed white;">业务课2</th>
                   <!-- <th style="min-width: 40px; border: 1px dashed white;">专业课2</th> -->
                    <th style="min-width: 30px; border: 1px dashed white;">总分</th>
                    <th style="min-width: 20px; border: 1px dashed white;">人数</th>
                    <th style="min-width: 20px; border: 1px dashed white;">大类</th>
                </tr>

            </table>
        </div>
    </form>
</body>
</html>

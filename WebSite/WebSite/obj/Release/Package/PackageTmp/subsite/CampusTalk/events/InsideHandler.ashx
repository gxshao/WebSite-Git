<%@ WebHandler Language="C#" Class="InsideHandler" %>

using System;
using System.Web;
using System.Collections;
using Newtonsoft.Json;
using WebSite.App_Code.Obj.CampusTalk;
using WebSite.App_Code.Utils;
public class InsideHandler: IHttpHandler
{

    //1.GPS坐标信息采集
    private HttpContext Content = null;
    string ServerPath = "";
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        Content = context;
        string key = "";
        key = Content.Request["key"];
        if (key == null || key.Equals(""))
        {
            context.Response.Write("非法访问已记录,时间:" + DateTime.Now.ToString());
            return;
        }
        int sum = CTAreaPool.getInstance().Count;
        int sumSchool = CTAreaPool.getInstance().SchoolCount;
        string result = "在线总人数:" + sum + "   在线所有学校:" + sumSchool;
        string people = "\n";
        foreach (string x in CTAreaPool.getInstance().getAllStuNickname()) {
            people += x + "\n";
        }
        result += people;
        context.Response.Write(result);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
<%@ WebHandler Language="C#" Class="ctGpsInfo" %>

using System;
using System.Web;
using System.Collections;
using Newtonsoft.Json;
using WebSite.App_Code.Obj.CampusTalk;
using WebSite.App_Code.Utils;
public class ctGpsInfo : IHttpHandler
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
        CTData<bool> res_gps = new CTData<bool>();
        res_gps.DataType = CTData<bool>.DATATYPE_REPLY;
        string json_location = context.Request.QueryString["gps"];
        if (json_location!=null)
        {
            context.Response.Write(JsonConvert.SerializeObject(res_gps));
            return;
        }
        ArrayList list = JsonConvert.DeserializeObject<ArrayList>(json_location);

        res_gps.Body = SQLOP.getInstance().AddGpsInfo(list) > 0;
        context.Response.Write(JsonConvert.SerializeObject(res_gps));
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
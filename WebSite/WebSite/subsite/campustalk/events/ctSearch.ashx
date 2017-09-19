<%@ WebHandler Language="C#" Class="ctSearch" %>

using System;
using System.Web;

public class ctSearch : IHttpHandler {
    
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

    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}
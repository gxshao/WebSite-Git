<%@ WebHandler Language="C#" Class="ctMatch" %>

using System;
using System.Web;
using WebSite.App_Code.Obj.CampusTalk;
using Newtonsoft.Json;
public class ctMatch : IHttpHandler
{

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
        HandleKeyEvents(key);
    }
    public void HandleKeyEvents(string key)
    {
        CTData<bool> res = new CTData<bool>();
        res.DataType = CTData<bool>.DATATYPE_REPLY;
        res.Body = false;
        string uid = Content.Request["uid"];
        string schoolcode = Content.Request["schoolcode"];
        if (uid == null || schoolcode == null)
        {
            //返回wrong
            Content.Response.Write(JsonConvert.SerializeObject(res));
            return;
        }
        switch (key)
        {
            case "match":
                //将该用户移动到 匹配表中
                res.Body = CTAreaPool.getInstance().moveUser(GlobalVar.STATE_PENDING, uid, schoolcode);;
                break;  
            case "quit":
                //单项退出的同时，匹配到的对象进入Pending模式，如果没有匹配到的对象则自己退出
                res.Body =   CTAreaPool.getInstance().moveUser(GlobalVar.STATE_NONE, uid, schoolcode);;
                break;
        }
        Content.Response.Write(JsonConvert.SerializeObject(res));
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}
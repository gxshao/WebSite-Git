<%@ WebHandler Language="C#" Class="ctMatch" %>

using System;
using System.Web;

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
        string uid = Content.Request["uid"];
        string schoolcode =Content.Request["schoolcode"];
        if (uid==null||schoolcode==null) {
            //返回wrong
            return;
        }
        switch (key)
        {
            case "match":
                //将该用户移动到 匹配表中
                bool x=CTAreaPool.getInstance().moveUser(GlobalVar.STATE_PENDING,uid,schoolcode);
                Content.Response.Write("通知客户端进入pending状态");
                break;
            case "quit":
                //单项退出的同时，匹配到的对象进入Pending模式，如果没有匹配到的对象则自己退出
                CTAreaPool.getInstance().moveUser(GlobalVar.STATE_NONE,uid,schoolcode);
                Content.Response.Write("通知客户端退出！");
                break;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}
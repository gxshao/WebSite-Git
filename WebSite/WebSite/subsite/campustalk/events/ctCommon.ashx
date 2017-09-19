<%@ WebHandler Language="C#" Class="ctCommon" %>

using System;
using System.Web;
using System.Collections;
using WebSite.App_Code.Obj.CampusTalk;
using Newtonsoft.Json;
using WebSite.App_Code.Utils;
public class ctCommon : IHttpHandler
{

    private HttpContext Content = null;
    string ServerPath = "";
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        Content = context;
        string key = "";
        key = Content.Request["key"];
        //||context.Request.HttpMethod=="GET"
        if (key == null || key.Equals(""))
        {
            context.Response.Write("非法访问已记录,时间:" + DateTime.Now.ToString());
            return;
        }
        HandleKeyEvents(key);
    }
    /// <summary>
    /// 1.获取关注好友列表
    /// 2.获取用户资料
    /// 3.上传系统
    /// 4.关注和取消关注
    /// 5.签到系统
    /// 6.资料完善
    /// </summary>
    private void HandleKeyEvents(string key)
    {
        switch (key)
        {
            case "getUserProfile":
                {
                    CTData<CTPerson> res_user = new CTData<CTPerson>();
                    res_user.DataType = CTData<CTPerson>.DATATYPE_REPLY;
                    string id = Content.Request.QueryString["uid"].ToString();
                    if (id.Equals(""))
                    {
                        Content.Response.Write(JsonConvert.SerializeObject(res_user));
                        break;
                    }
                    res_user.Body = SQLOP.getInstance().getUserProfile(id);
                    Content.Response.Write(JsonConvert.SerializeObject(res_user));
                    break;
                }
            case "followlist":
                CTData<ArrayList> res_list = new CTData<ArrayList>();
                res_list.DataType = CTData<ArrayList>.DATATYPE_REPLY;
                string uid = Content.Request.QueryString["uid"].ToString();
                if (uid.Equals(""))
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_list));
                    break;
                }
                res_list.Body = SQLOP.getInstance().getFollowlist(uid);
                Content.Response.Write(JsonConvert.SerializeObject(res_list));
                break;
            case "follow":
                CTData<bool> res_follow = new CTData<bool>();
                res_follow.Body = GlobalVar.FAIL;
                res_follow.DataType = CTData<bool>.DATATYPE_REPLY;
                string mid = Content.Request.QueryString["uid"].ToString();
                string tid = Content.Request.QueryString["tid"].ToString();
                string op = Content.Request.QueryString["op"].ToString(); // 1=关注 0=取消
                if (mid.Equals("") || tid.Equals("") || op.Equals(""))
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_follow));
                    break;
                }
                if (op.Equals("0"))
                {
                    res_follow.Body = SQLOP.getInstance().cancelfollow(mid, tid) > 0;
                }
                else if (op.Equals("1"))
                {
                    res_follow.Body = SQLOP.getInstance().followtid(mid, tid) > 0;
                }
                Content.Response.Write(JsonConvert.SerializeObject(res_follow));
                break;
            case "Sign":
                //业务加金币
                CTData<bool> res_sign = new CTData<bool>();
                res_sign.Body = GlobalVar.FAIL;
                res_sign.DataType = CTData<bool>.DATATYPE_REPLY;
                string sid = Content.Request.QueryString["uid"].ToString();
                if (sid.Equals(""))
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_sign));
                    break;
                }
                res_sign.Body = SQLOP.getInstance().AddSign(sid) > 0;
                Content.Response.Write(JsonConvert.SerializeObject(res_sign));
                break;
            case "updateprofile":
                CTData<bool> res_pro = new CTData<bool>();
                res_pro.Body = GlobalVar.FAIL;
                res_pro.DataType = CTData<bool>.DATATYPE_REPLY;
                string json_user = Content.Request.QueryString["user"].ToString();
                if (json_user.Equals(""))
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_pro));
                    break;
                }
                
                res_pro.Body = SQLOP.getInstance().updateProfile(JsonConvert.DeserializeObject<CTPerson>(json_user)) > 0;
                Content.Response.Write(JsonConvert.SerializeObject(res_pro));
                break;
            case "uploadheadpic": break;
            case "uploadstucard": break;

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
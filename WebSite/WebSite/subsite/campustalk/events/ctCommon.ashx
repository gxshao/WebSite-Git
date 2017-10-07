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
    /// 7.获取地区和学校
    /// </summary>
    private void HandleKeyEvents(string key)
    {
        string uid = Content.Request.QueryString["uid"];
        switch (key)
        {
            case "getUserProfile":
                {
                    CTData<CTPerson> res_user = new CTData<CTPerson>();
                    res_user.DataType = CTData<CTPerson>.DATATYPE_REPLY;
                    if (uid==null)
                    {
                        Content.Response.Write(JsonConvert.SerializeObject(res_user));
                        break;
                    }
                    res_user.Body = SQLOP.getInstance().getUserProfile(uid);
                    Content.Response.Write(JsonConvert.SerializeObject(res_user));
                    break;
                }
            case "followlist":
                CTData<ArrayList> res_list = new CTData<ArrayList>();
                res_list.DataType = CTData<ArrayList>.DATATYPE_REPLY;

                if (uid==null)
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
                string tid = Content.Request.QueryString["tid"];
                string op = Content.Request.QueryString["op"]; // 1=关注 0=取消
                if (uid==null || tid==null || op==null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_follow));
                    break;
                }
                if (op.Equals("0"))
                {
                    res_follow.Body = SQLOP.getInstance().cancelfollow(uid, tid) > 0;
                }
                else if (op.Equals("1"))
                {
                    res_follow.Body = SQLOP.getInstance().followtid(uid, tid) > 0;
                }
                Content.Response.Write(JsonConvert.SerializeObject(res_follow));
                break;
            case "Sign":
                //业务加金币
                CTData<bool> res_sign = new CTData<bool>();
                res_sign.Body = GlobalVar.FAIL;
                res_sign.DataType = CTData<bool>.DATATYPE_REPLY;
                if (uid==null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_sign));
                    break;
                }
                res_sign.Body = SQLOP.getInstance().AddSign(uid) > 0;
                Content.Response.Write(JsonConvert.SerializeObject(res_sign));
                break;
            case "updateprofile":
                CTData<bool> res_pro = new CTData<bool>();
                res_pro.Body = GlobalVar.FAIL;
                res_pro.DataType = CTData<bool>.DATATYPE_REPLY;
                string json_user = Content.Request.QueryString["user"];
                if (json_user==null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_pro));
                    break;
                }

                res_pro.Body = SQLOP.getInstance().updateProfile(JsonConvert.DeserializeObject<CTPerson>(json_user)) > 0;
                Content.Response.Write(JsonConvert.SerializeObject(res_pro));
                break;
            case "uploadheadpic":
                CTData<string> res_headpic = new CTData<string>();
                res_headpic.DataType = CTData<string>.DATATYPE_REPLY;
                res_headpic.Body = "";
                if (uid==null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_headpic));
                    break;
                }
                HttpPostedFile uploader = Content.Request.Files[0];
                if (uploader == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_headpic));
                    break;
                }
                else
                {
                    string fileName = uploader.FileName;
                    string suffix = fileName.Substring(fileName.LastIndexOf(".")).ToLower();
                    if (ctUtils.IsImage(suffix))
                    {
                        string picname = Guid.NewGuid().ToString();
                        string url = HttpContext.Current.Server.MapPath("~/subsite/CampusTalk/images/headpic/" + picname + suffix);
                        uploader.SaveAs(url);//保存图片  
                        res_headpic.Body =picname + suffix;
                        SQLOP.getInstance().updateHeadpic(res_headpic.Body, uid);
                    }
                    Content.Response.Write(JsonConvert.SerializeObject(res_headpic));
                }
                break;
            case "uploadstucard":
                CTData<string> res_stucard = new CTData<string>();
                res_stucard.DataType = CTData<string>.DATATYPE_REPLY;
                res_stucard.Body = "";
                if (uid==null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_stucard));
                    break;
                }
                HttpPostedFile upload = Content.Request.Files[0];
                if (upload == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_stucard));
                    break;
                }
                else
                {
                    string fileName = upload.FileName;
                    string suffix = fileName.Substring(fileName.LastIndexOf(".")).ToLower();
                    if (ctUtils.IsImage(suffix))
                    {
                        string picname = Guid.NewGuid().ToString();
                        string url = HttpContext.Current.Server.MapPath("~/subsite/CampusTalk/images/stucard/" + picname + suffix);
                        upload.SaveAs(url);//保存图片
                        SQLOP.getInstance().updateStucard(picname + suffix, uid);
                        res_stucard.Body =picname + suffix;
                    }
                    Content.Response.Write(JsonConvert.SerializeObject(res_stucard));
                }
                break;
            case "schoolinfo":
                CTData<string> res_schoolinfo = new CTData<string>();
                res_schoolinfo.DataType = CTData<string>.DATATYPE_REPLY;
                res_schoolinfo.Body = "";
                ArrayList areas=SQLOP.getInstance().getAreaList();
                ArrayList schools = SQLOP.getInstance().getSchoolList();
                string str_area = JsonConvert.SerializeObject(areas);
                string str_shool = JsonConvert.SerializeObject(schools);
                res_schoolinfo.Body = str_area + "$" + str_shool;
                Content.Response.Write(JsonConvert.SerializeObject(res_schoolinfo));
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
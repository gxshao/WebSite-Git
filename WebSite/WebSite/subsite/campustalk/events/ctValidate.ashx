<%@ WebHandler Language="C#" Class="ctValidate" %>

using System;
using System.Web;
using System.Data.SqlClient;
public class ctValidate : IHttpHandler
{
    private HttpContext Content = null;
    string ServerPath = "";
    HttpCookie cookie = new HttpCookie("MRSGXCOOKIE");
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
        ServerPath = Content.Server.MapPath("/");
        HandleKeyEvents(key);
        /************************2017/09/05 邵国鑫**************/
        //1.获取邮箱验证码 done
        //2.注册信息校验
        //3.登录信息校验
        //4.忘记密码
        //5.修改密码
        //6.已存在用户校验
        /**********************************************************/

    }
    public void HandleKeyEvents(string key)
    {
        string result = "";
        switch (key)
        {
            case "sendcode":
                string emailAddress = Content.Request.QueryString["email"].ToString();

                if (ctEMail.getInstance().senMail(emailAddress, TempCode.getInstance().getRandomCode()))
                {
                    result = "success";
                }
                else {
                    result = "fail";
                }
                Content.Response.Write(result);
                break;
            case "regesiter": break;
            case "login":
                //返回个人资料

                break;
            case "forgotpass": break;
            case "changepass": break;
            case "checkuser": break;

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
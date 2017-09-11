<%@ WebHandler Language="C#" Class="ctValidate" %>

using System;
using System.Web;
using System.Data;
using WebSite.App_Code.Obj.CampusTalk;
using Newtonsoft.Json;

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
        DataTable dt_res = new DataTable();
        string emailAddress = "";
        switch (key)
        {
            case "sendcode":
                CTData<String> ans = new CTData<String>();
                ans.DataType = CTData<String>.DATATYPE_REPLY;
                emailAddress = Content.Request.QueryString["email"].ToString();

                if (ctEMail.getInstance().senMail(emailAddress, TempCode.getInstance().getRandomCode()))
                {
                    ans.Body = GlobalVar.SUCCESS;
                }
                else
                {
                    ans.Body = GlobalVar.Fail;
                }

                Content.Response.Write(JsonConvert.SerializeObject(ans));
                break;
            case "regesiter": break;
            case "login":
                //返回个人资料
                CTData<CTPerson> logdata = new CTData<CTPerson>();
                logdata.DataType = CTData<CTPerson>.DATATYPE_REPLY;
                emailAddress = Content.Request.QueryString["email"].ToString();
                string pass = Content.Request.QueryString["pass"].ToString();
                if (emailAddress.Equals("") || pass.Equals(""))
                {
                    logdata.Body = new CTPerson();
                }
                else
                {
                    CTPerson person = new CTPerson();
                    logdata.Body = person;
                    string loginsql = "select * from " + GlobalVar.User.TABLE_USER + " where " + GlobalVar.User.EMAIL + "='" + emailAddress + "'";
                    dt_res = ctSqlHelper.getInstance().Query(loginsql);
                    if (dt_res != null && dt_res.Rows.Count > 0)  //判断账号是否存在
                    {
                        person.Email = dt_res.Rows[0][GlobalVar.User.EMAIL].ToString();
                        if (dt_res.Rows[0][GlobalVar.User.PASSWORD].ToString().Equals(pass))
                        { //密码是否正确
                            person.Uid = dt_res.Rows[0][GlobalVar.User.UID].ToString();
                            person.Age = dt_res.Rows[0][GlobalVar.User.AGE].ToString();
                            person.School = new CTSchool();
                            person.School.SCode=dt_res.Rows[0][GlobalVar.User.SCHOOLCODE].ToString();
                            DataTable dt = ctSqlHelper.getInstance().Query("select " + GlobalVar.SchoolInfo.SCHOOLNAME + " from " + GlobalVar.SchoolInfo.TABLE_SCHOOLINFO + " where " + GlobalVar.SchoolInfo.SCHOOLCODE + "='" + person.School.SCode + "'");
                            if (dt.Rows.Count > 0)
                            {
                                person.School.SName = dt.Rows[0][0].ToString();
                            }
                            person.Headpic = dt_res.Rows[0][GlobalVar.User.HEADPIC].ToString();
                            person.Sex = dt_res.Rows[0][GlobalVar.User.SEX].ToString();
                            person.Userexplain = dt_res.Rows[0][GlobalVar.User.USEREXPLAIN].ToString();
                            person.State = dt_res.Rows[0][GlobalVar.User.STATE].ToString();
                            person.Nickname = dt_res.Rows[0][GlobalVar.User.NICKNAME].ToString();
                        }
                    }
                }
                Content.Response.Write(JsonConvert.SerializeObject(logdata));
                logdata = null;
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
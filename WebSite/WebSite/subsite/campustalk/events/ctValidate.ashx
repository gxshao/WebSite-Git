<%@ WebHandler Language="C#" Class="ctValidate" %>

using System;
using System.Web;
using System.Data;
using WebSite.App_Code.Obj.CampusTalk;
using Newtonsoft.Json;
using WebSite.App_Code.Utils;

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
            context.Response.Write("非法访问已记录,时间:" + DateTime.Now.ToString()+"   ip:"+context.Request.UserHostAddress);
            return;
        }
        ServerPath = Content.Server.MapPath("/");
        HandleKeyEvents(key);
        /************************2017/09/05 邵国鑫**************/
        //1.获取邮箱验证码 done
        //2.注册信息校验 done
        //3.登录信息校验 done
        //4.忘记密码  //独立页面处理
        //5.修改密码  //独立页面处理
        //6.已存在用户校验 done
        /**********************************************************/

    }
    public void HandleKeyEvents(string key)
    {
        DataTable dt_res = new DataTable();
        string emailAddress = "";
        switch (key)
        {
            case "sendcode":
                CTData<bool> ans = new CTData<bool>();
                ans.DataType = CTData<String>.DATATYPE_REPLY;
                emailAddress = Content.Request.QueryString["email"].ToString();

                if (ctEMail.getInstance().sendMail(emailAddress, TempCode.getInstance().getRandomCode()))
                {
                    ans.Body = GlobalVar.SUCCESS;
                }
                else
                {
                    ans.Body = GlobalVar.FAIL;
                }

                Content.Response.Write(JsonConvert.SerializeObject(ans));
                break;
            case "regesiter":
                if (Content.Request.HttpMethod != "POST")
                    break;
                CTData<CTPerson> res_user = new CTData<CTPerson>();
                res_user.DataType = CTData<CTUser>.DATATYPE_REPLY;
                res_user.Body = new CTPerson();
                string code = Content.Request.QueryString["code"].ToString();
                if (TempCode.getInstance().ValidateCode(code))
                {

                    string json_user = Content.Request.QueryString["user"].ToString();
                    try
                    {
                        CTPerson tmp_user = JsonConvert.DeserializeObject<CTPerson>(json_user);
                        if (tmp_user != null)
                        {
                            string uid = Guid.NewGuid().ToString();
                            uid += tmp_user.Sex;
                            tmp_user.Uid = uid;
                            if (SQLOP.getInstance().AddUser(tmp_user) > 0)
                            {
                                res_user.Body = tmp_user;
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                    }
                }
                Content.Response.Write(JsonConvert.SerializeObject(res_user));
                break;
            case "login":
                //返回个人资料
                if (Content.Request.HttpMethod != "POST")
                    break;
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
                            person.School.SCode = dt_res.Rows[0][GlobalVar.User.SCHOOLCODE].ToString();
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
            case "checkemail":
                CTData<bool> res_ckemail = new CTData<bool>();
                res_ckemail.DataType = CTData<String>.DATATYPE_REPLY;
                emailAddress = Content.Request.QueryString["email"].ToString();

                if (SQLOP.getInstance().CheckEmailValidate(emailAddress))
                {
                    res_ckemail.Body = GlobalVar.SUCCESS;
                }
                else
                {
                    res_ckemail.Body = GlobalVar.FAIL;
                }
                Content.Response.Write(JsonConvert.SerializeObject(res_ckemail));
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
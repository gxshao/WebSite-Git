﻿<%@ WebHandler Language="C#" Class="ctValidate" %>

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
            context.Response.Write("非法访问已记录,时间:" + DateTime.Now.ToString() + "   ip:" + context.Request.UserHostAddress);
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
                ans.Body = GlobalVar.FAIL;
                emailAddress = Content.Request.QueryString["email"];
                if (emailAddress == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(ans));
                    break;
                }
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
                string code = Content.Request.QueryString["code"];
                string json_user = Content.Request.QueryString["user"];
                if (code == null || json_user == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_user));
                    break;
                }
                if (TempCode.getInstance().ValidateCode(code))
                {
                    try
                    {
                        CTPerson tmp_user = JsonConvert.DeserializeObject<CTPerson>(json_user);
                        if (tmp_user != null)
                        {
                            string uid = Guid.NewGuid().ToString();
                            uid += tmp_user.Sex;
                            tmp_user.Uid = uid;
                            tmp_user.State = GlobalVar.USER_STATE_UNATH;
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
                emailAddress = Content.Request.QueryString["email"];
                string pass = Content.Request.QueryString["pass"];
                if (emailAddress == null || pass == null)
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
                            person.Stucard = dt_res.Rows[0][GlobalVar.User.STUCARD].ToString();
                            person.Nickname = dt_res.Rows[0][GlobalVar.User.NICKNAME].ToString();
                        }
                    }
                }
                Content.Response.Write(JsonConvert.SerializeObject(logdata));
                logdata = null;
                break;
            case "forgotpass":
                CTData<bool> f_email = new CTData<bool>();
                f_email.DataType = CTData<String>.DATATYPE_REPLY;
                f_email.Body = GlobalVar.FAIL;
                emailAddress = Content.Request.QueryString["email"];
                if (emailAddress == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(f_email));
                    break;
                }
                if (ctEMail.getInstance().sendMail(emailAddress, TempCode.getInstance().getRandomCode()))
                {
                    f_email.Body = GlobalVar.SUCCESS;
                }
                else
                {
                    f_email.Body = GlobalVar.FAIL;
                }

                Content.Response.Write(JsonConvert.SerializeObject(f_email));
                break;
            case "changepass":
                if (Content.Request.HttpMethod != "POST")
                    break;
                CTData<CTPerson> ch_pass = new CTData<CTPerson>();
                ch_pass.DataType = CTData<CTUser>.DATATYPE_REPLY;
                ch_pass.Body = new CTPerson();
                emailAddress = Content.Request.QueryString["email"];
                string json_pass = Content.Request.QueryString["pass"];
                if (emailAddress == null || json_pass == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(json_pass));
                    break;
                }
                else
                {
                    CTPerson person = new CTPerson();
                    ch_pass.Body = person;
                    string loginsql = "select * from " + GlobalVar.User.TABLE_USER + " where " + GlobalVar.User.EMAIL + "='" + emailAddress + "'";
                    dt_res = ctSqlHelper.getInstance().Query(loginsql);
                    if (dt_res != null && dt_res.Rows.Count > 0)  //判断账号是否存在
                    {
                        person.Email = dt_res.Rows[0][GlobalVar.User.EMAIL].ToString();
                        if (dt_res.Rows[0][GlobalVar.User.PASSWORD].ToString().Equals(ch_pass))
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
                Content.Response.Write(JsonConvert.SerializeObject(ch_pass));
                ch_pass = null;
                break;
            case "ckemail":
                CTData<bool> res_ckemail = new CTData<bool>();
                res_ckemail.DataType = CTData<String>.DATATYPE_REPLY;
                emailAddress = Content.Request.QueryString["email"];
                if (emailAddress == null)
                {
                    Content.Response.Write(JsonConvert.SerializeObject(res_ckemail));
                    break;
                }
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
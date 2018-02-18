<%@ WebHandler Language="C#" Class="HandMsg" %>

using System;
using System.Web;
using System.IO;
using Tools;
using System.Data;
using System.Data.SqlClient;

public class HandMsg : IHttpHandler
{
    private string key = "";
    private HttpContext Content = null;
    Encryption en = new Encryption();
    string ServerPath = "";
    string conn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnString"].ToString();
    SqlConnection sc;
    HttpCookie cookie = new HttpCookie("MRSGXCOOKIE");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        Content = context;
        key = Content.Request["key"];
        if (key==null) {
            context.Response.Write("别瞎搞好吗··");
            return;
        }
        key = en.Decode(key);
        ServerPath = Content.Server.MapPath("/");
        //conn = en.Decode(conn);
        HandWithKey();
    }

    private void HandWithKey()
    {
        string text = "";
        try
        {
            if (key.Length <= 0)
                throw new Exception("");
            switch (key)
            {
                case "sign":
                    text = System.IO.File.ReadAllText(ServerPath + "log.txt");
                    break;
                case "login":
                    try
                    {
                        string UserName = Content.Request["usr"];
                        string Password = Content.Request["pwd"];
                        sc = new SqlConnection(conn);
                       
                        sc.Open();
                        DataTable dt_name = Query("select * from userinfo where name='" + UserName + "'");
                        if (dt_name.Rows.Count > 0 && dt_name.Rows.Count != 0)
                        {
                            string pwd = dt_name.Rows[0]["password"].ToString();
                            if (Password.Equals(pwd))
                            {
                                text = "var msg=0;var usr='" + UserName + "'";
                                //添加Cookie信息
                                cookie.Values.Add("UserName", HttpUtility.UrlEncode(UserName));
                                cookie.Expires = DateTime.Now.AddDays(1);
                                HttpContext.Current.Response.AppendCookie(cookie);
                            }
                            else
                            {
                                text = "var msg=-1;";
                            }
                        }
                        else
                        {
                            text = "var msg=-2";
                        }

                    }
                    catch
                    {
                        text = "var msg=-3";
                    }
                    break;
                case "logout":
                    if (cookie != null)
                    {
                        cookie.Expires = DateTime.Today.AddDays(-1);
                        HttpContext.Current.Response.Cookies.Add(cookie);
                        HttpContext.Current.Request.Cookies.Remove("MRSGXCOOKIE");
                        text = "var msg='注销成功！'";
                    }
                    break;
                default:
                    Content.Response.Write(text);
                    break;
            }
            Content.Response.Write(text);
        }
        catch
        {
            Content.Response.Write(text);
        }
    }
    #region 登录查询
    private DataTable Query(string sql)
    {
        SqlCommand sqlcmd = new SqlCommand(sql, sc);
        SqlDataReader sr = sqlcmd.ExecuteReader();
        DataTable dt = new DataTable();
        dt.Load(sr);
        return dt;
    }
    #endregion
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
<%@ WebHandler Language="C#" Class="GraduateInfo" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

public class GraduateInfo : IHttpHandler
{
    private string key = "";
    private string value = "";
    HttpContext Context;
    SqlConnection sc;
    string conn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnString"].ToString(); //important 2016-12-31
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        key = context.Request["key"];
        if (key == null)
        {
            context.Response.Write("Error,出现授权错误，已被记录！IP地址:" + context.Request.UserHostAddress.ToString());
            return;
        }
        value = context.Request["value"];
        Context = context;
        HandlerInfo();
    }
    public void HandlerInfo()
    {
        string result = "";
        JavaScriptSerializer jss = new JavaScriptSerializer();
        if (sc == null)
        {
            sc = new SqlConnection(conn);
            sc.Open();
        }
        switch (key)
        {
            case "GetAllArea":
                List<Area> areas = new List<Area>() { };
                DataTable dtarea = Query("select * from AreaInfo order by ClickRate");
                if (dtarea.Rows.Count > 0)
                {
                    for (int i = 0; i < dtarea.Rows.Count; i++)
                    {
                        Area temp = new Area();
                        temp.ACode = dtarea.Rows[i]["AreaCode"].ToString();
                        temp.AName = dtarea.Rows[i]["AreaName"].ToString();
                        temp.ARate = dtarea.Rows[i]["ClickRate"].ToString();
                        areas.Add(temp);
                    }
                    result = jss.Serialize(areas);
                    Context.Response.Write(result);
                }
                break;
            case "GetSchoolInfo":
                List<School> schools = new List<School>() { };
                DataTable dtschool = Query("select * from SchoolInfo where AreaCode='" + value + "'");
                if (dtschool.Rows.Count > 0)
                {
                    for (int i = 0; i < dtschool.Rows.Count; i++)
                    {
                        School temp = new School();
                        temp.SAttr = dtschool.Rows[i]["SchoolAttr"].ToString();
                        temp.SCode = dtschool.Rows[i]["SchoolCode"].ToString();
                        temp.SLink = dtschool.Rows[i]["SchoolLink"].ToString();
                        temp.SName = dtschool.Rows[i]["SchoolName"].ToString();
                        schools.Add(temp);
                    }
                    //序列化result
                    result = jss.Serialize(schools);
                    Context.Response.Write(result);
                }
                else
                {

                }
                break;
            case "GetMajorInfo":

                break;
            case "GetScores":

                break;
            case "GetCategroy":
                List<Categroy> cates = new List<Categroy>() { };
                DataTable dtcates = Query("select * from Categroy order by id");
                if (dtcates.Rows.Count > 0)
                {
                    for (int i = 0; i < dtcates.Rows.Count; i++)
                    {
                        Categroy temp = new Categroy();
                        temp.CoCode = dtcates.Rows[i]["CollectiveCode"].ToString();
                        temp.CoName = dtcates.Rows[i]["CollectiveName"].ToString();
                        cates.Add(temp);
                    }
                    result = jss.Serialize(cates);
                    Context.Response.Write(result);
                }
                break;
            case "GetAllScores":
                List<AllScores> scores = new List<AllScores>();
                string mTime = Context.Request["time"];
                string mdeg = Context.Request["degree"];
                string lastsql = "";
                if (mdeg != "all")
                {
                   lastsql=" and d.Degree='" + mdeg + "'";
                }
                string sql = "select a.Politics,a.language,a.procourseA,a.procourseB,a.years,a.summary,c.MajorCode,c.MajorName,c.Directions,e.number,d.CollectiveName from Scores a left join SchoolInfo b on a.SchoolCode=b.SchoolCode left join Major c on a.CollectiveCode=c.CollectiveCode left join Categroy d on a.CollectiveCode=d.CollectiveCode left join RecruitNum e on c.majorcode=e.majorcode  where c.SchoolCode='" + value + "' and a.years='" + mTime + "' and a.SchoolCode='"+value+"'" + lastsql;
                DataTable dtscores = Query(sql);
                if (dtscores.Rows.Count > 0)
                {
                    for (int i = 0; i < dtscores.Rows.Count; i++)
                    {
                        AllScores asocore = new AllScores();
                        asocore.MCode = dtscores.Rows[i]["MajorCode"].ToString();
                        asocore.MName = dtscores.Rows[i]["MajorName"].ToString();
                        asocore.MDire = dtscores.Rows[i]["Directions"].ToString();
                        asocore.MPlotics = dtscores.Rows[i]["Politics"].ToString();
                        asocore.MLanguage = dtscores.Rows[i]["language"].ToString();
                        asocore.MPro1 = dtscores.Rows[i]["procourseA"].ToString();
                        asocore.MPro2 = dtscores.Rows[i]["procourseB"].ToString();
                        asocore.MSum = dtscores.Rows[i]["summary"].ToString();
                        asocore.MPeople = dtscores.Rows[i]["number"].ToString();
                        asocore.MColName = dtscores.Rows[i]["CollectiveName"].ToString();
                        asocore.MYears = dtscores.Rows[i]["years"].ToString().Substring(0, 4);
                        scores.Add(asocore);
                    }
                    result = jss.Serialize(scores);
                }
                else
                {
                    result = null;
                }
                Context.Response.Write(result);
                break;
            case "GetSchoolName":
                DataTable dtSchoolName = Query("select SchoolName from SchoolInfo where SchoolCode='" + value + "'");
                if (dtSchoolName.Rows.Count > 0)
                {
                    result = dtSchoolName.Rows[0][0].ToString();
                }
                else
                {
                    result = null;
                }
                Context.Response.Write(result);
                break;
            default:
                Context.Response.Write("Error,出现授权错误，已被记录！IP地址:" + Context.Request.UserHostAddress.ToString());
                break;
        }
        sc.Close();
    }
    #region 查找
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
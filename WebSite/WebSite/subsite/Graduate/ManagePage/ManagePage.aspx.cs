using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class subsite_Graduate_ManagePage_ManagePage : System.Web.UI.Page
{
    string conn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnString"].ToString(); //important 2016-12-31
    SqlConnection sc;
    string ServerPath = "";
    private string selectArea = "", selectSchoolCode = "", selectYears = "", selectCollectvieCode = "";


    protected void Page_Load(object sender, EventArgs e)
    {

        string UserName = "";
        if (!IsPostBack)
        {
            HttpCookie cookie = Request.Cookies["MRSGXCOOKIE"];
            if (cookie != null)
            {
                UserName = HttpUtility.UrlDecode(cookie["UserName"].ToString());
            }
            else
            {
                Response.Redirect("http://www.mrsgx.cn/Main.aspx");
            }
            ServerPath = HttpContext.Current.Server.MapPath("/");
        }
    }

    protected void LoadTxtClick(object sender, EventArgs e)
    {
        StreamReader sr = null;
        FileUpload fu = new FileUpload();
        selectArea = areatemp.Value;
        string sql = "";
        switch (what.Value)
        {
            case "schoolinfo":
                fu = SchoolField;
                break;
            case "marjorinfo":
                selectSchoolCode = schooltemp.Value;
                selectCollectvieCode = collectivecode.Value;
                selectYears = Sel_Year.Value;
                fu = MajorField;
                break;
            case "scoreinfo":
                selectSchoolCode = schooltemp.Value;
                selectCollectvieCode = collectivecode.Value;
                selectYears = Sel_Year.Value;
                fu = ScoresField;
                break;
            default:
                return;
        }
        if (fu.HasFile)
        {
            fu.PostedFile.SaveAs("D:/" + "/cachefile/" + fu.FileName);
        }
        sr = new StreamReader("D:/" + "/cachefile/" + fu.FileName, System.Text.Encoding.UTF8);
        string line = "";

        switch (what.Value)
        {
            case "schoolinfo":
                sql = "insert into SchoolInfo (SchoolCode,SchoolName,SchoolAttr,SchoolLink,AreaCode) values ";
                while ((line = sr.ReadLine()) != null)
                {
                    string[] all = line.Split('-');
                    if (all.Length <= 0)
                    {
                        continue;
                    }
                    sql += "('" + all[0] + "','" + all[1] + "','" + all[2] + "','" + all[3] + "','" + selectArea + "'),";
                }
                sql = sql.Substring(0, sql.Length - 1) + ";";
                break;
            case "marjorinfo":
                sql = "insert into Major (MajorCode,MajorName,Directions,SchoolCode,CollectiveCode,SubjectA,SubjectB,SubjectC,SubjectD,SubjectE) values ";
                string sql2 = " insert into RecruitNum (MajorCode,Years,Number,Remark) values ";
                while ((line = sr.ReadLine()) != null)
                {
                    string[] all = line.Split('-');
                    if (all.Length <= 0)
                    {
                        continue;
                    }
                    string lastmajor = "null";
                    int len = all.Length;
                    if (len > 9)
                        lastmajor = all[9];
                    sql += "('" + all[0] + "','" + all[1] + "','" + all[2] + "','" + selectSchoolCode + "','" + selectCollectvieCode + "','" + all[3] + "','" + all[4] + "','" + all[5] + "','" + all[6] + "','" + lastmajor + "'),";
                    sql2 += "('" + all[0] + "','" + selectYears + "','" + all[7] + "','" + all[8] + "'),";
                }
                sql2 = sql2.Substring(0, sql2.Length - 1) + ";";
                sql = sql.Substring(0, sql.Length - 1) + ";" + sql2;

                break;
            case "scoreinfo":
                sql = "insert into Scores (Politics,Language,ProCourseA,ProCourseB,SchoolCode,Summary,Years,CollectiveCode) values ";
                while ((line = sr.ReadLine()) != null)
                {
                    string[] all = line.Split('-');
                    if (all.Length <= 0)
                    {
                        continue;
                    }
                    sql += "('" +
                         all[0] + "','" +
                         all[1] + "','" +
                         all[2] + "','" +
                         all[3] + "','" +
                        selectSchoolCode + "','" +
                        all[4] + "','" +
                        selectYears + "','" +
                        all[5] + "'),";
                }
                sql = sql.Substring(0, sql.Length - 1) + ";";
                break;
        }
        try
        {
            sc = new SqlConnection(conn);
            sc.Open();
            if (sql != "")
            {
                add(sql);
            }
            /*
            去重操作
            */
            if (what.Value == "marjorinfo")
            {
                subSQL(@"delete from RecruitNum  where MajorCode  
                          in (select  MajorCode  from RecruitNum  group  by MajorCode  
                having  count(MajorCode) > 1) 
                     and id not in (select min(id) from RecruitNum  group by MajorCode  having count(MajorCode) > 1)");
            }
        }
        catch (Exception s)
        {
            Response.Write(s.Message);
        }


        sc.Close();
        sr.Close();
    }
    #region 查找
    private void add(string sql)
    {
        try
        {
            SqlCommand sqlcmd = new SqlCommand(sql, sc);
            sqlcmd.ExecuteScalar();
        }
        catch (Exception e)
        {
           
        }
    }
    #endregion
    private void subSQL(string sql)
    {
        try
        {
            SqlCommand sqlcmd = new SqlCommand(sql, sc);
            sqlcmd.ExecuteScalar();
        }
        catch (Exception e)
        {
           
        }
    }
}
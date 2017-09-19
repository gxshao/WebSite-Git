using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// SqlHelper 的摘要说明
/// </summary>
public class ctSqlHelper
{
    SqlConnection sc;
    string conn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnCampusTalk"].ToString();
    static ctSqlHelper mHelper = null;
    public ctSqlHelper()
    {
        sc = new SqlConnection(conn);
    }
    public static ctSqlHelper getInstance()
    {
        if (mHelper == null)
        {
            mHelper = new ctSqlHelper();
        }
        return mHelper;
    }
    public int executeSql(string sql)
    {
        SqlTransaction tran = null;
        SqlCommand sqlcmd = null;
        if (sc != null)
        {
            try
            {
                sc.Open();
                tran = sc.BeginTransaction();
                sqlcmd = new SqlCommand(sql, sc);
                sqlcmd.Transaction = tran;
                int count=sqlcmd.ExecuteNonQuery();
                tran.Commit();
                return count;
            }
            catch (SqlException e)
            {
                if (tran != null)
                    tran.Rollback();

                sc.Close();
            }
            sc.Close();
          
        }
        return 0;
    }
    #region 查询
    public DataTable Query(string sql)
    {
        SqlTransaction tran = null;
        SqlCommand sqlcmd = null;
        DataTable dt = new DataTable();
        if (sc != null)
        {
            try
            {
                sc.Open();
                tran = sc.BeginTransaction();
                sqlcmd = new SqlCommand(sql, sc);
                sqlcmd.Transaction = tran;
                SqlDataReader sr = sqlcmd.ExecuteReader();
                dt.Load(sr);
                tran.Commit();

            }
            catch (SqlException e)
            {
                if (tran != null)
                    tran.Rollback();
                sc.Close();

            }
            sc.Close();
        }
        return dt;
    }
    #endregion
}
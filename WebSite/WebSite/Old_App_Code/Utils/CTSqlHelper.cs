using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// SqlHelper 的摘要说明
/// </summary>
public class ctSqlHelper:IDisposable
{
    SqlConnection sc;
    string conn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnString"].ToString();
    static ctSqlHelper mHelper = null;
    object lock_Obj = new object();
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
        int count = 0;
        lock (lock_Obj)
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
                    count = sqlcmd.ExecuteNonQuery();
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
        }
        return count;
    }
    #region 查询
    public DataTable Query(string sql)
    {
        DataTable dt = new DataTable();
        lock (lock_Obj)
        {
            SqlTransaction tran = null;
            SqlCommand sqlcmd = null;
            SqlDataReader sr = null;
            if (sc != null)
            {
                try
                {
                    if (sc.State != ConnectionState.Open)
                        sc.Open();
                    tran = sc.BeginTransaction();
                    sqlcmd = new SqlCommand(sql, sc);
                    sqlcmd.Transaction = tran;
                    sr = sqlcmd.ExecuteReader();

                    dt.Load(sr);
                    tran.Commit();
                    tran.Dispose();

                }
                catch (SqlException e)
                {
                    Console.WriteLine(e.Message);
                    if(sr!=null)
                    {
                        sr.Close();
                    }
                    if (tran != null)
                    {

                        tran.Rollback();
                    }
                    sc.Close();
                    throw e;

                }
                sc.Close();
            }
        }
        return dt;
    }

    public void Dispose()
    {
       
    }
    #endregion
}
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using WebSite.App_Code.Obj.CampusTalk;

namespace WebSite.App_Code.Utils
{
    public class SQLOP
    {
        static SQLOP mSqlop = null;
        public static SQLOP getInstance()
        {
            if (mSqlop == null)
                mSqlop = new SQLOP();
            return mSqlop;
        }
        /// <summary>
        /// 检查邮件可用性
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool CheckEmailValidate(string email)
        {
            string sql = "select * from " + GlobalVar.User.TABLE_USER + " where " + GlobalVar.User.EMAIL + "='" + email + "'";
            DataTable dt_email = ctSqlHelper.getInstance().Query(sql);
            if (dt_email.Rows.Count<=0) {
                return true;
            }
            return false;
        }

        public int AddUser(CTPerson user)
        {
            string sql = "insert into " + GlobalVar.User.TABLE_USER + " (" + GlobalVar.User.UID + "," + GlobalVar.User.PASSWORD + "," + GlobalVar.User.SEX + "," + GlobalVar.User.EMAIL + "," + GlobalVar.User.SCHOOLCODE + ") values('"+user.Uid+"','"+user.Password+"','"+user.Sex+"','"+user.Email+"','"+user.School.SCode+"')";
            return ctSqlHelper.getInstance().executeSql(sql);
        }
    }
}
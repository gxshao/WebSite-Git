using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebSite
{
    public partial class Welcome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string UserName = "";
            if (!IsPostBack)
            {
                HttpCookie cookie = Request.Cookies["MRSGXCOOKIE"];
                if (cookie != null)
                {
                    UserName = HttpUtility.UrlDecode(cookie["UserName"].ToString());
                    Btn_Login.InnerText = UserName;
                    this.Main_Layer.Visible = true;
                }
                else
                {
                    this.Main_Layer.Visible = false;
                }
            }
        }
    }
}
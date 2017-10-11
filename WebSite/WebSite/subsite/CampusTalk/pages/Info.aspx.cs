using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebSite.subsite.CampusTalk.pages
{
	public partial class Info : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            Response.Redirect("~/subsite/CampusTalk/events/InsideHandler.ashx?key=1");
         
		}

    }
}
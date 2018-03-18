using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebSite.App_Code.Obj.CampusTalk;
using Newtonsoft.Json;
using System.Collections.Generic;
using WebSite.Old_App_Code.Obj.CampusTalk;
using Microsoft.AspNet.SignalR.Messaging;

namespace WebSite.subsite.CampusTalk.pages
{
    public partial class PushMessage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_push_Click(object sender, EventArgs e)
        {
            //推送功能
            CTData<CTPushMessage> d = new CTData<CTPushMessage>();
            string title = tvTitle.Text.ToString();
            string msg= tvContent.Text.ToString();
            if (title==null||title.Equals("")) {
                showBox("标题不能为空～");
                return;
            }
            if (msg == null|| msg.Equals("")) {
                showBox("内容不能为空～");
                return;
            }
            btn_push.Text = "正在推送...";
            d.DataType = CTData<CTPushMsg>.DATATYPE_PUSH;
            CTPushMessage ctpm = new CTPushMessage();
            ctpm.Title = title;
            ctpm.Body = msg;
            d.Body = ctpm;
            msg = JsonConvert.SerializeObject(d);
            foreach (KeyValuePair<string, CTUserBase> who in GlobalVar.mClients)
            {
                CTPushMsg.Send(who.Key, msg);
            }
            btn_push.Text = "推送";
            showBox("推送成功");

        }

        private void showBox(string msg)
        {

            ClientScript.RegisterStartupScript(this.GetType(), " message", "<script language='javascript' >alert('"+msg+"');</script>");
        }
    }
}
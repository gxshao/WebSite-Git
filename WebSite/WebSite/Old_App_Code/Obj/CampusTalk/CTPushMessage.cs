using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSite.Old_App_Code.Obj.CampusTalk
{
    public class CTPushMessage
    {
        string title = "";
        string body = "";

        public string Title { get => title; set => title = value; }
        public string Body { get => body; set => body = value; }
    }
}
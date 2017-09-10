using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSite.subsite.campustalk.events
{
    /// <summary>
    /// ctLocations 的摘要说明
    /// </summary>
    public class ctLocations : IHttpHandler
    {

        //1.GPS坐标信息采集
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}  
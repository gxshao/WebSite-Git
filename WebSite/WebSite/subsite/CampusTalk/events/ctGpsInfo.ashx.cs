<%@ WebHandler Language = "C#" Class="ctGpsInfo" %>

using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
    /// <summary>
    /// ctGpsInfo 的摘要说明
    /// </summary>
public class ctGpsInfo : IHttpHandler
    {
        //1.GPS坐标信息采集
        private HttpContext Content = null;
        string ServerPath = "";
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            Content = context;
            string key = "";
            key = Content.Request["key"];
            if (key == null || key.Equals(""))
            {
                context.Response.Write("非法访问已记录,时间:" + DateTime.Now.ToString());
                return;
            }
            //locationinfo
            string json_location = context.Request.QueryString["gps"].ToString();
            ArrayList list = JsonConvert.DeserializeObject<ArrayList>(json_location);
            CTData<bool> res_gps = new CTData<bool>();

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
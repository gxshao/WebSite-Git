<%@ WebHandler Language="C#" Class="ctSearch" %>

using System;
using System.Web;
using WebSite.App_Code.Obj.CampusTalk;
using WebSite.App_Code.Utils;
using System.Collections.Generic;
using System.Collections;
using Newtonsoft.Json;
public class ctSearch : IHttpHandler
{

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
        /*
          必须获取uid字段
        1.获取时间段，返回区间内的经纬度坐标
        2.获取经纬度的坐标和时间段，返回这个坐标范围内的所有异性用户
        */
        string uid = Content.Request["uid"].ToString();

        if (uid == null || uid == "")
        {
            context.Response.Write("非法访问已记录,时间:" + DateTime.Now.ToString());
            return;
        }

        if (key == "getloc")
        {
            lock (this)
            {
                CTData<List<CTLocation>> ctdata = new CTData<List<CTLocation>>();
                ctdata.DataType = CTData<List<CTLocation>>.DATATYPE_REPLY;
                string time = context.Request.QueryString["time"];
                if (time != null && !time.Equals(""))
                {
                    string[] times = time.Split('$');
                    List<CTLocation> list = SQLOP.getInstance().getLocationByTime(uid, times[0], times[1]);
                    ctdata.Body = list;
                    context.Response.Write(JsonConvert.SerializeObject(ctdata));
                }
            }
        }
        else if (key == "getPWAM") //the people who was around me   10米左右的距离
        {
            lock (this)
            {
                CTData<List<CTPerson>> ctdata = new CTData<List<CTPerson>>();
                ctdata.DataType = CTData<List<CTPerson>>.DATATYPE_REPLY;
                string location = context.Request.QueryString["location"];
                if (location != null && !location.Equals(""))
                {
                    CTLocation loc = JsonConvert.DeserializeObject<CTLocation>(location);
                    if (loc == null)
                    {
                        ctdata.Body = new List<CTPerson>();
                        context.Response.Write(JsonConvert.SerializeObject(ctdata));
                    }
                    else
                    {
                        Degree myloc = new Degree(Double.Parse(loc.Latitude), Double.Parse(loc.Longitude));
                        List<CTPerson> res_person = new List<CTPerson>();
                        List<CTLocation> locdata = SQLOP.getInstance().getLcationListByLocate(loc);
                        List<CTLocation> newData = new List<CTLocation>();
                        //过滤经纬度坐标
                        foreach (CTLocation tmp in locdata)
                        {
                            double val = CoordDispose.GetDistanceGoogle(myloc, new Degree(Double.Parse(tmp.Latitude), Double.Parse(tmp.Longitude)));
                            if (val < 11&& val >-1)
                            {
                                newData.Add(tmp);
                            }
                        }
                        locdata.Clear();
                        ArrayList arr = new ArrayList();
                        for (int i = 0; i < newData.Count; i++)
                        {
                            if (arr.Contains(newData[i].Uid))
                            {
                                continue;
                            }
                            arr.Add(newData[i].Uid);
                            CTPerson tmp = SQLOP.getInstance().getUserProfile(newData[i].Uid);
                            res_person.Add(tmp);
                        }
                        ctdata.Body = res_person;
                        context.Response.Write(JsonConvert.SerializeObject(ctdata));

                    }
                }
            }
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
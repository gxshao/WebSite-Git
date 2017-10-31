using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Area 的摘要说明
/// </summary>
public class Area
{
    string areacode;
    string areaname;
    string clickrate;
    public Area()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    public string ACode
    {
        get
        {
            return areacode;
        }

        set
        {
            areacode = value;
        }
    }

    public string AName
    {
        get
        {
            return areaname;
        }

        set
        {
            areaname = value;
        }
    }

    public string ARate
    {
        get
        {
            return clickrate;
        }

        set
        {
            clickrate = value;
        }
    }
}
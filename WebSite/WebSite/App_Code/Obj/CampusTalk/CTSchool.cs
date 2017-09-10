using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ctSchool 的摘要说明
/// </summary>
public class CTSchool
{
    string sCode = "";
    string sName = "";
    public CTSchool()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    public string SCode
    {
        get
        {
            return sCode;
        }

        set
        {
            sCode = value;
        }
    }

    public string SName
    {
        get
        {
            return sName;
        }

        set
        {
            sName = value;
        }
    }
}
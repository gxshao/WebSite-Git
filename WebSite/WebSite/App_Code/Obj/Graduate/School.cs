using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Schoo 的摘要说明
/// </summary>
public class School
{
    string schoolCode = "";
    string schoolName = "";
    string schoolAttr = "";
    string schoolLink = "";

    public string SCode
    {
        get
        {
            return schoolCode;
        }

        set
        {
            schoolCode = value;
        }
    }

    public string SName
    {
        get
        {
            return schoolName;
        }

        set
        {
            schoolName = value;
        }
    }

    public string SAttr
    {
        get
        {
            return schoolAttr;
        }

        set
        {
            schoolAttr = value;
        }
    }

    public string SLink

    {
        get
        {
            return schoolLink;
        }

        set
        {
            schoolLink = value;
        }
    }

    public School()
    {
        //
        // TODO: 在此处添加构造函数逻辑

        //
    }
}
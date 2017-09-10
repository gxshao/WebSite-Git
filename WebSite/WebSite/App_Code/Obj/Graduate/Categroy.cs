using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Categroy 的摘要说明
/// </summary>
public class Categroy
{
    string coCode;
    string coName;
    public Categroy()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    public string CoCode
    {
        get
        {
            return coCode;
        }

        set
        {
            coCode = value;
        }
    }

    public string CoName
    {
        get
        {
            return coName;
        }

        set
        {
            coName = value;
        }
    }
}
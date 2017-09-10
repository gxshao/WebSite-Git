using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// User 的摘要说明
/// </summary>
public class CTUser: CTUserBase
{
    string sex;  //性别
    string uid;  //UUID+0 ||UUID+1
    string connectionid; //通信地址
    string state;  //通信状态
    string chatid;
    CTSchool school; //学校
    public CTUser()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

   
    public string ConnectionId
    {
        get
        {
            return connectionid;
        }

        set
        {
            connectionid = value;
        }
    }

    public string State
    {
        get
        {
            return state;
        }

        set
        {
            state = value;
        }
    }

    public string Chatid
    {
        get
        {
            return chatid;
        }

        set
        {
            chatid = value;
        }
    }
}
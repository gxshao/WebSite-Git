using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
/// <summary>
/// ctPushMsg 的摘要说明
/// </summary>
public class CTPushMsg
{
    static IPersistentConnectionContext push = GlobalHost.ConnectionManager.GetConnectionContext<CTConnection>();
    public CTPushMsg()
    {
    }
    public static void Send(string connectionId, string message)
    {
        push.Connection.Send(connectionId,message);
    }
}
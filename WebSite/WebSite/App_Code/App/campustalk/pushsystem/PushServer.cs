using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(PushServer))]
/// <summary>
/// PushServer 的摘要说明
/// </summary>
public class PushServer
{
    public void Configuration(IAppBuilder app)
    {
        app.MapSignalR<CTConnection>("/MyConnection");
    }
}
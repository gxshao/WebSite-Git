<%@ Application Language="C#" %>
<%@ Import Namespace="System.Timers" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="Microsoft.AspNet.SignalR" %>
<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        GlobalHost.Configuration.ConnectionTimeout = TimeSpan.FromMinutes(60);
        GlobalHost.Configuration.DisconnectTimeout = TimeSpan.FromSeconds(30);
        GlobalHost.Configuration.KeepAlive = TimeSpan.FromSeconds(10);
    }   

    private static bool IsTime(string StrSource)
    {
        return Regex.IsMatch(StrSource, @"^((21|22|\d):[0-5]?\d:[0-5]?\d)$");
    }
    private void GoSign(string data, string name)
    {


    }
    void Application_End(object sender, EventArgs e)
    {

        //这里设置你的web地址，可以随便指向你的任意一个aspx页面甚至不存在的页面，目的是要激发Application_Start  

        string url = "http://www.mrsgx.cn";

        HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(url);

        HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();

        Stream receiveStream = myHttpWebResponse.GetResponseStream();//得到回写的字节流  

    }

    void Application_Error(object sender, EventArgs e)
    {
        // 在出现未处理的错误时运行的代码

    }

    void Session_Start(object sender, EventArgs e)
    {

    }

    void Session_End(object sender, EventArgs e)
    {
        // 在会话结束时运行的代码。 
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer
        // 或 SQLServer，则不引发该事件。

    }


</script>

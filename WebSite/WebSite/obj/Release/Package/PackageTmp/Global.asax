<%@ Application Language="C#" %>
<%@ Import Namespace="System.Timers" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Net" %>
<script RunAt="server">
 
    System.Timers.Timer myTimer;
    string sers = "";
    string[] name = { "SGX", "SYZ", "WL" };
    string[] data = { "sn=1650412104&name=邵国鑫&location=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&longitude=117.106715&latitude=39.067892&address=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&room=5-702&class=业务1621&mobile=13662127830&remark=&type=1&device=Android",
        "sn=1650412102&name=沈豫洲&location=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&longitude=117.106715&latitude=39.067892&address=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&room=5-702&class=业务1621&mobile=13102195563&remark=&type=1&device=Android",
        "sn=1650512901&name=武励&location=天津市西青区摈水西道延长线靠近林鑫公寓&longitude=117.112214&latitude=39.075608&address=天津市西青区宾水西道延长线靠近林鑫公寓&room=6-1017&class=业务1621&mobile=18722382297&remark=&type=1&device=Android"};
    void Application_Start(object sender, EventArgs e)
    {
       
        /* FileStream fhead;
         sers = Server.MapPath("/");
         fhead = new FileStream(sers + "log.txt", FileMode.Append);
         string head = "===========================" + DateTime.Now.ToString() + "===========================";
         fhead.Write(Encoding.UTF8.GetBytes(head), 0, head.Length);
         fhead.Flush();
         fhead.Close();
         // 在应用程序启动时运行的代码
         // string data = "sn=1650412104&name=邵国鑫&location=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&longitude=117.106715&latitude=39.067892&address=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&room=5-702&class=业务1621&mobile=13662127830&remark=&type=1&device=Android";
         for (int i = 0; i < data.Length; i++)
             GoSign(data[i], name[i]);
         //定时器
         myTimer = new System.Timers.Timer(7100000);
         myTimer.Elapsed += new ElapsedEventHandler(myTimer_Elapsed);
         myTimer.Enabled = true;
         myTimer.AutoReset = true;*/
    }
    private void myTimer_Elapsed(object source, ElapsedEventArgs e)
    {
        // string data = "sn=1650412104&name=邵国鑫&location=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&longitude=117.106715&latitude=39.067892&address=天津市西青区泮缘道靠近天津市大学软件学院4号公寓&room=5-702&class=业务1621&mobile=13662127830&remark=&type=1&device=Android";
        if (IsTime(DateTime.Now.ToString()))
            for (int i = 0; i < data.Length; i++)
                GoSign(data[i].ToString(), name[i]);
        else
        {
            FileStream fi = new FileStream(sers + "log.txt", FileMode.Append);
            byte[] buffer = Encoding.UTF8.GetBytes("现在时间是：" + DateTime.Now.ToString() + "\r\n");
            fi.Write(buffer, 0, buffer.Length);
            fi.Flush();
            fi.Close();
        }

    }
    private static bool IsTime(string StrSource)
    {
        return Regex.IsMatch(StrSource, @"^((21|22|\d):[0-5]?\d:[0-5]?\d)$");
    }
    private void GoSign(string data, string name)
    {

        byte[] buffer;
        try
        {
            FileStream fs;
            fs = new FileStream(sers + "log.txt", FileMode.Append);
            string path = "http://appapi.tjise.edu.cn/sing";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(path);
            request.ContentType = "application/x-www-form-urlencoded";
            request.Method = "POST";
            Encoding encode = Encoding.UTF8;
            byte[] postData = encode.GetBytes(data);
            request.ContentLength = postData.Length;
            Stream writer = request.GetRequestStream();
            writer.Write(postData, 0, postData.Length);
            ////////////////////////////////////////
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            if (response.StatusCode != HttpStatusCode.OK)
            {
                buffer = encode.GetBytes("服务器返回失败\r\n Time:" + DateTime.Now.ToString());
                fs.Write(buffer, 0, buffer.Length);
                fs.Flush();
                fs.Close();
                return;
            }
            Stream reader = response.GetResponseStream();
            StreamReader read = new StreamReader(reader, encode);
            string temp = read.ReadToEnd();
            writer.Close();
            reader.Close();
            read.Close();


            buffer = encode.GetBytes(temp + "  Time:" + DateTime.Now.ToString() + "::" + name + "\r\n");
            fs.Write(buffer, 0, buffer.Length);
            fs.Flush();
            fs.Close();
        }
        catch
        {
            return;
        }
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

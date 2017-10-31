using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading.Tasks;
using System.Text;
using Newtonsoft.Json;
using WebSite.App_Code.Obj.CampusTalk;
/// <summary>
/// ctMyConnection 的摘要说明
/// </summary>
public class CTConnection : PersistentConnection
{
    object LocObj = new object();
    private static Dictionary<string, CTUserBase> mClients = new Dictionary<string, CTUserBase>();
    private static Dictionary<string, string> mFastClients = new Dictionary<string, string>();
    protected override Task OnConnected(IRequest request, string connectionId)
    {
        return base.OnConnected(request, connectionId);
    }
    protected override Task OnReceived(IRequest request, string connectionId, string data)
    {

        /***********************2017-09-08  邵国鑫***/
        //1.转发消息到对应id
        //2.连接信息 添加新用户
        lock (LocObj)
        {
        try
        {
            CTData<Object> d = new CTData<Object>();
            d = JsonConvert.DeserializeObject<CTData<Object>>(data);
            //初始json
            if (d != null)
            {
                switch (d.DataType)
                {
                    case CTData<Object>.DATATYPE_CONNECTED:
                        lock (LocObj)
                        {
                        CTData<CTUser> s = JsonConvert.DeserializeObject<CTData<CTUser>>(data);
                        CTUser user = s.Body;
                        user.ConnectionId = connectionId;
                        CTAreaPool.getInstance().addUser(user);
                        CTUserBase userbase = new CTUserBase();
                        userbase.Sex = user.Sex;
                        userbase.Uid = user.Uid;
                        userbase.School = user.School;
                        if (!mClients.ContainsKey(connectionId))
                            mClients.Add(connectionId, userbase);
                            else
                            {
                                mClients[connectionId] = userbase;
                            }
                        if (!mFastClients.ContainsKey(user.Uid))
                            mFastClients.Add(user.Uid, connectionId);
                            else
                            {
                                mFastClients[user.Uid] = connectionId;
                            }
                        }
                        break;
                    case CTData<Object>.DATATYPE_MESSAGE:
                        CTData<CTMessage> ctmsg = JsonConvert.DeserializeObject<CTData<CTMessage>>(data);
                        CTMessage msg = ctmsg.Body;
                        if (mFastClients.Count > 0 && mFastClients.ContainsKey(msg.To))
                            Connection.Send(mFastClients[msg.To], data);
                        /*
                        

                        switch (msg.Type)
                        {
                            //文本信息
                            case CTMessage.MESSAGE_TYPE_TEXT:
                               
                                break;
                            case CTMessage.MESSAGE_TYPE_EMOJI: break;
                            case CTMessage.MESSAGE_TYPE_AUDIO: break;
                            case CTMessage.MESSAGE_TYPE_PHOTO: break;
                        }*/
                        break;
                }

            }


        }
        catch (Exception e)
        {
            string x = e.Message;
        }
        }
        return base.OnReceived(request, connectionId, data);
    }
    protected override bool AuthorizeRequest(IRequest request)
    {
        return base.AuthorizeRequest(request);
    }
    protected override Task OnDisconnected(IRequest request, string connectionId, bool stopCalled)
    {
        lock (LocObj)
        {
            //移除该用户
            if (mClients.ContainsKey(connectionId))
            {
                CTUserBase userbase = mClients[connectionId];
                if (mFastClients.ContainsKey(userbase.Uid))
                    mFastClients.Remove(userbase.Uid);
                CTAreaPool.getInstance().removeUser(userbase.Uid, userbase.School.SCode);
                mClients.Remove(connectionId);
            }

        }
        return base.OnDisconnected(request, connectionId, stopCalled);
    }

}
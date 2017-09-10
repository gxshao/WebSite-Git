using Aliyun.Acs.Core;
using Aliyun.Acs.Core.Exceptions;
using Aliyun.Acs.Core.Profile;
using Aliyun.Acs.Dm.Model.V20151123;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

/// <summary>
/// ctEMail 的摘要说明
/// </summary>
public class ctEMail
{
    static ctEMail mCtEmail = null;
    IClientProfile profile = null;
    IAcsClient client = null;
    string appid = "";
    string secret = "";
    string myemail = "";
    public ctEMail()
    {
        appid = ConfigurationManager.AppSettings["aliaccount"];
        secret = ConfigurationManager.AppSettings["alipassword"];
        myemail = ConfigurationManager.AppSettings["myemail"];
        profile = DefaultProfile.GetProfile("cn-hangzhou", appid, secret);
        client = new DefaultAcsClient(profile);
    }
    public static ctEMail getInstance()
    {
        if (mCtEmail == null)
        {
            mCtEmail = new ctEMail();
        }
        return mCtEmail;
    }
    public bool senMail(string emailaddress,string code)
    {

        SingleSendMailRequest request = new SingleSendMailRequest();
        try
        {
            request.AccountName = myemail;
            request.FromAlias = "campustalk官方团队";
            request.AddressType = 1;
            request.TagName = "Regesiter";
            request.ReplyToAddress = true;
            request.ToAddress = emailaddress;
            request.Subject = "[campustalk]验证码消息";
            request.HtmlBody = "欢迎注册campustalk，您的验证码为:"+code;
            SingleSendMailResponse httpResponse = client.GetAcsResponse(request);
        }
        catch (ServerException e)
        {
            return false;
        }
        catch (ClientException e)
        {
            return false;
        }
        return true;
    }
}
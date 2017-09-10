<%@ WebHandler Language="C#" Class="ctCommon" %>

using System;
using System.Web;

public class ctCommon : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        
    }
    /// <summary>
    /// 1.获取关注好友列表
    /// 2.获取用户资料
    /// 3.上传系统
    /// 4.查询
    /// 
    /// 
    /// </summary>
    public bool IsReusable {
        get {
            return false;
        }
    }

}
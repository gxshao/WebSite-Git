using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
/// <summary>
/// ctAreaPool 的摘要说明
/// </summary>
public class CTAreaPool
{
    static CTAreaPool mCtAp = null;
    object LockObj = new object();
    Dictionary<string, ctUserPool> mPool = null;
    public CTAreaPool()
    {
        mPool = new Dictionary<string, ctUserPool>();
    }

    public static CTAreaPool getInstance()
    {
        if (mCtAp == null)
        {
            mCtAp = new CTAreaPool();
        }
        return mCtAp;

    }

    //新用户加入
    public void addUser(CTUser user)
    {
        if (user == null || user.School == null || user.School.SCode.Equals(""))
        {
            return;
        }
        if (mPool.ContainsKey(user.School.SCode))
        {
            mPool[user.School.SCode].addUser(user);
            if (mPool[user.School.SCode].IsMatched)
            {
                mPool[user.School.SCode].StartMatch();
            }
        }
        else
        {
            ctUserPool tmpUserPool = new ctUserPool();
            tmpUserPool.addUser(user);
            tmpUserPool.StartMatch();
            mPool.Add(user.School.SCode, tmpUserPool);
        }

    }

    //改变用户当前状态
    public bool moveUser(int to, string uid, string schoolcode)
    {
        if (uid.Equals("") || schoolcode.Equals(""))
        {
            return false;
        }
        if (!mPool.ContainsKey(schoolcode))
        {
            return false;
        }
        return mPool[schoolcode].moveUser(to, uid);

    }
    //移除用户
    public void removeUser(string uid, string schoolcode)
    {
        if (!schoolcode.Equals("") && mPool.ContainsKey(schoolcode))
        {
            mPool[schoolcode].removeUser(uid);
        }
        if (mPool[schoolcode].Count<=0) {
            mPool[schoolcode].StopMatch();
        }
    }

    /*******************2017/9/06 邵国鑫****************/
    //检测超时线程开启
    //匹配功能
    //结束匹配
    /****************************************************/
}
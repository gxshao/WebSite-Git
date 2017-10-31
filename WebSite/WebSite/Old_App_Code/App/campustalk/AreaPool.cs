using System;
using System.Collections;
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
    int count = 0; //获取当前连接池所有用户数
    int schoolCount = 0;  //在线学校数
    public int Count
    {
        get
        {
            return count;
        }

        set
        {
            count = value;
        }
    }

    public int SchoolCount
    {
        get
        {
            return schoolCount;
        }

        set
        {
            schoolCount = value;
        }
    }

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
            schoolCount++;
        }
        count++;

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
            //if (mPool[schoolcode].Count <= 0)
            //{
            //    mPool[schoolcode].StopMatch();
            //}
        }
        count--;
    }

    /*******************2017/9/06 邵国鑫****************/
    //检测超时线程开启
    //匹配功能
    //结束匹配
    /****************************************************/
    ///以下均为测试功能不作实际使用
    public ArrayList getAllStuNickname()
    {
        ArrayList list = new ArrayList();
        foreach(KeyValuePair<string,ctUserPool> temp in mPool)
        {
            list.AddRange(temp.Value.getAlluserNickname());
        }
        return list;
    }
}
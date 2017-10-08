using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using WebSite.App_Code.Obj.CampusTalk;

/// <summary>
/// ctUserPool 的摘要说明
/// </summary>
public class ctUserPool
{
    static Dictionary<string, TempPool> mPool = null;   //性别分组列表
    static Dictionary<string, List<CTUser>> mChattingRoom = null;
    Thread mMatchThread = null;
    bool isMatched = false;
    object LocObj = new object();
    private int count;

    internal int Count
    {
        get
        {

            return mPool[GlobalVar.SEX_MALE].Count + mPool[GlobalVar.SEX_FEMALE].Count;
        }
    }

    public bool IsMatched
    {
        get
        {
            return isMatched;
        }
    }

    public ctUserPool()
    {
        mPool = new Dictionary<string, TempPool>();
        mChattingRoom = new Dictionary<string, List<CTUser>>();
        TempPool mA = new TempPool();
        TempPool mB = new TempPool();
        mPool.Add(GlobalVar.SEX_MALE, mA);
        mPool.Add(GlobalVar.SEX_FEMALE, mB);
        mMatchThread = new Thread(Matching);
    }
    public void StartMatch()
    {
        mMatchThread.Start();
        isMatched = false;
    }
    public void StopMatch()
    {
        isMatched = true;
    }
    public void Matching()
    {
        //没有匹配到就继续匹配

        while (!IsMatched)
        {
            lock (LocObj)
            {
                try
                {
                    CTUser man = mPool[GlobalVar.SEX_MALE].MatchUser();
                    CTUser stranger = mPool[GlobalVar.SEX_FEMALE].MatchUser();
                    if (stranger != null && man != null)
                    {
                        string id = System.Guid.NewGuid().ToString();
                        man.Chatid = id;
                        stranger.Chatid = id;
                        moveUser(GlobalVar.STATE_BUSY, man.Uid);
                        moveUser(GlobalVar.STATE_BUSY, stranger.Uid);
                        //推送给用户匹配成功通知
                        List<CTUser> listuser = new List<CTUser>();
                        listuser.Add(man);
                        listuser.Add(stranger);
                        mChattingRoom.Add(id, listuser);
                        //推送信息包括:State:success,Stranger:uid
                        CTData<string> data = new CTData<string>();
                        data.DataType = CTData<string>.DATATYPE_REPLY;
                        data.Body = stranger.Uid;
                        CTPushMsg.Send(man.ConnectionId, JsonConvert.SerializeObject(data));
                        data.Body = man.Uid;
                        CTPushMsg.Send(stranger.ConnectionId, JsonConvert.SerializeObject(data));
                    }

                }
                catch
                {

                }
            }
            if (mPool[GlobalVar.SEX_MALE].isPendingEmpty() || mPool[GlobalVar.SEX_FEMALE].isPendingEmpty())
            {
                Thread.Sleep(3000);
            }
            Thread.Sleep(2000);
        }


    }

    public void addUser(CTUser user)
    {
        if (user.Sex.Equals(""))
            return;
        if (user.Sex != GlobalVar.SEX_MALE && user.Sex != GlobalVar.SEX_FEMALE)
        {
            return;
        }
        TempPool tp = mPool[user.Sex];
        tp.AddUser(user);
    }
    public bool moveUser(int to, string uid)
    {
        Dictionary<string, CTUser> tmp = null;
        tmp = mPool[ctUtils.getSexbyUid(uid)].hasUser(uid);
        if (tmp != null)
        {
            CTUser user = mPool[ctUtils.getSexbyUid(uid)].MoveUser(tmp, to, uid);

            //解决聊天室 单向关闭
            if (user != null)
            {
                lock (LocObj)
                {
                    if (mChattingRoom.ContainsKey(user.Chatid))
                    {
                        List<CTUser> list = mChattingRoom[user.Chatid];
                        foreach (CTUser tu in list)
                        {
                            if (!tu.Uid.Equals(user.Uid))
                            {
                                tu.Chatid = "";
                                tu.State = GlobalVar.STATE_PENDING + "";
                                moveUser(GlobalVar.STATE_PENDING, tu.Uid);
                                CTData<string> msg = new CTData<string>();
                                msg.DataType = CTData<string>.DATATYPE_CONNECTED;
                                msg.Body = "next";
                                CTPushMsg.Send(tu.ConnectionId, JsonConvert.SerializeObject(msg));
                            }
                        }
                        mChattingRoom.Remove(user.Chatid);
                        user.Chatid = "";
                    }
                }
            }
            return true;
        }
        else
        {
            return false;
        }
    }

    public void removeUser(string uid)
    {
        mPool[ctUtils.getSexbyUid(uid)].RemoveUser(uid);
    }




}

class TempPool
{
    object LocObj = new object();
    int count;
    Dictionary<string, CTUser> mList = null;//空闲列表
    Dictionary<string, CTUser> mPending = null; //挂起列表
    Dictionary<string, CTUser> mBusy = null; //聊天列表

    public int Count
    {
        get
        {
            return mList.Count + mPending.Count + mBusy.Count;
        }
    }

    public TempPool()
    {
        mList = new Dictionary<string, CTUser>();
        mPending = new Dictionary<string, CTUser>();
        mBusy = new Dictionary<string, CTUser>();
    }
    //登录操作
    public void AddUser(CTUser user)
    {
        lock (LocObj)
        {
            if (mList != null && !mList.ContainsKey(user.Uid))
            {
                mList.Add(user.Uid, user);
            }
        }
    }

    //掉线、登出 清理用户
    public void RemoveUser(string uid)
    {
        lock (LocObj)
        {
            if (mList != null && mList.ContainsKey(uid))
            {
                mList.Remove(uid);
            }
            if (mPending != null)
            {
                mPending.Remove(uid);
            }
            if (mBusy != null && mBusy.ContainsKey(uid))
            {
                mBusy.Remove(uid);
            }
        }
    }
    //状态切换
    public CTUser MoveUser(Dictionary<string, CTUser> tmpList, int to, string uid)
    {
        CTUser tmpUser = null;
        lock (LocObj)
        {

            //先寻找后添加再移除
            if (tmpList != null && tmpList.Count > 0)
            {
                tmpUser = tmpList[uid];
                if (tmpUser == null)
                {
                    return null;
                }
                switch (to)
                {
                    case GlobalVar.STATE_NONE:
                        tmpUser.State = GlobalVar.STATE_NONE + "";
                        if (!mList.ContainsKey(uid))  //不包含则添加进去
                            mList.Add(tmpUser.Uid, tmpUser);

                        break;
                    case GlobalVar.STATE_PENDING:
                        tmpUser.State = GlobalVar.STATE_PENDING + "";
                        if (!mPending.ContainsKey(tmpUser.Uid))
                            mPending.Add(tmpUser.Uid, tmpUser);

                        break;
                    case GlobalVar.STATE_BUSY:
                        if (!tmpUser.Chatid.Equals(""))
                            tmpUser.State = GlobalVar.STATE_BUSY + "";
                        if (!mBusy.ContainsKey(tmpUser.Uid))
                            mBusy.Add(tmpUser.Uid, tmpUser);
                        break;
                }
                tmpList.Remove(uid);
            }
            else
            {
                return null; ;
            }
        }
        return tmpUser;
    }

    //是否存在此用户
    public Dictionary<string, CTUser> hasUser(string uid)
    {
        lock (LocObj)
        {
            Dictionary<string, CTUser> tmp = null;
            tmp = mList.ContainsKey(uid) ? mList : null;
            if (tmp != null)
                return tmp;
            tmp = mPending.ContainsKey(uid) ? mPending : null;
            if (tmp != null)
                return tmp;
            tmp = mBusy.ContainsKey(uid) ? mBusy : null;
            if (tmp != null)
                return tmp;
        }
        return null;
    }

    //匹配对象
    public CTUser MatchUser()
    {
        lock (LocObj)
        {
            if (mPending.Count <= 0)
                return null;
            int x = new Random().Next(mPending.Count - 1);
            return mPending.ElementAt(x).Value;
        }
    }

    public bool isPendingEmpty()
    {
        return mPending.Count == 0;
    }
}
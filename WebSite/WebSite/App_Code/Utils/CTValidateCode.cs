using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Collections;

/// <summary>
/// TempCode 的摘要说明
/// </summary>
public class TempCode
{
    static TempCode mTc = null;
    Thread mThread = null;
    Hashtable mHt = null;
    bool checkState = true;
    public TempCode()
    {
        mHt = new Hashtable();
        mThread = new Thread(CheckCodes);
        mThread.IsBackground = true;
        mThread.Start();
    }
   //循环线程检查验证码有效性
    private void CheckCodes()
    {
        while (checkState) {
            DateTime now = DateTime.Now;
            List<string> keys = new List<string>();
            foreach (DictionaryEntry de in mHt)
            {
                TimeSpan ts = now - (DateTime)de.Value;
                if (ts.TotalMinutes > GlobalVar.CODE_VAL_TIME)
                {
                    keys.Add((string)de.Key);
                }
            }
            foreach (string x in keys) {
                object obj = new object();
                lock (obj)
                {
                    mHt.Remove(x);
                }
            }
            keys.Clear();
            keys = null;
            Thread.Sleep(10000);
          }
    }
    //获取单例模式
    public static TempCode getInstance() {
        if (mTc==null) {
            mTc = new TempCode();
        }
        return mTc;
    }
    //获取随机验证码
    public string getRandomCode() {
        string code = "";
        Random rand = new Random();
        while (code.Equals("")||mHt.ContainsKey(code)) { 
            code = rand.Next(100000,999999).ToString();
        }
        mHt.Add(code,DateTime.Now);
        return code;
    }
    //校验验证码合法性
    public bool ValidateCode(string code) {
        object t = new object();
        lock (t)
        {
            if (mHt.Count > 0&&mHt.ContainsKey(code))
            {
                mHt.Remove(code);
                return true;
            }
        }
        return false;

    }
    //释放检查线程
    public void releaseCheck() {
        if (mThread.IsAlive) {
            checkState = false;
        }
        mHt.Clear();
    }
    ~TempCode() {
        releaseCheck();
    }
}
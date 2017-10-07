using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// GlobalVar 的摘要说明
/// </summary>
public class GlobalVar
{
    public const string SEX_MALE = "0";
    public const string SEX_FEMALE = "1";
    public const  int STATE_NONE = 0;
    public const int STATE_PENDING = 1;
    public const int STATE_BUSY = 2;
    public const bool SUCCESS = true;
    public const int CODE_VAL_TIME = 5; //验证码有效期
    public const bool FAIL = false;
    public const string USER_STATE_GOOD = "0"; //正常
    public const string USER_STATE_UNATH = "1";//未认证
    public const string USER_STATE_WAITING = "2";//待认证
    public const string USER_STATE_STOPPED = "3";//已停用
    public GlobalVar()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    /// <summary>
    /// 
    /// 用户表
    /// </summary>
    public class User
    {
        public const string TABLE_USER = "users";
        public const string UID = "uid";
        public const string EMAIL = "email";
        public const string NICKNAME = "nickname";
        public const string PASSWORD = "password";
        public const string SEX = "sex";
        public const string HEADPIC = "headpic";
        public const string AGE = "age";
        public const string SCHOOLCODE = "schoolcode";
        public const string USEREXPLAIN = "userexplain";
        public const string STUCARD = "stucard";
        public const string STATE = "state";
    }
    /// <summary>
    /// 签到表
    /// </summary>
    public class Sign {
        public const string TABLE_SIGN = "sign";
        public const string UID = "uid";
        public const string TIME = "time";
    }
    /// <summary>
    /// GPS位置表
    /// </summary>
    public class Location {
        public const string TABLE_LOCATION = "location";
        public const string UID = "uid";
        public const string TIME = "time";
        public const string LONGITUDE = "longitude";
        public const string LATITUDE = "latitude";
    }
    /// <summary>
    /// 关注表
    /// </summary>
    public class Follow
    {
        public const string TABLE_FOLLOW = "follow";
        public const string UID = "uid";
        public const string FOLLOW = "follow";
        public const string TIME = "time";
    }
    /// <summary>
    ///个人资产表
    /// </summary>
    public class Goods
    {
        public const string TABLE_GOODS = "goods";
        public const string UID = "uid";
        public const string FLOWER = "flower";
        public const string MONEY = "money";
    }
    /// <summary>
    /// 地区表
    /// </summary>
    public class AreaInfo
    {
        public const string TABLE_AREA = "areainfo";
        public const string AREACODE = "areacode";
        public const string AREANAME = "areaname";
    }
    /// <summary>
    /// 学校表
    /// </summary>
    public class SchoolInfo
    {
        public const string TABLE_SCHOOLINFO = "schoolinfo";
        public const string SCHOOLCODE = "SchoolCode";
        public const string SCHOOLNAME = "SchoolName";
        public const string AREACODE = "AREACODE";
    }

}
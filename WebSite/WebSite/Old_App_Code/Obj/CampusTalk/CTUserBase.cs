using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

    public class CTUserBase
    {
        string uid;  //UUID+0 ||UUID+1
        CTSchool school; //学校
        string sex;  //性别

    public string Uid
    {
        get
        {
            return uid;
        }

        set
        {
            uid = value;
        }
    }

    public CTSchool School
    {
        get
        {
            return school;
        }

        set
        {
            school = value;
        }
    }

    public string Sex
    {
        get
        {
            return sex;
        }

        set
        {
            sex = value;
        }
    }
}

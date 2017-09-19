using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSite.App_Code.Obj.CampusTalk
{
    public class CTPerson:CTUserBase
    {
        string email;
        string nickname;
        string headpic;
        string age;
        string userexplain;
        string state;
        string password;
        public string Password
        {
            get
            {
                return password;
            }

            set
            {
                password = value;
            }
        }

        public string Email
        {
            get
            {
                return email;
            }

            set
            {
                email = value;
            }
        }

        public string Nickname
        {
            get
            {
                return nickname;
            }

            set
            {
                nickname = value;
            }
        }

        public string Headpic
        {
            get
            {
                return headpic;
            }

            set
            {
                headpic = value;
            }
        }

        public string Age
        {
            get
            {
                return age;
            }

            set
            {
                age = value;
            }
        }

        public string Userexplain
        {
            get
            {
                return userexplain;
            }

            set
            {
                userexplain = value;
            }
        }

        public string State
        {
            get
            {
                return state;
            }

            set
            {
                state = value;
            }
        }
    }
}
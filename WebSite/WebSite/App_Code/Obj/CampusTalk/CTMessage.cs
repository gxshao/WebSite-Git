using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSite.App_Code.Obj.CampusTalk
{
    public class CTMessage
    {
        string from;
        string to;
        string body;
        string time;

        public string From
        {
            get
            {
                return from;
            }

            set
            {
                from = value;
            }
        }

        public string To
        {
            get
            {
                return to;
            }

            set
            {
                to = value;
            }
        }

        public string Body
        {
            get
            {
                return body;
            }

            set
            {
                body = value;
            }
        }

        public string Time
        {
            get
            {
                return time;
            }

            set
            {
                time = value;
            }
        }
    }
}
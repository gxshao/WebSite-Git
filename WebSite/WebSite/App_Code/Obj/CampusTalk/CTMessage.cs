using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSite.App_Code.Obj.CampusTalk
{
    public class CTMessage
    {
        public const string MESSAGE_TYPE_TEXT = "0";
        public const string MESSAGE_TYPE_EMOJI = "1";
        public const string MESSAGE_TYPE_AUDIO = "2";
        public const string MESSAGE_TYPE_PHOTO = "3";
        string from;
        string to;
        string type; // 文字 0，表情 1，语音 2， 图片 3
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

        public string Type
        {
            get
            {
                return type;
            }

            set
            {
                type = value;
            }
        }
    }
}
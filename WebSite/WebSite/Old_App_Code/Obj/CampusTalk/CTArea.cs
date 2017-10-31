using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebSite.App_Code.Obj.CampusTalk
{
    public class CTArea
    {
        string areacode = "";
        string areaname = "";

        public string Areacode
        {
            get
            {
                return areacode;
            }

            set
            {
                areacode = value;
            }
        }

        public string Areaname
        {
            get
            {
                return areaname;
            }

            set
            {
                areaname = value;
            }
        }
    }
}
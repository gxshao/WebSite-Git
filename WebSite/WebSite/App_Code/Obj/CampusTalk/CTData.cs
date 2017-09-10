using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebSite.App_Code.Obj.CampusTalk
{
    public class CTData<T>
    {
        public const string DATATYPE_CONNECTED = "0";
        public const string DATATYPE_MESSAGE = "1";
        string dataType;
        T body;
        public string DataType
        {
            get
            {
                return dataType;
            }

            set
            {
                dataType = value;
            }
        }

        public T Body
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
    }
}

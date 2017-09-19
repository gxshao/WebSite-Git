using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// ctUtils 的摘要说明
/// </summary>
public class ctUtils
{
    public ctUtils()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    public static string getSexbyUid(string uid)
    {
        return uid.Substring(uid.Length - 1, 1).Equals("0")?GlobalVar.SEX_MALE:GlobalVar.SEX_FEMALE;
    }
    public static string GetUTF8String(byte[] buffer)
    {
        if (buffer == null)
            return null;

        if (buffer.Length <= 3)
        {
            return Encoding.UTF8.GetString(buffer);
        }

        byte[] bomBuffer = new byte[] { 0xef, 0xbb, 0xbf };

        if (buffer[0] == bomBuffer[0]
            && buffer[1] == bomBuffer[1]
            && buffer[2] == bomBuffer[2])
        {
            return new UTF8Encoding(false).GetString(buffer, 3, buffer.Length - 3);
        }

        return Encoding.UTF8.GetString(buffer);
    }
    public static bool IsImage(string str)
    {
        bool isimage = false;
        string thestr = str.ToLower();
        //限定只能上传jpg和gif图片
        string[] allowExtension = { ".jpg", ".gif", ".bmp", ".png" };
        //对上传的文件的类型进行一个个匹对
        for (int i = 0; i < allowExtension.Length; i++)
        {
            if (thestr == allowExtension[i])
            {
                isimage = true;
                break;
            }
        }
        return isimage;
    }
}
<%@ WebHandler Language="C#" Class="upload" %>

using System;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;

public class upload : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        //文件大小限制10M
        const int maxSize = 10485760;
        //定义允许上传的文件扩展名
        var ext = new[] { "rar", "zip", "gif", "jpg", "jpeg", "png", "bmp", "xls", "xlsx", "doc", "docx", "et", "wps" };
        string strExt = "";
        foreach (var a in ext)
        {
            strExt += a + "/";
        }
        strExt = strExt.TrimEnd('/');
        string savePath = "/upLoads/";                //文件保存路径

        var resp = new UploadResponse();
        HttpFileCollection imgFile = context.Request.Files;
        if (imgFile.Count > 0)
        {
            string fileExt = Path.GetExtension(imgFile[0].FileName);           //获得扩展名
            if (string.IsNullOrEmpty(fileExt) || Array.IndexOf(ext, fileExt.Substring(1).ToLower()) < 0)
            {
                resp.Eor = "error";
                resp.Msg = string.Format("扩展名为{0}的文件不允许上传!\n只允许上传{1}格式的文件。", fileExt, strExt);
            }
            else
            {
                if (imgFile[0].InputStream.Length > maxSize)
                {
                    resp.Eor = "error";
                    resp.Msg = "上传文件大小超过限制！";
                }
                else
                {
                    string fileNewName = DateTime.Now.ToString("yyyyMMddHHmmssffff") + fileExt;     //新的文件名
                    try
                    {
                        SaveFile(imgFile[0], context.Server.MapPath(savePath), fileNewName);       //保存文件

                        resp.Eor = "succss";
                        resp.Msg = "上传成功! 文件大小为:" + imgFile[0].ContentLength;
                        resp.ImgUrl = savePath + fileNewName;
                        resp.FName = fileNewName;
                        resp.OName = imgFile[0].FileName;
                    }
                    catch (Exception ex)
                    {
                        resp.Eor = "error";
                        resp.Msg = ex.ToString();
                    }
                }
            }
        }
        else
        {
            resp.Eor = "error";
            resp.Msg = "请选择文件!";
        }
        context.Response.ContentType = "text/html";
        context.Response.Write(new JavaScriptSerializer().Serialize(resp));
        context.Response.End();
    }

    private void SaveFile(HttpPostedFile imgFile, string savePath, string fileName)
    {
        if (!Directory.Exists(savePath))    //判断文件存放路径是否存在
        {
            Directory.CreateDirectory(savePath);
        }

        imgFile.SaveAs(Path.Combine(savePath, fileName));
    }
    
    public class UploadResponse
    {
        public string Eor { get; set; }
        public string Msg { get; set; }
        public string ImgUrl { get; set; }
        public string FName { get; set; }
        public string OName { get; set; }

    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}
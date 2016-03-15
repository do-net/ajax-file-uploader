<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="js/ajaxfileupload.js"></script>
    <script type="text/javascript">
        function CheckFile() {
            $.ajaxFileUpload({
                url: 'upload.ashx?time=' + new Date(),
                secureuri: false,
                fileElementId: 'fuFileLoad', //上传控件ID  
                dataType: 'json', //返回值类型 一般设置为json
                success: function (data, status) {
                    var jsonData = $.parseJSON(data);
                    alert(jsonData.Eor);
                    if (jsonData.Eor == "succss") {
                        alert(jsonData.Msg);
                    } else {
                        alert(jsonData.Msg);
                    }
                },
                error: function (data, status, e) {
                    alert(e);   //就是在这弹出“语法错误”   
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:FileUpload ID="fuFileLoad" runat="server" onchange="CheckFile();" />
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentFailed.aspx.cs" Inherits="NETframeworkPaymentGateway.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Error notification</title>
</head>
<body style="background-color: #63E9FC">
    <center>
    <h1>Error notification</h1>
    <div style="font-size:25px; color:red" >
	        An error has occurred during order processing.<BR>
    </div>
    
    <br /><br />
     <div style="font-size:15px; color:black" >

        <%
        foreach (String key in Request.QueryString.AllKeys)
        {
        Response.Write(key + " : " + Request.QueryString[key]+ "<br />");
        }

            %>
         <br /><br />
         <p>Copyright Bankart d.o.o.</p>
    </div>
    </center>
</body>
</html>

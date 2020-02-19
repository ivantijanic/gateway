<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentSuccessful.aspx.cs" Inherits="NETframeworkPaymentGateway.PaymentSuccessful" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bill payment</title>
</head>
<body style="background-color: #63E9FC">
    <center>
    <h1>Bill payment</h1>
    <div style="font-size:25px; color:green" >
	        The transaction has been approved. Thank you for your purchase.<BR>
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
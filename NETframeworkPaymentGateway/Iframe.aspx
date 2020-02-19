<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Iframe.aspx.cs" Inherits="NETframeworkPaymentGateway.Iframe" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <TITLE>Test iframe - PHP:</TITLE>
    </head>
    <body style="background-color: #63E9FC">
        <h1>Test iframe - PHP:</h1>
        <iframe id="form-iframe" src="<% Response.Write(Request.Params["TranType"]); %>" style="margin:0; width:100%; height:700px; border:none; overflow:hidden; background: red; max-width: 800px" scrolling="yes"></iframe>
</body>

</html>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Callback.aspx.cs" Inherits="NETframeworkPaymentGateway.Callback" %>
<%@ Import Namespace="ClassPaymentGateway" %>
<%@ Import Namespace="ClassPaymentGateway.Callback" %>
<%@ Import Namespace="System.Net.Http" %>
<%@ Import Namespace ="System.IO" %>

    <%


        callbackType reansactionResponse = Class1.CallbackRequest(Request.InputStream);

        Response.Write("OK");


        %>

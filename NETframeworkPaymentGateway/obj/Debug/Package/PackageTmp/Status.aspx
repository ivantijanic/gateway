<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Status.aspx.cs" Inherits="NETframeworkPaymentGateway.Status" %>
<%@ Import Namespace="ClassPaymentGateway.Status" %>
<%@ Import Namespace="ClassPaymentGateway.StatusResult" %>
<%@ Import Namespace="ClassPaymentGateway" %>
<%@ Import Namespace ="System.IO" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Status</title>
</head>
<body style="background-color: #63E9FC">
 <%

         String GATEWAY_USERNAME = "ApiUsername";
         String GATEWAY_PASSWORD = "ApiPassword";
         String GATEWAY_CONNECTOR_API_KEY = "ConnectorApiKeyName";
         String GATEWAY_CONNECTOR_SHARED_SECRET = "ConnectorSharedSecret";
         statusType myTransaction = new statusType
         {

             username = GATEWAY_USERNAME,
             password = Class1.SHA1(GATEWAY_PASSWORD),
             ItemElementName = ItemChoiceType.transactionUuid,
             Item = Request.Form["RefTranId"],


             /*
             ItemElementName = ItemChoiceType1.@void,
             Item = new voidType
             {
                 transactionId = "V-" + Guid.NewGuid().ToString(),

                 referenceTransactionId = Request.Form["RefTranId"],
             },*/
         };

         //send the transaction request
         statusResultType transactionResponse = Class1.StatusRequest(GATEWAY_CONNECTOR_API_KEY, GATEWAY_CONNECTOR_SHARED_SECRET, myTransaction);
         //manage with response
         Response.Write("gatewayReferenceId=" + transactionResponse.transactionUuid);
         Response.Write("<br>transactionType=" + transactionResponse.transactionType);
         Response.Write("<br>transaction Status=" + transactionResponse.transactionStatus);
         Response.Write("<br>transaction Amount=" + transactionResponse.amount);


    %>
</body>
</html>

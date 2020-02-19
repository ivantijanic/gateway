<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Void.aspx.cs" Inherits="NETframeworkPaymentGateway.Void" %>
<%@ Import Namespace="ClassPaymentGateway.Transaction" %>
<%@ Import Namespace="ClassPaymentGateway.Result" %>
<%@ Import Namespace="ClassPaymentGateway" %>
<%@ Import Namespace ="System.IO" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Void</title>
</head>
<body style="background-color: #63E9FC">
    <%

        String GATEWAY_USERNAME = "ApiUsername";
        String GATEWAY_PASSWORD = "ApiPassword";
        String GATEWAY_CONNECTOR_API_KEY = "ConnectorApiKeyName";
        String GATEWAY_CONNECTOR_SHARED_SECRET = "ConnectorSharedSecret";
        transactionType myTransaction = new transactionType
        {

            username = GATEWAY_USERNAME,
            password = Class1.SHA1(GATEWAY_PASSWORD),
            ItemElementName = ItemChoiceType1.@void,
            Item = new voidType
            {
                transactionId = "V-" + Guid.NewGuid().ToString(),
               
                referenceTransactionId = Request.Form["RefTranId"],
            },
        };

              //send the transaction request
              resultType transactionResponse = Class1.TransactionRequest(GATEWAY_CONNECTOR_API_KEY, GATEWAY_CONNECTOR_SHARED_SECRET, myTransaction);


        switch (transactionResponse.returnType.Value)
        {
            case returnTypeValues.FINISHED:
                if (transactionResponse.success == true) {
                    Response.Redirect("/PaymentSuccessful.aspx");
                    break;
                }
                else {
                    Response.Redirect("/PaymentFailed.aspx");
                    break;
                }
            case returnTypeValues.REDIRECT:                        // with payment.js this covers the case for 3DS redirect to the card issuer's site
                Response.Redirect(transactionResponse.redirectUrl);
                break;
            case returnTypeValues.ERROR:
                string postString = "?code=" + transactionResponse.errors.First().code;
                postString = postString + "&message=" + transactionResponse.errors.First().message;
                postString = postString + "&adapterCode=" + transactionResponse.errors.First().adapterCode;
                postString = postString + "&adapterMessage=" + transactionResponse.errors.First().adapterCode;
                Response.Redirect("/PaymentFailed.aspx" + postString);
                break;

            default: // just in case since other status are possible (but not expected)
                Response.Redirect("/PaymentFailed.aspx");
                break;
        }
    %>
</body>
</html>

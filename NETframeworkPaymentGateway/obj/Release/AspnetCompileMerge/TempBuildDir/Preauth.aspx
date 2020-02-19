<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Preauth.aspx.cs" Inherits="NETframeworkPaymentGateway.Preauth" %>
<%@ Import Namespace="ClassPaymentGateway.Transaction" %>
<%@ Import Namespace="ClassPaymentGateway.Result" %>
<%@ Import Namespace="ClassPaymentGateway" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Preauthorization</title>
</head>
<body style="background-color: #63E9FC">
  <%
                  String token = Request.Form["transaction_token"];
                  bool isWithRegister = bool.Parse(Request.Form["withRegister"]);
                  bool isCardOnFile = bool.Parse(Request.Form["CardOnFile"]);

                  String GATEWAY_USERNAME = "ApiUsername";
                  String GATEWAY_PASSWORD = "ApiPassword";
                  String GATEWAY_CONNECTOR_API_KEY = "ConnectorApiKeyName";
                  String GATEWAY_CONNECTOR_SHARED_SECRET = "ConnectorSharedSecret";
                  transactionType myTransaction = new transactionType
                  {

                      username = GATEWAY_USERNAME,
                      password = ClassRequests.SHA1(GATEWAY_PASSWORD),
                      language = "sl",
                      ItemElementName = ItemChoiceType1.preauthorize,
                  Item = new preauthorizeType
                  {
                      transactionId = "P-" + Guid.NewGuid().ToString(),
                      currency = "EUR",
                      amountSpecified = true,
                      amount = 100.00M,
                      withRegister = isWithRegister,
                      transactionToken = token,
                      transactionIndicatorSpecified = true,
                      transactionIndicator = ClassRequests.SetCoF(isCardOnFile),
                      referenceTransactionId = ClassRequests.SetReferenceTransactionId(isCardOnFile, Request.Form["RefTranId"]),
                      successUrl = "www.domain.si/successURL",
                      errorUrl = "www.domain.si/errorURL",
                      cancelUrl= "www.domain.si/cancelURL",
                      callbackUrl = "www.domain.si/callbackURL",
                      Item = new customerType
                      {
                          firstName = "First Name",
                          lastName = "Last Name",
                          billingAddress1 = "Street 1",
                          billingCity = "City",
                          billingCountry = "SI",
                          billingPostcode ="1000",
                          email = "customer@email.com",
                          ipAddress = "1.1.1.1",
                      },
                  },
                };

              //send the transaction request
              resultType transactionResponse = ClassRequests.TransactionRequest(GATEWAY_CONNECTOR_API_KEY, GATEWAY_CONNECTOR_SHARED_SECRET, myTransaction);


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

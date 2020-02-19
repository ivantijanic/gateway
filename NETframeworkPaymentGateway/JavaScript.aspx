<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JavaScript.aspx.cs" Inherits="NETframeworkPaymentGateway.JavaScript" %>

<!DOCTYPE html>

<html>
<head>
<script data-main="payment-js" src="https://gateway.bankart.si/js/integrated/payment.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<TITLE>Transaction settings - JSP:</TITLE>
</head>   
<body style="background-color: #63E9FC">


<form id="payment_form" method="POST" action="<% Response.Write(Request.Params["TranType"]); %>"  onsubmit="interceptSubmit(); return false;">
    <input type="hidden" name="transaction_token" id="transaction_token" />
    <div>
        
        <% 
        String tranType = Request.Params["TranType"];
	if(tranType != null){

            %>
             <p style='color:green; font-size: 20px'> <% Response.Write(tranType); %> </p><br>
            <% } %>

    </div>
    
    <div>
        <label for="first_name">First name</label>
        <input type="text" id="first_name" name="first_name" value='Janez'/>
    </div>
    <div>
        <label for="last_name">Last name</label>
        <input type="text" id="last_name" name="last_name" value='Novak'/>
    </div>
    <div>
        <label for="number_div">Card number</label>
        <div id="number_div" style="height: 35px; width: 200px;"></div>
    </div>
    <div>
        <label for="cvv_div">CVV</label>
        <div id="cvv_div" style="height: 35px; width: 200px;"></div>
    </div>

    <div>
        <label for="exp_month">Month</label>
        <input type="text" id="exp_month" name="exp_month" value="05" />
    </div>
    <div>
        <label for="exp_year">Year</label>
        <input type="text" id="exp_year" name="exp_year" value="2024"/>
    </div>
    <div>
        <label for="email">Email</label>
        <input type="text" id="email" name="email" />
    </div>
    <div>
        <input type="submit" value="Submit" />
    </div>
</form>


<script type="text/javascript">
    var payment = new PaymentJs("1.2");
    
    
   // payment.init('G1zWYsFfbHql3DLHfzBa', 'number_div', 'cvv_div', function(payment) {
    payment.init('PublicIntegrationKey', 'number_div', 'cvv_div', function (payment) {
        var numberFocused = false;
        var cvvFocused = false;
        var style = {
            'color': '#555',
            'border': '1px solid #ccc',
            'border-radius': '4px',
            'box-shadow': 'inset 0 1px 1px rgba(0, 0, 0, .075)',
            'transition':'border-color ease-in-out .15s, box-shadow ease-in-out .15s'
        };
        var focusStyle = {
            'border-color': '#747171',
            '-webkit-box-shadow': 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6)',
            'box-shadow': 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(34, 36, 38, 0.6)'
        };

        payment.setNumberStyle(style);
        payment.setCvvStyle(style);
        
        payment.numberOn('focus', function() {
            numberFocused = true;
            payment.setNumberStyle(focusStyle);
         });
        payment.cvvOn('focus', function() {
            numberFocused = true;
            payment.setCvvStyle(focusStyle);
        });
          // Blur events
        payment.numberOn('blur', function() {
            numberFocused = false;
            payment.setNumberStyle(style);
        });
        payment.cvvOn('blur', function() {
            cvvFocused = false;
            payment.setCvvStyle(style);
        });
        payment.numberOn('input', function(data) {
            
        });
    });



    function interceptSubmit() {

    
        var data = {
        first_name: $('#first_name').val(),
        last_name: $('#last_name').val(),
// OR   card_holder: $('#card_holder').val(),
        month: $('#exp_month').val(),
        year: $('#exp_year').val(),
        email: $('#email').val()
    };
    payment.tokenize(
        data, //additional data, MUST include card_holder (or first_name & last_name), month and year
        function(token, cardData) { //success callback function
            $('#transaction_token').val(token); //store the transaction token
            $('#payment_form').get(0).submit(); //submit the form
            console.log(token);
        }, 
        function(errors) { //error callback function
            alert('Errors occured');
            //render error information here
        }
    );
}
</script>

</body>
</html>
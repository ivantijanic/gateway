using System;
using ClassPaymentGateway.Transaction;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using System.Net.Http;
using System.Net.Http.Headers;
using ClassPaymentGateway.Status;
using ClassPaymentGateway.StatusResult;
using ClassPaymentGateway.Callback;


namespace ClassPaymentGateway
{
    public class ClassRequests
    {
        private static string GenerateHashString(HashAlgorithm algo, string text)
        {
            // Compute hash from text parameter
            algo.ComputeHash(Encoding.UTF8.GetBytes(text));

            // Get has value in array of bytes
            var result = algo.Hash;


            return BitConverter.ToString(result).Replace("-", string.Empty).ToLower();

        }
        public static string SHA1(string text)
        {
            var result = default(string);

            using (var algo = new SHA1Managed())
            {
                result = GenerateHashString(algo, text);
            }

            return result;
        }
        private static byte[] TransactionRequestContent(transactionType transaction)
        {
            // serialize transaction object to XML

            XmlSerializerNamespaces xlmnsEdit = new XmlSerializerNamespaces();
            xlmnsEdit.Add(string.Empty, "http://gateway.bankart.si/Schema/V2/Transaction"); // because I'm OCD and I want to remove :xsd :xsi
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(Transaction.transactionType));

            byte[] xmlByte;
            using (MemoryStream memoryStream = new MemoryStream())
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Indent = true;                 // feel free to set to false
                settings.NewLineOnAttributes = true;    // cosmetic, feel free to set to false
                settings.Encoding = Encoding.UTF8;      // probably default but doesn't hurt to be sure

                using (var xmlWriter = XmlWriter.Create(memoryStream, settings))
                {

                    xmlSerializer.Serialize(xmlWriter, transaction, xlmnsEdit);
                }
                xmlByte = memoryStream.ToArray();
            }
            return xmlByte;

        }

        private static byte[] StatusRequestContent(statusType transaction)
        {
            // serialize transaction object to XML

            XmlSerializerNamespaces xlmnsEdit = new XmlSerializerNamespaces();
            xlmnsEdit.Add(string.Empty, "http://gateway.bankart.si/Schema/V2/Status"); // because I'm OCD and I want to remove :xsd :xsi
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(Status.statusType));

            byte[] xmlByte;
            using (MemoryStream memoryStream = new MemoryStream())
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Indent = true;                 // feel free to set to false
                settings.NewLineOnAttributes = true;    // cosmetic, feel free to set to false
                settings.Encoding = Encoding.UTF8;      // probably default but doesn't hurt to be sure

                using (var xmlWriter = XmlWriter.Create(memoryStream, settings))
                {

                    xmlSerializer.Serialize(xmlWriter, transaction, xlmnsEdit);
                }
                xmlByte = memoryStream.ToArray();
            }
            return xmlByte;

        }

        public static Result.resultType TransactionRequest(String apiKey, String sharedSecret, Transaction.transactionType transaction)
        {
            String CONTENT_TYPE = "text/xml; charset=utf-8";
            byte[] body = TransactionRequestContent(transaction);
            string hmacValue;

            DateTime timeSent = DateTime.Now;

            using (HMACSHA512 hmac = new HMACSHA512(Encoding.UTF8.GetBytes(sharedSecret)))
            {
                using (MD5 md5 = MD5.Create())
                {
                    string md5xml = BitConverter.ToString(md5.ComputeHash(body)).Replace("-", string.Empty).ToLower();
                    string[] headerData = { "POST", md5xml, CONTENT_TYPE, timeSent.ToUniversalTime().ToString("r"), "", "/transaction" };
                    hmacValue = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(String.Join("\n", headerData))));
                }
            }

            HttpClient client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Clear();

            HttpRequestMessage request = new HttpRequestMessage
            {
                Method = HttpMethod.Post,
                RequestUri = new Uri("https://gateway.bankart.si/transaction"),
                
                Content = new StringContent(Encoding.UTF8.GetString(body), Encoding.UTF8, "text/xml")
            };
            request.Headers.Date = timeSent.ToUniversalTime();    // make sure the time is the same due to validation
            request.Headers.Authorization = new AuthenticationHeaderValue("Gateway", apiKey + ":" + hmacValue);
            HttpResponseMessage myHttpresponse = client.SendAsync(request).Result;

            
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(Result.resultType));

            Result.resultType response;
            using (Stream stream = myHttpresponse.Content.ReadAsStreamAsync().Result)
            {
                response = (Result.resultType)xmlSerializer.Deserialize(stream);
            }
            
            return response;
        }


        public static statusResultType StatusRequest(String apiKey, String sharedSecret, Status.statusType transaction)
        {
            String CONTENT_TYPE = "text/xml; charset=utf-8";
            byte[] body = StatusRequestContent(transaction);
            string hmacValue;

            DateTime timeSent = DateTime.Now;

            using (HMACSHA512 hmac = new HMACSHA512(Encoding.UTF8.GetBytes(sharedSecret)))
            {
                using (MD5 md5 = MD5.Create())
                {
                    string md5xml = BitConverter.ToString(md5.ComputeHash(body)).Replace("-", string.Empty).ToLower();
                    string[] headerData = { "POST", md5xml, CONTENT_TYPE, timeSent.ToUniversalTime().ToString("r"), "", "/status" };
                    hmacValue = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(String.Join("\n", headerData))));
                }
            }

            HttpClient client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Clear();

            HttpRequestMessage request = new HttpRequestMessage
            {
                Method = HttpMethod.Post,
                RequestUri = new Uri("https://gateway.bankart.si/status"),
                Content = new StringContent(Encoding.UTF8.GetString(body), Encoding.UTF8, "text/xml")
            };
            request.Headers.Date = timeSent.ToUniversalTime();    // make sure the time is the same due to validation
            request.Headers.Authorization = new AuthenticationHeaderValue("Gateway", apiKey + ":" + hmacValue);
            HttpResponseMessage myHttpresponse = client.SendAsync(request).Result;


            XmlSerializer xmlSerializer = new XmlSerializer(typeof(StatusResult.statusResultType));

            StatusResult.statusResultType response;
            using (Stream stream = myHttpresponse.Content.ReadAsStreamAsync().Result)
            {
                response = (StatusResult.statusResultType)xmlSerializer.Deserialize(stream);
            }

            return response;
        }
        
        public static callbackType CallbackRequest ( Stream transaction)
        {
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(Callback.callbackType));


            Callback.callbackType response;
           // using (Stream stream = myHttpresponse.Content.ReadAsStreamAsync().Result)
            //{
                response = (Callback.callbackType)xmlSerializer.Deserialize(transaction);
            //}

            return response;
        }

    

        public static transactionIndicatorType SetCoF(bool isCardOnFile)
        {
            if (isCardOnFile)
                return transactionIndicatorType.CARDONFILE;
            else
                return transactionIndicatorType.SINGLE;
        }
        public static string SetReferenceTransactionId(bool isCardOnFile, string refId )
        {
            if (isCardOnFile)
                return refId;
            else
                return null;
        }

    }
}

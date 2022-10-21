function loadScript(url, callback) {
    console.log(url);
    var script = document.createElement("script")
    script.type = "text/javascript";
    script.src = url;
    document.getElementsByTagName("head")[0].appendChild(script);
    return new Promise((res, rej) => {
        script.onload = function() {
            callback(window.Paytm.CheckoutJS);
        }
    });
}

function onScriptLoad(txnToken, orderId, amount, src) {
    console.log(txnToken + " " + orderId + " " + amount);
    var config = {
        "root": "",
        "flow": "DEFAULT",
        "merchant": {
            "redirect": false,
            "name": "XYZ Enterprises",
            "logo": "https://developer.paytm.com/demo//static/images/merchant-logo.png?v=1.4"
        },

        "data": {
            "orderId": orderId,
            "token": txnToken,
            "tokenType": "TXN_TOKEN",
            "amount": amount
        },
        "handler": {
            // Only Mandatory when Merchant -> redirect is false
            "transactionStatus": function transactionStatus(paymentStatus) {
                //                 console.log("paymentStatus => "+JSON.stringify(paymentStatus));
                window.Paytm.CheckoutJS.close();
                onResultCallback(JSON.stringify(paymentStatus));
            },
            "notifyMerchant": function notifyMerchant(eventName, data) {
                console.log("notify merchant about the payment state");
                console.log("eventName = >" + eventName);
                console.log("data - >" + console.log(JSON.stringify(data)));
            },

            //Note: To be used only when the initialisation of JS module is done using Access Token.
            /*                 "initiateTransaction": function(emiSubventionToken, payableAmount, txnAmount, offer) {
                                                          console.log("initiateTransaction called", emiSubventionToken, payableAmount, txnAmount, offer)
                                                          return new Promise(function (res) {
                                                             setTimeout( function (){ res({token: txnToken, orderId: orderId})}, 2000);
                                                          });
                                       }*/
        }
    };
    return loadScript(src, function(init) {
        console.log('Script loaded!');

        if (window.Paytm && init) {
            init.onLoad(function excecuteAfterCompleteLoad() {
                // initialze configuration using init method
                init.init(config).then(function onSuccess() {
                    // after successfully update configuration invoke checkoutjs
                    init.invoke();
                }).catch(function onError(error) {
                    console.log("error => ", error);
                });
            });
        }
    });
}
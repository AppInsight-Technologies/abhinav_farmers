//function startCashfreePayment(path, params, method = 'post') {
//
//    // The rest of this code assumes you are not using a library.
//    // It can be made less verbose if you use one.
//    const form = document.createElement('form');
//    form.method = method;
//    form.action = path;
//
//    for (const key in params) {
//
//        if (params.hasOwnProperty(key)) {
//            console.log(key + " " + params[key]);
//            const hiddenField = document.createElement('input');
//            hiddenField.type = 'hidden';
//            hiddenField.name = key;
//            hiddenField.value = fparams[key];
//
//            form.appendChild(hiddenField);
//        }
//    }
//
//    document.body.appendChild(form);
//    form.submit();
//}
//const orderToken = "your-token";
const cashfree = new Cashfree();

function startCashfreePayments(orderToken) {
//    alert("Order is PROCEEDING" )

    const paymentDom = document.getElementById("payment-form");
    var modal = document.getElementById("myModal");

    var span = document.getElementsByClassName("close")[0];
    span.onclick = function(data) {
      modal.style.display = "none";
      onResultFailure(JSON.stringify(data))
    }

    const success = function(data) {
        if (data.order && data.order.status == "PAID") {
            //            alert("Order is PAID")
            modal.style.display = "none";
            onResultSuccess(JSON.stringify(data));
            //order is paid
            //verify order status by making an API call using your server to cashfree's server
            // using data.order.order_id
        } else {
            //order is still active

            // alert("failure...hi..")
            alert("Order is ACTIVE")
        }
    }
    let failure = function(data) {
  //         alert("error" + data.order.errorText)
        modal.style.display = "none";

        onResultFailure(JSON.stringify(data))
    }
    const dropConfig = {
        "components": [
            "vorder-details",
            "card",
            "netbanking",
            "app",
            "upi"
        ],
        "orderToken": orderToken,
        "onSuccess": success,
        "onFailure": failure,
        "style": {
            "outline": "0",
            "border-width": "1px",
            "border-radius": "0px",
            "backgroundColor": "#ffffff",
            "color": "#11385b",
            "fontFamily": "Lato",
            "fontSize": "14px",
            "errorColor": "#ff0000",
            "theme": "light", //(or dark)
        }
    }
    modal.style.display = "block";
    cashfree.initialiseDropin(paymentDom, dropConfig);
}
function razorCheckout(key, amount, currency, name, phone, email, description) {
    var st = str;
    var options = {
        "key": "rzp_test_i74l9TMwp6M8A9", // Enter the Key ID generated from the Dashboard
        "amount": (amount * 100).toString(), // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
        "currency": currency,
        "name": "Acme Corp",
        "description": description,
        "image": "https://example.com/your_logo",
        //        "order_id": "144444", //This is a sample Order ID. Pass the `id` obtained in the response of Step 1
        "handler": function(response) {
            alert(response.razorpay_payment_id);
            alert(response.razorpay_order_id);
            alert(response.razorpay_signature)
        },
        "prefill": {
            "name": name,
            "email": email,
            "contact": phone
        },
        "notes": {
            "address": "Razorpay Corporate Office"
        },
        "theme": {
            "color": "#3399cc"
        }
    };
    var rzp1 = new Razorpay(options);
    rzp1.on('payment.failed', function(response) {
        alert(response.error.code);
        alert(response.error.description);
        alert(response.error.source);
        alert(response.error.step);
        alert(response.error.reason);
        alert(response.error.metadata.order_id);
        alert(response.error.metadata.payment_id);
    });
    rzp1.open();
    //    e.preventDefault();
}
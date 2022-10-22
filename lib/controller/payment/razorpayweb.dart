  import 'dart:convert';
  import 'package:eventify/eventify.dart';

import  'paytmabstactsdk.dart' if (dart.library.html) 'dart:js' as js ;

class WebRazorPaySdk{
  static const _CODE_PAYMENT_SUCCESS = 0;
  static const _CODE_PAYMENT_ERROR = 1;
  static const _CODE_PAYMENT_EXTERNAL_WALLET = 2;

  // Event names
  static const EVENT_PAYMENT_SUCCESS = 'payment.success';
  static const EVENT_PAYMENT_ERROR = 'payment.error';
  static const EVENT_EXTERNAL_WALLET = 'payment.external_wallet';

  // Payment error codes
  static const NETWORK_ERROR = 0;
  static const INVALID_OPTIONS = 1;
  static const PAYMENT_CANCELLED = 2;
  static const TLS_ERROR = 3;
  static const INCOMPATIBLE_PLUGIN = 4;
  static const UNKNOWN_ERROR = 100;

  static Map<dynamic, dynamic>? param;

   EventEmitter? _eventEmitter;
WebRazorPaySdk(){
  _eventEmitter = new EventEmitter();
}
  void open(Map<String, dynamic> options) async {
    Map<String, dynamic> validationResult = _validateOptions(options);

    if (!validationResult['success']) {
      _handleResult({
        'type': _CODE_PAYMENT_ERROR,
        'data': {
          'code': INVALID_OPTIONS,
          'message': validationResult['message']
        }
      });
      return;
    }

    js.context.callMethod('razorCheckout', [options]);
    js.context['onResultCallback'] = (String parameter) async{
      print("response=> $parameter");
      _handleResult(json.decode(parameter) as Map<dynamic, dynamic>);

    };
  }

  void on(String event, Function handler) {
    EventCallback cb = (event, cont) {
      handler(event.eventData);
    };
    _eventEmitter!.on(event, null, cb);
    // _resync();
  }

  void _handleResult(Map<dynamic, dynamic> response) {
    String eventName;
    Map<dynamic, dynamic> data = response["data"];

    dynamic payload;

    switch (response['type']) {
      case _CODE_PAYMENT_SUCCESS:
        eventName = EVENT_PAYMENT_SUCCESS;
        payload = PaymentSuccessResponse.fromMap(data);
        break;

      case _CODE_PAYMENT_ERROR:
        eventName = EVENT_PAYMENT_ERROR;
        payload = PaymentFailureResponse.fromMap(data);
        break;

      case _CODE_PAYMENT_EXTERNAL_WALLET:
        eventName = EVENT_EXTERNAL_WALLET;
        payload = ExternalWalletResponse.fromMap(data);
        break;

      default:
        eventName = 'error';
        payload =
            PaymentFailureResponse(UNKNOWN_ERROR, 'An unknown error occurred.');
    }

    _eventEmitter!.emit(eventName, null, payload);
  }
  static Map<String, dynamic> _validateOptions(Map<String, dynamic> options) {
    var key = options['key'];
    if (key == null) {
      return {
        'success': false,
        'message': 'Key is required. Please check if key is present in options.'
      };
    }
    return {'success': true};
  }

  static Future<Map<dynamic, dynamic>> startTransaction(txnToken,orderId,amount,bool isStaging,mid,onResponse) async {

    if(isStaging){
      print("paytm Web:$txnToken ,$orderId ,$amount ,$isStaging , xexqsh45840354978392 ");
      js.context.callMethod('onScriptLoad', [txnToken,orderId,amount,"https://securegw-stage.paytm.in/merchantpgpui/checkoutjs/merchants/xexqsh45840354978392.js"]);
    }else{
      print("paytm Web:$txnToken ,$orderId ,$amount ,$isStaging ,$mid ");
      js.context.callMethod('onScriptLoad', [txnToken,orderId,amount,"https://securegw.paytm.in/merchantpgpui/checkoutjs/merchants/$mid.js"]);
    }
    js.context['onResultCallback'] = (String parameter) async{
      print("response=> $parameter");
      onResponse(json.decode(parameter) as Map<dynamic, dynamic>);
    };
    return  Future.value(param);
    }

  // void _resync() async {
  //   var response = await _channel.invokeMethod('resync');
  //   if (response != null) {
  //     _handleResult(response);
  //   }
  // }
  }

  class PaymentSuccessResponse {
    String paymentId;
    String orderId;
    String signature;

    PaymentSuccessResponse(this.paymentId, this.orderId, this.signature);

    static PaymentSuccessResponse fromMap(Map<dynamic, dynamic> map) {
      String paymentId = map["razorpay_payment_id"];
      String signature = map["razorpay_signature"];
      String orderId = map["razorpay_order_id"];

      return new PaymentSuccessResponse(paymentId, orderId, signature);
    }
  }

  class PaymentFailureResponse {
    int code;
    String message;

    PaymentFailureResponse(this.code, this.message);

    static PaymentFailureResponse fromMap(Map<dynamic, dynamic> map) {
      var code = map["code"] as int;
      var message = map["message"] as String;
      return new PaymentFailureResponse(code, message);
    }
  }

  class ExternalWalletResponse {
    String walletName;

    ExternalWalletResponse(this.walletName);

    static ExternalWalletResponse fromMap(Map<dynamic, dynamic> map) {
      var walletName = map["external_wallet"] as String;
      return new ExternalWalletResponse(walletName);
    }
  }

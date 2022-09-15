/*
import 'package:eventify/eventify.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayWeb extends Razorpay{
  static const _CODE_PAYMENT_SUCCESS = 0;
  static const _CODE_PAYMENT_ERROR = 1;
  static const _CODE_PAYMENT_EXTERNAL_WALLET = 2;
   EventEmitter _eventEmitter;
  RazorPayWeb(){
    _eventEmitter = new EventEmitter();
  }
  @override
  void open(Map<String, dynamic> options) {

  }

  @override
  void on(String event, Function handler) {
    EventCallback cb = (event, cont) {
      handler(event.eventData);
    };
    _eventEmitter.on(event, null, cb);
    _resync();
  }

  @override
  void clear() {

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
  void _handleResultweb(Map<dynamic, dynamic> response) {
    String eventName;
    Map<dynamic, dynamic> data = response["data"];

    dynamic payload;

    switch (response['type']) {
      case _CODE_PAYMENT_SUCCESS:
        eventName = EVENT_PAYMENT_SUCCESS;
        payload = PaymentSuccessResponse.fromMap(data!);
        break;

      case _CODE_PAYMENT_ERROR:
        eventName = EVENT_PAYMENT_ERROR;
        payload = PaymentFailureResponse.fromMap(data!);
        break;

      case _CODE_PAYMENT_EXTERNAL_WALLET:
        eventName = EVENT_EXTERNAL_WALLET;
        payload = ExternalWalletResponse.fromMap(data!);
        break;

      default:
        eventName = 'error';
        payload =
            PaymentFailureResponse(UNKNOWN_ERROR, 'An unknown error occurred.');
    }

    _eventEmitter.emit(eventName, null, payload);
  }
}*/

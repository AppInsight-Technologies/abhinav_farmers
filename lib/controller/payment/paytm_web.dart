
  import 'dart:convert';
  import  'paytmabstactsdk.dart' if (dart.library.html) 'dart:js' as js ;

class WebPaytmSdk{
  static Map<dynamic, dynamic>? param;


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
  }

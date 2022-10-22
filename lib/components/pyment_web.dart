/*
import 'package:flutter/material.dart';
import '../../constants/IConstants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../generated/l10n.dart';
import '../../screens/orderconfirmation_screen.dart';
import '../../screens/payment_screen.dart';

class PymentWebView extends StatefulWidget {
  final routeArgs;
bool  isweb = false;

   PymentWebView({Key key,this.routeArgs,this.isweb}) : super(key: key);

  @override
  _PymentWebViewState createState() => _PymentWebViewState();
}

class _PymentWebViewState extends State<PymentWebView> {
 BuildContext loadingDailogCtx;

  var orderId;
  var amount;
  var customerId;

  String queryParams = "";

  WebViewController _webController;
  @override
  void initState() {
    // TODO: implement initState
   loadingdailog(context,widget.routeArgs);
    orderId = widget.routeArgs['orderId'];
    amount = widget.routeArgs['orderAmount'] */
/*"1.0"*//*
;
    queryParams = '?orderid=$orderId&customer=$customerId&price=$amount';
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        //hidden: true,
        debuggingEnabled: false,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller){
          _webController = controller;
          _webController
              .loadUrl(IConstants.API_PAYTM + queryParams);
        },
        onPageFinished: (page){
          if(page.contains("/order")) {
            setState(() {
              Navigator.of(ctx).pop();
            });
          }
          if(page.contains("/cancelTransaction")) {
            Navigator.of(context).pop();
          }
          if(!page.contains("/cancelTransaction")) {
            if (page.contains("/pgResponse.php")) {
              final routeArgs = ModalRoute
                  .of(context)
                  .settings
                  .arguments as Map<String, String>;

              final orderId = routeArgs['orderId'];

              Navigator.of(context).pushReplacementNamed(
                  OrderconfirmationScreen.routeName,
                  arguments: {
                    'orderstatus': "waiting",
                    'orderId': orderId.toString(),
                  }
              );
            }
          }
        },
      ),
    );
  }

  loadingdailog(context,routeArgs){
    showDialog(context: context, builder:(BuildContext dcontext)
    { this.loadingDailogCtx = dcontext;
      return  Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                  height: 150.0,
                  width: 400,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text(
                        S .of(context).cancel_payment, //"Cancel Payment?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 120.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    left: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    right: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  )),
                              child: Center(
                                child: Text(
                                  S .of(context).paytm_no, //'No',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacementNamed(
                                context,
                                PaymentScreen.routeName,
                                arguments: routeArgs,
                              );
                            },
                            child: Container(
                              width: 120.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    left: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    right: BorderSide(
                                      width: 1.0,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  )),
                              child: Center(
                                child: Text(
                                  S .of(context).paytm_yes, //'Yes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            );});}}
*/

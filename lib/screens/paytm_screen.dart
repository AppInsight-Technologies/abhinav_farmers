// import 'package:grocbay/rought_genrator.dart';
//
// import  '../controller/payment/payment_web_html.dart' if (dart.library.html) 'dart:html' as html;
// import '../controller/payment/payment_web_html.dart' if (dart.library.html)'dart:ui' as ui;
// import 'dart:io' as io;
// import 'package:flutter/material.dart';
// import '../generated/l10n.dart';
// import '../utils/ResponsiveLayout.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../constants/IConstants.dart';
// import '../screens/payment_screen.dart';
// import '../screens/orderconfirmation_screen.dart';
// import '../utils/prefUtils.dart';
//
// class PaytmScreen extends StatefulWidget {
//   static const routeName = '/paytm-screen';
//
//   @override
//   _PaytmScreenState createState() => _PaytmScreenState();
// }
//
// class _PaytmScreenState extends State<PaytmScreen>with Navigations {
//   WebViewController? _webController;
//   bool _loadingPayment = true;
//   String customerId = "";
//   //SharedPreferences prefs;
//   bool _isLoading = true;
//   bool _isWeb = false;
//
//   BuildContext? loadingDailogCtx;
//   @override
//   void dispose() {
//     _webController = null;
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     print("webview payment");
//     try {
//       if (io.Platform.isIOS) {
//         setState(() {
//           _isWeb = false;
//         });
//       } else {
//         setState(() {
//           _isWeb = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isWeb = true;
//       });
//     }
//     Future.delayed(Duration.zero, () async {
//       //prefs = await SharedPreferences.getInstance();
//       setState(() {
//         customerId = PrefUtils.prefs!.getString('userID')!;
//         _isLoading = false;
//       });
//     });
//     super.initState();
//   }
// //   _dialogforCancel(String minimumOrderAmountNoraml,String deliveryChargeNormal,String
// //   minimumOrderAmountPrime,String deliveryChargePrime,String minimumOrderAmountExpress,String
// //   deliveryChargeExpress,String deliveryType,String note) {
// //     final routeArgs = ModalRoute
// //         .of(context)
// //         .settings
// //         .arguments as Map<String, String>;
// //     return showDialog(
// //         context: context,
// //         builder: (context) {
// //           return StatefulBuilder(builder: (context, setState) {
// //             return Dialog(
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12.0)),
// //               child: Container(
// //                   height: 150.0,
// //                   width: 400,
// //                   child:  Column(
// //                     children: <Widget>[
// //                       SizedBox(height: 20.0),
// //                       Text(
// //                         S .of(context).cancel_payment,//"Cancel Payment?",
// //                         style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(height: 20.0),
// //                       Row(
// //                         children: [
// //                           SizedBox(width: 20.0),
// //                           GestureDetector(
// //                             onTap: (){
// //                               Navigator.of(context).pop();
// //                             },
// //                             child: Container(
// //                               width: 120.0,
// //                               height: 50.0,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(3.0),
// //                                   border: Border(
// //                                     top: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     bottom: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     left: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     right: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                   )),
// //                               child: Center(
// //                                 child: Text(
// //                                   S .of(context).paytm_no,//'No',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(color: Colors.black),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 30.0),
// //                           GestureDetector(
// //                             onTap: (){
// //
// //                               /*final orderId = routeArgs['orderId'];
// //                              final amount = routeArgs['orderAmount'] *//*"1.0"*//*;
// //                               final queryParams =
// //                                   '?orderid=$orderId&customer=$customerId&price=$amount';
// //                               Navigator.pushReplacementNamed(context, PaymentScreen.routeName, arguments: {
// //                                 'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
// //                                 'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
// //                                 'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
// //                                 'deliveryChargePrime': routeArgs['deliveryChargePrime'],
// //                                 'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
// //                                 'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
// //                                 'deliveryType': routeArgs['deliveryType'],
// //                                 'note': routeArgs['note'],
// //                               },);
// // */
// //                               Navigator.of(context).pop();
// //                               Navigator.pushReplacementNamed(context, PaymentScreen.routeName, arguments: {
// //                                 'minimumOrderAmountNoraml': minimumOrderAmountNoraml,
// //                                 'deliveryChargeNormal': deliveryChargeNormal,
// //                                 'minimumOrderAmountPrime': minimumOrderAmountPrime,
// //                                 'deliveryChargePrime': deliveryChargePrime,
// //                                 'minimumOrderAmountExpress': minimumOrderAmountExpress,
// //                                 'deliveryChargeExpress': deliveryChargeExpress,
// //                                 'deliveryType': deliveryType,
// //                                 'note': note,
// //                               },);
// //                             },
// //                             child: Container(
// //                               width: 120.0,
// //                               height: 50.0,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.lightBlueAccent,
// //                                   borderRadius: BorderRadius.circular(3.0),
// //                                   border: Border(
// //                                     top: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     bottom: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     left: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     right: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                   )),
// //                               child: Center(
// //                                 child: Text(
// //                                   S .of(context).paytm_yes,//'Yes',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(color: Colors.white),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       )
// //                     ],
// //                   )
// //               ),
// //             );
// //           });
// //         });
// //   }
//   @override
//   Widget build(BuildContext context) {
//     String channel = "";
//     final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     final orderId = routeArgs['orderId'];
//     final amount = routeArgs['amount'] /*"1.0"*/;
//
//     final queryParams = '?orderid=$orderId&customer=$customerId&price=$amount';
//     print("parm : $queryParams");
//     try{
//       if(io.Platform.isIOS) {
//         channel = "IOS";
//       } else {
//         channel = "Android";
//       }
//     } catch(e){
//       channel = "Web";
//     }
//
//     // if(_isWeb && !_isLoading) {
//     //   html.IFrameElement iframeElement = html.IFrameElement()
//     //     ..width = '640'
//     //     ..height = '360'
//     //     ..src = IConstants.API_PAYTM + queryParams
//     //     ..allowPaymentRequest= true
//     //     ..style.border = 'none';
//     //   ui.platformViewRegistry.registerViewFactory( IConstants.APP_NAME , (int viewId) => iframeElement, );
//     // }
//
//     return (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ? _isLoading ?
//     Center(child: CircularProgressIndicator(),) :
//     channel == "Web" ? HtmlElementView( viewType: IConstants.APP_NAME ) :
//     SafeArea(
//       child: Scaffold(
//           body: Stack(
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: WebView(
//                   //hidden: true,
//                   debuggingEnabled: false,
//                   javascriptMode: JavascriptMode.unrestricted,
//                   onWebViewCreated: (controller){
//                     _webController = controller;
//                     _webController!.loadUrl(IConstants.API_PAYTM + queryParams);
//                   },
//                   onPageFinished: (page){
//                     print("page: $page");
//                     if(page.contains("/order")) {
//                       setState(() {
//                         _loadingPayment = false;
//                       });
//                     }
//                     if(page.contains("/cancelTransaction")) {
//                       Navigator.of(context).pop();
//                     }
//                     if(!page.contains("/cancelTransaction")) {
//                       if (page.contains("/pgResponse.php")) {
//                         final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//                         final orderId = routeArgs['orderId'];
//                        // Navigator.of(context).pushReplacementNamed(OrderconfirmationScreen.routeName, arguments: {'orderstatus': "waiting", 'orderId': orderId.toString(),}
//                         Navigation(context, name: Routename.OrderConfirmation, navigatore: NavigatoreTyp.Push,
//                             parms: {'orderstatus' : "waiting",
//                               'orderid': orderId.toString()});
//                         //);
//                       }
//                     }
//                   },
//                 ),
//               ),
//               // if(_loadingPayment)
//               //   Center(child: CircularProgressIndicator(),),
//             ],
//           )
//       ),
//     ) :WillPopScope(
//         onWillPop: () { // this is the block you need
//           /*        Navigator.pushReplacementNamed(context, PaymentScreen.routeName, arguments: {
//           'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
//           'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
//           'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
//           'deliveryChargePrime': routeArgs['deliveryChargePrime'],
//           'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
//           'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
//           'deliveryType': routeArgs['deliveryType'],
//           'note': routeArgs['note'],
//         },);
//         return Future.value(false);*/
//
//           CancelPaymentDialog(context,routeArgs);
//           return Future.value(false);
//         },
//         child: _isLoading ?
//         Center(
//           child: CircularProgressIndicator(),
//         )
//             : channel == "Web" ? HtmlElementView(viewType: IConstants.APP_NAME) : SafeArea(
//           child: Scaffold(
//               body: Stack(
//                 children: <Widget>[
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child: WebView(
//                       //hidden: true,
//                       debuggingEnabled: false,
//                       javascriptMode: JavascriptMode.unrestricted,
//                       onWebViewCreated: (controller){
//                         _webController = controller;
//                         _webController!
//                             .loadUrl(IConstants.API_PAYTM + queryParams);
//                       },
//                       onPageFinished: (page){
//                         if(page.contains("/order")) {
//                           setState(() {
//                             _loadingPayment = false;
//                           });
//                         }
//                         if(page.contains("/cancelTransaction")) {
//                           Navigator.of(context).pop();
//                         }
//                         if(!page.contains("/cancelTransaction")) {
//                           if (page.contains("/pgResponse.php")) {
//                             final routeArgs = ModalRoute
//                                 .of(context)!
//                                 .settings
//                                 .arguments as Map<String, String>;
//
//                             final orderId = routeArgs['orderId'];
// /*
//                             Navigator.of(context).pushReplacementNamed(
//                                 OrderconfirmationScreen.routeName,
//                                 arguments: {
//                                   'orderstatus': "waiting",
//                                   'orderId': orderId.toString(),
//                                 }
//                             );*/
//                             Navigation(context, name: Routename.OrderConfirmation, navigatore: NavigatoreTyp.Push,
//                                 parms: {'orderstatus' : "success",
//                                   'orderid':  orderId.toString()});
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               )
//           ),
//         )
//     );
//   }
//
//   CancelPaymentDialog(context,routeArgs){
//     showDialog(context: context, builder:(BuildContext dcontext)
//     { this.loadingDailogCtx = dcontext;
//     return  Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0)),
//       child: Container(
//           height: 150.0,
//           width: 400,
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 20.0),
//               Text(
//                 S .of(context).cancel_payment, //"Cancel Payment?",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20.0),
//               Row(
//                 children: [
//                   SizedBox(width: 20.0),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: 120.0,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(3.0),
//                           border: Border(
//                             top: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                             bottom: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                             left: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                             right: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                           )),
//                       child: Center(
//                         child: Text(
//                           S .of(context).paytm_no, //'No',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 30.0),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     /*  Navigator.pushReplacementNamed(
//                         context,
//                         PaymentScreen.routeName,
//                         arguments: routeArgs,
//                       );*/
//                       Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
//                           qparms: routeArgs);
//                     },
//                     child: Container(
//                       width: 120.0,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                           color: Colors.lightBlueAccent,
//                           borderRadius: BorderRadius.circular(3.0),
//                           border: Border(
//                             top: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                             bottom: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                             left: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                             right: BorderSide(
//                               width: 1.0,
//                               color: Colors.lightBlueAccent,
//                             ),
//                           )),
//                       child: Center(
//                         child: Text(
//                           S .of(context).paytm_yes, //'Yes',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           )),
//     );});}
// }
//
//
//
// // import 'dart:html';
// // import 'dart:io' as io;
// //
// // import 'package:flutter/material.dart';
// // import 'package:grocbay/generated/l10n.dart';
// // import 'package:grocbay/models/VxModels/VxStore.dart';
// // import 'package:velocity_x/velocity_x.dart';
// // //import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import '../constants/IConstants.dart';
// // import '../screens/payment_screen.dart';
// // import '../screens/orderconfirmation_screen.dart';
// // import '../utils/prefUtils.dart';
// // import 'dart:ui' as ui;
// //
// // class PaytmScreen extends StatefulWidget {
// //   static const routeName = '/paytm-screen';
// //
// //   @override
// //   _PaytmScreenState createState() => _PaytmScreenState();
// // }
// //
// // class _PaytmScreenState extends State<PaytmScreen> {
// //   WebViewController _webController;
// //   bool _loadingPayment = true;
// //   String customerId = "";
// //   //SharedPreferences prefs;
// //   bool _isLoading = true;
// //   String deliveryCharge;
// //   GroceStore store = VxState.store;
// //
// //   @override
// //   void dispose() {
// //     _webController = null;
// //     super.dispose();
// //   }
// //
// //   @override
// //   void initState() {
// //     Future.delayed(Duration.zero, () async {
// //       //prefs = await SharedPreferences.getInstance();
// //       setState(() {
// //         customerId = PrefUtils.prefs!.getString('apikey');
// //         _isLoading = false;
// //       });
// //     });
// //     super.initState();
// //   }
// //   _dialogforCancel(String minimumOrderAmountNoraml,String deliveryChargeNormal,String
// //   minimumOrderAmountPrime,String deliveryChargePrime,String minimumOrderAmountExpress,String
// //   deliveryChargeExpress,String deliveryType,String note,String deliveryCharge) {
// //     final routeArgs = ModalRoute
// //         .of(context)
// //         .settings
// //         .arguments as Map<String, String>;
// //     return showDialog(
// //         context: context,
// //         builder: (context) {
// //           return StatefulBuilder(builder: (context, setState) {
// //             return Dialog(
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12.0)),
// //               child: Container(
// //                   height: 150.0,
// //                   width: 400,
// //                   child:  Column(
// //                     children: <Widget>[
// //                       SizedBox(height: 20.0),
// //                       Text(
// //                         S .of(context).cancel_payment,//"Cancel Payment?",
// //                         style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(height: 20.0),
// //                       Row(
// //                         children: [
// //                           SizedBox(width: 20.0),
// //                           GestureDetector(
// //                             onTap: (){
// //                               Navigator.of(context).pop();
// //                             },
// //                             child: Container(
// //                               width: 120.0,
// //                               height: 50.0,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(3.0),
// //                                   border: Border(
// //                                     top: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     bottom: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     left: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     right: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                   )),
// //                               child: Center(
// //                                 child: Text(
// //                                   S .of(context).paytm_no,//'No',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(color: Colors.black),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 30.0),
// //
// //                           GestureDetector(
// //                             onTap: (){
// //                               final routeArgs = ModalRoute
// //                                   .of(context)
// //                                   .settings
// //                                   .arguments as Map<String, String>;
// //
// //                               final orderId = routeArgs['orderId'];
// //                              final amount = routeArgs['orderAmount'] ;
// //                               final queryParams =
// //                                   '?orderid=$orderId&customer=$customerId&price=$amount';
// //                               Navigator.of(context).pop();
// //                               Navigator.pushReplacementNamed(context, PaymentScreen.routeName, arguments: {
// //                                 'orderId': routeArgs['orderId'],
// //                                 'orderAmount': routeArgs['orderAmount'],
// //                                 'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
// //                                 'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
// //                                 'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
// //                                 'deliveryChargePrime': routeArgs['deliveryChargePrime'],
// //                                 'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
// //                                 'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
// //                                 'deliveryType': routeArgs['deliveryType'],
// //                                 'note': routeArgs['note'],
// //                                 'addressId': routeArgs['addressId'],
// //                                 'deliveryCharge': routeArgs['deliveryCharge'],
// //                                 'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
// //                               },);
// //                             },
// //                             child: Container(
// //                               width: 120.0,
// //                               height: 50.0,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.lightBlueAccent,
// //                                   borderRadius: BorderRadius.circular(3.0),
// //                                   border: Border(
// //                                     top: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     bottom: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     left: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                     right: BorderSide(
// //                                       width: 1.0,
// //                                       color: Colors.lightBlueAccent,
// //                                     ),
// //                                   )),
// //                               child: Center(
// //                                 child: Text(
// //                                   S .of(context).paytm_yes,//'Yes',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(color: Colors.white),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       )
// //                     ],
// //                   )
// //               ),
// //             );
// //           });
// //         });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     String channel = "";
// //
// //     final routeArgs = ModalRoute
// //         .of(context)
// //         .settings
// //         .arguments as Map<String, String>;
// //
// //     final orderId = routeArgs['orderId'];
// //     final amount = routeArgs['orderAmount'] /*"1.0"*/;
// //     final name = store.userData.username;
// //     String email;
// //     if (store.userData.email != null && store.userData.email != "") {
// //       email = store.userData.email;
// //     } else {
// //       email = 'test123@gmail.com';
// //     }
// //     final queryParams =
// //         '?orderid=$orderId&amount=$amount&name=$name&email=$email';
// //     debugPrint("queryParams..." + " " + queryParams.toString());
// //
// //
// //     try{
// //       if(io.Platform.isIOS) {
// //         channel = "IOS";
// //       } else {
// //         channel = "Android";
// //       }
// //     } catch(e){
// //       channel = "Web";
// //     }
// //
// //     if(!_isLoading) {
// //
// //      IFrameElement iframeElement = IFrameElement()
// //         ..width = '640'
// //         ..height = '360'
// //         ..src = IConstants.API_PAYTM + queryParams
// //         ..style.border = 'none';
// //
// //       ui.platformViewRegistry.registerViewFactory(
// //         IConstants.APP_NAME,
// //             (int viewId) => iframeElement,
// //       );
// //
// //     }
// //
// //     return WillPopScope(
// //         onWillPop: () { // this is the block you need
// //
// //
// //           String minimumOrderAmountNoraml=routeArgs['minimumOrderAmountNoraml'];
// //           String deliveryChargeNormal =routeArgs['deliveryChargeNormal'];
// //           String minimumOrderAmountPrime =routeArgs['minimumOrderAmountPrime'];
// //           String deliveryChargePrime =routeArgs['deliveryChargePrime'];
// //           String minimumOrderAmountExpress =routeArgs['minimumOrderAmountExpress'];
// //           String deliveryChargeExpress =routeArgs['deliveryChargeExpress'];
// //           String deliveryType =routeArgs['deliveryType'];
// //           String note =routeArgs['note'];
// //           deliveryCharge =routeArgs['deliveryCharge'];
// //           _dialogforCancel(minimumOrderAmountNoraml,deliveryChargeNormal,minimumOrderAmountPrime,deliveryChargePrime,minimumOrderAmountExpress,deliveryChargeExpress,deliveryType,note,deliveryCharge);
// //           return Future.value(false);
// //         },
// //         child: _isLoading ?
// //         Center(
// //           child: CircularProgressIndicator(),
// //         )
// //             : channel == "Web" ? HtmlElementView(viewType: IConstants.APP_NAME) : SafeArea(
// //           child: Scaffold(
// //               body: Stack(
// //                 children: <Widget>[
// //                   Container(
// //                     width: MediaQuery.of(context).size.width,
// //                     height: MediaQuery.of(context).size.height,
// //                     child: WebView(
// //                       //hidden: true,
// //                       debuggingEnabled: false,
// //                       javascriptMode: JavascriptMode.unrestricted,
// //                       onWebViewCreated: (controller){
// //                         _webController = controller;
// //                         _webController
// //                             .loadUrl(IConstants.API_PAYTM + queryParams);
// //                       },
// //                       onPageFinished: (page){
// //                         print("page: $page");
// //                         if(page.contains("/order")) {
// //                           setState(() {
// //                             _loadingPayment = false;
// //                           });
// //                         }
// //                         if(page.contains("/cancelTransaction")) {
// //                           debugPrint("cancelled....");
// //                           Navigator.pushReplacementNamed(context, PaymentScreen.routeName, arguments: {
// //                             'orderId': routeArgs['orderId'],
// //                             'orderAmount': routeArgs['orderAmount'],
// //                             'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
// //                             'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
// //                             'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
// //                             'deliveryChargePrime': routeArgs['deliveryChargePrime'],
// //                             'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
// //                             'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
// //                             'deliveryType': routeArgs['deliveryType'],
// //                             'note': routeArgs['note'],
// //                             'addressId': routeArgs['addressId'],
// //                             'deliveryCharge': routeArgs['deliveryCharge'],
// //                             'deliveryDurationExpress' : routeArgs['deliveryDurationExpress'],
// //                           },);
// //                         }
// //                         if(!page.contains("/cancelTransaction")) {
// //                           debugPrint("cancelled....not");
// //                           if (page.contains("/response.php")) {
// //                             Navigator.of(context).pushReplacementNamed(
// //                                 OrderconfirmationScreen.routeName,
// //                                 arguments: {
// //                                   'orderstatus': "waiting",
// //                                   'orderId': orderId.toString(),
// //                                 }
// //                             );
// //                           }
// //                         }
// //                       },
// //                     ),
// //                   ),
// //
// //
// //                 ],
// //               )
// //           ),
// //         )
// //     );
// //   }
// // }

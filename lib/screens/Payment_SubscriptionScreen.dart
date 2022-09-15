import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/screens/paytm_screen.dart';
import 'package:grocbay/widgets/bottom_navigation.dart';
import 'package:grocbay/widgets/custome_stepper.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../providers/branditems.dart';
import '../repository/authenticate/AuthRepo.dart';
import '../rought_genrator.dart';
import '../screens/subscription_confirm_screen.dart';
import '../controller/payment/payment_contoller.dart';
//import '../screens/subscribe_screen.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import 'package:package_info/package_info.dart';


import '../utils/ResponsiveLayout.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../widgets/simmers/pymentoption_Simmer.dart';

class PaymenSubscriptionScreen extends StatefulWidget {
  static const routeName = '/payment-subscriptionscreen';

  String itemid="";
  String itemname ="";
  String itemimg ="";
  String varname ="";
  String varmrp = "";
  String varprice="";
  String paymentMode="";
  String cronTime="";
  String name="";
  String varid="";
  String brand="";
  String addressid="";
  String useraddtype="";
  String startDate="";
  String endDate="";
  String itemCount="";
  String deliveries="";
  String total="";
  String schedule="";
  String address="";
  String weeklist="";
  String no_of_days="";
  String deliveriesarry ="";
  String daily="";
  String dailyDays="";
  String weekend="";
  String weekendDays="";
  String weekday="";
  String weekdayDays="";
  String custom="";
  String alternativeDays = "";
  String customDays="";
  String weight = "";
  String  planId = "";
  String varType = "";
  Map<String, String>? params1;

  PaymenSubscriptionScreen(Map<String, String> params){
    this.params1 = params;
    this.itemid = params["itemid"]??"" ;
    this.itemname= params["itemname"]??"";
    this.itemimg= params["itemimg"]??"";
    this.varname= params["varname"]??"";
    this.varmrp= params["varmrp"]??"";
    this.varprice= params["varprice"]??"";
    this.paymentMode= params["paymentMode"]??"";
    this.cronTime= params["cronTime"]??"";
    this.name= params["name"]??"";
    this.varid= params["varid"]??"";
    this.brand= params["brand"]??"";
    this.addressid= params["addressid"]??"";
    this.useraddtype= params["useraddtype"]??"";
    this.startDate= params["startDate"]??"";
    this.endDate= params["endDate"]??"";
    this.itemCount= params["itemCount"]??"";
    this.deliveries= params["deliveries"]??"";
    this.total= params["total"]??"";
    this.schedule= params["schedule"]??"";
    this.address= params["address"]??"";
    this.weeklist= params["weeklist"]??"";
    this.no_of_days= params["no_of_days"]??"";
    this.deliveriesarry= params["deliveriesarray"]??"";
    this.daily= params["daily"]??"";
    this.dailyDays= params["dailyDays"]??"";
    this.weekend= params["weekend"]??"";
    this.weekendDays= params["weekendDays"]??"";
    this.weekday= params["weekday"]??"";
    this.weekdayDays= params["weekdayDays"]??"";
    this.custom= params["custom"]??"";
    this.alternativeDays = params["alternativeDays"] ?? "";
    this.customDays= params["customDays"]??"";
    this.weight= params["weight"]??"";
    this.planId = params["planId"]??"";
    this.varType = params["varType"]??"";
  }
  @override
  _PaymenSubscriptionScreenState createState() => _PaymenSubscriptionScreenState();
}

class _PaymenSubscriptionScreenState extends State<PaymenSubscriptionScreen> with Navigations {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  int _groupValue = -1;
  var walletbalance = "0";
  bool checked = false;

  bool disable = false;
  bool _isWeb = false;

  PackageInfo? packageInfo;
  bool iphonex = false;
  var addressid ;
  var useraddtype ;
  var startDate ;
  var endDate ;
  var itemCount ;
  var deliveries ;
  var total ;

  var schedule ;
  var itemid ;
  var itemimg ;
  var itemname ;
  var varprice ;
  var varname ;
  var address ;
  var paymentMode ;
  var cronTime ;
  var name ;
  var varid ;
  var varmrp ;
 var weeklist;
 var no_of_days;
  final user_data = (VxState.store as GroceStore).userData;

  var paymentData;
  bool _isWallet = false;
  bool loading = true;
  bool _isRemainingAmount = false;
  bool _ischeckboxshow = true;
  bool _ischeckbox = true;
  double walletAmount = 0.0;
  double remainingAmount = 0.0;
  int _selectedIndex = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        } else {
          setState(() {
            _isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          _isWeb = true;
        });
      }
      await auth.getuserProfile(onsucsess: (value){
      }, onerror: (){
      });

      //debugPrint("walletbalance...."+walletbalance);
      _initial();
      packageInfo = await PackageInfo.fromPlatform();

    });
    super.initState();

  }
  Future<void> _initial() async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    await Provider.of<BrandItemsList>(context, listen: false).fetchPaymentMode().then((_) {
    paymentData = Provider.of<BrandItemsList>(context,listen: false);
    walletbalance = (VxState.store as GroceStore).prepaid.prepaid.toString();
    debugPrint("walletbalance...."+walletbalance);
    for(int i = 0; i < paymentData.itemspayment.length; i++){
      if(paymentData.itemspayment[i].paymentMode == "2") {
        _isWallet = true;
        loading = false;
        break;
      } else {
        _isWallet = false;
      }
    }
    });
    bool _isOnline = false;
    setState(() {
      if(_isWallet) {
        double totalAmount = 0.0;
        totalAmount = (int.parse(widget.itemCount) * double.parse(widget.total)) * int.parse(widget.deliveries);
        debugPrint("walletbalance...."+walletbalance+"...."+totalAmount.toString());
        if (int.parse(walletbalance) <= 0 ) {
          _isRemainingAmount = false;
          _ischeckboxshow = false;
          _ischeckbox = false;
        } else if ( totalAmount <= (int.parse(walletbalance))) {
          _isRemainingAmount = false;
          _groupValue = -1;
          PrefUtils.prefs!.setString("payment_type", "wallet");
          debugPrint("walletAmount....1.."+walletbalance);
          walletAmount =  totalAmount;
        } else if ( totalAmount > int.parse(walletbalance)) {

              _groupValue = 2;
              _isOnline = true;

          if(_isOnline) {
            _selectedIndex = 2;
            _groupValue = 2;
            _isRemainingAmount = true;
            debugPrint("walletAmount....2.."+walletbalance);
            walletAmount = double.parse(walletbalance);
            remainingAmount =  totalAmount - int.parse(walletbalance);
          } else {
          //  _isWallet = false;
           // _ischeckbox = false;
          }

        }
      } else {
        _ischeckbox = false;
      }


      //if both wallet is not there in payment method
      if(!_isWallet) {
        _selectedIndex = 2;
        _groupValue = 2;
      /*  if(paymentData.itemspayment[0].paymentMode == "1") {
          PrefUtils.prefs!.setString("payment_type", "paytm");
        } else {
          PrefUtils.prefs!.setString("payment_type", paymentData.itemspayment[0].paymentType);
        }*/
      }

    });


  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    payment.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    addressid = /*routeArgs['addressid'].toString()*/widget.addressid;
    useraddtype = /*routeArgs['useraddtype'].toString()*/widget.useraddtype;
    startDate = /*routeArgs['startDate'].toString()*/widget.startDate;
    endDate = /*routeArgs['endDate'].toString()*/widget.endDate;
    itemCount = /*routeArgs['itemCount'].toString()*/widget.itemCount;
    deliveries = /* routeArgs['deliveries'].toString()*/widget.deliveries;
    total = (double.parse(/*routeArgs['total']!*/widget.total) - double.parse(walletbalance)).toString();

    schedule =  /*routeArgs['schedule']*/widget.schedule;
    itemid = /*routeArgs['itemid'].toString()*/widget.itemid;
    itemimg = /*routeArgs['itemimg'].toString()*/widget.itemimg;
    itemname = /*routeArgs['itemname'].toString()*/widget.itemname;
    varprice = /*routeArgs['varprice'].toString()*/widget.varprice;
    varname = /*routeArgs['varname'].toString()*/widget.varname;
    address = /*routeArgs['address'].toString()*/widget.address;
    paymentMode = /*routeArgs['paymentMode'].toString()*/widget.paymentMode;
    cronTime = /*routeArgs['cronTime'].toString()*/widget.cronTime;
    name = /*routeArgs['name'].toString()*/widget.name;
    varid = /*routeArgs['varid'].toString()*/widget.varid;
    varmrp = /*routeArgs['varmrp'].toString()*/widget.varmrp;
    weeklist = /*routeArgs['weeklist'].toString()*/widget.weeklist;
    no_of_days = /*routeArgs['no_of_days'].toString()*/widget.no_of_days;
    _dialogforOrdering() {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AbsorbPointer(
                child: WillPopScope(
                  onWillPop: (){
                    return Future.value(false);
                  },
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Container(
                        width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
                        // color: Theme.of(context).primaryColor,
                        height: 100.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(
                                S .of(context).placing_order,//'Placing order...'
                            ),
                          ],
                        )),
                  ),
                ),
              );
            });
          });
    }

    _buildBottomNavigationBar() {
      int quantity = int.parse(/*routeArgs['itemCount']!*/widget.itemCount);
      double subscriptionAmount = double.parse(/*routeArgs['total']!*/widget.total);
      int deliveryNum = int.parse(/*routeArgs['deliveries']!*/widget.deliveries);
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return  BottomNaviagation(
        itemCount: "1" + " " + S .of(context).items,
        title: S .current.proceed_pay, //'PROCEED TO PAY',
        total: ((subscriptionAmount * quantity) * deliveryNum).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
        onPressed: (){
          debugPrint("_ischeckbox...."+_ischeckbox.toString());
          setState(() {
            if(_groupValue == -1  && !_ischeckbox && _selectedIndex == 0) {
              Fluttertoast.showToast(
                msg:
                S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                fontSize: MediaQuery
                    .of(context)
                    .textScaleFactor * 13,);
            }else {
              debugPrint("else....");
              _dialogforOrdering();
              CreateSubscription(quantity,subscriptionAmount,deliveryNum);
            }
          });
        },
      );
        // Container(
        // width: MediaQuery.of(context).size.width,
        // height: 54.0,
        // child: Row(
        //   children: <Widget>[
        //     Container (
        //         color: Theme.of(context).primaryColor,
        //         height: 54,
        //         width: MediaQuery.of(context).size.width * 40 / 100,
        //         child: Column(
        //           children: <Widget>[
        //             SizedBox(
        //               height: 15,
        //             ),
        //             Center(
        //               child: Text(
        //                   S .of(context).grand_total//"Grand Total: "
        //                           + IConstants.currencyFormat +
        //                           " "+double.parse(routeArgs['total'].toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) ,
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),
        //                       textAlign: TextAlign.center))
        //               ]),
        //             ),
        //     GestureDetector(
        //       onTap: (){
        //         if(_groupValue == -1) {
        //           Fluttertoast.showToast(
        //             msg:
        //             S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
        //             fontSize: MediaQuery
        //               .of(context)
        //               .textScaleFactor * 13,);
        //         }else {
        //             _dialogforOrdering();
        //             /*Navigator.of(context).pushNamed(
        //                 SubscriptionWalletScreen.routeName,
        //                 arguments: {
        //
        //                   "addressid":addressid.toString(),
        //                   "useraddtype": useraddtype.toString(),
        //                   "startDate":startDate.toString(),
        //                   "endDate": endDate.toString(),
        //                   "itemCount": itemCount.toString(),
        //                   "deliveries": deliveries.toString(),
        //                   "total": (double.parse(routeArgs['total']) - walletbalance).toString(),
        //                   "subscriptionAmount": routeArgs['total'].toString(),
        //                   //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
        //                   "schedule": schedule.toString(),
        //                   "itemid": itemid.toString(),
        //                   "itemimg": itemimg.toString(),
        //                   "itemname": itemname.toString(),
        //                   "varprice": varprice.toString(),
        //                   "varname": varname.toString(),
        //                   "address": address.toString(),
        //                   "paymentMode": paymentMode.toString(),
        //                   "cronTime": cronTime.toString(),
        //                   "name": name.toString(),
        //                   "varid": varid.toString(),
        //                   "varmrp": varmrp.toString(),
        //
        //                 }
        //             );*/
        //
        //           CreateSubscription();
        //         }
        //
        //      /*   if(_groupValue == -1) {
        //           Fluttertoast.showToast(
        //             msg:
        //             S .of(context).please_select_paymentmenthods//"Please select a payment method!!!"
        //             , fontSize: MediaQuery
        //               .of(context)
        //               .textScaleFactor * 13,);
        //         }else {
        //           if(_groupValue == 1){
        //             if(routeArgs['paymentMode'].toString() == "1"){
        //               _dialogforOrdering();
        //               if(walletbalance >= double.parse(routeArgs['total'])){
        //                 CreateSubscription();
        //               }else{
        //                 Navigator.of(context).pushNamed(
        //                     SubscriptionWalletScreen.routeName,
        //                     arguments: {
        //
        //                       "addressid":addressid.toString(),
        //                       "useraddtype": useraddtype.toString(),
        //                       "startDate":startDate.toString(),
        //                       "endDate": endDate.toString(),
        //                       "itemCount": itemCount.toString(),
        //                       "deliveries": deliveries.toString(),
        //                       "total": (double.parse(routeArgs['total']) - walletbalance).toString(),
        //                       "subscriptionAmount": routeArgs['total'].toString(),
        //                       //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
        //                       "schedule": schedule.toString(),
        //                       "itemid": itemid.toString(),
        //                       "itemimg": itemimg.toString(),
        //                       "itemname": itemname.toString(),
        //                       "varprice": varprice.toString(),
        //                       "varname": varname.toString(),
        //                       "address": address.toString(),
        //                       "paymentMode": paymentMode.toString(),
        //                       "cronTime": cronTime.toString(),
        //                       "name": name.toString(),
        //                       "varid": varid.toString(),
        //                       "varmrp": varmrp.toString(),
        //
        //                     }
        //                 );
        //               }
        //
        //             }else{
        //               Fluttertoast.showToast(
        //                   msg:"This product is not eligible for Wallet payment",
        //                   fontSize: MediaQuery.of(context).textScaleFactor *13,
        //                   backgroundColor: Colors.black87,
        //                   textColor: Colors.white);
        //             }
        //           }else if(_groupValue == 2){
        //             if(routeArgs['paymentMode'].toString() == "0"){
        //               _dialogforOrdering();
        //               CreateSubscription();
        //             }else{
        //               //Navigator.of(context).pop();
        //               Fluttertoast.showToast(
        //                   msg:"This product is not eligible for Online payment",
        //                   fontSize: MediaQuery.of(context).textScaleFactor *13,
        //                   backgroundColor: Colors.black87,
        //                   textColor: Colors.white);
        //             }
        //           }
        //
        //
        //         }*/
        //       },
        //       child: Container (
        //         color: Theme.of(context).primaryColor,
        //         height: 54,
        //         width: MediaQuery.of(context).size.width * 60 / 100,
        //         child: Column(
        //             children: <Widget>[
        //               SizedBox(
        //                 height: 10,
        //               ),
        //               Center(
        //                   child: Text(
        //                       S .of(context).add_to//"Add to "
        //                           +IConstants.APP_NAME+"\n" + S .of(context).subscription_wallet,///" Subscription Wallet",
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold),
        //                       textAlign: TextAlign.center)),
        //               SizedBox(
        //                 height: 10,
        //               ),
        //             ]
        //         ),
        //       ),
        //     ),
        //
        //           ],
        //         )
        //       );
    }
    gradientappbarmobile() {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      return AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor/*Colors.white*/),
            onPressed: () {
            /*  Navigator.of(context).pushNamed(
                  SubscribeScreen.routeName,
                  arguments: {
                    "addressid":addressid.toString(),
                    "useraddtype": useraddtype.toString(),
                    "startDate":startDate.toString(),
                    "endDate": endDate.toString(),
                    "itemCount": itemCount.toString(),
                    "deliveries": deliveries.toString(),
                    "total": (double.parse(routeArgs['total']!) - double.parse(walletbalance)).toString(),
                    //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
                    "schedule": schedule.toString(),
                    "itemid": itemid.toString(),
                    "itemimg": itemimg.toString(),
                    "itemname": itemname.toString(),
                    "varprice": varprice.toString(),
                    "varname": varname.toString(),
                    "address": address.toString(),
                    "paymentMode": paymentMode.toString(),
                    "cronTime": cronTime.toString(),
                    "name": name.toString(),
                    "varid": varid.toString(),
                    "varmrp": varmrp.toString(),
                    "brand": routeArgs['brand'].toString()
                    *//*"itemid": itemid.toString(),
                    "itemname": itemname.toString(),
                    "itemimg": itemimg.toString(),
                    "varname": routeArgs[varname].toString(),
                    "varmrp":varmrp.toString(),
                    "varprice": routeArgs[varprice].toString(),
                    "paymentMode": paymentMode.toString(),
                    "cronTime": cronTime.toString(),
                    "name": name.toString(),
                    "varid": varid.toString()*//*

                  }
              );*/
              Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                  qparms: {
                    "addressid":addressid.toString(),
                    "useraddtype": useraddtype.toString(),
                    "startDate":startDate.toString(),
                    "endDate": endDate.toString(),
                    "itemCount": itemCount.toString(),
                    "deliveries": deliveries.toString(),
                    "total": (double.parse(/*routeArgs['total']!*/widget.total) - double.parse(walletbalance)).toString(),
                    //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
                    "schedule": schedule.toString(),
                    "itemid": itemid.toString(),
                    "itemimg": itemimg.toString(),
                    "itemname": itemname.toString(),
                    "varprice": varprice.toString(),
                    "varname": varname.toString(),
                    "address": address.toString(),
                    "paymentMode": paymentMode.toString(),
                    "cronTime": cronTime.toString(),
                    "name": name.toString(),
                    "varid": varid.toString(),
                    "varmrp": varmrp.toString(),
                    "brand": /*routeArgs['brand'].toString()*/widget.brand,
                    "deliveriesarray":widget.deliveriesarry,
                    "daily":widget.daily,
                    "dailyDays":widget.dailyDays,
                    "weekend": widget.weekend,
                    "weekendDays": widget.weekendDays,
                    "weekday": widget.weekday,
                    "weekdayDays":widget.weekdayDays,
                    "custom": widget.custom,
                    "alternativeDays": widget.alternativeDays,
                    "customDays": widget.customDays,
                    "weight": widget.weight
                  });
            }
        ),
        title: Text(
          S .of(context).subscription_payment_option,
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18)
          //'Subscription Payment Options',
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorCodes.appbarColor,
                    ColorCodes.appbarColor2
                  ])),
        ),
      );
    }

    Widget _bodyMobile() {
      double amountPayable = 0.0;
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      Widget promocodeMethod() {
        double amount = double.parse(/*routeArgs['varmrp']!*/widget.varmrp);
        int quantity = int.parse(/*routeArgs['itemCount']!*/widget.itemCount);
        double subscriptionAmount = double.parse(/*routeArgs['total']!*/widget.total);
        int deliveryNum = int.parse(/*routeArgs['deliveries']!*/widget.deliveries);

            return Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: ColorCodes.greenColor,
                  //strokeWidth: 1,
                  dashPattern: [3.0],
                  child: Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    height: 30.0,
                   // color: ColorCodes.lightBlueColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S .of(context).your_savings,//"Your savings",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.mediumBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Features.iscurrencyformatalign?
                          (((subscriptionAmount * quantity) * deliveryNum) -((subscriptionAmount * quantity) * deliveryNum) ).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " +IConstants.currencyFormat :
                          IConstants.currencyFormat +
                              " " +
                              (((subscriptionAmount * quantity) * deliveryNum) -((subscriptionAmount * quantity) * deliveryNum) ).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorCodes.mediumBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              //  Divider(color: ColorCodes.blackColor),
              ],
            );

      }

      Widget paymentDetails() {
        double amount = double.parse(/*routeArgs['varmrp']!*/widget.varmrp);
        int quantity = int.parse(/*routeArgs['itemCount']!*/widget.itemCount);
        double subscriptionAmount = double.parse(/*routeArgs['total']!*/widget.total);
        int deliveryNum = int.parse(/*routeArgs['deliveries']!*/widget.deliveries);

        if (_ischeckbox && _isRemainingAmount) {
          _isRemainingAmount = true;
        } else {
          _isRemainingAmount = false;
        }

        debugPrint("_isWallet...."+_isWallet.toString());
        return Column(
          children: [
            SizedBox(height: 20,),
            if (_isWallet)
             (_ischeckboxshow)
                ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _ischeckbox = !_ischeckbox;
                  double totalAmount = 0.0;
                  bool _isOnline = false;
                   totalAmount = ((subscriptionAmount*quantity) * deliveryNum);
                  if(_isWallet) {
                    if (int.parse(walletbalance) <= 0 ) {
                      _isRemainingAmount = false;
                      _ischeckboxshow = false;
                      _ischeckbox = false;
                    } else if (totalAmount <= (int.parse(walletbalance))) {
                      _isRemainingAmount = false;
                      _groupValue = -1;
                      PrefUtils.prefs!.setString("payment_type", "wallet");
                      debugPrint("walletAmount....3.."+walletbalance);
                      walletAmount = totalAmount;
                    } /*else if ( totalAmount > int.parse(walletbalance)) {
                      bool _isOnline = false;
                      for(int i = 0; i < paymentData.itemspayment.length; i++) {
                        if(paymentData.itemspayment[i].paymentMode == "1") {
                          _isOnline = true;
                          break;
                        }
                      }
                      if(_isOnline) {
                        _groupValue = -1;
                        _isRemainingAmount = true;
                        debugPrint("walletAmount....4.."+walletbalance);
                        walletAmount = double.parse(walletbalance);
                        remainingAmount = (totalAmount - int.parse(walletbalance));
                      } else {
                       // _isWallet = false;
                      //  _ischeckbox = false;
                      }
                      for(int i = 0; i < paymentData.itemspayment.length; i++) {
                        if(paymentData.itemspayment[i].paymentMode == "1") {
                          _groupValue = i;
                          break;
                        }
                      }

                    }*/else if ( totalAmount > int.parse(walletbalance)) {

                      _groupValue = 2;
                      _isOnline = true;

                      if(_isOnline) {
                        _selectedIndex = 2;
                        _groupValue = 2;
                        _isRemainingAmount = true;
                        debugPrint("walletAmount....2.."+walletbalance);
                        walletAmount = double.parse(walletbalance);
                        remainingAmount =  totalAmount - int.parse(walletbalance);
                      } else {
                        //  _isWallet = false;
                        // _ischeckbox = false;
                      }

                    }
                  } else {
                    _ischeckbox = false;
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(left:15, right: 15, top: 15, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all( color: ColorCodes.greylight)
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.4),
                  //     spreadRadius: 1,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 1), // changes position of shadow
                  //   ),
                  // ],
                ),
                padding: EdgeInsets.only(left: 9, top: 10, right: 9, bottom: 10),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(Images.walletImg, width: 25,height: 25, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor),
                    SizedBox(width: 5),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            IConstants.APP_NAME + " "+  S .of(context).wallet,//" Wallet",
                            style: TextStyle(
                                fontSize: 17,
                                color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                S .of(context).wallet_balance,    //"Balance:  ",
                                style: TextStyle(
                                  color: ColorCodes.greyColor,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                Features.iscurrencyformatalign?
                                walletbalance + "" + IConstants.currencyFormat:
                                IConstants.currencyFormat + "" + walletbalance,
                                style: TextStyle(
                                  color: ColorCodes.greyColor,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          _ischeckbox = !_ischeckbox;
                          double totalAmount = 0.0;
                          bool _isOnline = false;
                          totalAmount = ((subscriptionAmount*quantity) * deliveryNum);
                          if(_isWallet) {
                            if (int.parse(walletbalance) <= 0 ) {
                              _isRemainingAmount = false;
                              _ischeckboxshow = false;
                              _ischeckbox = false;
                            } else if (totalAmount <= (int.parse(walletbalance))) {
                              _isRemainingAmount = false;
                              _groupValue = -1;
                              PrefUtils.prefs!.setString("payment_type", "wallet");
                              debugPrint("walletAmount....5.."+walletbalance);
                              walletAmount = totalAmount;
                            } /*else if ( totalAmount > int.parse(walletbalance)) {
                              bool _isOnline = false;
                              for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                if(paymentData.itemspayment[i].paymentMode == "1") {
                                  _isOnline = true;
                                  break;
                                }
                              }
                              if(_isOnline) {
                                _groupValue = -1;
                                _isRemainingAmount = true;
                                debugPrint("walletAmount....6.."+walletbalance);
                                walletAmount = double.parse(walletbalance);
                                remainingAmount =  (totalAmount - int.parse(walletbalance));
                              } else {
                               // _isWallet = false;
                              //  _ischeckbox = false;
                              }
                              for(int i = 0; i < paymentData.itemspayment.length; i++) {
                                if(paymentData.itemspayment[i].paymentMode == "1") {
                                  _groupValue = i;
                                  break;
                                }
                              }

                            }*/else if ( totalAmount > int.parse(walletbalance)) {

                              _groupValue = 2;
                              _isOnline = true;

                              if(_isOnline) {
                                _selectedIndex = 2;
                                _groupValue = 2;
                                _isRemainingAmount = true;
                                debugPrint("walletAmount....2.."+walletbalance);
                                walletAmount = double.parse(walletbalance);
                                remainingAmount =  totalAmount - int.parse(walletbalance);
                              } else {
                                //  _isWallet = false;
                                // _ischeckbox = false;
                              }

                            }
                          } else {
                            _ischeckbox = false;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          if (_ischeckboxshow && _ischeckbox)
                            SizedBox(
                              width: 5.0,
                            ),
                          if (_ischeckboxshow && _ischeckbox)
                            Text(
                              Features.iscurrencyformatalign?
                              walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+
                                  " " + IConstants.currencyFormat :
                              IConstants.currencyFormat +
                                  " " +
                                  walletAmount.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.greenColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          SizedBox(width: 5.0),
                          _ischeckbox
                              ? Icon(
                            Icons.check_box,
                            size: 25.0,
                            color: ColorCodes.greenColor,
                          )
                              : Icon(
                              Icons.check_box_outline_blank,
                              size: 25.0,
                              color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.greenColor
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ) :
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: S.of(context).wallet_toast,/*"Your wallet balance is 0"*/);
              },
              child: Container(
                margin: EdgeInsets.only(left:15, right: 15, top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all( color: ColorCodes.greylight)
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.4),
                  //     spreadRadius: 1,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 1), // changes position of shadow
                  //   ),
                  // ],
                ),
                padding: EdgeInsets.only(left: 9, top: 10, right: 9, bottom: 10),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(Images.walletImg, width: 25,height: 25, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor),
                    SizedBox(width: 5),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            IConstants.APP_NAME + " "+ S .of(context).wallet,//" Wallet",
                            style: TextStyle(
                                fontSize: 17,
                                color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.blackColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                S .of(context).wallet_balance,    //"Balance:  ",
                                style: TextStyle(
                                    color: ColorCodes.grey,
                                    fontSize: 12.0),
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                Features.iscurrencyformatalign?
                                walletbalance + "" +  IConstants.currencyFormat:
                                IConstants.currencyFormat + "" + walletbalance,
                                style: TextStyle(
                                    color: ColorCodes.grey,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.check_box_outline_blank,
                            size: 25.0, color: (walletbalance == "0")? ColorCodes.grey : ColorCodes.greenColor)
                      ],
                    ),
                  ],
                ),
              ),
            ),
           SizedBox(height: 20,),
            Container(
              width: (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
              MediaQuery.of(context).size.width * 0.40
              :MediaQuery.of(context).size.width,
              // decoration: BoxDecoration(
              //     color: ColorCodes.whiteColor,
              //     boxShadow: [
              //       BoxShadow(
              //         color: ColorCodes.grey.withOpacity(0.3),
              //         spreadRadius: 4,
              //         blurRadius: 5,
              //         offset: Offset(0, 3),
              //       )
              //     ]
              // ),
              padding: EdgeInsets.only(
                  top: 15.0, left: 20.0, right: 20.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
                          MediaQuery.of(context).size.width * 0.20:
                          MediaQuery.of(context).size.width/2
                          ,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S .of(context).your_itemvalue,//"Your subscription value",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              DottedLine(
                                  dashColor: ColorCodes.lightgrey,
                                  lineThickness: 1.0,
                                  dashLength: 2.0,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0),
                              SizedBox(
                                height: 5.0,
                              ),


                                Text(
                                  S .of(context).discount_applied,//"Discount applied:",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              SizedBox(
                                height: 5.0,
                              ),
                              DottedLine(
                                  dashColor: ColorCodes.lightgrey,
                                  lineThickness: 1.0,
                                  dashLength: 2.0,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                S .of(context).amount_payable,//"Amount payable:",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width:   (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
                        MediaQuery.of(context).size.width * 0.10:MediaQuery.of(context).size.width / 4.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Features.iscurrencyformatalign?
                                ((subscriptionAmount*quantity) * deliveryNum).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
        " " + IConstants.currencyFormat :
                                IConstants.currencyFormat +
                                    " " + ((subscriptionAmount*quantity) * deliveryNum).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: ColorCodes.greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              /*if (!_isPickup)
                                Text(
                                  deliverychargetext,
                                  style: TextStyle(
                                      fontSize: 12.0, color: ColorCodes.redColor),
                                ),
                              if (!_isPickup)
                                SizedBox(
                                  height: 10.0,
                                ),*/

                                Text(
                                  "- " +
                                      (((subscriptionAmount * quantity) * deliveryNum) -((subscriptionAmount * quantity) * deliveryNum) )
                                          .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: ColorCodes.greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                Features.iscurrencyformatalign?
                                ((subscriptionAmount * quantity) * deliveryNum).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " +IConstants.currencyFormat :
                                IConstants.currencyFormat +
                                    " " +
                                    ((subscriptionAmount * quantity) * deliveryNum).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: ColorCodes.blackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Divider(
                    color: ColorCodes.greyColor,
                    thickness: 0.8,
                  ),

                  // promocodeMethod() goes here
                  promocodeMethod(),
                ],
              ),
            ),
            if(_isWeb && ! ResponsiveLayout.isSmallScreen(context))
              Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: 55.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //  SizedBox(width: 60,),
                      GestureDetector(
                        onTap: (){
                          if(_groupValue == -1 || !_ischeckbox || _selectedIndex == 0) {
                            Fluttertoast.showToast(
                              msg:
                              S .of(context).please_select_paymentmenthods,//"Please select a payment method!!!",
                              fontSize: MediaQuery
                                  .of(context)
                                  .textScaleFactor * 13,);
                          }else {
                            _dialogforOrdering();
                            CreateSubscription(quantity,subscriptionAmount,deliveryNum);
                          }
                        },
                        child: Container (
                          color: Theme.of(context).primaryColor,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child:
                                    Text(

                                        S .of(context).proceed_pay,//"Your subscription value",
                                        // style: TextStyle(
                                        //     fontSize: 14.0,
                                        //     color: ColorCodes.greyColor,
                                        //     fontWeight: FontWeight.bold),




                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center)
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ]
                          ),
                        ),
                      ),
                      //  SizedBox(width: 60,),
                    ],
                  )
              ),
          ],
        );
      }
      Widget paymentSelection() {
        return Container(
          width: (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
          MediaQuery.of(context).size.width * 0.40
              :MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   color: ColorCodes.whiteColor,
          //   boxShadow: [
          //     BoxShadow(
          //       color: ColorCodes.grey.withOpacity(0.3),
          //       spreadRadius: 4,
          //       blurRadius: 5,
          //       offset: Offset(0, 3),
          //     )
          //   ],
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           // mainAxisAlignment: MainAxisAlignment.start,
           // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?SizedBox(height: 20,): SizedBox(height: 0,),
              Container(
                  width:  (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
              MediaQuery.of(context).size.width * 0.40:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      /*top: 10.0,*/ left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    S .of(context).payment_option,//"Payment Method",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: ColorCodes.blackColor,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 10,),
              _isRemainingAmount
                  ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  _selectedIndex = 2;
                  _ischeckbox = false;
                  _groupValue=2;
                },
                child: Container(
                  width:
                  MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            S .of(context).online_payment,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: ColorCodes
                                    .greyColor),
                          ),
                          Image.asset(Images.onlineImg, height: 24),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              Features.iscurrencyformatalign?
                              remainingAmount
                                  .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) +
                                  " " + IConstants.currencyFormat :
                              IConstants.currencyFormat +
                                  " " +
                                  remainingAmount
                                      .toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                              style: TextStyle(
                                  color: ColorCodes
                                      .blackColor,
                                  fontSize: 12.0)),
                          SizedBox(
                            width: 10.0,
                          ),
                          handler(2),
                          /*SizedBox(
                            width: 20.0,
                            child: _myRadioButton(
                              title: "",
                              value: 2,
                              onChanged: (newValue) {
                                setState(() {
                                  _groupValue = newValue!;
                                  _ischeckbox = false;
                                });
                              },
                            ),
                          )*/
                        ],
                      ),
                    ],
                  ),
                ),
              )
                  : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                    _ischeckbox = false;
                    _groupValue=2;
                  });
                },
                child: Column(
                  children: [
                    Container(

                      padding: EdgeInsets.only(
                          top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                S .of(context).online_payment,//"Online Payment",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorCodes
                                        .blackColor),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Image.asset(Images.onlineImg, height: 24),
                            ],
                          ),
                          handler(2),
                          // SizedBox(
                          //   width: 20.0,
                          //   child: _myRadioButton(
                          //     title: "",
                          //     value: 2,
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         _groupValue = newValue!;
                          //         _ischeckbox = false;
                          //       });
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),

            ],
          ),
        );
      }

      return Expanded(
        child: SingleChildScrollView(
          child: (_isWeb) ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      paymentSelection(),
                      SizedBox(width: 20,),
                      paymentDetails(),
                    ],
                  ),
                   Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              )
              :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              paymentDetails(),
              SizedBox(height: 20,),
              paymentSelection(),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: (){
        final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

       /* Navigator.of(context).pushNamed(
            SubscribeScreen.routeName,
            arguments: {
              "addressid":addressid.toString(),
              "useraddtype": useraddtype.toString(),
              "startDate":startDate.toString(),
              "endDate": endDate.toString(),
              "itemCount": itemCount.toString(),
              "deliveries": deliveries.toString(),
              "total": (double.parse(routeArgs['total']!) - double.parse(walletbalance)).toString(),
              //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
              "schedule": schedule.toString(),
              "itemid": itemid.toString(),
              "itemimg": itemimg.toString(),
              "itemname": itemname.toString(),
              "varprice": varprice.toString(),
              "varname": varname.toString(),
              "address": address.toString(),
              "paymentMode": paymentMode.toString(),
              "cronTime": cronTime.toString(),
              "name": name.toString(),
              "varid": varid.toString(),
              "varmrp": varmrp.toString(),
              "brand": routeArgs['brand'].toString()
              *//*"itemid": itemid.toString(),
              "itemname": itemname.toString(),
              "itemimg": itemimg.toString(),
              "varname": varname.toString(),
              "varmrp":varmrp.toString(),
              "varprice": varprice.toString() ,
              "paymentMode": paymentMode.toString(),
              "cronTime": cronTime.toString(),
              "name": name.toString(),
              "varid": varid.toString()*//*
            }
        );*/
        Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
            qparms: {
              "addressid":addressid.toString(),
              "useraddtype": useraddtype.toString(),
              "startDate":startDate.toString(),
              "endDate": endDate.toString(),
              "itemCount": itemCount.toString(),
              "deliveries": deliveries.toString(),
              "total": (double.parse(/*routeArgs['total']!*/widget.total) - double.parse(walletbalance)).toString(),
              //"weeklist":(typeselected == "Daily")? SelectedDaily.toString():SelectedWeek.toString(),
              "schedule": schedule.toString(),
              "itemid": itemid.toString(),
              "itemimg": itemimg.toString(),
              "itemname": itemname.toString(),
              "varprice": varprice.toString(),
              "varname": varname.toString(),
              "address": address.toString(),
              "paymentMode": paymentMode.toString(),
              "cronTime": cronTime.toString(),
              "name": name.toString(),
              "varid": varid.toString(),
              "varmrp": varmrp.toString(),
              "brand": widget.brand,
              "deliveriesarray":widget.deliveriesarry,
              "daily":widget.daily,
              "dailyDays":widget.dailyDays,
              "weekend": widget.weekend,
              "weekendDays": widget.weekendDays,
              "weekday": widget.weekday,
              "weekdayDays":widget.weekdayDays,
              "custom": widget.custom,
              "alternativeDays": widget.alternativeDays,
              "customDays": widget.customDays,
              "weight": widget.weight
            });
        return Future.value(false);
      },
      child: Scaffold (
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        body: Column(
          children: [
            if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false),
            // !_isWeb ? _bodyMobile() : _bodyWeb(),
           /* (_isWeb && !ResponsiveLayout.isSmallScreen(context)) ? null :*/loading?  Expanded(
              child: Center(
                child: PaymnetOption(),
              ),
            )
                :_bodyMobile(),
            // if (_isWeb && !ResponsiveLayout.isLargeScreen(context)) _bodyMobile(),
          ],
        ),
        bottomNavigationBar:
        _isWeb ? SizedBox.shrink() : _buildBottomNavigationBar(),
      ),
    );
  }


  Widget handler(int isSelected) {
    debugPrint("handler...."+isSelected.toString()+"  "+_selectedIndex.toString());
    if (_groupValue != -1) {
      if (_groupValue == 1) {
        PrefUtils.prefs!.setString("payment_type", "Wallet");
      } else if (_groupValue == 2) {
        PrefUtils.prefs!.setString("payment_type", "Paytm");
      }
    }
    return (isSelected == _selectedIndex )  ?
    Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: ColorCodes.whiteColor,
        border: Border.all(
          color: ColorCodes.greenColor,
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color:ColorCodes.whiteColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check,
            color: ColorCodes.greenColor,
            size: 15.0),
      ),
    )
        :
    Icon(
        Icons.radio_button_off_outlined,
        color: ColorCodes.lightGreyColor);


  }
  Widget _myRadioButton({String? title, int? value, Function(int?)? onChanged}) {
    if (_groupValue != -1) {
      if (_groupValue == 1) {
        PrefUtils.prefs!.setString("payment_type", "Wallet");
      } else if (_groupValue == 2) {
        PrefUtils.prefs!.setString("payment_type", "Paytm");
      }
    }

    return Radio<int>(
      activeColor: Theme.of(context).primaryColor,
      value: value!,
      groupValue: _groupValue,
      onChanged: onChanged!,
      //title: Text(title),
    );
  }

  Future<void> CreateSubscription(int quantity, double subscriptionAmount, int deliveryNum) async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }
    try {
      List items = [];
      String text = weeklist.toString().replaceAll('[', "").replaceAll(']', '').replaceAll(' ', '');
      debugPrint("text...."+text +"  "+weeklist.toString().replaceAll('[', "").replaceAll(']', ''));
      items.clear();
      items.add({
        "itemId": widget.itemid,
        "varId": varid.toString(),
        "type": widget.varType,
        "mrp": varmrp,
        "price": varprice,
        "weight": widget.weight,
        "quantity":widget.itemCount,
      });
      var resBody = {};
      resBody["user_id"] = PrefUtils.prefs!.getString('apikey');
      resBody["delivery"] = widget.deliveries;
      resBody["start_date"] =widget.startDate;
      resBody["address"] = widget.address;
      resBody["address_type"] = user_data.billingAddress![0].addressType.toString();
      resBody["address_id"] = user_data.billingAddress![0].id.toString();
      resBody["amount"] = ((subscriptionAmount * quantity) * deliveryNum).toString();
      resBody["branch"] =PrefUtils.prefs!.getString('branch')??"999";
      resBody["slot"] = widget.schedule; //widget.name.toString();
      resBody["payment_type"] = user_data.prepaidModule == "1"? "credits" :(_ischeckbox && _groupValue == 2)?  "wallet": (_ischeckbox && _groupValue == -1)?"wallet":"Paytm";
      resBody["cron_time"] = widget.cronTime;
      resBody["channel"] = channel;
      resBody["var_id"] = widget.varid;
      resBody["type"] = widget.schedule;
      resBody["mrp"] = varmrp;
      resBody["price"] = varprice;
      resBody["quantity"] = widget.itemCount;
      resBody["days"] = text;
      resBody["no_of_days"] = no_of_days;
      resBody["subscriptionType"] = user_data.prepaidModule == "1"? "2" :widget.paymentMode;
      resBody["planId"] = widget.planId;
      resBody["paymentMode"] = paymentMode.toString();
      resBody["walletBalance"] = _ischeckbox?walletAmount.toString():"0";
      resBody["only_wallet"] = (_ischeckbox && _groupValue == -1)? "1":"0";

      for(int i= 0; i< items.length;i++){
        resBody["variation[" + i.toString() + "][itemId]"] = items[i]["itemId"];
        resBody["variation[" + i.toString() + "][varId]"] = items[i]["varId"];
        resBody["variation[" + i.toString() + "][type]"] = items[i]["type"];
        resBody["variation[" + i.toString() + "][mrp]"] = items[i]["mrp"];
        resBody["variation[" + i.toString() + "][price]"] = items[i]["price"];
        resBody["variation[" + i.toString() + "][weight]"] = items[i]["weight"];
        resBody["variation[" + i.toString() + "][quantity]"] = items[i]["quantity"];
      }
      debugPrint(resBody.toString());
      final response = await http.post(Api.subscriptionCreate,
          // headers: {"Content-Type": "application/json"},
          body: resBody
        // jsonEncode({
        //     "user_id":PrefUtils.prefs!.getString('apikey'),
        //     "quantity":widget.itemCount,
        //     "delivery":widget.deliveries,
        //     "start_date":widget.startDate,
        //     "address":widget.address,
        //     "address_type":widget.useraddtype,
        //     "address_id":widget.addressid,
        //     "amount":((subscriptionAmount * quantity) * deliveryNum).toString(),
        //     "branch":PrefUtils.prefs!.getString('branch')??"999",
        //     "slot":widget.name,
        //     "payment_type":user_data.prepaidModule == "1"? "credits" :(_ischeckbox && _groupValue == 2)?  "wallet": (_ischeckbox && _groupValue == -1)?"wallet":"Paytm",
        //     "cron_time":widget.cronTime,
        //     "channel":channel,
        //     "var_id": widget.varid,
        //     "type": widget.schedule,
        //     "mrp":varmrp,
        //     "price":varprice,
        //     'variation': [
        //       {
        //         "itemId": widget.itemid,
        //         "varId": varid.toString(),
        //         "type": widget.schedule,
        //         "mrp": varmrp,
        //         "price": varprice,
        //         "weight": widget.weight,
        //         "quantity":widget.itemCount,
        //       }
        //     ],
        //     "days":text,
        //     "no_of_days":no_of_days,
        //     "subscriptionType":user_data.prepaidModule == "1"? "2" :widget.paymentMode,
        //     "planId": widget.planId,
        //     "walletBalance": _ischeckbox?walletAmount.toString():"0",
        //     "only_wallet": (_ischeckbox && _groupValue == -1)? "1":"0",
        //   })
      );

      final responseJson = json.decode(response.body);
      debugPrint("response....sub"+responseJson.toString());
      if (responseJson['status'] == 200) {
        double orderAmount = double.parse(responseJson['amount'].toString());
        var orderId = responseJson['id'];
        debugPrint("orderId..."+orderId.toString());
        PrefUtils.prefs!.setString("subscriptionorderId", responseJson['id'].toString());
        PrefUtils.prefs!.setString("startDate", /*routeArgs['startDate'].toString()*/widget.startDate);

        if(_ischeckbox && _groupValue == -1){
          Navigator.of(context).pop();

          Navigation(context, name: Routename.SubscriptionConfirm, navigatore: NavigatoreTyp.Push,
              parms: {
                'orderstatus' : "success",
                'sorderId': PrefUtils.prefs!.getString("subscriptionorderId").toString()
              });

        }else {
          payment.startPaytmTransaction(
              context, _isWeb, orderId: orderId.toString(),
              username: PrefUtils.prefs!.getString('apikey'),
              amount: orderAmount.toString(),
              routeArgs: /*routeArgs*/widget.params1,
              prev: "SubscribeScreen");

        }
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: S.of(context).something_went_wrong,
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    } catch (error) {
      throw error;
    }
  }
}

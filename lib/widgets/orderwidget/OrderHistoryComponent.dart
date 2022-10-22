import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../providers/addressitems.dart';
import '../../providers/branditems.dart';
import '../../providers/myorderitems.dart';
import '../../providers/notificationitems.dart';
import '../../rought_genrator.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../footer.dart';
import '../invoice/invoice_button.dart';
import '../orderhistory_display.dart';
import '../simmers/orderhistory_shimmer.dart';

class OrderHistoryComponent extends StatefulWidget {
  String? orderid = "";
  String? fromscreen = "";
  String? orderstattus = "";
  Map<String, String>? orderhistory;
  String? notificationId = "";
  String? notificationStatus = "";

  OrderHistoryComponent(this.orderid,this.fromscreen,this.orderstattus,this.notificationId,this.notificationStatus){

  }

  @override
  State<OrderHistoryComponent> createState() => _OrderHistoryComponentState();
}

class _OrderHistoryComponentState extends State<OrderHistoryComponent>   with Navigations {
  var _address = "";

  String? id;
  String? itemid;
  String? itemname;
  String? varname;
  String? price;
  String? qty;
  String? itemoactualamount;
  String? discount;
  String? subtotal;
  String? itemImage;
  String? menuid;
  String? barcode;
  var orderitemData;
  bool _isLoading = true;
  var phone = "";
  var _isWeb = false;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool _showReturn = false;
  int _groupValue = -1;
  String? orderid, orderstatus, prev;
  String? extraAmount;
  bool _isIOS = false;
  var addressitemsData;
  double dueamount = 0.0;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isIOS = true;
          _isWeb = false;
        });
      } else {
        setState(() {
          _isWeb = false;
          _isIOS = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWeb = true;
        _isIOS = false;
      });
    }
    Future.delayed(Duration.zero, () async {
      BrandItemsList().GetRestaurantNew(PrefUtils.prefs!.getString("branch")!, () async {});
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      if (PrefUtils.prefs!.getString('mobile') != null) {
        phone = PrefUtils.prefs!.getString('mobile')!;
      } else {
        phone = "";
      }
      final routeArgs =
      ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      orderid = widget.orderid;
      orderstatus = widget.orderstattus;
      prev = widget.fromscreen;

      Provider.of<MyorderList>(context, listen: false)
          .Vieworders(widget.orderid)
          .then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(
            context,
            listen: false,
          );

          extraAmount = orderitemData.vieworder1[0].extraAmount;
          dueamount = double.parse(orderitemData.vieworder[0].dueamount);
          if (orderitemData.vieworder1[0].deliveryOn != "") {
            DateTime today = new DateTime.now();
            for (int i = 0; i < orderitemData.vieworder1.length; i++) {
              DateTime orderAdd = DateTime.parse(
                  orderitemData.vieworder1[i].deliveryOn)
                  .add(Duration(
                  hours:
                  int.parse(orderitemData.vieworder1[i].returnTime)));
              if ((orderAdd.isAtSameMomentAs(today) ||
                  orderAdd.isAfter(today)) &&
                  (orderitemData.vieworder[0].returnStatus == "" ||
                      orderitemData.vieworder[0].returnStatus == "null") &&
                  (orderitemData.vieworder1[i].ostatus.toLowerCase() ==
                      "delivered" ||
                      orderitemData.vieworder1[i].ostatus.toLowerCase() ==
                          "completed")) {
                if (orderitemData.vieworder1[i].returnTime != "" &&
                    orderitemData.vieworder1[i].returnTime != "0") {
                  setState(() {
                    _showReturn = true;
                  });
                  break;
                }
              }
            }
          }
          if (prev == "splashNotification" ||
              prev == "pushNotificationScreen") {
            Provider.of<NotificationItemsList>(context, listen: false)
                .updateNotificationStatus( widget.notificationId!, "1");
          }
          if ((prev == "splashNotification" &&
              orderitemData.vieworder[0].ostatus.toString().toUpperCase() ==
                  "DELIVERED") ||
              (prev ==
                  "pushNotificationScreen" && widget
                  .notificationStatus ==
                  "0" &&
                  orderitemData.vieworder[0].ostatus.toString().toUpperCase() ==
                      "DELIVERED")) {
            ShowpopupforReview();
          }
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  _dialogforReturn(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid = queryData!.size.width;
    maxwid = wid! * 0.90;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 150.0,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))
                      ? MediaQuery.of(context).size.width * 0.50
                      : MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        S.of(context).do_you_want_return_exchange,
                        //"Do you want to return or exchange",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      _myRadioButton(
                        title: S.of(context).returns,
                        //    "Return",
                        value: 0,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue!),
                      ),
                      _myRadioButton(
                        title: S.of(context).exchange,
                        // "Exchange",
                        value: 1,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue!),
                      ),
                    ],
                  )),
            );
          });
        });
  }

  Widget _myRadioButton(
      {String? title, int? value, Function(int?)? onChanged}) {
    final addressitemsData =
    Provider.of<AddressItemsList>(context, listen: false);

    if (_groupValue == 0) {
      PrefUtils.prefs!.setString("return_type", "0"); // 0 => Return
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        _groupValue = -1;
        Navigation(context,
            name: Routename.Return,
            navigatore: NavigatoreTyp.Push,
            parms: {
              'orderid': orderid!,
              'title': S.of(context).returns,
            });
      });
    } else if (_groupValue == 1) {
      PrefUtils.prefs!.setString("return_type", "1"); // 1 => Exchange
      Future.delayed(Duration.zero, () async {
        Navigator.pop(context);
        _groupValue = -1;
        Navigation(context,
            name: Routename.Return,
            navigatore: NavigatoreTyp.Push,
            parms: {
              'orderid': orderid!,
              'title': S.of(context).exchange,
            });
      });
    }

    return RadioListTile<int>(
      activeColor: Theme.of(context).primaryColor,
      value: value!,
      groupValue: _groupValue,
      onChanged: onChanged!,
      title: Text(title!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // this is the block you need
        if (prev == "splashNotification") {
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        } else if (prev == "orderConfirmation") {
          HomeScreenController(
              user: (VxState.store as GroceStore).userData.id ??
                  PrefUtils.prefs!.getString("tokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        } else if (prev == "weborderConfirmation") {
          HomeScreenController(
              user: (VxState.store as GroceStore).userData.id ??
                  PrefUtils.prefs!.getString("tokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          Navigation(context, navigatore: NavigatoreTyp.homenav);
        } else if (prev == "pushNotificationScreen") {
          Navigation(context,
              navigatore: NavigatoreTyp.Push, name: Routename.notify);
        } else if (prev == "webmyOrders") {
          Navigation(
            context,
            name: Routename.MyOrders,
            navigatore: NavigatoreTyp.Push,
          );
        } else {
          if (_isWeb) {
            Navigation(
              context,
              name: Routename.MyOrders,
              navigatore: NavigatoreTyp.Push,
            );
          } else {
            Navigator.of(context).pop();
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: ColorCodes.whiteColor,//Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            // if (_isWeb && !ResponsiveLayout.isSmallScreen(context))
            //   Header(false),
            _body(),
          ],
        ),
      ),
    );
  }

  _body() {
    final routeArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    //final itemLeftCount = routeArgs['itemLeftCount'];
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorCodes.whiteColor,//ColorCodes.lightGreyWebColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(
                child:
                OrderHistoryShimmer(), //CircularProgressIndicator(),
              )
                  : viewOrder(),
              SizedBox(
                height: 40,
              ),
              if (_isWeb && ResponsiveLayout.isSmallScreen(context))
                Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],
          ),
        ),
      ),
    );
  }

  _dialogforProcessing() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }

  void _repeatOrder() {
    cartcontroller.reorder((onload) {
      Navigator.of(context).pop();
      if (onload) {
        Navigation(context,
            name: Routename.Cart,
            navigatore: NavigatoreTyp.Push,
            qparms: {"afterlogin": null});
      }
    }, orderid: orderid!);
  }

  Widget viewOrder() {
    queryData = MediaQuery.of(context);
    wid = queryData!.size.width;
    maxwid = wid! * 0.90;
    double total;
    double subtotal;
    if (orderitemData.vieworder[0].itemodelcharge != 0) {
      total = double.parse(orderitemData.vieworder[0].itemoactualamount) +
          double.parse(orderitemData.vieworder[0].itemodelcharge) -
          orderitemData
              .vieworder[0].loyalty
          -
          double.parse(orderitemData.vieworder[0].totalDiscount) +
          double.parse(orderitemData.vieworder[0].dueamount);
    } else {
      total = double.parse(orderitemData.vieworder[0].itemoactualamount) -
          orderitemData
              .vieworder[0].loyalty
          -
          double.parse(orderitemData.vieworder[0].totalDiscount) +
          double.parse(orderitemData.vieworder[0].dueamount);
    }
    subtotal = double.parse(orderitemData.vieworder[0].itemoactualamount) +
        double.parse(orderitemData.vieworder[0].dueamount);
    String total_saving = (orderitemData.vieworder[0].promocode_discount +
        orderitemData.vieworder[0].membership_earned)
        .toString();
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))
            ? BoxConstraints(maxWidth: maxwid!)
            : null,
        child: Column(
          children: [
            (orderitemData.vieworder[0].loyalty_earned.toString() == "0")
                ? SizedBox.shrink()
                :
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration:
              BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  (orderitemData.vieworder[0].loyalty_earned.toString() ==
                      "0")
                      ? SizedBox.shrink()
                      :
                  Row(
                    children: [
                      Text(S.of(context).loyalty_earned,
                        style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Image.asset(Images.coinImg,
                          height: 15.0, width: 15.0),
                      SizedBox(width: 4),
                      Text(orderitemData
                          .vieworder[0].loyalty_earned,
                          style: TextStyle(color: ColorCodes.primaryColor,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (orderitemData.vieworder[0].membership_earned
                      .toString() ==
                      "0")
                      ? SizedBox.shrink()
                      :
                  Row(
                    children: [
                      Text(S.of(context).membership_earned,
                          style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(orderitemData
                          .vieworder[0].membership_earned,
                          style: TextStyle(color: ColorCodes.primaryColor,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (orderitemData.vieworder[0].promocode_discount
                      .toString() ==
                      "0")
                      ? SizedBox.shrink()
                      :
                  Row(
                    children: [
                      Text(S.of(context).promocode_discount,
                          style: TextStyle(color: ColorCodes.blackColor,fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(orderitemData
                          .vieworder[0].promocode_discount,
                          style: TextStyle(color: ColorCodes.primaryColor,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (total_saving == "00")
                      ? SizedBox.shrink()
                      :
                  Row(
                    children: [
                      Text(S.of(context).total_savings,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorCodes.greenColor)),
                      Spacer(),
                      Text(orderitemData
                          .vieworder[0].promocode_discount +
                          orderitemData
                              .vieworder[0].membership_earned,
                          style: TextStyle(color: ColorCodes.primaryColor,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            (orderitemData.vieworder[0].loyalty_earned.toString() == "0")?SizedBox.shrink():
            Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(color: ColorCodes.lightGreyWebColor,thickness: 1,),
            ):
            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).delivery,
                      // "Delivery Slot",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorCodes.greenColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).delivery_from
                      ),
                      Spacer(),
                      Text(orderitemData.vieworder[0].resturantname),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).ordered_on
                      ),
                      Spacer(),
                      Text(orderitemData.vieworder[0].odate),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).delivery_on
                        // "Delivery on : "
                      ),
                      Spacer(),
                      Text(orderitemData.vieworder[0].odeltime),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (orderitemData.vieworder[0].returnStatus == "" ||
                      orderitemData.vieworder[0].returnStatus == "null")
                      ? Row(
                    children: [
                      Text(S.of(context).order_status
                        // "Order Status : "
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].ostatus,
                        style: TextStyle(color: ColorCodes.greenColor),
                      )
                    ],
                  )
                      : Row(
                    children: [
                      Text(
                        //S .of(context).ret
                          S.of(context).return_status //"Return Status : "
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].returnStatus,
                        style: TextStyle(color: ColorCodes.greenColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(color: ColorCodes.lightGreyWebColor,thickness: 1,),
            ):
            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.only(left:15,right: 15,top: 5,bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).address,
                      // "Address",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorCodes.greenColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    orderitemData.vieworder[0].customerName,
                    style: TextStyle(color: ColorCodes.greyColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    orderitemData.vieworder[0].oaddress,
                    style: TextStyle(color: ColorCodes.greyColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    phone,
                    style: TextStyle(color: ColorCodes.greyColor),
                  )
                ],
              ),
            ),
            Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(color: ColorCodes.lightGreyWebColor,thickness: 1,),
            ):
            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.only(left: 15,right: 15,top:5,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).payment_details,
                      // "Payment Details",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorCodes.greenColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).ordered_ID
                        //"Ordered Id : "
                        ,
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].itemorderid,
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (!(orderitemData.vieworder[0].invoice == "-" ||
                      orderitemData.vieworder[0].invoice == "" ||
                      orderitemData.vieworder[0].invoice == null))
                      ? Row(
                    children: [
                      Text(
                        S.of(context).invoice_no,
                        //"Invoice No : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].invoice,
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                  (!(orderitemData.vieworder[0].invoice == "-" ||
                      orderitemData.vieworder[0].invoice == "" ||
                      orderitemData.vieworder[0].invoice == null))
                      ? SizedBox(
                    height: 10,
                  )
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      Text(
                        S.of(context).payment_option,
                        //"Payment Options : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].opaytype,
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).ordered_items,
                        //"Ordered Items : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.vieworder[0].itemsCount +
                            S.of(context).items,
                        //  " items",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).sub_total,
                        //"Sub Total : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        Features.iscurrencyformatalign
                            ? subtotal.toStringAsFixed(
                            IConstants.numberFormat == "1"
                                ? 0
                                : IConstants.decimaldigit) +
                            " " +
                            IConstants.currencyFormat
                            : IConstants.currencyFormat +
                            " " +
                            subtotal.toStringAsFixed(IConstants
                                .numberFormat ==
                                "1"
                                ? 0
                                : IConstants
                                .decimaldigit), //double.parse(orderitemData.vieworder[0].itemoactualamount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).delivery_charge_order,
                        //"Delivery Charges : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      double.parse(orderitemData.vieworder[0].itemodelcharge) ==
                          0.0
                          ? Text(
                        S.of(context).free,
                        //"FREE",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.0),
                      )
                          : Text(
                        Features.iscurrencyformatalign
                            ? "+" +
                            " " +
                            double.parse(orderitemData
                                .vieworder[0].itemodelcharge)
                                .toStringAsFixed(
                                IConstants.numberFormat == "1"
                                    ? 0
                                    : IConstants.decimaldigit) +
                            " " +
                            IConstants.currencyFormat
                            : "+" +
                            " " +
                            IConstants.currencyFormat +
                            " " +
                            double.parse(orderitemData
                                .vieworder[0].itemodelcharge)
                                .toStringAsFixed(
                                IConstants.numberFormat == "1"
                                    ? 0
                                    : IConstants.decimaldigit),
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  if (orderitemData.vieworder[0].loyalty != 0.0)
                    SizedBox(
                      height: 10,
                    ),
                  if (orderitemData.vieworder[0].loyalty != 0.0)
                    Row(
                      children: [
                        Text(
                          S.of(context).discount_applied_order,
                          // "Discount Applied (loyalty): ",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                        Spacer(),
                        Text(
                          Features.iscurrencyformatalign
                              ? "-" +
                              " " +
                              (orderitemData.vieworder[0].loyalty)
                                  .toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit) +
                              " " +
                              IConstants.currencyFormat
                              : "-" +
                              " " +
                              IConstants.currencyFormat +
                              " " +
                              (orderitemData.vieworder[0].loyalty)
                                  .toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  if (double.parse(orderitemData.vieworder[0].totalDiscount) !=
                      0)
                    SizedBox(
                      height: 10,
                    ),
                  if (double.parse(orderitemData.vieworder[0].totalDiscount) !=
                      0)
                    Row(
                      children: [
                        Text(
                          S.of(context).promo
                              //  "Promo ("
                              +
                              (orderitemData.vieworder[0].promocode)
                                  .toString() +
                              ")",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                        Spacer(),
                        Text(
                          Features.iscurrencyformatalign
                              ? "-" +
                              " " +
                              double.parse(orderitemData
                                  .vieworder[0].totalDiscount
                                  .toString())
                                  .toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit) +
                              " " +
                              IConstants.currencyFormat
                              : "-" +
                              " " +
                              IConstants.currencyFormat +
                              " " +
                              double.parse(orderitemData
                                  .vieworder[0].totalDiscount
                                  .toString())
                                  .toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  if (orderitemData.vieworder[0].wallet != 0.0)
                    SizedBox(
                      height: 10,
                    ),
                  if (orderitemData.vieworder[0].wallet != 0.0)
                    Row(
                      children: [
                        Text(
                          S.of(context).wallet,
                          //   "Wallet : ",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                        Spacer(),
                        Text(
                          Features.iscurrencyformatalign
                              ? "-" +
                              " " +
                              (orderitemData.vieworder[0].wallet)
                                  .toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit) +
                              " " +
                              IConstants.currencyFormat
                              : "-" +
                              " " +
                              IConstants.currencyFormat +
                              " " +
                              (orderitemData.vieworder[0].wallet)
                                  .toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  DottedLine(
                    dashColor: ColorCodes.greyColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).total_amount,
                        //  "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        Features.iscurrencyformatalign
                            ? total.toStringAsFixed(
                            IConstants.numberFormat == "1"
                                ? 0
                                : IConstants.decimaldigit) +
                            " " +
                            IConstants.currencyFormat
                            : IConstants.currencyFormat +
                            " " +
                            total.toStringAsFixed(
                                IConstants.numberFormat == "1"
                                    ? 0
                                    : IConstants.decimaldigit),
                        style: TextStyle(fontWeight: FontWeight.bold,
                          color: ColorCodes.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (double.parse(orderitemData.vieworder[0].totalDiscount) != 0)
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: ColorCodes.varcolor),
                padding: const EdgeInsets.fromLTRB(28.0, 5.0, 30.0, 5.0),
                child: Row(
                  children: [
                    Text(
                      S.of(context).your_total_saving,
                      //  "Total",
                      style: TextStyle(fontWeight: FontWeight.bold,color: ColorCodes.primaryColor),
                    ),
                    Spacer(),
                    Text(
                      Features.iscurrencyformatalign
                          ? double.parse(orderitemData
                          .vieworder[0].totalDiscount
                          .toString())
                          .toStringAsFixed(
                          IConstants.numberFormat == "1"
                              ? 0
                              : IConstants.decimaldigit) +
                          " " +
                          IConstants.currencyFormat
                          : IConstants.currencyFormat +
                          " " +
                          double.parse(orderitemData
                              .vieworder[0].totalDiscount
                              .toString())
                              .toStringAsFixed(
                              IConstants.numberFormat == "1"
                                  ? 0
                                  : IConstants.decimaldigit),
                      style: TextStyle(
                        color:  ColorCodes.primaryColor,//ColorCodes.mediumBlueColor,
                      ),
                    ),
                  ],
                ),
              ),
            if (Features.isRefundModule)
              if (dueamount > 0) SizedBox(height: 10),
            if (Features.isRefundModule)
              if (dueamount > 0)
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right:15),
                  child: Divider(),
                ),
            if (Features.isRefundModule)
              if (dueamount > 0)
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                  BoxDecoration(color: Theme.of(context).buttonColor),
                  // padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: Text(S.of(context).refund,
                            // "Address",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorCodes.greenColor)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).due_amount,
                              //  "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              Features.iscurrencyformatalign
                                  ? dueamount.toStringAsFixed(
                                  IConstants.numberFormat == "1"
                                      ? 0
                                      : IConstants.decimaldigit) +
                                  " " +
                                  IConstants.currencyFormat
                                  : IConstants.currencyFormat +
                                  " " +
                                  dueamount.toStringAsFixed(
                                      IConstants.numberFormat == "1"
                                          ? 0
                                          : IConstants.decimaldigit),
                              style: TextStyle(fontWeight: FontWeight.bold
                                //color: ColorCodes.mediumBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigation(context,
                              name: Routename.Refund,
                              navigatore: NavigatoreTyp.Push,
                              parms: {
                                "orderid": orderid!,
                                "total": total.toString(),
                              });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          decoration:
                          BoxDecoration(color: ColorCodes.varcolor),
                          height: 45,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    30.0, 5.0, 30.0, 5.0),
                                child: Text(
                                  S.of(context).view_details_order,
                                  //  "Total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorCodes.greenColor),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right:15.0),
                                child: IconButton(
                                    onPressed: () {
                                      Navigation(context,
                                          name: Routename.Refund,
                                          navigatore: NavigatoreTyp.Push,
                                          parms: {
                                            "orderid": orderid!,
                                            "total": total.toString(),
                                          });
                                    },
                                    icon: new Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorCodes.greenColor,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),


            Padding(
              padding: const EdgeInsets.only(left:15.0,right:15),
              child: Divider(),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).item_details,
                  //"Item Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.primaryColor)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.only(left:15,right:15),
              child: SizedBox(
                child: new ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: int.parse(orderitemData.vieworder[0].itemsCount),
                    itemBuilder: (_, i) {
                      return Column(
                        children: [
                          OrderhistoryDisplay(
                              orderitemData.vieworder1[i].itemname,
                              orderitemData.vieworder1[i].varname,
                              orderitemData.vieworder1[i].price,
                              orderitemData.vieworder1[i].qty,
                              orderitemData.vieworder1[i].subtotal,
                              orderitemData.vieworder1[i].itemImage,
                              orderitemData.vieworder1[i].extraAmount,
                              orderitemData.vieworder1[i].toppings,
                              (orderitemData.vieworder1[i].item_type == "1")
                                  ? orderitemData.vieworder1[i].itemid
                                  : orderitemData.vieworder1[i].menuid,
                              orderitemData.vieworder1[i].parent_id,
                              orderitemData.toppingsdata,
                              orderitemData.vieworder[0].ostatus,
                              orderitemData.vieworder1[i].tmrp),
                          // SizedBox(
                          //   height: 10,
                          // )
                        ],
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (Features.isReturnOrExchange)
              _showReturn
                  ? GestureDetector(
                onTap: () {
                  _dialogforReturn(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 20,
                  color: ColorCodes.varcolor,
                  child: Center(
                      child: Text(S.of(context).return_exchange,
                          //   'Return or Exchange'
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.primaryColor,
                              fontWeight: FontWeight.bold))),
                ),
              )
                  : SizedBox.shrink(),
            //:SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),
            if (Features.isRepeatOrder)
              (orderitemData.vieworder1[0].ostatus.toLowerCase() ==
                  "delivered" ||
                  orderitemData.vieworder1[0].ostatus.toLowerCase() ==
                      "completed")
                  ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _dialogforProcessing();
                    _repeatOrder();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 20,
                    color: ColorCodes.varcolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.repeat,
                            color: ColorCodes.primaryColor,),
                          onPressed: () {},
                        ),
                        Text(
                          S.of(context).repeat_order,
                          // 'REPEAT ORDER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorCodes.primaryColor,//ColorCodes.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : SizedBox.shrink(),
            _isWeb
                ? SizedBox(
              height: 10.0,
            )
                : SizedBox.shrink(),

            SizedBox(
              height: 10,
            ),

            if ((orderitemData.vieworder1[0].ostatus.toLowerCase() ==
                "delivered" ||
                orderitemData.vieworder1[0].ostatus.toLowerCase() ==
                    "completed"))
              InvoiceButton(
                  orderId: orderid,
                  orderItemData: orderitemData,
                  subTotal: subtotal,
                  total: total,
                  totalSaving: total_saving,
                  deliveryDateTime: orderitemData.vieworder[0].odeltime,
                  paymentOption: orderitemData.vieworder[0].opaytype)
          ],
        ),
      ),
    );
  }

  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise) ? 0 : 1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color:  ColorCodes.iconColor),
          onPressed: () async {
            if (prev == "splashNotification") {
              // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            } else if (prev == "orderConfirmation") {
              HomeScreenController(
                  user: (VxState.store as GroceStore).userData.id ??
                      PrefUtils.prefs!.getString("tokenid"),
                  branch:
                  (VxState.store as GroceStore).userData.branch ?? "999",
                  rows: "0");
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            } else if (prev == "weborderConfirmation") {
              HomeScreenController(
                  user: (VxState.store as GroceStore).userData.id ??
                      PrefUtils.prefs!.getString("tokenid"),
                  branch:
                  (VxState.store as GroceStore).userData.branch ?? "999",
                  rows: "0");
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            } else if (prev == "pushNotificationScreen") {
              HomeScreenController(
                  user: (VxState.store as GroceStore).userData.id ??
                      PrefUtils.prefs!.getString("tokenid"),
                  branch:
                  (VxState.store as GroceStore).userData.branch ?? "999",
                  rows: "0");
              Navigation(context,
                  navigatore: NavigatoreTyp.Push, name: Routename.notify);
            } else if (prev == "webmyOrders") {
              Navigation(
                context,
                name: Routename.MyOrders,
                navigatore: NavigatoreTyp.Push,
              );
            } else {
              if (_isWeb) {
                Navigation(
                  context,
                  name: Routename.MyOrders,
                  navigatore: NavigatoreTyp.Push,
                );
              } else {
                Navigator.of(context).pop();
              }
            }
            return Future.value(false);
          }),
      title: Text(
        S.of(context).order_details, //  'Orders Details',
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
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

  ShowpopupforReview() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Center(
                child: Image.asset(
                  Images.logoImg,
                  height: 50,
                  width: 138,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(S.of(context).enjoying
                  //  "Enjoying "
                  +
                  IConstants.APP_NAME +
                  "?"),
            ],
          ),
          content: Text(_isIOS
              ? S.of(context).if_enjoying
              // "If you enjoy using "
              +
              IConstants.APP_NAME +
              S.of(context).wouldyou_mind_rating_appstore
          //  " app, would you mind rating us on App Store then?"
              :
          //"If you enjoy using "
          S.of(context).if_enjoying +
              IConstants.APP_NAME +
              //" app, would you mind rating us on Play Store then?"
              S.of(context).wouldyou_mind_rating_playstore),
          actions: <Widget>[
            FlatButton(
              child: Text(
                // 'Rate Us'
                  S.of(context).rate_us),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  if (Platform.isIOS) {
                    LaunchReview.launch(writeReview: false, iOSAppId: IConstants.appleId);
                  } else {
                    LaunchReview.launch();
                  }
                } catch (e) {}
                ;
                //launch("https://play.google.com/store/apps/details?id=" + IConstants.androidId);
              },
            ),
            FlatButton(
              child: Text(S.of(context).no_thanks),
              // 'No, Thanks'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

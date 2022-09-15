import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/rought_genrator.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../screens/home_screen.dart';
import '../generated/l10n.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/orderhistory_shimmer.dart';
import 'package:provider/provider.dart';
import '../utils/prefUtils.dart';

import '../providers/myorderitems.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';

class ViewSubscriptionDetails extends StatefulWidget {
  static const routeName = '/viewsubscriptiondetails-screen';

  String orderid  = "";
  String fromScreen = "";

  ViewSubscriptionDetails(Map<String, String> params){
    this.orderid = params["orderid"]??"" ;
    this.fromScreen = params["fromScreen"]??"";
  }
  @override
  _ViewSubscriptionDetailsState createState() => _ViewSubscriptionDetailsState();
}

class _ViewSubscriptionDetailsState extends State<ViewSubscriptionDetails> with Navigations {

  var orderitemData;
  bool _isLoading = true;
  var phone = "";
  var name = "";
  var _isWeb = false;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  late String orderid;
  var fromScreen ="";
  bool _isIOS = false;
  GroceStore store = VxState.store;

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
      if (PrefUtils.prefs!.getString('mobile') != null) {
        phone = PrefUtils.prefs!.getString('mobile')!;
      } else {
        phone = "";
      }
     /* if (PrefUtils.prefs!.getString('FirstName') != null) {
        if (PrefUtils.prefs!.getString('LastName') != null) {
          name =  PrefUtils.prefs!.getString('FirstName') + " " + PrefUtils.prefs!.getString('LastName');
        } else {
          name =  PrefUtils.prefs!.getString('FirstName');
        }
      } else {
        name = "";
      }*/
      name = store.userData.username!;
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      fromScreen = /*routeArgs['fromScreen']!*/widget.fromScreen;
      orderid = /*routeArgs['orderid']!*/widget.orderid;
      Provider.of<MyorderList>(context, listen: false).Viewsubscriptionorders(orderid).then((_) {
        setState(() {
          orderitemData = Provider.of<MyorderList>(context, listen: false,);
          _isLoading = false;
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return WillPopScope(
      onWillPop: () {
        if(fromScreen == "subscConfirmation"){
         // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          _moveToScreen2(context);
        }else{
          Navigator.of(context).pop();
        }

        return Future.value(true);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,

        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            _body(),
          ],
        ),
      ),
    );
  }

  _body() {
    final routeArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final itemLeftCount = routeArgs['itemLeftCount'];
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorCodes.whiteColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(
                child: OrderHistoryShimmer(),//CircularProgressIndicator(),
              )
                  : viewOrder(),
              SizedBox(height: 40,),
              if (_isWeb)
                Footer(address: PrefUtils.prefs!.getString("restaurant_address")!/*PrefUtils.prefs!.getString("restaurant_address")*/),
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

  Widget viewOrder() {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.only(left:15,right: 15,bottom:5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                      S .of(context).delivery,
                      // "Delivery Slot",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.greenColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(S .of(context).start_dat + " : " + orderitemData.viewordersubscription[0].startdate),
                  orderitemData.viewordersubscription[0].plan == "Default Plan"?SizedBox.shrink(): SizedBox(
                    height: 10,
                  ),
                  orderitemData.viewordersubscription[0].plan == "Default Plan"?SizedBox.shrink(): Text(S .of(context).end_date + " : " + orderitemData.viewordersubscription[0].enddate),
                 SizedBox(
                    height: 10,
                  ),
                  Text(S .of(context).cron_time + orderitemData.viewordersubscription[0].crontime),
                  SizedBox(
                    height: 10,
                  ),
                  orderitemData.viewordersubscription[0].plan == "Default Plan"?SizedBox.shrink(): Text(S .of(context).no_deliveries + orderitemData.viewordersubscription[0].delivery),
                  orderitemData.viewordersubscription[0].plan == "Default Plan"?SizedBox.shrink(): SizedBox(
                    height: 10,
                  ),
                  Text(/*"Pending Deliveries Amount: "*/S.of(context).pending_delamount+orderitemData.viewordersubscription[0].pending_amount),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).order_status+": "
                        // "Order Status : "
                      ),

                      Text(
                        orderitemData.viewordersubscription[0].status! == "4"? /*"Failure"*/S.of(context).failure_subscription:/*"Success"*/S.of(context).success_subscription,
                        style: TextStyle(color: ColorCodes.greenColor),
                      )
                    ],
                  ),

                ],
              ),
            ),

           SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.only(left:15,right: 15),
              child: Divider(color: ColorCodes.greylight,),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.only(left:15,right: 15,bottom:5,top:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S .of(context).address,
                      // "Address",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.greenColor)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    name,
                    style: TextStyle(color: ColorCodes.greyColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    orderitemData.viewordersubscription[0].addres + " "+orderitemData.viewordersubscription[0].addresstype,
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
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.only(left:15,right: 15),
              child: Divider(color: ColorCodes.greylight,),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              padding: EdgeInsets.only(left:15,right: 15,bottom:5,top:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      S .of(context).payment_details,
                      // "Payment Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.greenColor)),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text(
                        S .of(context).ordered_ID + " : ",//"Ordered Id : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        orderitemData.viewordersubscription[0].subid,
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
                        S .of(context).payment_option + " : ",//"Payment Options : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                        (orderitemData.viewordersubscription[0].paymenttype ),
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
                      S .of(context).ordered_items + " : ",//"Ordered Items : ",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                      Spacer(),
                      Text(
                          S .of(context).one_item,//"1 items",
                        style: TextStyle(color: ColorCodes.greyColor),
                      ),
                    ],
                  ),
                  /*SizedBox(
                    height: 10,
                  ),*/
                /*  if(orderitemData.viewordersubscription[0].wallet != 0.0 )
                    SizedBox(
                      height: 10,
                    ),
                  if(orderitemData.viewordersubscription[0].wallet != 0.0 )
                    Row(
                      children: [
                        Text(
                          "Wallet : ",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
                        ),
                        Spacer(),
                        Text(
                          IConstants.currencyFormat + " " + (orderitemData.viewordersubscription[0].wallet).toStringAsFixed(0),
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
                        ),
                      ],
                    ),*/
                  SizedBox(height:10),
                  DottedLine(dashColor: ColorCodes.greyColor,),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(S .of(context).total_amount,
                        //  "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        Features.iscurrencyformatalign?
                        double.parse(orderitemData.viewordersubscription[0].amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                        IConstants.currencyFormat + " " + double.parse(orderitemData.viewordersubscription[0].amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),/*orderitemData.vieworder[0].itemototalamount,*/
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                          //color: ColorCodes.mediumBlueColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width - 20,
              padding: EdgeInsets.only(left:15,right: 15,bottom:5,top:10),
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(S .of(context).item_details,//"Item Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorCodes.primaryColor)),
            ),
             Container(
               width: MediaQuery.of(context).size.width - 20,
               padding: EdgeInsets.only(left:15,right: 15,bottom:5),
            decoration: BoxDecoration(color: Theme.of(context).buttonColor),
            child:
            Row(
              children: [
                Container(
                child: CachedNetworkImage(
                  imageUrl: IConstants.BaseDomain  + orderitemData.viewordersubscription[0].image,
                  placeholder: (context, url) => Image.asset(Images.defaultProductImg,
                    width: 50,
                    height: 50,),
                  errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg,
                    width: 50,
                    height: 50,),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    orderitemData.viewordersubscription[0].name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                ),
               SizedBox(height: 5,),
                Text(S .of(context).qty//"Qty:"
                    +" " +orderitemData.viewordersubscription[0].quantity, style: TextStyle(color: ColorCodes.lightGreyColor,fontSize: 9),),
                SizedBox(height: 10,),
                Text(/*"Selected Subscription Plan: "*/S.of(context).selected_sub_plan, style: TextStyle(color: ColorCodes.grey,fontSize: 10),),
                SizedBox(height: 5,),
                Text(orderitemData.viewordersubscription[0].plan, style: TextStyle(color: ColorCodes.lightGreyColor,fontSize: 9),),
                ],
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  Features.iscurrencyformatalign?double.parse(orderitemData.viewordersubscription[0].amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                  IConstants.currencyFormat + " " + double.parse(orderitemData.viewordersubscription[0].amount).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),

      ),
          ],
        ),
      ),
    );
  }

  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,

      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
          onPressed: () {

            if(fromScreen == "subscConfirmation"){
              debugPrint("fromScreen...1"+fromScreen);
              _moveToScreen2(context);

              //Navigator.pushNamedAndRemoveUntil(context,  HomeScreen.routeName, (route) => false);  //present code

            }else
              Navigator.of(context).pop();

            }
      ),
      title: Text(S .of(context).subscription_detail,//'Subscription Details',
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
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
   _moveToScreen2(BuildContext context) async{
    //debugPrint("inside moveto funtion");

    Navigation(context, navigatore: NavigatoreTyp.homenav);
  }

}
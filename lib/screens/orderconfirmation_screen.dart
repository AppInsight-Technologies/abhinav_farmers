import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../constants/features.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../screens/home_screen.dart';
import '../../utils/facebook_app_events.dart';
import '../controller/mutations/cart_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../providers/sellingitems.dart';
import '../rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/images.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../providers/branditems.dart';
import '../widgets/simmers/orderconfirmation_shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../widgets/footer.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/header.dart';
import '../utils/prefUtils.dart';
import '../providers/cartItems.dart';
import 'orderhistory_screen.dart';

class OrderconfirmationScreen extends StatefulWidget {
  static const routeName = '/orderconfirmation-screen';

  Map<String,String> params;
  OrderconfirmationScreen(this.params);
  @override
  OrderconfirmationScreenState createState() => OrderconfirmationScreenState();
}

class OrderconfirmationScreenState extends State<OrderconfirmationScreen> with Navigations{
  bool _isOrderstatus = true;
  bool _isLoading = true;
  bool _isWeb = false;
  var _address = "";
  double? wid;
  double? maxwid;
  var orderid;
  MediaQueryData? queryData;
  bool iphonex = false;
  String referalCode = "";
  Uri? dynamicUrl;
  var name = "";
  double amount = 0.00;
  List<CartItem> productBox=[];
  GroceStore store = VxState.store;
  @override
  void initState() {
    productBox =  (VxState.store as GroceStore).CartItemList;
    PrefUtils.prefs!.remove("subscriptionorderId");
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
      setState(() {
        name = store.userData.username!;
      });

      referalCode= store.userData.myref!;


      var referData;
      Provider.of<BrandItemsList>(context,listen: false).ReferEarn().then((_) async {
        referData = await Provider.of<BrandItemsList>(context, listen: false);
        setState(() {
          amount = double.parse(referData.referEarn.amount);
        });
      });
      final routeArgs = ModalRoute
          .of(context)!
          .settings
          .arguments as Map<String, String>;

      final orderstatus = widget.params['orderstatus'];
      orderid = widget.params['orderid'];
      if(orderstatus == "success"){
         cartcontroller.clear((value) {
           if(value){
             setState(() {
               _isOrderstatus = true;
               _isLoading = false;
             });
           }
         });
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          sellingitemData.featuredVariation[i].varQty = 0;
        }

        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          sellingitemData.itemspricevarOffer[i].varQty = 0;
          break;
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          sellingitemData.itemspricevarSwap[i].varQty = 0;
          break;
        }

        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          sellingitemData.discountedVariation[i].varQty = 0;
          break;
        }

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          cartItemsData.items[i].itemQty = 0;
        }

      }
      else {
        for(int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1"){
            PrefUtils.prefs!.setString("membership", "0");
          }
        }
        final orderId = widget.params['orderid'];
        paymentStatus(orderId!);
      }
    });
    super.initState();
  }

  Future<String> createReferralLink(String referralCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: 'https://gbay.page.link',
        link: Uri.parse('https://referandearn.com/refer?code=$referralCode'),
        androidParameters: AndroidParameters(
          packageName: IConstants.androidId,
        ),
        iosParameters: IOSParameters(
            bundleId: IConstants.androidId,
            appStoreId: IConstants.appleId
        )
    );

    final ShortDynamicLink shortLink =
    await (await FirebaseDynamicLinks.instance).buildShortLink(dynamicLinkParameters);
    dynamicUrl = shortLink.shortUrl;
    return dynamicUrl.toString();
  }

  Future<void> paymentStatus(String orderId) async { // imp feature in adding async is the it automatically wrap into Future.
    try {
      debugPrint("payment status....."+{ // await keyword is used to wait to this operation is complete.
        "branch": PrefUtils.prefs!.getString('branch'),
      }.toString());
      final response = await http.post(
          Api.getOrderStatus + orderId,
          body: { // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs!.getString('branch'),
          }
      );
      final responseJson = json.decode(response.body);
      debugPrint("responsjson...."+responseJson['status'].toString());
      if(responseJson['status'].toString() == "yes") {
        PrefUtils.prefs!.remove("orderId");
        for(int i = 0; i < productBox.length; i++) {
          // if(Features.isfacebookappevent)
          //   FaceBookAppEvents.facebookAppEvents.logPurchase(parameters: {
          //   "id":orderId,
          // },amount: amount,currency:IConstants.currencyFormat);
          if (productBox[i].mode == "1"){
            PrefUtils.prefs!.setString("membership", "2");
            auth.getuserProfile(onsucsess: (value){
            }, onerror: (){
            });
          }
        }
        cartcontroller.clear((value) {
          if(value){
            setState(() {
              _isOrderstatus = true;
              _isLoading = false;
            });
          }
        });
        final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
        for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
          sellingitemData.featuredVariation[i].varQty = 0;
        }

        for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
          sellingitemData.itemspricevarOffer[i].varQty = 0;
          break;
        }
        for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
          sellingitemData.itemspricevarSwap[i].varQty = 0;
          break;
        }

        for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
          sellingitemData.discountedVariation[i].varQty = 0;
          break;
        }

        final cartItemsData = Provider.of<CartItems>(context, listen: false);
        for(int i = 0; i < cartItemsData.items.length; i++) {
          cartItemsData.items[i].itemQty = 0;
        }

      }
      else {
        for(int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1"){
            PrefUtils.prefs!.setString("membership", "0");
          }
        }
        setState(() {
          _isOrderstatus = false;
          _isLoading = false;
        });

      }

    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () { // this is the block you need
        HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
            PrefUtils.prefs!.getString("tokenid"),
            branch: (VxState.store as GroceStore).userData.branch ?? "999",
            rows: "0");
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ColorCodes.lightsteelblue,

        body:SafeArea(
          child: Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _body(),
            ],
          ),
        ),

      ),
    );
  }
  _body(){
    return _isWeb?_bodyweb():
    _bodymobile();
  }
  _bodymobile() {

    return _isLoading ?
    Center(
      child: OrderConfirmationShimmer(),//CircularProgressIndicator(),
    )
        :
    Expanded(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(

                height:MediaQuery.of(context).size.height/2.5,
                color: ColorCodes.varcolor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isOrderstatus ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check_circle, color: ColorCodes.primaryColor, size: 50,),
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        S .of(context).hi//'Thank You for Choosing '
                            + name + ',',
                        style: TextStyle(fontSize: 20.0, color: ColorCodes.primaryColor),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      Text(
                        S .of(context).thanks_choosing_confirm//'Thank You for Choosing '
                            + IConstants.APP_NAME + '.',
                        style: TextStyle(fontSize: 25.0, color: ColorCodes.primaryColor),
                        // textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            S .of(context).order + "#" +orderid,
                            style: TextStyle(fontSize: 16 , color: ColorCodes.primaryColor),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(_isWeb) {
                            (Vx.isWeb &&
                                !ResponsiveLayout.isSmallScreen(context)) ?
                            OrderhistoryWeb(
                                context, orderid: orderid.toString(),
                                fromscreen: "weborderConfirmation")
                                :
                            Navigation(context, name: Routename.OrderHistory,
                                navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'orderid': orderid.toString(),
                                  "fromScreen": "weborderConfirmation",
                                });
                          }
                          else {
                            Navigation(context, name: Routename.OrderHistory,
                                navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'orderid': orderid.toString(),
                                  "fromScreen": "orderConfirmation",
                                });
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width ,
                          // height: 32,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              width: 1.0,
                              color: ColorCodes.primaryColor,
                            ),
                          ),
                          child: Text(
                            S .of(context).view_details,//"LOGIN USING OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: ColorCodes.primaryColor),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(Images.gift, height: 100.0, width: 50.0,color: ColorCodes.primaryColor,),
                        Features.iscurrencyformatalign?
                        Text(S .of(context).share_get + amount.toString() + IConstants.currencyFormat,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),):
                        Text(S .of(context).share_get + IConstants.currencyFormat + amount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(height:8),
                        Text(S .of(context).inwallet_invite_friends + IConstants.APP_NAME + S .of(context).with_unique_referal ,
                            textAlign: TextAlign.center),
                        SizedBox(height:10),
                        GestureDetector(
                          onTap: (){
                            Share.share(/*'Download '*/S.of(context).download +
                                IConstants.APP_NAME +
                                /*' from Google Play Store and use my referral code ('*/ S.of(context).from_googleplay+ VxState.store.userData.myref +')'+" "+dynamicUrl.toString());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width ,
                            // height: 32,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorCodes.greenColor,
                              ),
                            ),
                            child: Text(
                              S .of(context).share_now,//"LOGIN USING OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: ColorCodes.greenColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                    //:
               // SizedBox.shrink(),

              if(_isWeb && !ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ]
        ),
      ),

    );
  }
  _bodyweb() {
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;
    return  _isLoading ?
    Center(
      child: OrderConfirmationShimmer(),//CircularProgressIndicator(),
    )
        :
    Expanded(

      child: SingleChildScrollView(

        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(


                  height:MediaQuery.of(context).size.height/2,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                  color: ColorCodes.ordergreen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isOrderstatus ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.check_circle, color: ColorCodes.whiteColor, size: 50,),
                          ),
                        )
                            :
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.cancel, color: Colors.red, size: 50.0),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          S .of(context).hi//'Thank You for Choosing '
                              + name + ',',
                          style: TextStyle(fontSize: 20.0, color: ColorCodes.whiteColor),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        Text(
                          S .of(context).thanks_choosing_confirm//'Thank You for Choosing '
                              + IConstants.APP_NAME + '.',
                          style: TextStyle(fontSize: 25.0, color: ColorCodes.whiteColor),
                          // textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              S .of(context).order + "#" +orderid,
                              style: TextStyle(fontSize: 16 , color: ColorCodes.whiteColor),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            (Vx.isWeb &&
                                !ResponsiveLayout.isSmallScreen(context)) ?
                            OrderhistoryWeb(
                                context, orderid: orderid.toString(),)
                                :
                            Navigation(context, name:Routename.OrderHistory,navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'orderid': orderid.toString(),
                                });
                          },
                          child: Container(
                            width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,
                            // height: 32,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorCodes.greenColor,
                              ),
                            ),
                            child: Text(
                              S .of(context).view_details,//"LOGIN USING OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: ColorCodes.greenColor),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                if(Features.isReferEarn)
                  if(amount > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                    ),

                if(_isWeb && !ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              ]
          ),
        ),
      ),

    );
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,

      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),onPressed: () {
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);
        });
      } ),
      title: Text(
        S .of(context).order_confirmation,
        //'Order Confirmation',
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
                ]
            )
        ),
      ),
    );
  }

}

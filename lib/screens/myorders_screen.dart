import 'dart:io';

import 'package:flutter/scheduler.dart';
import '../assets/ColorCodes.dart';
import '../generated/l10n.dart';
import '../models/myordersfields.dart';
import '../utils/prefUtils.dart';
import '../assets/images.dart';
import '../providers/myorderitems.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/myorder_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  static const routeName = '/myorders-screen';

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  var totalamount;
  var totlamount;
  var _isLoading = true;
  var _checkorders = false;
  var _isWeb= false;
  var name = "", email = "", photourl = "", phone = "";
  bool checkskip = false;
  List<List<MyordersFields>> myorders =[] ;

  SharedPreferences? prefs;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
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

    Future.delayed(Duration.zero, () {
     /* Provider.of<MyorderList>(context,listen: false).Getorders().then((_) async {
        prefs = await SharedPreferences.getInstance();

        setState(() {
          _isLoading = false;
        });

      });*/



      Provider.of<MyorderList>(context, listen: false).GetSplitorders("0","initialy").then((_) async {
        prefs = await SharedPreferences.getInstance();

        setState(() {
          _isLoading = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () { // this is the block you need
       // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
        Navigator.of(context).pop();
        return Future.value(false);

      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body:  Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
             Header(false),
            _body(),
          ],
        ),
        //),
      ),
    );
  }
  _body(){
    final myorderData = Provider.of<MyorderList>(context, listen: false);
    if (myorderData.items.length <= 0) {
      _checkorders = false;
    } else {
      _checkorders = true;
    }

    return Expanded(
      child: _isLoading ?
      Center(
        child: CircularProgressIndicator(),
      ) :
      _checkorders ?

      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if(myorderData.items.length>0)
              SizedBox(
                child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: myorders.length,
                  itemBuilder: (_, i) => Column(children: [
                    MyorderDisplay(myorders[i],
                      /*myorderData.items[i].reference_id,
                      myorderData.items[i].paymentType,
                      myorderData.items[i].id,
                      myorderData.items[i].oid,
                      myorderData.items[i].itemid,
                      myorderData.items[i].itemname,
                      myorderData.items[i].varname,
                      myorderData.items[i].price,
                      myorderData.items[i].qty,
                      myorderData.items[i].itemoactualamount,
                      myorderData.items[i].discount,
                      myorderData.items[i].subtotal,
                      myorderData.items[i].menuid,
                      myorderData.items[i].odeltime,
                      myorderData.items[i].itemImage,
                      myorderData.items[i].odate,
                      myorderData.items[i].itemPrice,
                      myorderData.items[i].itemQuantity,
                      myorderData.items[i].itemLeftCount,
                      myorderData.items[i].odelivery,
                      myorderData.items[i].isdeltime,
                      myorderData.items[i].ostatustext,
                      myorderData.items[i].ototal,
                      myorderData.items[i].orderType,
                      myorderData.items[i].ostatus,
                      myorderData.items[i].extraAmount,
                      myorderData.items[i].returnStatus,*/
                    ),
                  ],
                  ),
                ),
              ),
            SizedBox(
              height: 10.0,
            ),
            if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        ),
      ) :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(Images.bag),
          Text(S .of(context).you_have_no_order,
            //"You have no past orders",
            style: TextStyle(fontSize: 16.0),),
          SizedBox(height: 10.0,),
          Text(S .of(context).lets_get_you_started,
          //"Let's get you started",
          style: TextStyle(color: Colors.grey),),
          SizedBox(height: 20.0,),
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            },
            child: Container(
              width: 120.0,
              height: 40.0,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                  border: Border(
                    top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                    bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                    left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                    right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                  )),
              child: Center(
                  child: Text( S .of(context).start_shopping,
                   // 'Start Shopping',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
            ),
          ),
        ],
      ),
    );
  }

  //
  // void launchWhatsapp({required number,required message})async{
  //   String url ="whatsapp://send?phone=$number&text=$message";
  //   await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  // }
  //


  // bottomNavigationbar() {
  //   return SingleChildScrollView(
  //     child: Container(
  //       height: 60,
  //       color: Colors.white,
  //       child: Row(
  //         children: <Widget>[
  //           Spacer(),
  //           GestureDetector(
  //             onTap: () {
  //               /*Navigator.of(context).pushReplacementNamed(
  //                   HomeScreen.routeName,
  //                 );*/
  //               Navigator.of(context).popUntil(ModalRoute.withName(
  //                 HomeScreen.routeName,
  //               ));
  //             },
  //             child: Column(
  //               children: <Widget>[
  //                 SizedBox(
  //                   height: 7.0,
  //                 ),
  //                 CircleAvatar(
  //                   maxRadius: 11.0,
  //                   foregroundColor: Colors.white,
  //                   backgroundColor: Colors.transparent,
  //                   child: Image.asset(
  //                       Images.homeImg,
  //                       color: ColorCodes.lightgrey
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 5.0,
  //                 ),
  //                 Text(  S .of(context).home,
  //                     //  "Home",
  //                     style: TextStyle(
  //                         color: ColorCodes.lightgrey, fontSize: 10.0)),
  //               ],
  //             ),
  //           ),
  //           Spacer(),
  //           Column(
  //             children: <Widget>[
  //               SizedBox(
  //                 height: 7.0,
  //               ),
  //               CircleAvatar(
  //                 maxRadius: 11.0,
  //                 foregroundColor: Colors.white,
  //                 backgroundColor: Colors.transparent,
  //                 child: Image.asset(Images.categoriesImg,
  //                     color: ColorCodes.greenColor),
  //               ),
  //               SizedBox(
  //                 height: 5.0,
  //               ),
  //               Text( S .of(context).categories,
  //                   //"Categories",
  //                   style: TextStyle(
  //                       color: ColorCodes.greenColor,
  //                       fontSize: 10.0,
  //                       fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //           if(Features.isWallet)
  //             Spacer(),
  //           if(Features.isWallet)
  //             GestureDetector(
  //               onTap: () {
  //                 (PrefUtils.prefs!.containsKey("apikey"))
  //                     ? Navigator.of(context).pushNamed(
  //                   SignupSelectionScreen.routeName,
  //                 )
  //                     : Navigator.of(context).pushReplacementNamed(
  //                     WalletScreen.routeName,
  //                     arguments: {"type": "wallet"});
  //               },
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 7.0,
  //                   ),
  //                   CircleAvatar(
  //                     radius: 11.0,
  //                     backgroundColor: Colors.transparent,
  //                     child: Image.asset(Images.walletImg),
  //                   ),
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text( S .of(context).wallet,
  //                       //"Wallet",
  //                       style: TextStyle(
  //                           color: ColorCodes.lightgrey, fontSize: 10.0)),
  //                 ],
  //               ),
  //             ),
  //           if(Features.isMembership)
  //             Spacer(),
  //           if(Features.isMembership)
  //             GestureDetector(
  //               onTap: () {
  //                 (PrefUtils.prefs!.containsKey("apikey"))
  //                     ? Navigator.of(context).pushNamed(
  //                   SignupSelectionScreen.routeName,
  //                 )
  //                     : Navigator.of(context).pushReplacementNamed(
  //                   MembershipScreen.routeName,
  //                 );
  //               },
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 7.0,
  //                   ),
  //                   CircleAvatar(
  //                     radius: 11.0,
  //                     backgroundColor: Colors.transparent,
  //                     child: Image.asset(
  //                       Images.bottomnavMembershipImg,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text( S .of(context).membership,
  //                       // "Membership",
  //                       style: TextStyle(
  //                           color: ColorCodes.lightgrey, fontSize: 10.0)),
  //                 ],
  //               ),
  //             ),
  //           if(!Features.isMembership)
  //             Spacer(),
  //           if(!Features.isMembership)
  //             GestureDetector(
  //               onTap: () {
  //                 checkskip
  //                     ? Navigator.of(context).pushNamed(
  //                   SignupSelectionScreen.routeName,
  //                 )
  //                     : Navigator.of(context).pushReplacementNamed(
  //                   MyorderScreen.routeName,
  //                 );
  //               },
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 7.0,
  //                   ),
  //                   CircleAvatar(
  //                     radius: 11.0,
  //                     backgroundColor: Colors.transparent,
  //                     child: Image.asset(
  //                       Images.shoppinglistsImg,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text( S .of(context).my_orders,
  //                       // "My Orders",
  //                       style: TextStyle(
  //                           color:  ColorCodes.lightgrey, fontSize: 10.0)),
  //                 ],
  //               ),
  //             ),
  //           if(Features.isShoppingList)
  //             Spacer(flex: 1),
  //           if(Features.isShoppingList)
  //             GestureDetector(
  //               onTap: () {
  //                 checkskip
  //                     ? Navigator.of(context).pushNamed(
  //                   SignupSelectionScreen.routeName,
  //                 )
  //                     : Navigator.of(context).pushReplacementNamed(
  //                   ShoppinglistScreen.routeName,
  //                 );
  //               },
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 7.0,
  //                   ),
  //                   CircleAvatar(
  //                     radius: 11.0,
  //                     backgroundColor: Colors.transparent,
  //                     child: Image.asset(Images.shoppinglistsImg),
  //                   ),
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text( S .of(context).shopping_list,
  //                       //"Shopping list",
  //                       style: TextStyle(
  //                           color:  ColorCodes.lightgrey,fontSize: 10.0)),
  //                 ],
  //               ),
  //             ),
  //           if(!Features.isShoppingList)
  //             Spacer(),
  //           if(!Features.isShoppingList)
  //             GestureDetector(
  //               onTap: () {
  //                 checkskip && Features.isLiveChat
  //                     ? Navigator.of(context).pushNamed(
  //                   SignupSelectionScreen.routeName,
  //                 )
  //                     : (Features.isLiveChat && Features.isWhatsapp)?
  //                 Navigator.of(context)
  //                     .pushNamed(CustomerSupportScreen.routeName, arguments: {
  //                   'name': name,
  //                   'email': email,
  //                   'photourl': photourl,
  //                   'phone': phone,
  //                 }):
  //                 (!Features.isLiveChat && !Features.isWhatsapp)?
  //                 Navigator.of(context).pushNamed(SearchitemScreen.routeName)
  //
  //                     :
  //                 Features.isWhatsapp?launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery"):
  //                 Navigator.of(context)
  //                     .pushNamed(CustomerSupportScreen.routeName, arguments: {
  //                   'name': name,
  //                   'email': email,
  //                   'photourl': photourl,
  //                   'phone': phone,
  //                 });
  //               },
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 7.0,
  //                   ),
  //                   CircleAvatar(
  //                     radius: 11.0,
  //                     backgroundColor: Colors.transparent,
  //                     child: (!Features.isLiveChat && !Features.isWhatsapp)?
  //                     Icon(
  //                       Icons.search,
  //                       color: ColorCodes.lightgrey,
  //                     )
  //                         :
  //                     Image.asset(
  //                       Features.isLiveChat?Images.appCustomer: Images.whatsapp,
  //                       color: Features.isLiveChat?ColorCodes.lightgrey:null,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text((!Features.isLiveChat && !Features.isWhatsapp)? S .of(context).search: S .of(context).chat,
  //                       //   "Search":"Chat",
  //                       style: TextStyle(
  //                           color: ColorCodes.grey, fontSize: 10.0)),
  //                 ],
  //               ),
  //             ),
  //           Spacer(),
  //           if (_isWeb)
  //             Footer(
  //               address: PrefUtils.prefs!.getString("restaurant_address"),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  gradientappbarmobile() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: (){
          /*SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-screen', (Route<dynamic> route) => false);
          });*/
          Navigator.of(context).pop();
        /*  Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
              builder: (context) => HomeScreen()
          ),
          ModalRoute.withName("/home-screen")
          );*/
        },
      ),
      titleSpacing: 0,
      title: Text( S .of(context).my_orders,
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
        //"My Orders",
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme
                      .of(context)
                      .accentColor,
                  Theme
                      .of(context)
                      .primaryColor
                ]
            )
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../models/newmodle/shoppingModel.dart';
import '../repository/authenticate/AuthRepo.dart';
import '../rought_genrator.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';
import '../screens/searchitem_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/features.dart';
import 'package:provider/provider.dart';

import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../screens/shoppinglistitems_screen.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/membership_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/signup_selection_screen.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';
import '../utils/prefUtils.dart';
import 'customer_support_screen.dart';
import 'myorder_screen.dart';

enum FilterOptions {
  Remove,
}

class ShoppinglistScreen extends StatefulWidget with Navigations{
  static const routeName = '/shoppinglist-screen';
  @override
  _ShoppinglistScreenState createState() => _ShoppinglistScreenState();
}

class _ShoppinglistScreenState extends State<ShoppinglistScreen> with Navigations{
  bool _isshoplistdata = false;
  bool checkskip = false;
  bool _isWeb = false;
  bool _isLoading = true;
  //SharedPreferences prefs;
   var _address = "";
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  bool iphonex = false;
  var name = "", email = "", photourl = "", phone = "";
  GroceStore store = VxState.store;
  Auth _auth = Auth();
  List<ShoppingListData> shoplistData=[];

  @override
  void initState() {


    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
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
      shoplistData = (VxState.store as GroceStore).ShoppingList;
      //await Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist();
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      setState(() {

        _isLoading=false;
        /*  if (PrefUtils.prefs!.getString('FirstName') != null) {
            if (PrefUtils.prefs!.getString('LastName') != null) {
              name = PrefUtils.prefs!.getString('FirstName') +
                  " " +
                  PrefUtils.prefs!.getString('LastName');
            } else {
              name = PrefUtils.prefs!.getString('FirstName');
            }
          } else {
            name = "";
          }*/
        name = store.userData.username!;
          if (PrefUtils.prefs!.getString('Email') != null) {
            email = PrefUtils.prefs!.getString('Email')!;
          } else {
            email = "";
          }

          if (PrefUtils.prefs!.getString('mobile') != null) {
            phone = PrefUtils.prefs!.getString('mobile')!;
          } else {
            phone = "";
          }


        if (!PrefUtils.prefs!.containsKey("apikey")) {
          checkskip = true;
        } else {
          checkskip = false;
        }
      });
    });
    super.initState();
  }

  void removelist(String listid) {
    Provider.of<BrandItemsList>(context,listen: false).removeShoppinglist(listid).then((_) {
      Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglist().then((_) {
        setState(() {
          shoplistData = shoplistData;//Provider.of<BrandItemsList>(context, listen: false);
          if (shoplistData.length <= 0) {
            _isshoplistdata = false;
          } else {
            _isshoplistdata = true;
          }
        });
        _auth.getuserProfile(onsucsess: (value){
          shoplistData = (VxState.store as GroceStore).ShoppingList;
        },onerror: (){

        });
        Navigator.of(context).pop();
      });
    });
  }

  _dialogforRemoving(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                  height: 100.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 40.0,
                      ),
                      Text(  S .of(context).removing_list,
                        //  "Removing List..."
                      ),
                    ],
                  )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
        Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav)
        //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false)
            :Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
        body:  Column(
            children: <Widget>[
              if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _body(),
            ]
        ),
        bottomNavigationBar: _isWeb ? SizedBox.shrink() : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: bottomNavigationbar(),
        ),
      ),
    );
  }


 /* void launchWhatsapp({required number,required message})async{
    String url ="whatsapp://send?phone=$number&text=$message";
    await canLaunch(url)?launch(url):print('can\'t open whatsapp');
  }*/
  void launchWhatsApp() async {
    String phone = /*"+918618320591"*/IConstants.secondaryMobile;
    debugPrint("Whatsapp . .. . . .. . .");
    String url() {
      if (Platform.isIOS) {
        debugPrint("Whatsapp1 . .. . . .. . .");
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";
        const url = "https://wa.me/?text=YourTextHere";

      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  bottomNavigationbar() {
    return SingleChildScrollView(
      child: Container(
        height: 65,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: ColorCodes.primaryColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          // shape: BoxShape.circle,
        ),
        child: Row(
          children: <Widget>[
            Spacer(),
            GestureDetector(
              onTap: () {
               /* Navigator.of(context).popUntil(ModalRoute.withName(
                  HomeScreen.routeName,
                ));*/
                Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
              },
              child: Container(
                width: 60,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        Images.homeImg,
                          color: ColorCodes.whiteColor ,
                          width: 30,
                          height: 25

                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        //"Home",
                        S .of(context).home,
                        style: TextStyle(
                            color: ColorCodes.whiteColor , fontSize: 10.0)),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            if(Features.isCategory)
            Spacer(),
            if(Features.isCategory)
            GestureDetector(
              onTap: () {
                /*Navigator.of(context).pushReplacementNamed(
                  CategoryScreen.routeName,
                );*/
                Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
              },
              child: Container(
                width: 60,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(Images.categoriesImg,
                        color: ColorCodes.whiteColor ,
                          width: 20,
                          height: 25),

                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        S .of(context).categories,
                        //"Categories",
                        style: TextStyle(
                            color: ColorCodes.whiteColor , fontSize: 10.0)),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            if(Features.isWallet)
            Spacer(),
            if(Features.isWallet)
            GestureDetector(
              onTap: () {
                checkskip
                    ?
                /*Navigator.of(context).pushNamed(
                  SignupSelectionScreen.routeName,
                )*/
                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
                /*Navigator.of(context).pushReplacementNamed(
                    WalletScreen.routeName,
                    arguments: {"type": "wallet"});*/
                Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,qparms: {
                  "type":"wallet",
                });
              },
              child: Container(
                width: 60,
                child: Column(
                  children: <Widget>[
                    /*SizedBox(
                      height: 3.0,
                    ),
                    (PrefUtils.prefs!.containsKey("apikey")) ?((VxState.store as GroceStore).prepaid.prepaid.toString() != null || (VxState.store as GroceStore).prepaid.prepaid.toString() != "null" || (VxState.store as GroceStore).prepaid.prepaid.toString() != "")?Text(
                      Features.iscurrencyformatalign?
                      (VxState.store as GroceStore).prepaid.prepaid!.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                      IConstants.currencyFormat + " " + (VxState.store as GroceStore).prepaid.prepaid!.toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                      style: TextStyle(
                          color: ColorCodes.greenColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold
                      ),
                    ):
                    SizedBox(
                      height: 10.0,
                    ):*/
                    SizedBox(
                      height: 8.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(Images.walletImg,  color: ColorCodes.whiteColor ,
                          width: 20,
                          height: 25),

                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(  S .of(context).wallet,
                        //"Wallet",
                        style: TextStyle(
                            color: ColorCodes.whiteColor, fontSize: 10.0)),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            if(Features.isMembership)
            Spacer(),
            if(Features.isMembership)
            GestureDetector(
              onTap: () {
                checkskip
                    ? /*Navigator.of(context).pushNamed(
                  SignupSelectionScreen.routeName,
                )*/
                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                    : /*Navigator.of(context).pushReplacementNamed(
                  MembershipScreen.routeName,
                );*/
                   (Vx.isWeb &&
                  !ResponsiveLayout.isSmallScreen(context))?
                  MembershipInfo(context):
                Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
              },
              child: Container(
                width: 60,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        Images.bottomnavMembershipImg,
                        color: ColorCodes.whiteColor ,
                          width: 20,
                          height: 25
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(  S .of(context).membership,
                        //"Membership",
                        style: TextStyle(
                            color: ColorCodes.whiteColor , fontSize: 10.0)),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            if(!Features.isMembership)
              Spacer(),
            if(!Features.isMembership)
              GestureDetector(
                onTap: () {
                  checkskip
                      ? /*Navigator.of(context).pushNamed(
                    SignupSelectionScreen.routeName,
                  )*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                      : /*Navigator.of(context).pushReplacementNamed(
                    MyorderScreen.routeName,arguments: {
                    "orderhistory": ""
                  }
                  );*/
                  Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                     /* parms: {
                    "orderhistory": ""
                  }*/);
                },
                child: Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          Images.bag,
                         // color: ColorCodes.greenColor,
                          color:ColorCodes.whiteColor,
                            width: 20,
                            height: 25),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(   S .of(context).my_orders,
                          //"My Orders",
                          style: TextStyle( color:ColorCodes.whiteColor,
                             // color: ColorCodes.greenColor,
                              fontSize: 10.0)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            if(Features.isShoppingList)
              Spacer(),
            if(Features.isShoppingList)
              GestureDetector(
                onTap: () {
                  checkskip
                      ? /*Navigator.of(context).pushNamed(
                    SignupSelectionScreen.routeName,
                  )*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                      :
                  /*Navigator.of(context).pushReplacementNamed(
                    ShoppinglistScreen.routeName,
                  );*/
                  Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                },
                child: Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.shoppinglistsImg,
                          //color: ColorCodes.greenColor,
                          color:IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome,
                            width: 18,
                            height: 25),

                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(  S .of(context).shopping_list,
                          //"Shopping list",
                          style: TextStyle(
                              color:IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome,
                            //  color: ColorCodes.greenColor,
                              fontSize: 10.0)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            if(!Features.isShoppingList)
              Spacer(),
            if(!Features.isShoppingList)
              GestureDetector(
                onTap: () {
                  checkskip && Features.isLiveChat
                      ? /*Navigator.of(context).pushNamed(
                    SignupSelectionScreen.routeName,
                  )*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                      : (Features.isLiveChat && Features.isWhatsapp)?
                  Navigator.of(context)
                      .pushNamed(CustomerSupportScreen.routeName, arguments: {
                    'name': name,
                    'email': email,
                    'photourl': photourl,
                    'phone': phone,
                  }):
                  (!Features.isLiveChat && !Features.isWhatsapp)?
                  Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search)
                      :
                  Features.isWhatsapp?launchWhatsApp()/*launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery")*/:
                  Navigator.of(context)
                      .pushNamed(CustomerSupportScreen.routeName, arguments: {
                    'name': name,
                    'email': email,
                    'photourl': photourl,
                    'phone': phone,
                  });
                },
                child: Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: (!Features.isLiveChat && !Features.isWhatsapp)?
                        Icon(
                          Icons.search,
                          color: ColorCodes.whiteColor,
                        )
                            :
                        Image.asset(
                          Features.isLiveChat?Images.appCustomer: Images.whatsapp,
                          width: 50,
                          height: 30,
                          color: Features.isLiveChat?ColorCodes.whiteColor:null,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text((!Features.isLiveChat && !Features.isWhatsapp)?
                      S .of(context).search:S .of(context).chat,
                      //"Search":"Chat",
                          style: TextStyle(
                              color: ColorCodes.whiteColor, fontSize: 10.0)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  _body(){
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    shoplistData = (VxState.store as GroceStore).ShoppingList;//Provider.of<BrandItemsList>(context, listen: false);
    if (shoplistData.length <= 0) {
      _isshoplistdata = false;
    } else {
      _isshoplistdata = true;
    }
    return  Expanded(
      child: _isLoading
          ? Center(
        child:LoyalityorWalletShimmer(),
      ) :
       SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  _isshoplistdata ?
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            /// screen shows error if we add padding add constraints instead
                           constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                          //   padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:null,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:null ),

                            child: new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: shoplistData.length,
                              itemBuilder: (_, i) =>
                                  MouseRegion(
                                   cursor: SystemMouseCursors.click,
                                     child: GestureDetector(
                                      onTap: () {
                                        if (shoplistData[i].count! <= 0) {
                                          Fluttertoast.showToast(
                                              msg: S .of(context).no_item_found,//"No items found!",
                                              fontSize: MediaQuery.of(context).textScaleFactor *13,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white);
                                        } else {
                                          /*Navigator.of(context).pushNamed(
                                              ShoppinglistitemsScreen.routeName,
                                              arguments: {
                                                'shoppinglistid':
                                                shoplistData.itemsshoplist[i].listid,
                                                'shoppinglistname':
                                                shoplistData.itemsshoplist[i].listname,
                                              });*/
                                          Navigation(context, name: Routename.ShoppinglistItem,navigatore: NavigatoreTyp.Push,
                                          parms: {
                                            'id':
                                            shoplistData[i].id!,
                                            'name':
                                            shoplistData[i].name!,
                                          });

                                        }
                            },
                                      child: Container(

                                        margin: EdgeInsets.only(
                                            left: 10.0, bottom: 10.0, right: 10.0,top: 5),
                                        padding: EdgeInsets.all(12.0),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(3.0),
                                            //border: Border.all(width: 0.0, color: ColorCodes.whiteColor),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(shoplistData[i].name!,
                                                    style: TextStyle(fontSize: 16.0,color:ColorCodes.menuColor,fontWeight: FontWeight.bold)),
                                                /*Text(
                                                    shoplistData
                                                        .itemsshoplist[i].totalitemcount +
                                                        " Items",
                                                    style: TextStyle(fontSize: 12.0)),*/
                                              ],
                                            ),
                                            Spacer(),
                                            Text(
                                                    shoplistData
                                                    [i].count!.toString() +
                                                        S.of(context).items_shopping,//" Items",
                                                    style: TextStyle(fontSize: 14.0,color: ColorCodes.emailColor)),
                                            SizedBox(width:40),
                                            IconButton(
                                                icon: Icon(Icons.delete_outline, color: ColorCodes.emailColor),
                                                onPressed: ()async {
                                                  _dialogforRemoving(context);
                                                  removelist(
                                                      shoplistData[i].id!);
                                                }
                                            )

                                            /*PopupMenuButton(
                                              onSelected: (FilterOptions selectedValue) {
                                                _dialogforRemoving(context);
                                                removelist(
                                                    shoplistData.itemsshoplist[i].listid);
                                              },
                                              icon: Icon(
                                                Icons.more_vert,
                                              ),
                                              itemBuilder: (_) =>
                                              [
                                                PopupMenuItem(
                                                  child: Text(  S .of(context).remove,
                                                     // 'Remove'
                                                  ),
                                                  value: FilterOptions.Remove,
                                                ),
                                              ],
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      :
                  (MediaQuery.of(context).size.width <= 600) ?
                  Container(
                  //  constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                    padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0 ),

                    child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Images.emptyShoppingImg,
                            width: 159,
                            height: 157,
                          ),
                          Text(  S .of(context).shopping_list_empty,
                            //'Your shopping list is empty',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: ColorCodes.greyColor,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(  S .of(context).add_item_shopping,
                           // 'Add items to continue shopping',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: ColorCodes.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      //width: 200,
                      margin: EdgeInsets.only(left: 80, right: 80),
                      child: RaisedButton(
                        color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                        /*  Navigator.of(context).popUntil(ModalRoute.withName(
                            HomeScreen.routeName,
                          ));*/
                          Navigation(context,navigatore: NavigatoreTyp.homenav);
                          //Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(  S .of(context).start_shopping,
                              //'START SHOPPING',
                              style: TextStyle(
                                color: ColorCodes.whiteColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                    ),
                  )
                  : Container(
                   // constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                    padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0 ),

                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                Images.emptyShoppingImg,
                                width: 159,
                                height: 157,
                              ),
                              Text(  S .of(context).shopping_list_empty,
                              //  'Your shopping list is empty',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text(S .of(context).add_item_shopping,
                               // 'Add items to continue shopping',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: ColorCodes.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 35,
                          margin: EdgeInsets.only(left: 80, right: 80),
                          child: RaisedButton(
                            color: ColorCodes.mediumBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                HomeScreen.routeName,);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S .of(context).start_shopping,
                                  //'START SHOPPING',
                                  style: TextStyle(
                                    color: ColorCodes.whiteColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  if(_isWeb) Footer(address:  PrefUtils.prefs!.getString("restaurant_address")!),
                ]
            )
        )
    );
  }
  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: ()=>Navigator.of(context).pop()),
      title: Text(S .of(context).shopping_lists,
        //'Shopping Lists',
        style: TextStyle(color: ColorCodes.iconColor,fontWeight: FontWeight.bold, fontSize: 18),
      ),
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.whiteColor,
                  ColorCodes.whiteColor
                ]
            )
        ),
      ),
    );
  }


  gradientWebbar() {
    if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
      return  AppBar(
        toolbarHeight: 80.0,
        elevation: 0,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),onPressed: ()=>Navigator.of(context).pop()),
        title: Text(   S .of(context).shopping_lists,
        //  'Shopping Lists',
                ),
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


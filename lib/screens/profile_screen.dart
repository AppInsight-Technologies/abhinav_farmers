import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../data/calculations.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../screens/addressbook_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/category_screen.dart';
import '../../screens/edit_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/membership_screen.dart';
import '../../screens/myorder_screen.dart';
import '../../screens/policy_screen.dart';
import '../../screens/refer_screen.dart';
import '../../screens/searchitem_screen.dart';
import '../../screens/shoppinglist_screen.dart';
import '../../screens/signup_selection_screen.dart';
import '../../screens/wallet_screen.dart';
import '../../utils/ResponsiveLayout.dart';

import '../../utils/prefUtils.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/badge.dart';
import '../../widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import "package:http/http.dart" as http;
import '../models/VxModels/VxStore.dart';
import '../rought_genrator.dart';
class ProfileScreen extends StatefulWidget{
  static const routeName = '/profile-screen';
  @override
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Navigations{
  bool _isRestaurant = false;
  bool _isDelivering = true;
  bool iphonex = false;
  GroceStore store = VxState.store;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {

    bottomNavigationbar() {
      return _isDelivering
          ? SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          height: 53,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context,value,widget){
                    return GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).pushReplacementNamed(
                          HomeScreen.routeName,
                        );*/
                        Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(Images.homeImg,
                              color: ColorCodes.blackColor ,
                              width: 32,
                              height: 23,),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                              S.of(context).home,//"Home",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: ColorCodes.blackColor, fontSize: 11.0)),
                        ],
                      ),
                    );
                  }),
              Spacer(),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context,value,widget){
                    return GestureDetector(
                      onTap: () {
                        if (value != S.of(context).not_available_location)
                         /* Navigator.of(context).pushNamed(
                            CategoryScreen.routeName,
                          );*/
                          Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(Images.categoriesImg,
                              color: ColorCodes.blackColor ,
                              width: 32,
                              height: 23,),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                              S.of(context).categories,//"Categories",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: ColorCodes.blackColor, fontSize: 11.0)),
                        ],
                      ),
                    );
                  }),
              if(Features.isWallet)
                Spacer(),
              // if(Features.isWallet)
              //   ValueListenableBuilder(
              //       valueListenable: IConstants.currentdeliverylocation,
              //       builder: (context,value,widget){
              //         return GestureDetector(
              //           onTap: () {
              //             if (value != S.of(context).not_available_location)
              //               !PrefUtils.prefs.containsKey("apikey")
              //                 ? Navigator.of(context).pushNamed(
              //               SignupSelectionScreen.routeName,
              //             )
              //                 : Navigator.of(context).pushNamed(
              //                 WalletScreen.routeName,
              //                 arguments: {"type": "wallet"});
              //           },
              //           child: Column(
              //             children: <Widget>[
              //               SizedBox(
              //                 height: 7.0,
              //               ),
              //               CircleAvatar(
              //                 radius: 13.0,
              //                 backgroundColor: Colors.transparent,
              //                 child: Image.asset(Images.walletImg,
              //                   color: ColorCodes.blackColor,
              //                   width: 50,
              //                   height: 30,),
              //               ),
              //               SizedBox(
              //                 height: 5.0,
              //               ),
              //               Text(
              //                   S.of(context).wallet,//"Wallet",
              //                   style: TextStyle(
              //                       color: ColorCodes.blackColor, fontSize: 10.0)),
              //             ],
              //           ),
              //         );
              //       }),
              ValueListenableBuilder(
                  valueListenable: IConstants.currentdeliverylocation,
                  builder: (context, value, widget){
                    return GestureDetector(
                      onTap: () {
                        if (value != S.of(context).not_available_location)
                          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                      },
                      child: VxBuilder(
                        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
                        builder: (context, box, index) {

                          return Consumer<CartCalculations>(
                            builder: (_, cart, ch) => Badge(
                              child: ch!,
                              color: ColorCodes.darkgreen,
                              value: CartCalculations.itemCount.toString(),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (value != S .of(context).not_available_location)
                                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                /* Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                              "afterlogin": ""
                            });*/
                              },
                              child:
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  CircleAvatar(
                                    radius: 13.0,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      Images.header_cart,
                                      color: ColorCodes.blackColor,
                                      width: 32,
                                      height: 22,),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                      S.of(context).my_bag,//"Membership",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: ColorCodes.blackColor, fontSize: 11.0)),
                                ],
                              ),
                            ),);
                        },mutations: {SetCartItem},
                      ),
                    );}),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value, widget){
                      return GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ?
                            /* Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                                arguments: {
                                  "prev": "signupSelectionScreen",
                                }
                            )
                                : Navigator.of(context).pushNamed(
                              MembershipScreen.routeName,
                            );*/
                                Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                    : /*Navigator.of(context).pushNamed(
                              MembershipScreen.routeName,
                            );*/


                                  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                                  MembershipInfo(context):
                                Navigation(context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                Images.bottomnavMembershipImg,
                                color: ColorCodes.blackColor,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S.of(context).membership,//"Membership",
                                style: TextStyle(
                                    color: ColorCodes.blackColor, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),


              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value ,widget){
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          CircleAvatar(
                            radius: 13.0,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              Images.Person,
                              color:ColorCodes.redColor,
                              width: 17,
                              height: 17,),
                          ),

                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                              S.of(context).profile,//"My Orders",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color:ColorCodes.redColor, fontSize: 11.0)),
                        ],
                      );
                    }),
              if(Features.isShoppingList)
                Spacer(),
              if(Features.isShoppingList)
                ValueListenableBuilder(
                    valueListenable: IConstants.currentdeliverylocation,
                    builder: (context, value ,widget){
                      return GestureDetector(
                        onTap: () {
                          if (value != S.of(context).not_available_location)
                            !PrefUtils.prefs!.containsKey("apikey")
                                ? /*Navigator.of(context).pushNamed(
                              SignupSelectionScreen.routeName,
                                arguments: {
                                  "prev": "signupSelectionScreen",
                                }
                            )
                                : Navigator.of(context).pushNamed(
                              ShoppinglistScreen.routeName,
                            );*/
                            Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                                :
                            /*Navigator.of(context).pushNamed(
                              ShoppinglistScreen.routeName,
                            );*/
                            Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(Images.shoppinglistsImg ,
                                color: ColorCodes.blackColor,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S.of(context).shopping_list,//"Shopping list",
                                style: TextStyle(
                                    color: ColorCodes.blackColor, fontSize: 10.0)),
                          ],
                        ),
                      );
                    }),
              SizedBox(width: 20),
            ],
          ),
        ),
      )
          : SingleChildScrollView(child: Container());
    }
    // TODO: implement build
    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ? _appBar() : PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox.shrink()),
      key: ProfileScreen.scaffoldKey,
      // drawer: ResponsiveLayout.isSmallScreen(context)
      //     ?
      // AppDrawer()
      //     : SizedBox.shrink(),
      backgroundColor: ColorCodes.backgroundcolor/*Theme.of(context).primaryColor*/,
      body: SafeArea(bottom: true,
        child: Container(
            color: ColorCodes.backgroundcolor,
            child: Column(
              children: <Widget>[
                // if(_isRestaurant || !Vx.isWeb)
                //   Header(true, true),
                Expanded(
                  child: _body(),
                )

              ],
            )
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //
      //     width: MediaQuery.of(context).size.width,
      //
      //     child: bottomNavigationbar()),
    );
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      title: Image.asset(
        Images.logoAppbarImglite,
        height: IConstants.isEnterprise ? 50 : 25,
        width: IConstants.isEnterprise ? 138 : 100,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ColorCodes.blackColor),
        onPressed: () {
          print("back.....");
          Navigator.of(context).pop();
          // Navigator.pushNamed(context, HomeScreen.routeName);

        },
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ])),
      ),
      /*actions: [
        GestureDetector(
          onTap:(){
            Navigator.of(context).pushNamed(SearchitemScreen.routeName);
          },
          child: Image.asset(
            Images.icon_search,
            height: 20,
            width: 20,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 5),
        SizedBox(width: 5),
      ],*/
    );
  }
  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    debugPrint("not loged in...");
                    Navigator.of(context).pop();
                   /* Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    );*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      "prev": "signupSelectionScreen",
                    });
                  }else {
                    Navigator.of(context).pop();
                 /*   Navigator.of(context)
                        .pushNamed(EditScreen.routeName);*/
                    Navigation(context, name: Routename.EditScreen, navigatore: NavigatoreTyp.Push);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorCodes.grey.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    children: [
                      Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).my_profile,//"My Profile",
                            style: TextStyle(
                                fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                fontWeight: FontWeight.w600,
                                color: ColorCodes.blackColor),
                          ),
                          SizedBox(height: 5),
                          Text(S.of(context).edit_info_prof,//"Edit personal info, Change password",
                            style: TextStyle(
                                fontSize:15,
                                fontWeight: FontWeight.w500,
                                color: ColorCodes.greyColor),
                          )
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                      size: 20,),


                    ],
                  )

                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    debugPrint("not loged in...");
                    Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    );*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                  }else {
                    Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                        MyorderScreen.routeName,
                        arguments: {
                          "orderhistory": ""
                        }
                    );*/
                    Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.MyOrders,
                    qparms: {
                      "orderhistory": ""
                    });
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).my_orders,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).view_ord_prof,//"View, Modify & Track orders",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    debugPrint("not loged in...");
                    Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    );*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                  }else {
                    Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                      AddressbookScreen.routeName,
                    );*/
                    Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.Push,
                    );
                  }

                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).address_book,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).edit_add_prof,//"Edit, Add or remove addresses",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              SizedBox(height: 15,),
              if(Features.isWalletroot)
              GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    Navigator.of(context).pop();
                    debugPrint("not loged in...");
                   /* Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    );*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                  }else {
                    Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                        WalletScreen.routeName,
                        arguments: {"type": "wallet"});*/
                    Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "type": "wallet",
                        });
                  }

                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).wallet,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(/*IConstants.APP_NAME+" "+*/S.of(context).wallet_history_prof,//"Idle Man wallet history",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              if(Features.isMembershiproot)SizedBox(height: 15,),
              if(Features.isMembershiproot)GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    debugPrint("not loged in...");
                    Navigator.of(context).pop();
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                  }else {
                    Navigator.of(context).pop();
                      if (Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context)) {
                      MembershipInfo(context);
                      }
                      else {
                        Navigation(
                            context, name: Routename.Membership, navigatore: NavigatoreTyp.Push);
                      }
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).membership,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).view_ord_prof,//"View, Modify & Track orders",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              if(Features.isLoyaltyroot)SizedBox(height: 15,),
              if(Features.isLoyaltyroot)
              GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    debugPrint("not loged in...");
                    Navigator.of(context).pop();
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                  }else {
                    Navigator.of(context).pop();
                    Navigation(context, name: Routename.Loyalty, navigatore: NavigatoreTyp.Push);
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).loyalty,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).view_ord_prof,//"View, Modify & Track orders",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              if(Features.isReferEarnroot)
              SizedBox(height: 15,),
              if(Features.isReferEarnroot)
              GestureDetector(
                onTap: () {
                  if(!PrefUtils.prefs!.containsKey("apikey")) {
                    debugPrint("not loged in...");
                    Navigator.of(context).pop();
                   /* Navigator.of(context).pushNamed(
                        SignupSelectionScreen.routeName,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        }
                    );*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                  }else {
                    Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                      ReferEarn.routeName,
                    );*/
                    Navigation(context, name:Routename.Refer,navigatore: NavigatoreTyp.Push);
                  }

                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).refer_earn,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).invite_prof,//"Invite your friends and earn rewards",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              SizedBox(height: 15,),
              if(Features.isLiveChatroot)
                GestureDetector(
                  onTap: () async {
                    //var response = await FlutterFreshchat.showConversations();
                    /*  Navigator.of(context).pushNamed(
                    CustomerSupportScreen.routeName,
                    arguments: {
                      'name' : name,
                      'email' : email,
                      'photourl': photourl,
                      'phone' : phone,
                    }
                );*/
                    Navigation(context, name:Routename.CustomerSupport,navigatore: NavigatoreTyp.Push,
                      /* parms:{'photourl': photourl}*/);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).chat,
                              // "Chat",
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).online_order_help,//"Get in touch with us",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),
                      ],
                    ),
                  ),
                ),
              if(Features.isLiveChatroot)
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.of(context).pop();
                    /*Navigator.of(context).pushNamed(
                        PolicyScreen.routeName,
                        arguments: {
                          'title' : "Profile",
                          'body' : "",
                          'businessname': IConstants.restaurantName,
                          'address': PrefUtils.prefs!.getString("restaurant_address"),
                          'contactnum': IConstants.primaryMobile,
                          'pemail': IConstants.primaryEmail,
                          'semail': IConstants.secondaryEmail,
                        }
                    );*/
                  Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.Policy,
                  parms: {
                    'title' : Features.ismultivendor ? "Contact Us" : "Profile",
                    /*'body' : "",
                    'businessname': IConstants.restaurantName,
                    'address': PrefUtils.prefs!.getString("restaurant_address")!,
                    'contactnum': IConstants.primaryMobile,
                    'pemail': IConstants.primaryEmail,
                    'semail': IConstants.secondaryEmail,*/
                  });


                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).contact_us,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).get_in_touch_prof,//"Get in touch with us",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              SizedBox(height: 15,),
              !PrefUtils.prefs!.containsKey("apikey") ?
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                 /* Navigator.of(context).pushNamed(
                      SignupSelectionScreen.routeName,
                      arguments: {
                        "prev": "signupSelectionScreen",
                      } );*/
                  Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        "prev": "signupSelectionScreen",
                      });
                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).login_register,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            Text(S.of(context).login_prof,//"Login or Signup",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.greyColor),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ):
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  //SharedPreferences prefs = await SharedPreferences.getInstance();
                  PrefUtils.prefs!.remove('LoginStatus');
                  PrefUtils.prefs!.remove("apikey");
                  store.CartItemList.clear();
                  store.homescreen.data = null;
                  if(Features.ismultivendor && IConstants.isEnterprise)  store.homestore.data = null;
                  if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle') {
                    PrefUtils.prefs!.setString("photoUrl", "");
                    await _googleSignIn.signOut();
                    bool? deliverystatus = PrefUtils.prefs!.getBool("deliverystatus");
                    String countryCode = PrefUtils.prefs!.getString("country_code")!;
                    String branch = PrefUtils.prefs!.getString("branch")!;
                    String tokenId = PrefUtils.prefs!.getString('tokenid')!;
                    String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
                    String _mapFetch = "null";
                    String _isDelivering = "false";
                    String defaultLocation = "null";
                    String deliverylocation = "null";
                    String _latitude = "null";
                    String _longitude = "null";
                    String currentdeliverylocation = IConstants
                        .currentdeliverylocation.value;
                    if (PrefUtils.prefs!.containsKey("ismapfetch")) {
                      _mapFetch = PrefUtils.prefs!.getString("ismapfetch")!;
                    }
                    if (PrefUtils.prefs!.containsKey("isdelivering")) {
                      _isDelivering =
                          PrefUtils.prefs!.getString("isdelivering")!;
                    }
                    if (PrefUtils.prefs!.containsKey("defaultlocation")) {
                      defaultLocation =
                          PrefUtils.prefs!.getString("defaultlocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("deliverylocation")) {
                      deliverylocation =
                          PrefUtils.prefs!.getString("deliverylocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("latitude")) {
                      _latitude = PrefUtils.prefs!.getString("latitude")!;
                    }

                    if (PrefUtils.prefs!.containsKey("longitude")) {
                      _longitude = PrefUtils.prefs!.getString("longitude")!;
                    }
                    PrefUtils.prefs!.clear();
                    PrefUtils.prefs!.setBool('deliverystatus', deliverystatus!);
                    PrefUtils.prefs!.setBool('introduction', true);
                    PrefUtils.prefs!.setString('country_code', countryCode);
                    PrefUtils.prefs!.setString("branch", branch);
                    PrefUtils.prefs!.setString("tokenid", tokenId);
                    PrefUtils.prefs!.setString("ftokenid", _ftokenId);
                    PrefUtils.prefs!.setString("ismapfetch", _mapFetch);
                    PrefUtils.prefs!.setString(
                        "isdelivering", _isDelivering);
                    PrefUtils.prefs!.setString(
                        "defaultlocation", defaultLocation);
                    PrefUtils.prefs!.setString(
                        "deliverylocation", deliverylocation);
                    PrefUtils.prefs!.setString("longitude", _longitude);
                    PrefUtils.prefs!.setString("latitude", _latitude);
                    IConstants.currentdeliverylocation.value =
                        currentdeliverylocation;

                    /*Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName,
                            (route) => false,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        });*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.homenav,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                    //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
                  } else if (PrefUtils.prefs!.getString('prevscreen') ==
                      'signinfacebook') {
                    PrefUtils.prefs!.getString("FBAccessToken");
                    var facebookSignIn = FacebookLogin();

                    final graphResponse = await http.delete(
                        'https://graph.facebook.com/v2.12/me/permissions/?access_token=${PrefUtils.prefs!.getString("FBAccessToken")}&httpMethod=DELETE&ref=logout&destroy=true');

                    PrefUtils.prefs!.setString("photoUrl", "");
                    await facebookSignIn.logOut().then((value) {
                      bool? deliverystatus = PrefUtils.prefs!.getBool("deliverystatus");
                      String countryCode = PrefUtils.prefs!.getString("country_code")!;
                      String branch = PrefUtils.prefs!.getString("branch")!;
                      String tokenId = PrefUtils.prefs!.getString('tokenid')!;
                      String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
                      String code = PrefUtils.prefs!.getString('referCodeDynamic')!;

                      String _mapFetch = "null";
                      String _isDelivering = "false";
                      String defaultLocation = "null";
                      String deliverylocation = "null";
                      String _latitude = "null";
                      String _longitude = "null";
                      String currentdeliverylocation = IConstants
                          .currentdeliverylocation.value;
                      if (PrefUtils.prefs!.containsKey("ismapfetch")) {
                        _mapFetch = PrefUtils.prefs!.getString("ismapfetch")!;
                      }
                      if (PrefUtils.prefs!.containsKey("isdelivering")) {
                        _isDelivering = PrefUtils.prefs!.getString(
                            "isdelivering")!;
                      }
                      if (PrefUtils.prefs!.containsKey("defaultlocation")) {
                        defaultLocation = PrefUtils.prefs!.getString(
                            "defaultlocation")!;
                      }
                      if (PrefUtils.prefs!.containsKey("deliverylocation")) {
                        deliverylocation = PrefUtils.prefs!.getString(
                            "deliverylocation")!;
                      }
                      if (PrefUtils.prefs!.containsKey("latitude")) {
                        _latitude = PrefUtils.prefs!.getString("latitude")!;
                      }

                      if (PrefUtils.prefs!.containsKey("longitude")) {
                        _longitude = PrefUtils.prefs!.getString("longitude")!;
                      }

                      PrefUtils.prefs!.clear();
                      PrefUtils.prefs!.setBool('deliverystatus', deliverystatus!);
                      PrefUtils.prefs!.setBool('introduction', true);
                      print("efrgddf" + countryCode.toString());
                      PrefUtils.prefs!.setString('country_code', countryCode);
                      PrefUtils.prefs!.setString("branch", branch);
                      PrefUtils.prefs!.setString("tokenid", tokenId);
                      PrefUtils.prefs!.setString("ftokenid", _ftokenId);
                      PrefUtils.prefs!.setString("referCodeDynamic", code);
                      PrefUtils.prefs!.setString("ismapfetch", _mapFetch);
                      PrefUtils.prefs!.setString(
                          "isdelivering", _isDelivering);
                      PrefUtils.prefs!.setString(
                          "defaultlocation", defaultLocation);
                      PrefUtils.prefs!.setString(
                          "deliverylocation", deliverylocation);
                      PrefUtils.prefs!.setString("longitude", _longitude);
                      PrefUtils.prefs!.setString("latitude", _latitude);
                      IConstants.currentdeliverylocation.value =
                          currentdeliverylocation;

                      /*Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false,
                          arguments: {
                            "prev": "signupSelectionScreen",
                          });*/
                      Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.homenav,
                          qparms: {
                            "prev": "signupSelectionScreen",
                          });
                      //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
                    });
                  } else {
                    // String countryCode = PrefUtils.prefs!.getString("country_code")!;
                    String branch = PrefUtils.prefs!.getString("branch")!;
                    String tokenId = PrefUtils.prefs!.getString('tokenid')!;
                    String _ftokenId = PrefUtils.prefs!.getString("ftokenid")!;
                    String _mapFetch = "null";
                    String _isDelivering = "false";
                    String defaultLocation = "null";
                    String deliverylocation = "null";
                    String _latitude = "null";
                    String _longitude = "null";
                    bool? deliverystatus = PrefUtils.prefs!.getBool("deliverystatus");
                    String currentdeliverylocation = IConstants
                        .currentdeliverylocation.value;
                    if (PrefUtils.prefs!.containsKey("ismapfetch")) {
                      _mapFetch = PrefUtils.prefs!.getString("ismapfetch")!;
                    }
                    if (PrefUtils.prefs!.containsKey("isdelivering")) {
                      _isDelivering =
                          PrefUtils.prefs!.getString("isdelivering")!;
                    }
                    if (PrefUtils.prefs!.containsKey("defaultlocation")) {
                      defaultLocation =
                          PrefUtils.prefs!.getString("defaultlocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("deliverylocation")) {
                      deliverylocation =
                          PrefUtils.prefs!.getString("deliverylocation")!;
                    }
                    if (PrefUtils.prefs!.containsKey("latitude")) {
                      _latitude = PrefUtils.prefs!.getString("latitude")!;
                    }

                    if (PrefUtils.prefs!.containsKey("longitude")) {
                      _longitude = PrefUtils.prefs!.getString("longitude")!;
                    }
                    PrefUtils.prefs!.clear();
                    PrefUtils.prefs!.setBool('introduction', true);
                    // PrefUtils.prefs!.setString('country_code', countryCode);
                    PrefUtils.prefs!.setBool('deliverystatus', deliverystatus!);
                    PrefUtils.prefs!.setString("branch", branch);
                    PrefUtils.prefs!.setString("tokenid", tokenId);
                    PrefUtils.prefs!.setString("ftokenid", _ftokenId);
                    PrefUtils.prefs!.setString("ismapfetch", _mapFetch);
                    PrefUtils.prefs!.setString(
                        "isdelivering", _isDelivering);
                    PrefUtils.prefs!.setString(
                        "defaultlocation", defaultLocation);
                    PrefUtils.prefs!.setString(
                        "deliverylocation", deliverylocation);
                    PrefUtils.prefs!.setString("longitude", _longitude);
                    PrefUtils.prefs!.setString("latitude", _latitude);
                    IConstants.currentdeliverylocation.value =
                        currentdeliverylocation;
                    Navigator.of(context).pop();
                   /* Navigator.pushNamedAndRemoveUntil(context, SignupSelectionScreen.routeName, (route) => false,
                        arguments: {
                          "prev": "signupSelectionScreen",
                        });*/
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.homenav,
                        qparms: {
                          "prev": "signupSelectionScreen",
                        });
                    //Navigator.of(context).pushReplacementNamed(SignupSelectionScreen.routeName,);
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorCodes.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).log_out,
                              style: TextStyle(
                                  fontSize: ResponsiveLayout.isSmallScreen(context)?16.0:24.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor),
                            ),
                            SizedBox(height: 5),
                            // Text("Login or Signup",
                            //   style: TextStyle(
                            //       fontSize:15,
                            //       fontWeight: FontWeight.w500,
                            //       color: ColorCodes.greyColor),
                            // )
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined, color: (IConstants.isEnterprise)?ColorCodes.blackColor:ColorCodes.blackColor,
                          size: 20,),


                      ],
                    )

                ),
              ),
              SizedBox(height: 15,),

            ],
          ),
        ),
      ),
    );

  }
}
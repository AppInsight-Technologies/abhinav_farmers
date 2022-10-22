import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/controller/mutations/cart_mutation.dart';
import 'package:grocbay/data/calculations.dart';
import 'package:grocbay/generated/l10n.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/rought_genrator.dart';
import 'package:grocbay/screens/profile_screen.dart';
import 'package:grocbay/screens/store_screen.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:grocbay/widgets/app_drawer.dart';
import 'package:grocbay/widgets/badge.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class StoreBottomNavigation extends StatefulWidget {
  const StoreBottomNavigation({Key? key}) : super(key: key);

  @override
  _StoreBottomNavigationState createState() => _StoreBottomNavigationState();
}

class _StoreBottomNavigationState extends State<StoreBottomNavigation> with Navigations{
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorCodes.greenColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 55,
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigation(context, navigatore: NavigatoreTyp.homenav);
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0,
                  ),
                  CircleAvatar(
                    radius: 13.0,
                    // minRadius: 50,
                    // maxRadius: 50,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(Images.homeImg,
                      //  color:ColorCodes.greenColor,
                      color: ColorCodes.whiteColor,

                      width: 50,
                      height: 30,
                    ),

                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      S.of(context).home,
                      // "Home",
                      style: TextStyle(
                          color: ColorCodes.whiteColor,
                          //  color: ColorCodes.greenColor,
                          fontSize: 10.0,
                      )),
                ],
              ),
            ),
            Spacer(),
            ValueListenableBuilder(
                valueListenable: IConstants.currentdeliverylocation,
                builder: (context, value, widget) {
                  return GestureDetector(
                    onTap: () {
                      if (value != S.of(context).not_available_location)
                      if(!PrefUtils.prefs!.containsKey("apikey")) {
                        debugPrint("not loged in...");
                        Navigator.of(context).pop();
                        Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "prev": "signupSelectionScreen",
                            });
                      }else {
                        Navigator.of(context).pop();
                        Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.MyOrders,
                            qparms: {
                              "orderhistory": ""
                            });
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 7.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.categoriesImg,
                            color: ColorCodes.whiteColor,
                            width: 50,
                            height: 30,),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                            S.of(context).my_orders, //"Categories",
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                      ],
                    ),
                  );
                }),
            Spacer(),
            ValueListenableBuilder(
                valueListenable: IConstants.currentdeliverylocation,
                builder: (context, value, widget){return VxBuilder(
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
                          if (value != S.of(context).not_available_location)
                            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                          /* Navigator.of(context).pushNamed(CartScreen.routeName,arguments: {
                            "afterlogin": ""
                          });*/
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 7.0,
                            ),
                            CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                Images.bag,
                                color: ColorCodes.whiteColor,
                                width: 50,
                                height: 30,),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                                S.of(context).my_bag,//"My Bag", //"Categories",
                                style: TextStyle(
                                    color: ColorCodes.whiteColor, fontSize: 10.0)),
                          ],
                        ),
                      ),);
                  },mutations: {SetCartItem},
                );}),
            Spacer(),
            ValueListenableBuilder(
                valueListenable: IConstants.currentdeliverylocation,
                builder: (context, value, widget) {
                  return GestureDetector(
                    onTap: () {
                      print("profilemclick...");
                      StoreScreen.scaffoldKey.currentState!.openDrawer();
                     ProfileScreen();
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
                            Images.profile,
                            color: ColorCodes.whiteColor,
                            width: 20,
                            height: 20,),
                        ),

                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                            S.of(context).profile,//"Profile", //"My Orders",
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                      ],
                    ),
                  );
                }),
            Spacer(),
          ],
        )
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:grocbay/components/sellingitem_component.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/models/newmodle/product_data.dart';

import 'package:velocity_x/velocity_x.dart';

import '../assets/images.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../models/VxModels/VxStore.dart';
import '../rought_genrator.dart';
import '../screens/address_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/map_screen.dart';
import '../widgets/addresswidget/address_info.dart';
import '../widgets/header.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../providers/sellingitems.dart';
import '../screens/home_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';


class NotavailabilityProduct extends StatefulWidget {
  static const routeName = 'notavailability-screen';
  Map<String,String> params;
  NotavailabilityProduct(this.params);
  @override
  _NotavailabilityProductState createState() => _NotavailabilityProductState();
}

class _NotavailabilityProductState extends State<NotavailabilityProduct> with Navigations{
  var similarlistData;
  //Box<Product>? productBox;
  String? currentBranch;
  String? val;
  String? item;
  var _checkitem = false;
  var _isLoading = true;
  bool _isWeb = false;
  bool iphonex = false;
  String itemFeaturedImage="";
  String type ="";
  String eligibleForExpress = "";
  String vegType = "";
  String delivery = "";
  String duration = "";
  String brand = "";
  String id = "";
  String itemName = "";
  String durationd = "";
  String durationType = "";
  bool membershipDisplayitem =  false;
  bool discointDisplay = false;
  int loyaltys = 0;
  bool membershipDisplay = false;
  String menuItemId = "";
  String netWeight = "";
  String weight = "";
  String pid = "";
  String variationName = "";
  String unit = "";
  String minItem = "";
  String maxItem = "";
  double stock = 0.0;
  String mrp = "";
  String price = "";
  String membershipPrice = "";
  bool _isAddToCart = false;
  bool endOfProduct = false;
  late Future<List<ItemData>> _futureNonavailability = Future.value([]);
  late Future<List<ItemData>> _futureNonavailability1 = Future.value([]);

  @override
 void initState() {

    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
          iphonex = MediaQuery
              .of(context)
              .size
              .height >= 812.0;
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
    Future.delayed(Duration.zero, () async {
      //productBox = Hive.box<Product>(productBoxName);

        final routeArgs = ModalRoute
            .of(context)!
            .settings
            .arguments as Map<String, dynamic>;
        currentBranch = widget.params['currentbranch'];//routeArgs['currentBranch'];
        val = widget.params['val'];//routeArgs['val'];
        item = widget.params['item'];
    //    debugPrint("currentBranch....rfgfd"+ currentBranch! + " "+val!);

        // SellingItemsList().fetchSwapProduct(currentBranch!, val!,item).then((value) {
        //   _futureNonavailability =  Future.value(value);
        //   debugPrint("loading false....");
        //   _futureNonavailability.then((value) {
        //     debugPrint("value.length..."+value.length.toString());
        //     if(value.length <= 0){
        //       setState(() {
        //         _checkitem = false;
        //       });
        //
        //     }else{
        //       setState(() {
        //         _isLoading = false;
        //         _checkitem = true;
        //       });
        //
        //     }
        //   });
        //
        //
        // });

        SellingItemsList().fetchSwapProduct(currentBranch!, val!, item!).then((value) {
          List<ItemData> list=[];
          List<ItemData> list1=[];
          list.addAll([...value.surveyProducts??[]]);
          list1.addAll([...value.data??[]]);
          _futureNonavailability =  Future.value(list1);
          _futureNonavailability1 =  Future.value(list);
          debugPrint("loading false....");
          _futureNonavailability.then((value) {
            debugPrint("value.length..."+value.length.toString());
            if(value.length <= 0){
              setState(() {
                _checkitem = false;
              });

            }else{
              setState(() {
                _isLoading = false;
                _checkitem = true;
              });

            }
          });
          _futureNonavailability1.then((value) {
            for (int j = 0; j < value.length; j++) {
              debugPrint("value[j].itemFeaturedImage!..."+value[j].itemFeaturedImage!.toString());
              itemFeaturedImage = value[j].itemFeaturedImage!;
              type = value[j].type!;
              eligibleForExpress = value[j].eligibleForExpress!;
              vegType = value[j].vegType!;
              delivery = value[j].delivery!;
              duration = value[j].duration!;
              brand = value[j].brand!;
              id = value[j].id!;
              itemName = value[j].itemName!;
              duration = value[j].deliveryDuration.duration!;
              durationType = value[j].deliveryDuration.durationType!;
              membershipDisplayitem = value[j].membershipDisplay!;
              for(int i= 0;i<value[j].priceVariation!.length; i++) {
                discointDisplay = value[j].priceVariation![i].discointDisplay!;
                loyaltys = value[j].priceVariation![i].loyalty!;
                membershipDisplay = value[j].priceVariation![i].membershipDisplay!;
                menuItemId = value[j].priceVariation![i].id!;
                netWeight = value[j].priceVariation![i].netWeight!;
                weight = value[j].priceVariation![i].weight!;
                pid = value[j].priceVariation![i].id!;
                variationName = value[j].priceVariation![i].variationName!;
                unit = value[j].priceVariation![i].unit!;
                minItem = value[j].priceVariation![i].minItem!;
                maxItem = value[j].priceVariation![i].maxItem!;
                stock = value[j].priceVariation![i].stock!;
                mrp = value[j].priceVariation![i].mrp!;
                price = value[j].priceVariation![i].price!;
                membershipPrice = value[j].priceVariation![i].membershipPrice!;
              }

              if(value[j].type ==1)
                cartcontroller.addtoCart(itemdata: ItemData(itemFeaturedImage: itemFeaturedImage,type: type,eligibleForExpress: eligibleForExpress,vegType:vegType,delivery: delivery,
                    duration: duration,brand: brand,id: id,itemName: itemName,mode: "3",deliveryDuration:DeliveryDurationData(duration:durationd,status: "",durationType: durationType,note: "", id: "",branch: "",blockFor: "") ), onload: (onload){

                  setState(() {
                    _isAddToCart = onload;
                  });
                  setState(() {
                    _isAddToCart = false;

                  });
                },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody: PriceVariation(quantity: 1,mode: "3",status: "0",discointDisplay: discointDisplay,
                    loyaltys: 0,membershipDisplay: membershipDisplayitem,menuItemId: menuItemId,
                    netWeight: "",weight: "",id: id,variationName: "",unit:"",minItem: "",maxItem: "",loyalty: 0,stock: 0.0,mrp: "",
                    price: "",membershipPrice: ""),context: context);
              else

                cartcontroller.addtoCart(itemdata: ItemData(itemFeaturedImage: itemFeaturedImage,type:type,eligibleForExpress: eligibleForExpress,vegType:vegType,delivery: delivery,
                    duration: duration,brand: brand,id: id,itemName: itemName,mode: "3",deliveryDuration:DeliveryDurationData(duration:durationd,status: "",durationType: durationType,note: "", id: "",branch: "",blockFor: "") ), onload: (onload){

                  setState(() {
                    _isAddToCart = onload;
                  });
                  setState(() {
                    _isAddToCart = false;

                  });
                },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody:
                PriceVariation(quantity: 1,mode: "3",status: "0",discointDisplay: discointDisplay,
                    loyaltys: loyaltys,membershipDisplay: membershipDisplay,menuItemId: menuItemId,
                    netWeight: netWeight,weight: weight,id: pid,variationName: variationName,
                    unit:unit,minItem: minItem,maxItem:maxItem,
                    loyalty: 0,stock: stock,mrp: mrp,
                    price: price,membershipPrice: membershipPrice),context: context);
            }
          });

        });


    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _bodyMobile(){
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = 1;
      if (deviceWidth > 1200) {
        widgetsInRow = 5;
      } else if (deviceWidth > 768) {
        widgetsInRow = 3;
      }
      double aspectRatio = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 340:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 180;
      return
        _isLoading
          ? /*Expanded(
        child: */Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ItemListShimmer(),
            //),
      ),
          ],
        )
          :
     _checkitem ? (_isWeb && !ResponsiveLayout.isSmallScreen(context))? Flexible(
          child: FutureBuilder<List<ItemData>?>(
            future: _futureNonavailability,
            builder: (context, AsyncSnapshot<List<ItemData>?> snapshot) {
              final swapproduct = snapshot.data;
              if(snapshot.connectionState ==ConnectionState.waiting)
                  return Container();
              else
              return SingleChildScrollView(
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90),
                      child: new GridView.builder(
                          shrinkWrap: true,
                          itemCount: swapproduct!.length,
                          controller: new ScrollController(keepScrollOffset: false),
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widgetsInRow,
                            crossAxisSpacing: 3,
                            childAspectRatio: aspectRatio,
                            mainAxisSpacing: 3,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return SellingItemsv2(
                               fromScreen: "notavailableProduct",
                              seeallpress: "",
                              itemdata: swapproduct[index],
                              notid: swapproduct[index].id,
                              /*"notavailableProduct",
                              similarlistData.itemsSwap[index].id,
                              snapshot.data![index],
                              ""*/
                            );
                          }),
                    ),
                    SizedBox(height: 30,),

                    if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                  ],
                ),
              );
            }
          ),
        )
          :FutureBuilder<List<ItemData>?>(
          future: _futureNonavailability,
          builder: (context, AsyncSnapshot<List<ItemData>?> snapshot) {
            final swapproduct = snapshot.data;
            debugPrint("swapproduct...."+swapproduct.toString());
            if(snapshot.connectionState ==ConnectionState.waiting)
              return Container();
            else
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    swapproduct!.length > 0 ?
                    SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: new GridView.builder(
                            shrinkWrap: true,
                            itemCount: swapproduct.length,
                            controller: new ScrollController(keepScrollOffset: false),
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: widgetsInRow,
                              crossAxisSpacing: 3,
                              childAspectRatio: aspectRatio,
                              mainAxisSpacing: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return SellingItemsv2(
                                fromScreen: "notavailableProduct",
                                seeallpress: "",
                                itemdata: swapproduct[index],
                                notid: "",
                                /*"notavailableProduct",
                                "",
                                snapshot.data![index],
                                ""*/
                            );
                            }),
                      ),
                    ):
                    SizedBox.shrink(),
                    SizedBox(height: 30,),

                    if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                  ],
                ),
              ),
            );
          }
        )
          :
      (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      Flexible(
        child: SingleChildScrollView(
          child: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.center,
//                   child: new Image.asset(
//                     Images.noItemImg, fit: BoxFit.fill,
//                     height: 250.0,
//                     width: 200.0,
// //                    fit: BoxFit.cover
//                   ),
//                 ),
//                 SizedBox(height: 5,),
//
//                 if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
//               ],
//             ),

              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/8,),
                  new Image.asset(
                    Images.noItemImg,
                    fit: BoxFit.fitHeight,
                    height: 200.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(S.of(context).no_product,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(S.of(context).find_item,
                      style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color:ColorCodes.grey),),
                  ),
                  if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                ],
              )

          ),
        ),
      ):
      SingleChildScrollView(
        child: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.center,
//                 child: new Image.asset(
//                   Images.noItemImg, fit: BoxFit.fill,
//                   height: 250.0,
//                   width: 200.0,
// //                    fit: BoxFit.cover
//                 ),
//               ),
//               SizedBox(height: 30,),
//
//               if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
//             ],
//           ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/8,),
                new Image.asset(
                  Images.noItemImg,
                  fit: BoxFit.fitHeight,
                  height: 200.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(S.of(context).no_product,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(S.of(context).find_item,
                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color:ColorCodes.grey),),
                ),
                if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
              ],
            )
        ),
      );
    //  );
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
              Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
              }
        ),
        title: Text(
          S .of(context).Swap_Products,
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

    _bottomNavigation() {
      return SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            SetCartItem(CartTask.fetch,onloade: (value){
            });
            if (PrefUtils.prefs!.getString("skip") == "no") {
              if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                  PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                if (PrefUtils.prefs!.containsKey("fromcart")) {
                  if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                    PrefUtils.prefs!.remove("fromcart");
                  /*  Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                        ModalRoute.withName(CartScreen.routeName), arguments: {
                          "after_login": ""
                        });*/
                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      // _dialogforaddress(context);
                      MapWeb(context);
                    }
                    else {
                      Navigation(context, name: Routename.MapScreen,
                          navigatore: NavigatoreTyp.Push);
                    }
                  /*  Navigator.of(context).pushReplacementNamed(
                      CartScreen.routeName, arguments: {
                      "afterlogin": ""
                    }
                    );*/
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                  } else {
                    debugPrint("location 9 . . . . .");
                     HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                                              PrefUtils.prefs!.getString("tokenid"),
                                              branch: (VxState.store as GroceStore).userData.branch ?? "999",
                                              rows: "0");
                                          Navigation(context, name:Routename.Home,navigatore: NavigatoreTyp.homenav);
                    //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                  }
                }else {
                  debugPrint("location 10 . . 5. . .");
                   HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                                              PrefUtils.prefs!.getString("tokenid"),
                                              branch: (VxState.store as GroceStore).userData.branch ?? "999",
                                              rows: "0");
                                          Navigation(context, name:Routename.Home,navigatore: NavigatoreTyp.homenav);
                  //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                }
              }
              else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
             /*   Navigator.of(context)
                    .pushReplacementNamed(AddressScreen.routeName, arguments: {
                  'addresstype': "new",
                  'addressid': "",
                });*/
                if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                  // _dialogforaddress(context);
                  AddressWeb(context,
                    addresstype: "new",
                    addressid: "",);
                }
                else {
                Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      'addresstype': "new",
                      'addressid': "",
                    });
              }
            } else {
                if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                    PrefUtils.prefs!.getString("formapscreen") ==
                        "homescreen") {
                  if (PrefUtils.prefs!.containsKey("fromcart")) {
                    if (PrefUtils.prefs!.getString("fromcart") ==
                        "cart_screen") {
                      PrefUtils.prefs!.remove("fromcart");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MapScreen.routeName,
                          ModalRoute.withName(CartScreen.routeName),
                          arguments: {
                            "afterlogin": ""
                          });

                      /*   Navigator.of(context).pushReplacementNamed(
                        CartScreen.routeName, arguments: {
                        "afterlogin": ""
                      }
                      );*/
                      Navigation(context, name: Routename.Cart,
                          navigatore: NavigatoreTyp.Push,
                          qparms: {"afterlogin": null});
                    } else {
                      debugPrint("location 7 . . . . .");
                      HomeScreenController(
                          user: (VxState.store as GroceStore).userData.id ??
                              PrefUtils.prefs!.getString("tokenid"),
                          branch: (VxState.store as GroceStore).userData
                              .branch ?? "999",
                          rows: "0");
                      Navigation(context, name: Routename.Home,
                          navigatore: NavigatoreTyp.homenav);
                      //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    }
                  } else {
                    debugPrint("location 8 . . . . .");
                    HomeScreenController(
                        user: (VxState.store as GroceStore).userData.id ??
                            PrefUtils.prefs!.getString("tokenid"),
                        branch: (VxState.store as GroceStore).userData.branch ??
                            "999",
                        rows: "0");
                    Navigation(context, name: Routename.Home,
                        navigatore: NavigatoreTyp.homenav);
                    //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    /*Navigator.of(context)
                        .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
                      "currentBranch": currentBranch
                    });*/

                    ///hello
                  }
                } else if (PrefUtils.prefs!.getString("formapscreen") ==
                    "addressscreen") {
                  /*   Navigator.of(context)
                      .pushReplacementNamed(AddressScreen.routeName, arguments: {
                    'addresstype': "new",
                    'addressid': "",
                  });*/
                  if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) {
                    // _dialogforaddress(context);
                    AddressWeb(context,
                      addresstype: "new",
                      addressid: "",);
                  }
                  else {
                    Navigation(context, name: Routename.AddressScreen,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {
                          'addresstype': "new",
                          'addressid': "",
                        });
                  }
                }
              }

            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                S .of(context).confirm,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
        ? gradientappbarmobile()
        : null,

      body: Column(
        children: [
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          _bodyMobile(),
        ],
      ),
      bottomNavigationBar: (_isWeb)?SizedBox.shrink():_bottomNavigation(),
    );
  }
}

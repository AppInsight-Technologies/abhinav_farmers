import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../models/newmodle/home_page_modle.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/product_request.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';

class BannerProductScreen extends StatefulWidget {
  static const routeName = '/banner-product-screen';
  String id = "";
  String type = "";
  Map<String,String>? bannerproduct;

  BannerProductScreen(Map<String, String> params){
    this.bannerproduct= params;
    this.id = params["id"]??"" ;
    this.type = params["type"]??"";

  }
  @override
  _BannerProductScreenState createState() => _BannerProductScreenState();
}

class _BannerProductScreenState extends State<BannerProductScreen> with Navigations{
  final homedata = (VxState.store as GroceStore).homescreen;
  bool _isLoading = true;
  var itemslistData;
  bool _checkmembership = false;
  bool _checkitem = false;
  bool endOfProduct = false;
  bool _isOnScroll = false;
  //SharedPreferences prefs;
  int startItem = 0;
  bool _isWeb =false;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  bool iphonex = false;
  ProductController productController = ProductController();

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
      setState(() {
        if(PrefUtils.prefs!.getString("membership") == "1"){
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final type = widget.type;//routeArgs['type'];
      final id = widget.id;//routeArgs['id'].toString();


      if(type == "category") {
        productController.getCategoryprodutlist(id, "0",0,(isendofproduct){
          setState(() {
            _isLoading = false;
          });
        },);
      /*  Provider.of<ItemsList>(context, listen: false).fetchItems(id, "0", startItem, "initialy").then((_) {
          itemslistData = Provider.of<ItemsList>(context, listen: false);
          setState(() {
            startItem = itemslistData.items.length;
            _isLoading = false;

            if (itemslistData.items.length <= 0) {
              _checkitem = false;
            } else {
              _checkitem = true;
            }
          });
        });*/
      } else {
        productController.getcategoryitemlist(id).then((_){
          setState(() {
            _isLoading = false;
          });
        });

      /*  Provider.of<NotificationItemsList>(context, listen: false).fetchProductItems(id).then((_) {
          setState(() {
            itemslistData = Provider.of<NotificationItemsList>(context, listen: false);
            _isLoading = false;
            if (itemslistData.items.length <= 0) {
              _checkitem = false;
            } else {
              _checkitem = true;
            }
          });
        });*/
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = widget.type;//routeArgs['type'];
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    // double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    double aspectRatio =   (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 370:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 290:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async{
            //  Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              Navigation(context, navigatore: NavigatoreTyp.Pop,);
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(
          S .of(context).products
        // "Products"
          ,style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
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
    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {SetCartItem},
        // valueListenable: Hive.box<Product>(productBoxName).listenable(),
        builder: (context, store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          if (box.isEmpty) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: _checkmembership ? (IConstants.numberFormat == "1")
                ?(CartCalculations.totalMember).toStringAsFixed(0):(CartCalculations.totalMember).toStringAsFixed(IConstants.decimaldigit)
                :
            (IConstants.numberFormat == "1")
                ?(CartCalculations.total).toStringAsFixed(0):(CartCalculations.total).toStringAsFixed(IConstants.decimaldigit),
            onPressed: (){
              setState(() {
             /*   Navigator.of(context)
                    .pushNamed(CartScreen.routeName,arguments: {
                  "afterlogin": ""
                });*/
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
          // return Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 50.0,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: <Widget>[
          //       Container(
          //         color: Theme.of(context).primaryColor,
          //         height: 50,
          //         width: MediaQuery.of(context).size.width * 35 / 100,
          //         child: Column(
          //           children: <Widget>[
          //             SizedBox(
          //               height: 8.0,
          //             ),
          //             _checkmembership
          //                 ? Text(  S .of(context).total
          //              // "Total: "
          //                 +
          //                 IConstants.currencyFormat +
          //                 (Calculations.totalMember).toStringAsFixed(IConstants.decimaldigit),
          //               style: TextStyle(color: ColorCodes.whiteColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16
          //               ),
          //             )
          //                 : Text(  S .of(context).total
          //               //"Total: "
          //                 + IConstants.currencyFormat + (Calculations.total).toStringAsFixed(IConstants.decimaldigit),
          //               style: TextStyle(
          //                   color: ColorCodes.whiteColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16
          //               ),
          //             ),
          //             Text(
          //               Calculations.itemCount.toString() +  S .of(context).item,
          //                   //" item",
          //               style: TextStyle(
          //                   color: ColorCodes.discount,
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 14),
          //             )
          //           ],
          //         ),
          //       ),
          //       GestureDetector(
          //           onTap: () => {
          //             setState(() {
          //               Navigator.of(context)
          //                   .pushNamed(CartScreen.routeName);
          //             })
          //           },
          //           child: Container(
          //               color: Theme.of(context).primaryColor,
          //               height: 50,
          //               width: MediaQuery.of(context).size.width * 65 / 100,
          //               child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     SizedBox(
          //                       width: 80,
          //                     ),
          //                     Text(  S .of(context).view_cart,
          //                     //  'VIEW CART',
          //                       style: TextStyle(
          //                           fontSize: 16.0,
          //                           color: ColorCodes.whiteColor,
          //                           fontWeight: FontWeight.bold),
          //                       textAlign: TextAlign.center,
          //                     ),
          //                     Icon(
          //                       Icons.arrow_right,
          //                       color: ColorCodes.whiteColor,
          //                     ),
          //                   ]))),
          //     ],
          //   ),
          // );
        },
      );
    }
    
   _body(){
     return _isLoading
         ? Expanded(
           child: Center(
                 child: CircularProgressIndicator(),
            ),
         )
         :VxBuilder(
         mutations: {ProductMutation},
         builder: (ctx, store,VxStatus? state) {
       final productlist = (store as GroceStore).productlist;
       debugPrint('hello..'+productlist.length.toString());
       return (productlist.length>0?Expanded(
         child: SingleChildScrollView(
           child: Column(
             children: [
               Container(
                 // constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid):null,
                 child: Column(
                   children: [
                     GridView.builder(
                         shrinkWrap: true,
                         itemCount: productlist.length,
                         physics: ScrollPhysics(),
                         gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: widgetsInRow,
                           crossAxisSpacing: 3,
                           childAspectRatio: aspectRatio,
                           mainAxisSpacing: 3,
                         ),
                         itemBuilder: (BuildContext context, int index) {
                           return SellingItemsv2(
                             fromScreen: (type == "category")
                                 ? "item_screen"
                                 : "not_product_screen",
                             seeallpress: type,
                              itemdata: productlist[index],
                             notid: widget.id,
                             /*(type == "category")
                                 ? "item_screen"
                                 : "not_product_screen",
                             type,
                               productlist[index],
                               widget.id,*///routeArgs['id'],
                           )/*SellingItems(
                             (type == "category")
                                 ? "item_screen"
                                 : "not_product_screen",
                             itemslistData.items[index].id,
                             itemslistData.items[index].title,
                             itemslistData.items[index].imageUrl,
                             itemslistData.items[index].brand,
                             "",
                             itemslistData.items[index].veg_type,
                             itemslistData.items[index].type,
                             itemslistData.items[index].eligible_for_express,
                             itemslistData.items[index].delivery,
                             itemslistData.items[index].duration,
                             itemslistData.items[index].durationType,
                             itemslistData.items[index].note,
                             itemslistData.items[index].subscribe,
                             itemslistData.items[index].paymentmode,
                             itemslistData.items[index].cronTime,
                             itemslistData.items[index].name,

                             returnparm: {
                               'id': routeArgs['id'].toString(),
                               "screen": "bannerprodscreen"
                               // 'type': "category"
                             },
                           )*/;
                         }),

                   ],
                 ),
               ),
               if(_isWeb) Footer(
                   address: PrefUtils.prefs!.getString("restaurant_address")!)
             ],
           ),
         ),
       ):
       Flexible(
           fit: FlexFit.loose,
           child: SingleChildScrollView(
           child: Container(
//            child: Column(
//            children: [
//            Align(
//            alignment: Alignment.center,
//            child: new Image.asset(
//            Images.noItemImg, fit: BoxFit.fill,
//            height: 250.0,
//            width: 200.0,
// //                    fit: BoxFit.cover
//            ),
//            ),
//            if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
//            ],
//            ),

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
                   if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                 ],
               )
           ),
           ),
           ));
     });
         }
/*    Widget _itemDisplay1() {
      return GridView.builder(
          itemCount: itemslistData.items.length,
        physics: ScrollPhysics(),
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widgetsInRow,
            crossAxisSpacing: 3,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return SellingItems(
              (type == "category") ? "item_screen" : "not_product_screen",
              itemslistData.items[index].id,
              itemslistData.items[index].title,
              itemslistData.items[index].imageUrl,
              itemslistData.items[index].brand,
              "",
            );
          });
    }*/


    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: ColorCodes.whiteColor,

      body: Column(
        children: [
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          _isLoading
              ? Center(
            child: _isWeb?CircularProgressIndicator():ItemListShimmer(),
          )
              :
          (type == "category") ?
        VxBuilder(
         mutations: {ProductMutation},
         builder: (ctx, store,VxStatus? state) {
         final productlist = (store as GroceStore).productlist;
         return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (productlist.length>0)
                    ? Flexible(
                  fit: FlexFit.loose,
                  child: NotificationListener<
                      ScrollNotification>(
                    // ignore: missing_return
                      onNotification:
                          // ignore: missing_return
                          (ScrollNotification scrollInfo) {
                        if (!endOfProduct) if (!_isOnScroll &&
                            // ignore: missing_return
                            scrollInfo.metrics.pixels ==
                                scrollInfo
                                    .metrics.maxScrollExtent) {
                          setState(() {
                            _isOnScroll = true;
                          });
                          productController.getCategoryprodutlist(/*routeArgs['id']*/ widget.id, (VxState.store as GroceStore).productlist.length,0,(isendofproduct){

                            if(endOfProduct){
                              setState(() {
                                _isOnScroll = false;
                                endOfProduct = true;
                              });
                            }else {
                              setState(() {
                                _isOnScroll = false;
                                endOfProduct = false;

                              });
                            }
                          },);
                      /*    Provider.of<ItemsList>(context, listen: false).fetchItems(routeArgs['id'], "0", startItem, "scrolling").then((_) {
                            setState(() {
                              //itemslistData = Provider.of<ItemsList>(context, listen: false);
                              startItem = itemslistData.items.length;
                              if (PrefUtils.prefs!.getBool("endOfProduct")) {
                                _isOnScroll = false;
                                endOfProduct = true;
                              } else {
                                _isOnScroll = false;
                                endOfProduct = false;
                              }
                            });
                          });*/
                        }
                        return true;
                      },

                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GridView.builder(
                                shrinkWrap: true,
                                controller: new ScrollController(keepScrollOffset:false),
                                itemCount: productlist.length,
                                gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widgetsInRow,
                                  crossAxisSpacing: 3,
                                  childAspectRatio: aspectRatio,
                                  mainAxisSpacing: 3,
                                ),
                                itemBuilder:
                                    (BuildContext context,
                                    int index) {
                                  return SellingItemsv2(
                                    fromScreen: (type == "category") ? "item_screen" : "not_product_screen",
                                    seeallpress: type,
                                    itemdata: productlist[index],
                                    notid: widget.id,
                                    /*(type == "category") ? "item_screen" : "not_product_screen",
                                    type,
                                      productlist[index],
                                    widget.id,*///routeArgs['id'],
                                  )/*SellingItems(
                                    (type == "category") ? "item_screen" : "not_product_screen",
                                    itemslistData.items[index].id,
                                    itemslistData.items[index].title,
                                    itemslistData.items[index].imageUrl,
                                    itemslistData.items[index].brand,
                                    "",
                                    itemslistData.items[index].veg_type,
                                    itemslistData.items[index].type,
                                    itemslistData.items[index].eligible_for_express,
                                    itemslistData.items[index].delivery,
                                    itemslistData.items[index].duration,
                                    itemslistData.items[index].durationType,
                                    itemslistData.items[index].note,
                                    itemslistData.items[index].subscribe,
                                    itemslistData.items[index].paymentmode,
                                    itemslistData.items[index].cronTime,
                                    itemslistData.items[index].name,

                                  )*/;
                                }),
                            if (endOfProduct)
                              Features.suggestproduct ?
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                  ),
                                  margin: EdgeInsets.only(top: 10.0),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: _footer(homedata)
                              ) : Container(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                ),
                                margin: EdgeInsets.only(top: 10.0),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                padding: EdgeInsets.only(
                                    top: 25.0, bottom: 25.0),
                                child: Text(
                                  S
                                      .of(context)
                                      .thats_all_folk, // "That's all folks!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                          ],
                        ),
                      )

                  ),

                )
                    : Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: new Image.asset(
                              Images.noItemImg, fit: BoxFit.fitHeight,
                              height: 200.0,
//                    fit: BoxFit.cover
                            ),
                          ),
                          if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                        ],
                      ),
                    ),
                  ),
                ),
                if(!_isWeb)Container(
                  height: _isOnScroll ? 50 : 0,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );}) : _body()

        ],
      ),
      bottomNavigationBar:  Vx.isWeb ? SizedBox.shrink() : Padding(
    padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
    child:_buildBottomNavigationBar(),
    ),
    );
  }
  Widget _footer(HomePageData homedata) {
    if (homedata.data!.footerImage!.length > 0) {
      return GestureDetector(
        onTap: () {
          !PrefUtils.prefs!.containsKey("apikey")
              ?
          Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push) :
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
            ),
            context: context,
            builder: ( context) {
              return productRequest();
            },
          );
        },
        child: new ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homedata.data!.footerImage!.length,
          itemBuilder: (_, i) =>
              Container(
                child: CachedNetworkImage(
                  imageUrl: homedata.data!.footerImage![i].bannerImage,
                  fit: BoxFit.fill,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultSliderImg),
                  errorWidget: (context, url, error) =>
                      Image.asset(Images.defaultSliderImg),
                ),
              ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
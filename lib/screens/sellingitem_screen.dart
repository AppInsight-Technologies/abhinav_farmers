  import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/rought_genrator.dart';
import '../controller/mutations/cart_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/home_page_modle.dart';
import '../repository/fetchdata/view_all_product.dart';
import '../components/sellingitem_component.dart';
import '../widgets/simmers/ItemWeb_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../screens/cart_screen.dart';
import '../screens/searchitem_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import '../assets/ColorCodes.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../constants/IConstants.dart';
import '../providers/sellingitems.dart';
import '../utils/ResponsiveLayout.dart';
import '../screens/home_screen.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

import '../utils/prefUtils.dart';

class SellingitemScreen extends StatefulWidget {
  static const routeName = '/sellingitem-screen';

  Map<String,String> params;
  SellingitemScreen(this.params);
  @override
  _SellingitemScreenState createState() => _SellingitemScreenState();
}

class _SellingitemScreenState extends State<SellingitemScreen>with Navigations {
  var _isLoading = true;
  bool _isWeb =false;
   MediaQueryData? queryData;
  bool iphonex = false;
  bool _checkmembership = false;
   Future<OfferByCart>?  futureproducts ;
  String? title;

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

    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final seeallpress = widget.params['seeallpress'];
       title = widget.params['title']!;
       if(seeallpress == "featured") {
        setState(() {
          futureproducts =  viewProducts.getData(ViewProductOf.featured,status: (onloadcompleate){
            setState(() {
              _isLoading = !onloadcompleate;
              title =  (VxState.store as GroceStore).homescreen.data!.featuredByCart!.label.toString();
            });
        });
        });
      } else if(seeallpress == "offers"){
        futureproducts =  viewProducts.getData(ViewProductOf.offer,status: (onloadcompleate){
          setState(() {
            _isLoading = !onloadcompleate;
            title =  (VxState.store as GroceStore).homescreen.data!.offerByCart!.label.toString();
          });
        });
      }else if(seeallpress == "forget"){
        futureproducts =  viewProducts.getData(ViewProductOf.itemData,status: (onloadcompleate){
          setState(() {
            _isLoading = !onloadcompleate;
            title =  title.toString();
          });
        });
      }
      else {
        futureproducts =  viewProducts.getData(ViewProductOf.discount,status: (onloadcompleate){
          setState(() {
            _isLoading = !onloadcompleate;
            title =  (VxState.store as GroceStore).homescreen.data!.discountByCart!.label.toString();
          });
        });
      }
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
      int _nestedIndex = 0;
      setState(() {
        if (PrefUtils.prefs!.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final sellingitemData = Provider.of<SellingItemsList>(context,listen: false);
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double wid= queryData.size.width;
    double maxwid=wid*0.90;
    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    // double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    double aspectRatio =   (_isWeb && !ResponsiveLayout.isSmallScreen(context))? (!Features.ismultivendor) ?
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 335:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170 :
    Features.btobModule?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 210:(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;


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
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
            (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
        },
      );
    }

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor,
              size: 25,),
            onPressed: () async {
             // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              Navigation(context, navigatore: NavigatoreTyp.Pop);
              return Future.value(false);
            }
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);
            },
            child: Container(
              height: 25,
              width: 25,
              margin: EdgeInsets.only(top: 16, right: 10, bottom: 18),
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.search,
                size: 25,
                color: ColorCodes.iconColor,
              ),
            ),
          ),
          SizedBox(width: 5),
          // ValueListenableBuilder(
          //   valueListenable: Hive.box<Product>(productBoxName).listenable(),
          //   builder: (context, Box<Product> box, index) {
          //     if (box.values.isEmpty)
          //       return GestureDetector(
          //         onTap: () {
          //           // Navigator.of(context).pushNamed(CartScreen.routeName);
          //         },
          //         child: Container(
          //           margin: EdgeInsets.only(top: 16, right: 10, bottom: 18),
          //           width: 25,
          //           height: 25,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(100),
          //               /*color: Theme.of(context).buttonColor*/),
          //           // child: /*Icon(
          //           //   Icons.shopping_cart_outlined,
          //           //   size: 18,
          //           //   color: Theme.of(context).primaryColor,
          //           // ),*/
          //           // Image.asset(
          //           //   Images.header_cart,
          //           //   height: 28,
          //           //   width: 28,
          //           //   color: Colors.white,
          //           // ),
          //         ),
          //       );
          //
          //     int cartCount = 0;
          //     for (int i = 0; i < Hive.box<Product>(productBoxName).length; i++) {
          //       cartCount = cartCount + Hive.box<Product>(productBoxName).values.elementAt(i).itemQty;
          //     }
          //     return Consumer<CartCalculations>(
          //       builder: (_, cart, ch) => Badge(
          //         child: ch,
          //         color: Colors.green,
          //         value: cartCount.toString(),
          //       ),
          //       child: GestureDetector(
          //         onTap: () {
          //           Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
          //             "afterlogin": ""
          //           });
          //         },
          //         child: Container(
          //           margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
          //           height: 28,
          //           width: 28,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(100),
          //              // color: Theme.of(context).buttonColor
          //           ),
          //           // child: Image.asset(
          //           //   Images.header_cart,
          //           //   height: 28,
          //           //   width: 28,
          //           //   color: IConstants.isEnterprise ?Colors.white: ColorCodes.mediumBlackWebColor,
          //           // ),
          //
          //           // Icon(
          //           //   Icons.shopping_cart_outlined,
          //           //   size: 18,
          //           //     color: Colors.white,
          //           // ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // SizedBox(width: 10,)
        ],
        titleSpacing: 0,
        title: Text(title??"",
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
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

    _body() {
      return  Expanded(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints:(Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context))
                      ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90)
                      : null,
                  child:
                  FutureBuilder<OfferByCart> (
                    future: futureproducts,
                    builder: (BuildContext context, AsyncSnapshot<OfferByCart> snapshot){
                      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                      final seeallpress = widget.params['seeallpress'];
                      switch(snapshot.connectionState){

                        case ConnectionState.none:
                          return SizedBox.shrink();
                          // TODO: Handle this case.
                          break;
                        case ConnectionState.waiting:
                          return (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                      ? ItemListShimmerWeb()
                          : ItemListShimmer();
                      // TODO: Handle this case.
                        default:
                          if(snapshot.data!=null)
                            return GridView.builder(
                                shrinkWrap: true,
                                itemCount:snapshot.data!.data!.length,
                                controller: new ScrollController(keepScrollOffset: false),
                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widgetsInRow,
                                  crossAxisSpacing: 3,
                                  childAspectRatio: aspectRatio,
                                  mainAxisSpacing: 3,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return SellingItemsv2(
                                    fromScreen: "sellingitem_screen",
                                      seeallpress: widget.params['seeallpress'].toString(),
                                      itemdata: snapshot.data!.data![index],
                                      notid: "",
                                      //"sellingitem_screen",widget.params['seeallpress'].toString(), snapshot.data!.data![index],""
                                  );
                                });
                          else
                            return SizedBox.shrink();
                      }

                    },
                  ),
                ),

              ),
              if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
            ],
          ),
        ),
      );

    }
    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          _body(),
        ],
      ),
      bottomNavigationBar:  _isWeb ? SizedBox.shrink() :Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
            child: _buildBottomNavigationBar()
        ),
      ),
    );
  }
}
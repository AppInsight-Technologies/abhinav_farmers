import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/newmodle/category_modle.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import '../constants/IConstants.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import '../data/calculations.dart';
import '../assets/ColorCodes.dart';
import '../screens/cart_screen.dart';
import '../screens/searchitem_screen.dart';
import '../providers/categoryitems.dart';
import '../utils/prefUtils.dart';

class SubcategoryScreen extends StatefulWidget {
  static const routeName = '/subcategory-screen';

  Map<String,String> params;
  SubcategoryScreen(this.params);
  @override
  _SubcategoryScreenState createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> with Navigations{
  bool _isLoading = true;
  //var subcategoryData;
  String catTitle = "";
  bool _checkmembership = false;
  bool _isWeb = false;
  //SharedPreferences prefs;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  bool iphonex = false;
  List<CategoryData> subcatData=[];
  late Future<List<CategoryData>> future;

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
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final catId = /*routeArgs['catId']*/widget.params['catId'];
      debugPrint("sub...."+catId.toString());
      ProductController productController = ProductController();
      productController.geSubtCategory(widget.params['catId'].toString(),onload: (status){

      });

       ProductRepo().getSubcategory(widget.params['catId'].toString(), (List<CategoryData> data) {
         setState(() {
          future=Future.value(data);
        });
      });
 /*     Provider.of<CategoriesItemsList>(context,listen: false).fetchNestedCategory(catId.toString(), "Subcategory").then((
          _) {
        setState(() {
          _isLoading = false;
        });
      });*/
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {ProductMutation},
        builder: (context, box, _) {
          if (box.userData!=null) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
                (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              setState(() {
             /*   Navigator.of(context)
                    .pushNamed(CartScreen.routeName, arguments: {
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
          //               //"Total: "
          //                   +
          //                 IConstants.currencyFormat +
          //                 (Calculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
          //               style: TextStyle(color: ColorCodes.whiteColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16
          //               ),
          //             )
          //                 : Text(  S .of(context).total
          //               //"Total: "
          //                 + IConstants.currencyFormat + (Calculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
          //               style: TextStyle(
          //                   color: ColorCodes.whiteColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16
          //               ),
          //             ),
          //             Text(
          //               Calculations.itemCount.toString() +
          //                   S .of(context).item,
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
          //                     Text(
          //                  S .of(context).view_cart,
          //                      // 'VIEW CART',
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

      /*if(Calculations.itemCount > 0) {
        return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height:50,
                width:MediaQuery.of(context).size.width * 35/100,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    _checkmembership
                        ?
                    Text(IConstants.currencyFormat + (Calculations.totalMember).toString(), style: TextStyle(color: Colors.black),)
                        :
                    Text(IConstants.currencyFormat + (Calculations.total).toString(), style: TextStyle(color: Colors.black),),
                    Text(Calculations.itemCount.toString() + " item", style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 9),)
                  ],
                ),),
              GestureDetector(
                  onTap: () =>
                  {
                    setState(() {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    })
                  },
                  child: Container(color: Theme.of(context).primaryColor, height:50,width:MediaQuery.of(context).size.width*65/100,
                      child:Column(children:[
                        SizedBox(height: 17,),
                        Text('VIEW CART', style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ]
                      )
                  )
              ),
            ],
          ),
        );
      }*/
    }

    /*final subcategoryData = Provider.of<CategoriesItemsList>(
       context,
      listen: false,
    ).findById(catId);*/


    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context)
          ? gradientappbarmobile()
          : null,
      backgroundColor: ColorCodes.whiteColor,
      body: Column(
        children: [
          if (_isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false),
          _body(),
        ],
      ),
      bottomNavigationBar:_isWeb
          ? SizedBox.shrink() :Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
        child:_buildBottomNavigationBar(),
      ),
    );
  }
  Widget _body(){
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 120;

    if (deviceWidth > 1200) {
      widgetsInRow = 6;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;
    } else if (deviceWidth > 650) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 140;
    }
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final catId = /*routeArgs['catId']*/widget.params['catId'];
    final catTitle = /*routeArgs['catTitle']*/widget.params['catTitle'];
    final subcategoryData = Provider.of<CategoriesItemsList>(context, listen: false,);

    return /*_isLoading ?
    Center(
      child: CircularProgressIndicator(),
    )
        :*/
      FutureBuilder<List<CategoryData>> (
          future: future,
          builder: (context,  snapshot){
            List<CategoryData> subcat =[];
            if(snapshot.hasData && snapshot.data!.length> 0)
              subcat = snapshot.data!.where((element) => element.categoryName!.toLowerCase().trim() != "all").toList();
            return (snapshot.hasData && subcat.length> 0) ?Expanded(child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        constraints: (_isWeb &&
                            !ResponsiveLayout.isSmallScreen(context))
                            ? BoxConstraints(maxWidth: maxwid)
                            : null,
                        child: GridView.builder(
                          shrinkWrap: true,
                          controller: new ScrollController(keepScrollOffset: false),
                          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                          itemCount: subcat.length,
                          itemBuilder: (ctx, i) =>
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                   /* Navigator.of(context).pushNamed(
                                        ItemsScreen.routeName, arguments: {
                                      'maincategory': catTitle,
                                      'catId': catId,
                                      'catTitle': subcat[i]
                                          .categoryName,
                                      'subcatId': subcat[i]
                                          .id,
                                      'indexvalue': i.toString(),
                                      'prev': "category_item"
                                    });*/
                                    Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                                        parms: {
                                          'maincategory': catTitle.toString(),
                                          'catId': catId.toString(),
                                          'catTitle': subcat[i].categoryName!,
                                          'subcatId': subcat[i].id!,
                                          'indexvalue': i.toString(),
                                          'prev': "category_item"
                                        });
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    elevation: 0,
                                    margin: EdgeInsets.all(5),
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl: subcat[i]
                                              .iconImage,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  Images.defaultCategoryImg),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  Images.defaultCategoryImg),
                                          height: 55,
                                          width: 85,
                                          fit: BoxFit.fill,
                                        ),
                                        Spacer(),
                                        Text(subcat[i].categoryName!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.0)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widgetsInRow,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                    if (_isWeb)
                      Footer(
                          address: PrefUtils.prefs!.getString("restaurant_address")!),
                  ],
                ),
              ),  ):SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: new Image.asset(
                  Images.noCategoryImg, fit: BoxFit.fill,
                  height: 200.0,
                  width: 200.0,
//                    fit: BoxFit.cover
                ),
              ),
              if (_isWeb)
                Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
            ],
          ));
    });
  }
  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () => Navigator.of(context).pop()),
      title: Text(
        catTitle ==
            "" ?
        S .of(context).categories
       // "Categories"
            : catTitle,
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
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);

          },
          child: Icon(Icons.search, size: 30.0,),
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }

}
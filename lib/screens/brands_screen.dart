import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import '../../components/sellingitem_component.dart';
import '../../rought_genrator.dart';
import '../../widgets/simmers/ItemWeb_shimmer.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../models/VxModels/VxStore.dart';
import 'package:velocity_x/velocity_x.dart';

import '../generated/l10n.dart';
import '../models/newmodle/home_page_modle.dart';
import '../widgets/bottom_navigation.dart';

import '../constants/features.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/product_request.dart';
import '../widgets/simmers/item_list_shimmer.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data/calculations.dart';
import '../providers/branditems.dart';
import '../screens/cart_screen.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/ColorCodes.dart';

class BrandsScreen extends StatefulWidget {
  static const routeName = '/brands-screen';
  Map<String, String> queryParams;
  BrandsScreen(this.queryParams);
  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<BrandsScreen>, Navigations {
  int startItem = 0;
  bool isLoading = true;
  var load = true;
  var brandslistData;
  int previndex = -1;
  String? indvalue;
  var _checkitem = false;
  bool _checkmembership = false;
  final ItemScrollController _scrollController = ItemScrollController();
  bool endOfProduct = false;
  bool _isOnScroll = false;
  String brandId = "";
  //SharedPreferences prefs;
  var brandsData;
  bool _isWeb = false;

  MediaQueryData? queryData;
  double? wid;
  double? maxwid;

  String? indexvalue;
  bool iphonex = false;
  ProductController productController = ProductController();
  final homedata = (VxState.store as GroceStore).homescreen;
  _displayitem(String brandid, int index) {
    debugPrint("brandid...."+brandid);
    setState(() {
      isLoading = true;
      brandId = brandid;
    });
     productController.getbrandprodutlist(brandid, 0,(isendofproduct){
        setState(() {
          isLoading = false;
         indexvalue =  index.toString();
          indvalue =  index.toString();
          endOfProduct = false;
        });
      });

  }

  @override
  void initState() {
    print("inside init");
    // _scrollController = ItemScrollController();
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
      //prefs = await SharedPreferences.getInstance();
      setState(() {
        if (PrefUtils.prefs!.getString("membership") == "1") {
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });

       indexvalue = widget.queryParams['indexvalue'];
      indvalue = (widget.queryParams['indexvalue']??"0");
setState(() {
  brandsData = Provider.of<BrandItemsList>(context, listen: false);
  for (int i = 0; i < brandsData.items.length; i++) {
    if (int.parse(indexvalue!) != i) {
      brandsData.items[i].boxbackcolor = Theme.of(context).buttonColor;
      brandsData.items[i].boxsidecolor =
          Theme.of(context).textSelectionTheme.selectionColor;
      brandsData.items[i].textcolor =
          Theme.of(context).textSelectionTheme.selectionColor;
    } else {
      brandsData.items[i].boxbackcolor = Theme.of(context).accentColor;
      brandsData.items[i].boxsidecolor = Theme.of(context).accentColor;
      brandsData.items[i].textcolor = Theme.of(context).buttonColor;
    }
  }
  setState(() {
    brandId = widget.queryParams['brandId']!;
  });

      ProductController productController = ProductController();
  productController.getbrandprodutlist(brandId, 0,(isendofproduct){
    setState(() {
      isLoading =false;
      endOfProduct = false;
    });
print("brand index value...."+indexvalue.toString());
    Future.delayed(Duration.zero, () async {
          _scrollController.jumpTo(index: int.parse(indexvalue!));
    });
  });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final brandsData =(VxState.store as GroceStore).homescreen.data!.allBrands;

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
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
        },
      );
    }

    return DefaultTabController(
      length: brandsData!.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ResponsiveLayout.isSmallScreen(context)   ?_appBarMobile() : PreferredSize(preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink()),
        body:
          Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            SizedBox(
              height: 10.0,
            ),
            isLoading?SizedBox.shrink():Container(
              constraints:(Vx.isWeb &&
                  !ResponsiveLayout.isSmallScreen(context))
                  ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90)
                  : null,
              child: SizedBox(
                height: 60,
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: brandsData.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            _displayitem(brandsData[i].id!, i);
                            Future.delayed(const Duration(seconds: 1), () async {
                              _scrollController.jumpTo(index: int.parse(i.toString()));
                            });

                          },
                          child: Container(
                            height: 45,
                            margin: EdgeInsets.only(left: 3.0, right: 3.0),
                            decoration: BoxDecoration(
                                color: (i.toString() !=indvalue.toString())?ColorCodes.whiteColor:ColorCodes.varcolor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1.0,
                                    color: (i.toString() !=indvalue.toString())? ColorCodes.grey:ColorCodes.greenColor,
                                )),
                            child: Padding(
                              padding:
                              EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: brandsData[i].iconImage,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          Images.defaultCategoryImg,
                                          height: 40,
                                          width: 40,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          Images.defaultCategoryImg,
                                          width: 40,
                                          height: 40,
                                        ),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),

                                  Text(
                                   // snapshot.data[i].categoryName,
                                   brandsData[i].categoryName!,
//                            textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color:(i.toString() !=indvalue.toString())? ColorCodes.grey:ColorCodes.greenColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          _body(),
             //

          ],
        ),
        bottomNavigationBar: _isWeb?SizedBox.shrink():Padding(
    padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
    child:_buildBottomNavigationBar(),
        ),
    ),
    );
  }
  _body(){
    return _isWeb ? _bodyweb() :
    _bodyMobile();
  }
  Widget _sliderShimmer() {
    return _isWeb ?
    SizedBox.shrink()
        :
    Shimmer.fromColors(
        baseColor: ColorCodes.shimmerColor,
        highlightColor: ColorCodes.shimmerColor,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              height: 150.0,
              width: MediaQuery.of(context).size.width - 20.0,
              color: Colors.white,
            ),
          ],
        ));
  }
  Widget _bodyweb(){
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 335:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 290:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;
    // return
    return
    Flexible(
      fit: FlexFit.loose,
      child: NotificationListener<ScrollNotification>(
        // ignore: missing_return
          onNotification: (ScrollNotification scrollInfo) {
            if (!endOfProduct) if (!_isOnScroll &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              setState(() {
                _isOnScroll = true;
              });
              productController.getbrandprodutlist(brandId, (VxState.store as GroceStore).productlist.length,(isendofproduct){
                isendofproduct = isendofproduct;
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
              });
            }
            return true;
          },
          child:

          VxBuilder(
          mutations: {ProductMutation},
          builder: (ctx, store,VxStatus? state) {

          final productlist = (store as GroceStore).productlist;
         return  (isLoading) ?

             Center(
               child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
                   ? ItemListShimmerWeb()
                   : ItemListShimmer(),

             )
             :
         (productlist.length>0)
             ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints:(Vx.isWeb &&
                  !ResponsiveLayout.isSmallScreen(context))
                  ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90)
                  : null,
              child: Column(
                children: <Widget>[
                  GridView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(
                          keepScrollOffset: false),
                      itemCount:
                      productlist.length,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widgetsInRow,
                        crossAxisSpacing: 3,
                        childAspectRatio: aspectRatio,
                        mainAxisSpacing: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final routeArgs =
                        ModalRoute
                            .of(context)!
                            .settings
                            .arguments as Map<String, dynamic>;
                        return SellingItemsv2(
                          fromScreen: "brands_screen",
                          seeallpress: "",
                          itemdata: productlist[index],
                          notid: "",

                          returnparm: {
                            "indexvalue": indexvalue!,
                            "brandId": brandId,
                          },
                        );
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
            ),
            if(endOfProduct)
              if (_isWeb) Footer(
                  address: PrefUtils.prefs!.getString("restaurant_address")!),
            if(!_isWeb)Container(
              height: _isOnScroll ? 50 : 0,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ): Container(
           height: MediaQuery
               .of(context)
               .size
               .height,
           child: Column(
             children: [
               Align(
                 // heightFactor: MediaQuery.of(context).size.height,
                 alignment: Alignment.center,
                 child: new Image.asset(
                   Images.noItemImg,
                   fit: BoxFit.fitHeight,
                   height: 200.0,
//                    fit: BoxFit.cover
                 ),
               ),
               SizedBox(height: 10,),
               if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
             ],
           ),
         );
          })
      ),
    );

  }

  Widget _bodyMobile(){
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;
    if (deviceWidth > 1200) {
      widgetsInRow = 4;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 350:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 180;
    return (isLoading) ?
    Center(

      child: (kIsWeb && !ResponsiveLayout.isSmallScreen(context))
          ? ItemListShimmerWeb()
          : ItemListShimmer(), //CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),

    )
        :
    Flexible(
     fit: FlexFit.loose,
     child: NotificationListener<ScrollNotification>(
    // ignore: missing_return
         onNotification: (ScrollNotification scrollInfo) {
           if (!endOfProduct) if (!_isOnScroll &&
               scrollInfo.metrics.pixels ==
                   scrollInfo.metrics.maxScrollExtent) {
             setState(() {
               _isOnScroll = true;
             });
             productController.getbrandprodutlist(brandId, (VxState.store as GroceStore).productlist.length,(isendofproduct){
               startItem = (VxState.store as GroceStore).productlist.length;
               endOfProduct = isendofproduct;
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
             });
           }
           return true;
           },
         child:
         SingleChildScrollView(

           child: Column(
             children: [
               VxBuilder(
                 mutations: {ProductMutation},
                 builder: (ctx, store,VxStatus? state){
                   final productlist = (store as GroceStore).productlist;
                   return (productlist.length>0)
                       ?  SingleChildScrollView(
                     child: Column(
                       children: <Widget>[
                         MouseRegion(
                           cursor: SystemMouseCursors.click,
                           child:
                           GridView.builder(
                               shrinkWrap: true,
                               controller: new ScrollController(
                                   keepScrollOffset: false),
                               itemCount: productlist.length,
                               gridDelegate:
                               new SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount: widgetsInRow,
                                 crossAxisSpacing: 3,
                                 childAspectRatio: aspectRatio,
                                 mainAxisSpacing: 3,
                               ),
                               itemBuilder: (BuildContext context, int index) {
                                 final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                                 /* return (_groupValue == 1) ?*/ return SellingItemsv2(
                                   fromScreen: "brands_screen",
                                   seeallpress: "",
                                   itemdata: productlist[index],
                                   notid: "",
                                   returnparm: {
                                     "indexvalue": indexvalue!,
                                     "brandId": brandId,
                                   },
                                 ) ;
                               }),

                         ),

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

                   :Column(
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
                       )
                     ],
                   );
                 },
               ),
               Container(
                 height: _isOnScroll ? 50 : 0,
                 child: Center(
                   child: new CircularProgressIndicator(),
                 ),
               ),
             ],
           ),
         ),

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
  PreferredSizeWidget _appBarMobile() {
    return  AppBar(
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      title: Text(S .of(context).brands
        //"Brands"
        ,style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
        onPressed: () {
          Navigator.of(context).pop();
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
                ])
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true; // ** and here
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/product_data.dart';
import '../../components/sellingitem_component.dart';
import '../../rought_genrator.dart';
import '../../widgets/simmers/item_list_shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../generated/l10n.dart';
import '../models/newmodle/home_page_modle.dart';
import '../widgets/bottom_navigation.dart';
import '../constants/features.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../providers/branditems.dart';
import '../providers/notificationitems.dart';
import '../assets/ColorCodes.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../providers/carouselitems.dart';
import '../utils/prefUtils.dart';
import '../widgets/product_request.dart';

class NotBrandScreen extends StatefulWidget {
  static const routeName = '/not-brand-screen';

  Map<String, String> routeArgs;

  NotBrandScreen(this.routeArgs);
  @override
  _NotBrandScreenState createState() => _NotBrandScreenState();
}

class _NotBrandScreenState extends State<NotBrandScreen> with Navigations {
  bool _isLoading = true;
  bool _isInit = true;
  var brandsData;
  ItemScrollController? _scrollController;
  int startItem = 0;
  bool isLoading = true;

  var load = true;
  var brandslistData;
  int previndex = -1;

  bool endOfProduct = false;
  bool _isOnScroll = false;
  String brandId = "";

  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool iphonex = false;
  Future<List<ItemData>>?  futurebrand ;
  ProductController productController = ProductController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<BrandItemsList>(context, listen: false).fetchShoppinglist();
    }
    _isInit = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      try {
        if (Platform.isIOS) {
          setState(() {
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        }
      } catch (e) {
      }
      final brandsId = widget.routeArgs['brandsId'].toString();
      brandId = widget.routeArgs['brandsId'].toString();

      if(widget.routeArgs['fromScreen'] == "Banner"){
        Provider.of<CarouselItemsList>(context, listen: false).fetchBrandsItems(brandsId).then((_) {
          final brandsData = Provider.of<CarouselItemsList>(context, listen: false);
          setState(() {
            if (brandsData.brands.length > 0) {
              for (int i = 0; i < brandsData.brands.length; i++) {
                if (i != 0) {
                  brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
                  brandsData.brands[i].textcolor = ColorCodes.grey;
                } else {
                  brandsData.brands[i].boxbackcolor = ColorCodes.varcolor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.varcolor;
                  brandsData.brands[i].textcolor = ColorCodes.primaryColor;
                }
              }
              setState(() {
                _isLoading = false;
              });
              final _splitBrandID = brandId.split(',');
              final Map<int, String> _brandIdValues= {
                for (int i = 0; i < _splitBrandID.length; i++)
                  i: _splitBrandID[i]
              };

              ProductController productController = ProductController();
              productController.getbrandprodutlist(_brandIdValues[0], 0,(isendofproduct){
                setState(() {
                  isLoading =false;
                });
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          });
        });
      } else if (widget.routeArgs['fromScreen'] == "ClickLink") {
        Provider.of<NotificationItemsList>(context, listen: false)
            .updateNotificationStatus(widget.routeArgs['notificationId']!, "1");
      } else {
        if (widget.routeArgs['notificationStatus'] == "2") {
          Provider.of<NotificationItemsList>(context, listen: false).updateNotificationStatus(widget.routeArgs['notificationId']!, "1").then((value) {
            final brandsData = Provider.of<NotificationItemsList>(context, listen: false);
            setState(() {
              if (brandsData.brands.length > 0) {
                for (int i = 0; i < brandsData.brands.length; i++) {
                  if (i != 0) {
                    brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
                    brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
                    brandsData.brands[i].textcolor = ColorCodes.grey;
                  } else {
                    brandsData.brands[i].boxbackcolor = ColorCodes.varcolor;
                    brandsData.brands[i].boxsidecolor = ColorCodes.varcolor;
                    brandsData.brands[i].textcolor = ColorCodes.primaryColor;
                  }
                }
                setState(() {
                  _isLoading = false;
                });
                ProductController productController = ProductController();
                productController.getbrandprodutlist(brandId, 0,(isendofproduct){
                  setState(() {
                    isLoading =false;
                  });
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          });
        }
      }

      if(widget.routeArgs['fromScreen'] != "Banner")
        Provider.of<NotificationItemsList>(context, listen: false).fetchBrandsItems(brandsId).then((_) {
          final brandsData = Provider.of<NotificationItemsList>(context, listen: false);
          setState(() {
            if (brandsData.brands.length > 0) {
              for (int i = 0; i < brandsData.brands.length; i++) {
                if (i != 0) {
                  brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
                  brandsData.brands[i].textcolor = ColorCodes.grey;
                } else {
                  brandsData.brands[i].boxbackcolor = ColorCodes.varcolor;
                  brandsData.brands[i].boxsidecolor = ColorCodes.varcolor;
                  brandsData.brands[i].textcolor = ColorCodes.primaryColor;
                }
              }
              setState(() {
                _isLoading = false;
              });
              final _splitBrandID = brandId.split(',');
              final Map<int, String> _brandIdValues= {
                for (int i = 0; i < _splitBrandID.length; i++)
                  i: _splitBrandID[i]
              };

              ProductController productController = ProductController();
              productController.getbrandprodutlist(_brandIdValues[0], 0,(isendofproduct){
                setState(() {
                  isLoading =false;
                });
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          });
        });
      if(widget.routeArgs['fromScreen'] == "Banner"){
        brandsData = Provider.of<CarouselItemsList>(context, listen: false);
      } else {
        brandsData = Provider.of<NotificationItemsList>(context, listen: false);
      }// only create the future once.
    });
    super.initState();
  }

  _displayitem(String brandid, int index) {
    setState(() {
      brandId = brandid;
      endOfProduct = false;
      load = true;
      startItem = 0;
      if(widget.routeArgs['fromScreen'] == "Banner"){
        brandsData = Provider.of<CarouselItemsList>(context, listen: false);
      } else {
        brandsData = Provider.of<NotificationItemsList>(context, listen: false);
      }
      for (int i = 0; i < brandsData.brands.length; i++) {
        if (index != i) {
          brandsData.brands[i].boxbackcolor = ColorCodes.whiteColor;
          brandsData.brands[i].boxsidecolor = ColorCodes.blackColor;
          brandsData.brands[i].textcolor = ColorCodes.grey;
        } else {
          brandsData.brands[i].boxbackcolor = ColorCodes.varcolor;
          brandsData.brands[i].boxsidecolor = ColorCodes.varcolor;
          brandsData.brands[i].textcolor = ColorCodes.primaryColor;
        }
      }
      productController.getbrandprodutlist(brandid, 0,(isendofproduct){
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homedata = (VxState.store as GroceStore).homescreen;
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;

    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio =   (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 370:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 300:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170;

    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {SetCartItem},
        builder: (context, store, index) {
          final box = (VxState.store as GroceStore).CartItemList;
          if (box.isEmpty) return SizedBox.shrink();
          return BottomNaviagation(
            itemCount: CartCalculations.itemCount.toString() + " " + S .of(context).items,
            title: S .current.view_cart,
            total: VxState.store.userData.membership! == "1" ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
                :
            (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
            onPressed: (){
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
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
            icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
            onPressed: () async{
              if(widget.routeArgs['fromScreen'] == "ClickLink"){
                Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
              }
              else {
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                });
              }
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(
          S .of(context).brands,// "Brands",
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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);

            },
            child: Icon(
              Icons.search,
              size: 30.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
        if(widget.routeArgs['fromScreen'] == "ClickLink"){
          Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
        }
        else {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-screen', (Route<dynamic> route) => false);
          });
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor: ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            SizedBox(
              height: 15.0,
            ),
            (!_isLoading)?
            Container(
              child: SizedBox(
                height: 60,
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: brandsData.brands.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          _displayitem(brandsData.brands[i].id, i);
                        },
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                              color: brandsData.brands[i].boxbackcolor,
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: ColorCodes.primaryColor,
                                ),
                                bottom: BorderSide(
                                  width: 1.0,
                                  color:  ColorCodes.primaryColor,
                                ),
                                left: BorderSide(
                                  width: 1.0,
                                  color:  ColorCodes.primaryColor,
                                ),
                                right: BorderSide(
                                  width: 1.0,
                                  color:  ColorCodes.primaryColor,
                                ),
                              )),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  brandsData.brands[i].title,
                                  style: TextStyle(
                                      color: brandsData.brands[i].textcolor, fontWeight: FontWeight.bold),
                                ),
                              ],
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
            ):
            Container(height:60),
            isLoading
                ? Center(
              child: ItemListShimmer(),
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
                  child: VxBuilder (
                      mutations: {ProductMutation},
                      builder: (ctx, store,VxStatus? state) {
                        final productlist = (store as GroceStore).productlist;
                        return (productlist.length>0)?
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    GridView.builder(
                                        shrinkWrap: true,
                                        controller: new ScrollController(
                                            keepScrollOffset: false),
                                        itemCount:productlist.length,
                                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: widgetsInRow,
                                          crossAxisSpacing: 3,
                                          childAspectRatio: aspectRatio,
                                          mainAxisSpacing: 3,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return SellingItemsv2(
                                            fromScreen: "brands_screen",
                                            seeallpress: "",
                                            itemdata: productlist[index],
                                            notid: "",
                                            /*"brands_screen",

                                            "",
                                            productlist[index],
                                            "",*/
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
                              if(Vx.isWeb) Footer(
                                  address: PrefUtils.prefs!.getString("restaurant_address")!)
                            ],
                          ),

                        ):
                        SingleChildScrollView(
                          child: Container(
                            // child: Column(
                            //   children: [
                            //     Align(
                            //       alignment: Alignment.center,
                            //       child: new Image.asset(
                            //         Images.noItemImg, fit: BoxFit.fill,
                            //         height: 250.0,
                            //         width: 200.0,
                            //       ),
                            //     ),
                            //     if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!)
                            //   ],
                            // ),
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
                      })
              ),
            ),
            if(!Vx.isWeb)Container(
              height: _isOnScroll ? 50 : 0,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          ],
        ),
        bottomNavigationBar:  Vx.isWeb ? SizedBox.shrink() : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _buildBottomNavigationBar(),
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
}

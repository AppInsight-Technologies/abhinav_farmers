import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocbay/controller/mutations/home_store_mutation.dart';
import 'package:grocbay/controller/mutations/search_mutation.dart';
import 'package:grocbay/controller/mutations/store_mutation.dart';
import 'package:grocbay/models/newmodle/search_data.dart';
import 'package:grocbay/widgets/MultivendorOffersWidget.dart';

import '../../controller/mutations/cart_mutation.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/home_page_modle.dart';
import '../models/newmodle/product_data.dart';
import '../providers/branditems.dart';
import '../repository/productandCategory/category_or_product.dart';
import '../components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/features.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';

import '../services/firebaseAnaliticsService.dart';
import '../widgets/product_request.dart';
import '../widgets/simmers/item_list_shimmer.dart';
import '../blocs/search_item_bloc.dart';
import '../blocs/sliderbannerBloc.dart';

import '../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/itemslist.dart';
import '../data/calculations.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../assets/ColorCodes.dart';

class SearchStoreScreen extends StatefulWidget {
  static const routeName = '/searchitem-screen';
  String itemname = "";
  Map<String,String>? search;
  SearchStoreScreen(Map<String, String> params){
    this.search= params;
    this.itemname = params["itemname"]??"" ;
  }

  @override
  _SearchStoreScreenState createState() => _SearchStoreScreenState();
}

class _SearchStoreScreenState extends State<SearchStoreScreen> with Navigations{
  final storedata = (VxState.store as GroceStore).homestore;
  bool shimmereffect = true;
  var notificationData;
  int unreadCount = 0;
  bool checkskip = false;
  var popularSearch;
  bool _isSearchShow = false;
  bool _issearchloading = false;
  List searchDispaly = [];
  var searchData;
  String searchValue = "";
  bool _isShowItem = false;
  bool _isLoading = false;
  FocusNode _focus = new FocusNode();
  bool _isNoItem = false;
  bool _checkmembership = false;

  var _address = "";
  var _membership = "";
  ProductRepo _searshproductrepo = ProductRepo();
  var itemname;
  var itemid;
  var itemimg;
  bool iphonex = false;
  final homedata = (VxState.store as GroceStore).homescreen;
  var searchDispalyvar = [];

  bool issearchloading = true;

  Future<List<StoreSearchData>>? future;

  StateSetter? setstate;

  bool _isOnScroll =false;

  List<StoreSearchData> listitem =[];

  bool endOfProduct = false;
  bool loading = false;

  @override
  void initState() {
    bloc.SearcheditemBloc();
    sbloc.searchItemsBloc();
    Future.delayed(Duration.zero, () async {

      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      setState(() {
        if((VxState.store as GroceStore).userData.membership! == "1"){
          _checkmembership = true;
        } else {
          _checkmembership = false;
        }
      });
      if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) {
        var routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
        itemname = widget.itemname;//routeArgs['itemname'];
        itemid = routeArgs['itemid'];
        itemimg = routeArgs['itemimg'];
        _isShowItem = true;
      }
      // setstate(() {
      //   future = _searshproductrepo.getSearchQuery(itemname);
      // });

      SearchStoreScreenController(itemname: itemname,lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
          long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
      future = _searshproductrepo.getSearchStoreQuery(itemname,(VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
        (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
      print("future value...."+future.toString());
      //Provider.of<CartItems>(context,listen: false).fetchCartItems();
    });

    /*(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
        ? _focus.addListener(_onFocusChangeWeb)
        :*/ _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChangeWeb() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
        debugPrint("hello3...");
        _isShowItem = true;
        _isLoading = false;
        search(itemname);
      } else {
        _isShowItem = true;
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
        _isShowItem = false;
        _isLoading = false;
      } else {
        //_isShowItem = false;
      }
    });
  }

  search(String value) async {
    //sbloc.searchiemsof.add(value);
    /*StreamBuilder<List<SellingItemsFields>>(
      stream: sbloc.serchItems,
      builder: (context,AsyncSnapshot<List<SellingItemsFields>> snapshot){
        return ;
      },
    );*/
    _issearchloading = true;
    await Provider.of<ItemsList>(context,listen: false).fetchsearchItems(value,true).then((isdone) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _issearchloading = false;
          _isSearchShow = true;
          searchData = Provider.of<ItemsList>(context,listen: false);
          searchDispaly = searchData.searchitems.toList();
          if (searchDispaly.length <= 0) {
            _isNoItem = true;
          } else {
            _isNoItem = false;

          }

        });

      });
    });
    setstate!(() {
      itemname =value;
      SearchStoreScreenController(itemname: itemname,lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
      long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
      future = _searshproductrepo.getSearchStoreQuery(value,(VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
      (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
    });
  }

  onSubmit(String value) async {
    fas.LogSearchItem(search: value);
    //FocusScope.of(context).requestFocus(_focus);
    /*_focus = new FocusNode();
    FocusScope.of(context).requestFocus(_focus);*/
    setState(() {
      _isShowItem = true;
      _isLoading = true;
    });

    setstate!(() {
      itemname =value;
      SearchStoreScreenController(itemname: itemname,lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
          long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
      future = _searshproductrepo.getSearchStoreQuery(value,(VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
          (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focus.dispose();
    /*sbloc.dispose();
    bloc.dispose();*/
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 4;

    if (deviceWidth > 1200) {
      widgetsInRow = 3;
    } else if (deviceWidth > 768) {
      widgetsInRow = 2;
    }
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 28;
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
                /*    Navigator.of(context)
                    .pushNamed(CartScreen.routeName, arguments: {
                  "afterlogin": ""
                });*/
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
              });
            },
          );
        },
      );

    }

    return WillPopScope(
      onWillPop: (){
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ColorCodes.whiteColor,
        appBar: (ResponsiveLayout.isSmallScreen(context))?_searchContainermobile():null ,
        body: Column(children: <Widget>[
          if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false,onsearchClick: (queery){
            setstate!((){
              endOfProduct = false;
              listitem.clear();
              _isShowItem = true;
              itemname = queery;
              SearchStoreScreenController(itemname: itemname,lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                  long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
              future = _searshproductrepo.getSearchStoreQuery(queery,(VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                  (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
            });
          },),
          Expanded(
            child: NotificationListener<
                ScrollNotification>(
              // ignore: missing_return
              onNotification: (ScrollNotification scrollInfo) {
                if (!endOfProduct) if (!_isOnScroll &&
                    // ignore: missing_return
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setstate!(() {
                    _isOnScroll = true;
                    SearchStoreScreenController(itemname: itemname,lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                        long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
                    future = _searshproductrepo.getSearchStoreQuery(itemname,(VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
                        (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"),start: listitem.length);
                    future!.then((value) {
                      _isOnScroll = false;
                      if(value.isEmpty){
                        endOfProduct = true;
                      }
                    });
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                child: StatefulBuilder(
                    builder: (context,setState){
                      setstate = setState;
                      return Column(children: [
                        /// display list of search item
                        if (_isShowItem)//Show Searched Items

                          FutureBuilder<List<StoreSearchData>> (
                            future: future,
                            builder: (context,  snapshot){
                              bool shimmerloading = false;
                              switch(snapshot.connectionState){
                              // case ConnectionState.none:
                              //   // TODO: Handle this case.
                              //   break;
                                case ConnectionState.waiting:
                                  shimmerloading =listitem.isEmpty;
                                  loading = true;
                                  // TODO: Handle this case.
                                  break;
                              // case ConnectionState.active:
                              //   // TODO: Handle this case.
                              //   break;
                                case ConnectionState.done:
                                  shimmerloading =false;
                                  loading = false;
                                  // return _ListSerchItem(snapshot);
                                  // TODO: Handle this case.
                                  break;
                                default:
                                  shimmerloading =false;
                                  loading = false;
                              // return SizedBox.shrink();
                              }
                              return shimmerloading?ItemListShimmer():Column(
                                children: [
                                  _ListSerchItem(loading?null:snapshot),
                                ],
                              );
//
                            },)
                        else
                        /// display dropdown of  search item
                        //Search item list Ui
                          (ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)||
                              ResponsiveLayout.isLargeScreen(context))? Container (
                            // searchin...
                            width: MediaQuery.of(context).size.width,
                            //height: MediaQuery.of(context).size.height,
                            margin: EdgeInsets.all(8.0),
                            color: (Features.ismultivendor) ? Colors.transparent : Theme.of(context).backgroundColor,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    child: FutureBuilder<List<StoreSearchData>> (
                                        future: future,
                                        builder: (context,  snapshot){
                                          return Column(
                                            children: [
                                              if(snapshot.hasData)
                                                if (snapshot.data!.isNotEmpty)
                                                  if(_isSearchShow)
                                                    new ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data!.length,
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (_, i) => Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                             // Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":snapshot.data![i].priceVariation!.first.id!,"productId":snapshot.data![i].priceVariation!.first.menuItemId!});
                                                             /*SellingItemsv2(
                                                             fromScreen: "search_item_multivendor",
                                                             seeallpress: "",
                                                              storedsearchdata: snapshot.data![i],
                                                              notid: "",
                                                              );*/


                                                                print("clicked text serahc....");
                                                              _isLoading = true;
                                                              FocusScope.of(context)
                                                                  .requestFocus(
                                                                  new FocusNode());


                                                              /*_isLoading?ItemListShimmer():Column(
                                                               children: [
                                                                 _ListSerchItem(_isLoading?null:snapshot),
                                                               ],
                                                             );*/

                                                                //  searchValue = value;
                                                                  _isShowItem = true;
                                                                  _isLoading = true;
                                                                  // if (Vx.isWeb) onSubmit(itemname);
                                                                  // else{
                                                                  if(!_issearchloading)
                                                                    onSubmit( snapshot.data![i].itemName!);
                                                                  else{
                                                                    FocusScope.of(context).requestFocus(_focus);
                                                                  }




                                                              // onSubmit(searchValue);
                                                            },

                                                            child: Container(
                                                              padding: EdgeInsets.all(12.0),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  border: Border(
                                                                    bottom: BorderSide(
                                                                      width: 2.0,
                                                                      color: Theme.of(
                                                                          context)
                                                                          .backgroundColor,
                                                                    ),
                                                                  )),
                                                              width: MediaQuery.of(context)
                                                                  .size
                                                                  .width,
                                                              child: Text(
                                                                snapshot.data![i].itemName!,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              if(_issearchloading) LinearProgressIndicator(
                                                // color: ColorCodes.primaryColor,
                                                minHeight: 5,
                                              ),
                                              Column(
                                                children: [
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context))
                                                    Container(
                                                      padding: (Features.ismultivendor)? EdgeInsets.only(left: 5.0, right: 5.0) : EdgeInsets.only(left: 0.0, right: 0.0),
                                                      margin: (Features.ismultivendor) ? EdgeInsets.only(top: 10.0) : EdgeInsets.all(14.0),
                                                      child: (Features.ismultivendor) ? Text(
                                                       /*"Top up your daily essentials"*/S.of(context).topup_essential, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), //"Popular Searches"
                                                      ) : Text(
                                                        S
                                                            .of(context)
                                                            .popular_search, //"Popular Searches"
                                                      ),
                                                      width: double.maxFinite,
                                                    ),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context) && Features.ismultivendor)
                                                    SizedBox(height: 5,),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context) && Features.ismultivendor)
                                                  Container(
                                                    padding: (Features.ismultivendor)? EdgeInsets.only(left: 5.0, right: 5.0) : EdgeInsets.only(left: 0.0, right: 0.0),
                                                    margin: EdgeInsets.all(0.0),
                                                    child:  Text(
                                                      S.of(context).trending_area,//"Trending in your area",
                                                      style: TextStyle(color: ColorCodes.emailColor),//"Popular Searches"
                                                    ),
                                                    width: double.maxFinite,
                                                  ),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context) && Features.ismultivendor)
                                                    SizedBox(height: 15,),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context))
                                                    SizedBox(
                                                      child: VxBuilder(
                                                        mutations: {SearchStoreScreenController},
                                                        builder: (ctx, store,VxStatus? state){
                                                          final snapshot = store!.storesearch;
                                                         // print("snapshot length...."+snapshot.data!.length.toString());
                                                          //stream: bloc.featureditems,

                                                          if (snapshot!=null) {
                                                            if(Features.ismultivendor) {
                                                              return Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                              //  new GridView.builder(
                                                              //    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              //      crossAxisCount: widgetsInRow,
                                                              //      childAspectRatio: aspectRatio,
                                                              //      crossAxisSpacing: 0,
                                                              //      mainAxisSpacing: 0,
                                                              //    ),
                                                              // shrinkWrap: true,
                                                              //   physics:
                                                              //   NeverScrollableScrollPhysics(),
                                                              //   itemCount:
                                                              //   snapshot.data!.length,
                                                              //   padding: EdgeInsets.zero,
                                                              //   itemBuilder: (_, i) =>
                                                              //     GestureDetector(
                                                              //       onTap: () {
                                                              //         // Navigator.of(context).pushNamed(
                                                              //         Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":snapshot.data![i].priceVariation!.first.id!,"productId":snapshot.data![i].priceVariation!.first.menuItemId!});
                                                              //       },
                                                              //       child: Container(
                                                              //         margin: EdgeInsets.only(right: 10, bottom: 6,),
                                                              //         padding: EdgeInsets.only(left: 6, right: 6, bottom: 3, top: 3),
                                                              //           decoration: BoxDecoration(
                                                              //             borderRadius: BorderRadius.circular(2),
                                                              //             border: Border.all(color: ColorCodes.ordergreen),
                                                              //           ),
                                                              //           child: new Text(snapshot.data![i].shop!,
                                                              //           style: TextStyle(fontSize: 11),)),
                                                              //     ),
                                                              // ),
                                                                ],
                                                              );
                                                              }
                                                            else{
                                                              return new ListView.builder(
                                                                shrinkWrap: true,
                                                                physics:
                                                                NeverScrollableScrollPhysics(),
                                                                itemCount:
                                                                snapshot.data!.length,
                                                                padding: EdgeInsets.zero,
                                                                itemBuilder: (_, i) =>
                                                                    Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            // Navigator.of(context).pushNamed(
                                                                            Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":snapshot.data![i].priceVariation!.first.id!,"productId":snapshot.data![i].priceVariation!.first.menuItemId!});
                                                                          },
                                                                          child: Container(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                14.0),
                                                                            decoration:
                                                                            BoxDecoration(
                                                                                color: Colors
                                                                                    .white,
                                                                                border:
                                                                                Border(
                                                                                  bottom:
                                                                                  BorderSide(
                                                                                    width:
                                                                                    2.0,
                                                                                    color: Theme.of(context)
                                                                                        .backgroundColor,
                                                                                  ),
                                                                                )),
                                                                            width:
                                                                            MediaQuery.of(
                                                                                context)
                                                                                .size
                                                                                .width,
                                                                            child: Text(
                                                                              snapshot.data![i].shop!,
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  fontSize:
                                                                                  12.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              );
                                                            }
                                                          } else {
                                                            return SizedBox.shrink();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context) && Features.ismultivendor)
                                                    SizedBox(height: 20,),
                                                  if (ResponsiveLayout.isSmallScreen(
                                                      context) && Features.ismultivendor)
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: SizedBox(
                                                        height: ResponsiveLayout.isSmallScreen(context) ?
                                                        200: 250,
                                                        child: new ListView.builder(
                                                          padding: EdgeInsets.only(right: 15),
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: storedata.data!.featuredStores!.length,
                                                          itemBuilder: (_, i) {
                                                            return Column(
                                                                children: [
                                                                  MultivendorOffers(
                                                                    "home_screen",
                                                                    storedata.data!.featuredStores![i],
                                                                  ),
                                                                  //sellingitemData.items[i].brand,
                                                                ]


                                                            );
                                                          },
                                                        )),
                                                  ),

                                                ],
                                              )
                                            ],
                                          );
                                        }
                                    ),
                                  ),
                                ]),
                          ) : SizedBox.shrink(),
                      ]);}
                ),
              ),
            ),
          )
        ]),
        bottomNavigationBar: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
            ? SizedBox.shrink()
            : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  _searchContainermobile() {
    return PreferredSize(
      preferredSize: Size.fromHeight(120),
      child: Container(child:  (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?
      Opacity(
          opacity: 0.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.topRight,
                colors:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context)) ?[Colors.transparent,Colors.transparent]:[
                  IConstants.isEnterprise && !Features.ismultivendor && !Features.isWebTrail?ColorCodes.primaryColor:ColorCodes.appbarColor,
                  IConstants.isEnterprise && !Features.ismultivendor && !Features.isWebTrail?ColorCodes.accentColor:ColorCodes.appbarColor
                  /*Theme.of(context).primaryColor,
                  Theme.of(context).accentColor*/
                ],
              ),
            ),
            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Theme.of(context).buttonColor,
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                  Text(
                    S .of(context).search_product,//"Search Products",
                    style: TextStyle(color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Colors.white, fontSize: 18.0),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height:2,

                //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(
                          color: (Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent:Colors.grey.withOpacity(0.5), width: 1.0),
                      color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: ColorCodes.whiteColor,
                    ),
                    child: Row(children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: Colors.grey,
                        ), onPressed: () {  },
                      ),
                      Container(
                        //margin: EdgeInsets.only(bottom: 30.0),
                          width: MediaQuery.of(context).size.width * 50 / 100,
                          child: TextField(
                              autofocus: true,
                              //controller: (Vx.isWeb)?TextEditingController(text:itemname):null,
                              textInputAction: TextInputAction.search,
                              focusNode: _focus,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding:
                                EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                hintText: S .of(context).type_to_search_product,//"Type to search products",
                              ),
                              onSubmitted: (value) {
                                searchValue = value;
                                _isShowItem = true;
                                _isLoading = true;
                                // if (Vx.isWeb) onSubmit(itemname);
                                // else{
                                if(!_issearchloading)
                                  onSubmit(value);
                                else{
                                  FocusScope.of(context).requestFocus(_focus);
                                }
                                // }
                              },
                              onChanged: (String newVal) {
                                setState(() {
                                  searchValue = newVal;

                                  if (newVal.length == 0) {
                                    _isSearchShow = false;
                                  } else if (newVal.length == 2) {
                                    //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                                    //search(newVal);
                                  } else if (newVal.length >= 3) {
                                    debugPrint("hello1...");
                                    search(newVal);
                                  }
                                });
                              })),
                    ])),
              ),
            ]),
          )):
      Material(
        elevation: (IConstants.isEnterprise)?0:1,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.topRight,
                colors:[
                  IConstants.isEnterprise && !Features.ismultivendor && !Features.isWebTrail && !Features.ismultivendor ? ColorCodes.accentColor:ColorCodes.appbarColor,
                  IConstants.isEnterprise && !Features.ismultivendor && !Features.isWebTrail && !Features.ismultivendor ?ColorCodes.primaryColor:ColorCodes.appbarColor
                  /*ColorCodes.accentColor,
                  ColorCodes.primaryColor*/
                ],
              ),
            ),

            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Column(
                children: <Widget>[
              if(Features.ismultivendor)
              SizedBox(
                height: 30.0,
              ),
              if(!Features.ismultivendor)
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color:IConstants.isEnterprise && !Features.ismultivendor ? ColorCodes.whiteColor:ColorCodes.blackColor,
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                    },
                  ),
                  Text(
                    S .of(context).search_product,//"Search Products",
                    style: TextStyle(color: IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.menuColor:ColorCodes.iconColor, fontSize: 18.0),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width,
                height: (Features.ismultivendor)? 50 : 40.0,

                //padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                padding: (Features.ismultivendor)? EdgeInsets.only(left: 15.0, right: 15.0) : EdgeInsets.only(left: 10.0, right: 10.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.circular(8.0),
                      border: Border.all(
                          color: ColorCodes.grey, width: 1.0 ),
                      color: ColorCodes.whiteColor,
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color:IConstants.isEnterprise && !Features.ismultivendor ? ColorCodes.whiteColor:ColorCodes.blackColor,
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                        },
                      ),
                      Container(
                        //margin: EdgeInsets.only(bottom: 30.0),
                          width: MediaQuery.of(context).size.width * 80 / 100,
                          child: TextField(
                            style: TextStyle(fontSize:  18.0,
                                color: ColorCodes.blackColor,
                                fontWeight: FontWeight.bold
                            ),
                              autofocus: true,
                              maxLines: 1,
                              //controller: (Vx.isWeb)?TextEditingController(text:itemname):null,
                              textInputAction: TextInputAction.search,
                              focusNode: _focus,

                              onTap: (){
                                listitem.clear();
                                _isShowItem = false;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding:
                                EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 14.0),
                                hintText: (Features.ismultivendor) ? /*"Search stores and products" */ S.of(context).search_store: S .of(context).type_to_search_product,//"Type to search products",
                              ),
                              onSubmitted: (value) {
                                //searchValue = value;

                                if (Vx.isWeb) onSubmit(itemname);
                                else{
                                  endOfProduct = false;
                                  if(!_issearchloading)
                                    onSubmit(value);
                                  else{
                                    FocusScope.of(context).requestFocus(_focus);
                                  }
                                }
                              },
                              onChanged: (String newVal) {
                                setState(() {
                                  searchValue = newVal;

                                  if (newVal.length == 0) {
                                    _isSearchShow = false;
                                  } else if (newVal.length == 2) {
                                    //Provider.of<ItemsList>(context,listen: false).fetchsearchItems(newVal);
                                    //search(newVal);
                                  } else if (newVal.length >= 3) {
                                    debugPrint("hello2...");
                                    search(newVal);
                                  }
                                });
                              })),
                    ])),
              ),
            ])),
      ),),
    );
  }
  Widget _ListSerchItem([AsyncSnapshot<List<StoreSearchData>>? snapshot]) {
    //print("snapshot data..."+snapshot!.data!.length.toString());
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 370:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 330 : Features.btobModule?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 310:(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 250;
    if(snapshot==null && listitem.isEmpty) return SizedBox.shrink();
    else{
      //listitem.clear();
      //return SizedBox.shrink();
     // print("snapshot data..."+snapshot.data!.length.toString());
      if( snapshot!=null ) {
        listitem.addAll(snapshot.data!);
        snapshot.data!.clear();
      }
      if (listitem.length <= 0) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.65,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: new Image.asset(
//                   Images.noItemImg,
//                   fit: BoxFit.fill,
//                   height: 250.0,
//                   width: 200.0,
// //                    fit: BoxFit.cover
//                 ),
//               ),
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
              ],
            )
        );//ItemListShimmer();
      }else{
        return  Column(
          children: [
            GridView.builder(
                padding: EdgeInsets.only(top: 5.0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: listitem.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 13, top:5, bottom: 10, right: 13),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: ColorCodes.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ColorCodes.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          )
                        ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listitem[index].shop!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize:  20.0,
                                      color: ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  listitem[index].location!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorCodes.grey,
                                    /*fontWeight: FontWeight.bold*/),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(Images.starimg,
                                          height: 12,
                                          width: 12,
                                          color: ColorCodes.darkthemeColor),
                                      SizedBox(width: 3,),
                                      Text(
                                          listitem[index].ratings!.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: ColorCodes.darkthemeColor),
                                      ),
                                      SizedBox(width: 15,),
                                      Icon(Icons.info, color: ColorCodes.lightGreyColor, size: 6),
                                      SizedBox(width: 15,),
                                      Text(
                                        listitem[index].distance!.toStringAsFixed(2) +
                                           /* " Km"*/S.of(context).km,
                                        style: TextStyle(
                                            fontSize: 11, color: ColorCodes.greyColord),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color:IConstants.isEnterprise && !Features.ismultivendor ? ColorCodes.whiteColor:ColorCodes.blackColor,
                                ),
                                onPressed: () {
                                  String prevbranch = PrefUtils.prefs!.getString("branch")!;
                                  PrefUtils.prefs!.setString("prevbranch", prevbranch);
                                  print("store tap..."+prevbranch.toString()+"....."+PrefUtils.prefs!.getString("prevbranch")!);
                                  PrefUtils.prefs!.setString("branch",listitem[index].branchId!.toString());
                                  print("store tap...branch"+listitem[index].branchId!.toString()+"....."+PrefUtils.prefs!.getString("branch")!);
                                  GroceStore store = VxState.store;
                                  store.homescreen.data = null;
                                  IConstants.storename = listitem[index].shop.toString();
                                  Navigation(context,name: Routename.Home,navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        "title":listitem[index].shop.toString(),
                                        "distance":listitem[index].distance!.toStringAsFixed(2),
                                        "restloc":listitem[index].location!.toString(),
                                        "ratings":listitem[index].ratings!.toStringAsFixed(2),
                                        "product_count":listitem[index].menuItemCount.toString(),
                                      });

                                  print("store tap...branch"+prevbranch.toString()+"....."+PrefUtils.prefs!.getString("branch")!);

                                  BrandItemsList().GetRestaurantNew(PrefUtils.prefs!.getString("branch")!,()async {
                                  });

                                },
                              ),
                            ],),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DottedLine(
                            dashColor: ColorCodes.lightgrey,
                            lineThickness: 1.0,
                            dashLength: 2.0,
                            dashRadius: 0.0,
                            dashGapLength: 1.0),
                        SizedBox(
                          height: 5,
                        ),
                        SellingItemsv2(
                          fromScreen: "search_item_multivendor",
                            seeallpress: "",
                            storedsearchdata: listitem[index],
                            notid: "",
                            /*"search_item", "", listitem[index],""*/),
                      ],
                    ),
                  );
                }),
            if(loading)
              Container(
                height: 50,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            if(endOfProduct) if(endOfProduct) Features.suggestproduct ?
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
            if (Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        );
      }
    }
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
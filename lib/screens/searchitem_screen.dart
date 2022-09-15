import 'package:cached_network_image/cached_network_image.dart';

import '../../controller/mutations/cart_mutation.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/home_page_modle.dart';
import '../models/newmodle/product_data.dart';
import '../repository/productandCategory/category_or_product.dart';
import '../components/sellingitem_component.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/features.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../widgets/bottom_navigation.dart';

import '../services/firebaseAnaliticsService.dart';
import '../widgets/categoryOne.dart';
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

class SearchitemScreen extends StatefulWidget {
  static const routeName = '/searchitem-screen';
  String itemname = "";
  Map<String,String>? search;
  SearchitemScreen(Map<String, String> params){
    this.search= params;
    this.itemname = params["itemname"]??"" ;
  }

  @override
  _SearchitemScreenState createState() => _SearchitemScreenState();
}

class _SearchitemScreenState extends State<SearchitemScreen> with Navigations{
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
  final homedata = (VxState.store as GroceStore).homescreen;

  var _address = "";
  var _membership = "";
  ProductRepo _searshproductrepo = ProductRepo();
  var itemname;
  var itemid;
  var itemimg;
  bool iphonex = false;

  var searchDispalyvar = [];

  bool issearchloading = true;

  Future<List<ItemData>>? future;

  StateSetter? setstate;

  bool _isOnScroll =false;

  List<ItemData> listitem =[];

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
      future = _searshproductrepo.getSearchQuery(itemname);
    });
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChangeWeb() {
    setState(() {
      if (_focus.hasFocus.toString() == "true") {
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
      future = _searshproductrepo.getSearchQuery(value);
    });
  }

  onSubmit(String value) async {
    fas.LogSearchItem(search: value);
    setState(() {
      _isShowItem = true;
      _isLoading = true;
    });

    setstate!(() {
      itemname =value;
      future = _searshproductrepo.getSearchQuery(value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focus.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    _buildBottomNavigationBar() {
      return VxBuilder(
        mutations: {SetCartItem},
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

    return WillPopScope(
      onWillPop: (){
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
              future = _searshproductrepo.getSearchQuery(queery);
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
                    future = _searshproductrepo.getSearchQuery(itemname,start: listitem.length);
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
                child: Container(
                  constraints:(Vx.isWeb &&
                      !ResponsiveLayout.isSmallScreen(context))
                      ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90)
                      : null,
                  child: StatefulBuilder(
                      builder: (context,setState){
                        setstate = setState;
                        return Column(children: [
                          /// display list of search item
                          if (_isShowItem)//Show Searched Items

                            FutureBuilder<List<ItemData>> (
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
                              //color: Theme.of(context).backgroundColor,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    SizedBox(
                                      child: FutureBuilder<List<ItemData>> (
                                          future: future,
                                          builder: (context,  snapshot){
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
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
                                                                Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":snapshot.data![i].type == "1"? snapshot.data![i].id!:snapshot.data![i].priceVariation!.first.menuItemId!,"productId":snapshot.data![i].type == "1"? snapshot.data![i].id!:snapshot.data![i].priceVariation!.first.menuItemId!});
                                                                _isLoading = true;
                                                                FocusScope.of(context)
                                                                    .requestFocus(
                                                                    new FocusNode());
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
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    if (ResponsiveLayout.isSmallScreen(
                                                        context))
                                                      Container(
                                                        margin: EdgeInsets.only(bottom: 10),
                                                        child: Text(
                                                          S.of(context).popular_search,//"Popular Searches"
                                                          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
                                                        ),
                                                        width: double.maxFinite,
                                                      ),
                                                    if (ResponsiveLayout.isSmallScreen(
                                                        context))
                                                      SizedBox(
                                                        child: VxBuilder(
                                                          mutations: {HomeScreenController},
                                                          builder: (ctx, store,VxStatus? state){
                                                            final snapshot = store!.homescreen.data!.featuredByCart;
                                                            //stream: bloc.featureditems,

                                                            if (snapshot!=null) {
                                                              return Wrap(
                                                                spacing:8.0,
                                                                runSpacing: 8.0,
                                                                children: snapshot.data!.map<Widget>((e) =>
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        // Navigator.of(context).pushNamed(
                                                                        Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid":e.priceVariation!.first.menuItemId!,"productId":e.priceVariation!.first.menuItemId!});
                                                                      },
                                                                      child: Container(
                                                                        padding: EdgeInsets.all(6),
                                                                        color: ColorCodes.varcolor,
                                                                        child: Text(e.itemName!,
                                                                          style: TextStyle(
                                                                              color: ColorCodes.primaryColor,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize:
                                                                              12.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ).toList(),
                                                              );
                                                            } else {
                                                              return SizedBox.shrink();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(height: 25,),
                                                if(Features.isCategoryOne)
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          S.of(context).trending,//"Trending"
                                                          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
                                                        ),
                                                        if(Features.isCategoryOne)CategoryOne(
                                                            homedata),
                                                      ],
                                                    ),
                                                  ),

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
                          width: MediaQuery.of(context).size.width * 50 / 100,
                          child: TextField(
                              autofocus: true,
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
                                if(!_issearchloading)
                                  onSubmit(value);
                                else{
                                  FocusScope.of(context).requestFocus(_focus);
                                }
                              },
                              onChanged: (String newVal) {
                                setState(() {
                                  searchValue = newVal;

                                  if (newVal.length == 0) {
                                    _isSearchShow = false;
                                  } else if (newVal.length == 2) {
                                  } else if (newVal.length >= 3) {
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
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ],
              ),
            ),

            //color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            height: 160.0,
            child: Column(children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorCodes.iconColor,
                    ),
                    onPressed: () {
                      (Features.ismultivendor)?
                      Navigator.of(context).pop():
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                    },
                  ),
                  Text(
                    S .of(context).search_product,//"Search Products",
                    style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                padding: EdgeInsets.only(left: 12.0, right: 12.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color:(Vx.isWeb&&!ResponsiveLayout.isSmallScreen(context))?Colors.transparent: ColorCodes.lightsteelblue,
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: ColorCodes.primaryColor,
                        ), onPressed: () {  },
                      ),
                      Container(
                        //margin: EdgeInsets.only(bottom: 30.0),
                          width: MediaQuery.of(context).size.width * 80 / 100,
                          child: TextField(
                              autofocus: true,
                              maxLines: 1,
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
                                hintText: S .of(context).type_to_search_product,//"Type to search products",
                              ),
                              onSubmitted: (value) {
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
                                  } else if (newVal.length >= 3) {
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
  Widget _ListSerchItem([AsyncSnapshot<List<ItemData>>? snapshot]) {
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 1;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth > 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ?
    (Features.isSubscription)?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 335:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 310 :  (!Features.ismultivendor) ? (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 170 : Features.btobModule?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 210:(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 140;
    if(snapshot==null && listitem.isEmpty) return SizedBox.shrink();
    else{
      //listitem.clear();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: new Image.asset(
                  Images.noItemImg,
                  fit: BoxFit.fitHeight,
                  height: 200.0,
//                    fit: BoxFit.cover
                ),
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
          ),
        );//ItemListShimmer();
      }else{
        return  Column(
          children: [
            GridView.builder(
                padding: EdgeInsets.only(top: 10.0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: listitem.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return SellingItemsv2(
                    fromScreen: "search_item",
                    seeallpress: "",
                    itemdata: listitem[index],
                    notid: "",
                  );
                }),
            if(loading)
              Container(
                height: 50,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            if(endOfProduct) Features.suggestproduct ?
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
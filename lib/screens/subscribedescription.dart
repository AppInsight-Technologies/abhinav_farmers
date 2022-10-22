

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../controller/mutations/subscription_mutation.dart';
import '../generated/l10n.dart';
import '../helper/custome_calculation.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/subscription_data.dart';
import '../models/newmodle/user.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/SliderShimmer.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/header.dart';
import '../widgets/productWidget/item_badge.dart';
import '../widgets/simmers/ItemWeb_shimmer.dart';
import '../widgets/simmers/item_list_shimmer.dart';

class SubscribeDescription extends StatefulWidget{
  String index ="";
  String subscriptionid = "";
  SubscribeDescription(Map<String, String> params){
    this.index = params["index"]??"";
    this.subscriptionid = params["subscription_id"]??"";

  }
  @override
  _SubscribeDescriptionState createState() => _SubscribeDescriptionState();

}

class _SubscribeDescriptionState extends State<SubscribeDescription> with Navigations {
  bool _isWeb =false;
  bool iphonex = false;
  bool loading =true;
  String address = "";
  String itemImage = "";
  String boxDescreiption = "";
  String subscriptiontype = "";
  String boxName = "";
  String itemid = "";
  late UserData addressdata;
  String Customername = "";
  bool checkaddress = false;
  int _selectedIndex = 0;
   Future<List<SubscriptionBoxData>> _subscription = Future.value([]);
  Map<String, List<SubscriptionBoxData>>? newMap;
  List<Products> productsdata = [];
  List<BoxProducts> finalList = [];
  String _price = "";
  String _mrp = "";
  var _checkmembership = false;
  var margins;
  bool isLoading = true;
  var promoData;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //  productBoxSub = Hive.box<Subscription>(productBoxNameSub);
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

      SubscriptionBoxController(type: "all",
          branch: PrefUtils.prefs!.getString("branch"),
          languageid: IConstants.languageId,
          user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
              .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
          subscription_id: widget.subscriptionid.toString());




      // subscriptionApibox.getSubsctiptionBoxID(ParamBodyDatabox(type: "all",
      //     branch: PrefUtils.prefs!.getString("branch"),
      //     languageid: IConstants.languageId,
      //     user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
      //         .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
      //   subscription_id: widget.subscriptionid.toString()
      // ),
      // )
      //     .then((value) {
      //
      //   setState(() {
      //     _subscription = Future.value(value);
      //   });
      //
      //   print("subscription id..."+widget.subscriptionid.toString());
      //   print("subscription.....data " + _subscription.toString());
      //   _subscription.then((value) {
      //     itemImage = value[int.parse(widget.index)].featuredImage!;
      //     boxDescreiption =
      //     value[int.parse(widget.index)].subscriptionboxDescription!;
      //     subscriptiontype =  value[int.parse(widget.index)].subscriptionType!;
      //     boxName = value[int.parse(widget.index)].boxName!;
      //     itemid = value[int.parse(widget.index)].id!;
      //     addressdata = (VxState.store as GroceStore).userData;
      //     if (addressdata.billingAddress!.length <= 0) {
      //       setState(() {
      //         checkaddress = true;
      //         print("jwehdgb" + checkaddress.toString());
      //         loading = false;
      //       });
      //     } else {
      //       setState(() {
      //         address = addressdata.billingAddress![0].address.toString();
      //         Customername = addressdata.billingAddress![0].fullName.toString();
      //         debugPrint("address..." + address + " " + Customername);
      //         loading = false;
      //       });
      //     }
      //
      //   });
      //
      //
      // });
      super.initState();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bottomNavigationbar() {
      String channel = "";
      try {
        if (Platform.isIOS) {
          channel = "IOS";
        } else {
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }
      return  loading /*&& loader*/?
      BottomNaviagation(
        itemCount: "0",
        title: S .current.subscribe,
        total: "0",
        onPressed: (){
          setState(() {

          });
        },
      ):
      BottomNaviagation(
        itemCount: "0",
        title: S .current.subscribe,
        total: "0",
        onPressed: (){
          setState(() {

            if(address == ""){
              Fluttertoast.showToast(msg: S .current.please_add_delivery_address);
            }else{
              Navigation(context,
                  name: Routename.SubscribeScreen,
                  navigatore: NavigatoreTyp.Push,
                  qparms: {
                    "itemid": itemid,
                    "index": widget.index,
                    //"items": promoData[i].boxProducts,
                    "fromScreen": "home",
                    "addressid": "",
                    "useraddtype": "",
                    "startDate": "",
                    "endDate": "",
                    "itemCount": "",
                    "deliveries": "",
                    "total": "",
                    "schedule": "",
                    "itemimg": "",
                    "itemname": "",
                    "varprice": "",
                    "varname": "",
                    "address": "",
                    "paymentMode": "",
                    "cronTime": "",
                    "name": "",
                    "varid": "",
                    "varmrp": "",
                    "brand": "",
                    "deliveriesarray": "",
                    "daily": "",
                    "dailyDays": "",
                    "weekend": "",
                    "weekendDays": "",
                    "weekday": "",
                    "weekdayDays": "",
                    "custom": "",
                    "customDays": "",
                    "subscriptionType" : subscriptiontype,
                  });
            }
          });
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
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async {
              // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              Navigation(context, navigatore: NavigatoreTyp.homenav);
              // Navigator.of(context).pop();
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(boxName,
          style: TextStyle(color: ColorCodes.iconColor,fontWeight: FontWeight.bold),),
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


    return WillPopScope(
      onWillPop: (){
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        // Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold (
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor:  ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            Flexible(child: DescriptionBox()),

          ],
        ),
        bottomNavigationBar:(_isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox.shrink(): bottomNavigationbar(),
      ),
    );


  }
  DescriptionBox(){
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

    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom:5),
      width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                  imageUrl: itemImage,
                  placeholder: (context, url) {
                    return SliderShimmer().sliderShimmer(context, height: 220);
                  },
                  errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                  fit: BoxFit.fitWidth),
              SizedBox(height: 10,),
              Text(/*boxName + " " + */S.of(context).description/*"Description"*/, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,),),
              SizedBox(height: 6,),
              Text(boxDescreiption, style: TextStyle(fontSize: 14,),),
              SizedBox(height: 10,),
              Text(S.of(context).select_menu_pref,style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18,
              ),),
              SizedBox(height: 10,),


    VxBuilder(
    mutations: {SubscriptionBoxController},
    builder: (ctx, store,VxStatus? state) {
      promoData = store!.subscriptionboxlist[0].boxProducts;
      productsdata.clear();
      productsdata = promoData!
          .where((map) => map.label == promoData[_selectedIndex].label)
          .first
          .products!
          .toList();
      print("product bix lengthh....."+productsdata.length.toString());
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              controller: new ScrollController(keepScrollOffset: false),
              itemCount: promoData.length,
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: ()  {
                    setState(()  {
                      if(_selectedIndex == i){
                        _selectedIndex= 0;
                      }else{
                        _selectedIndex= i;
                      }
                      print("promo data selected..."+promoData[i].label.toString());
                      print("promo data ...."+promoData.where(
                              (x) => x.label == promoData[i].label
                      ).toList().length.toString());

                      productsdata.clear();
                      productsdata = promoData
                          .where((map) => map.label == promoData[i].label)
                          .first
                          .products!
                          .toList();

                      print("dynamic21...." + productsdata.toString() +
                          "length..." + productsdata.length.toString());
                    });

                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                    margin: EdgeInsets.only(left: 8.0, top: 5.0, right: 2.0, bottom: 5.0),
                    decoration: new BoxDecoration(
                        color: i == _selectedIndex ? ColorCodes.primaryColor:ColorCodes.whiteColor,
                        border: Border.all(color: i == _selectedIndex ? ColorCodes.primaryColor:ColorCodes.emailColor),
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(5.0),)),
                    child: Center(
                      child: Text(promoData[i].label.toString(),
                        maxLines: 2,
                        style:
                        TextStyle(
                            color: i == _selectedIndex ? ColorCodes.whiteColor:ColorCodes.emailColor,
                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
                        (productsdata != null && productsdata.length > 0) ?
              GridView.builder(
                shrinkWrap: true,
                itemCount:productsdata.length,
                controller: new ScrollController(keepScrollOffset: false),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  crossAxisSpacing: 3,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
print("product data length.....grid,..."+productsdata.length.toString());
                  double margins;

                  margins = (productsdata[index].type == "1") ? Calculate().getmargin(
                      productsdata[index].mrp.toString(),
                      productsdata[index].price.toString()) :
                  Calculate().getmargin(productsdata[index].priceVariation![index].mrp.toString(),
                      productsdata[index].priceVariation![index].price.toString());

                  if(_checkmembership) { //Membered user
                    if(productsdata[index].type == "1") {  //SingleSku item
                      if (productsdata[index].membershipDisplay!) { //Eligible to display membership price
                        _price = productsdata[index].membershipPrice!.toString();
                        _mrp = productsdata[index].mrp!.toString();
                      } else if (productsdata[index].discointDisplay!) { //Eligible to display discounted price
                        _price = productsdata[index].price!.toString();
                        _mrp = productsdata[index].mrp!.toString();
                      } else { //Otherwise display mrp
                        _price = productsdata[index].mrp!.toString();
                      }
                    }
                    else{ //multisku
                      if (productsdata[index].priceVariation![index]
                          .membershipDisplay!) { //Eligible to display membership price
                        _price = productsdata[index].priceVariation![ index].membershipPrice!.toString();
                        _mrp = productsdata[index].priceVariation![ index].mrp!.toString();
                      } else if (productsdata[index].priceVariation![ index]
                          .discointDisplay!) { //Eligible to display discounted price
                        _price = productsdata[index].priceVariation![ index].price!.toString();
                        _mrp = productsdata[index].priceVariation![index].mrp!.toString();
                      } else { //Otherwise display mrp
                        _price = productsdata[index].priceVariation![index].mrp!.toString();
                      }
                    }
                  } else { //Non membered user

                    if(productsdata[index].type == "1") { //singlesku
                      if(productsdata[index].discointDisplay!){ //Eligible to display discounted price
                        _price = productsdata[index].price!.toString();
                        _mrp = productsdata[index].mrp!.toString();
                      } else { //Otherwise display mrp
                        _price = productsdata[index].mrp!.toString();
                      }
                    }
                    else{ //multisku
                      if(productsdata[index].priceVariation![index].discointDisplay!){ //Eligible to display discounted price
                        _price = productsdata[index].priceVariation![index].price!.toString();
                        _mrp = productsdata[index].priceVariation![index].mrp!.toString();
                      } else { //Otherwise display mrp
                        _price = productsdata[index].priceVariation![index].mrp!.toString();
                      }
                    }

                  }
                  if(Features.iscurrencyformatalign) {
                    _price = '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
                    if(_mrp != "")
                      _mrp = '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
                  } else {
                    _price = IConstants.currencyFormat + '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ';
                    if(_mrp != "")
                      _mrp =  IConstants.currencyFormat + '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ';
                  }
                  print("image ...."+productsdata[index].itemFeaturedImage.toString());
                  return  productsdata[index].type=="1"?
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width / 2) - 75,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  ItemBadge(
                                    outOfStock: productsdata[index].stock!<=0?OutOfStock(singleproduct: false,):null,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});

                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: productsdata[index].itemFeaturedImage,
                                              errorWidget: (context, url, error) => Image.asset(
                                                Images.defaultProductImg,
                                                width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              ),
                                              placeholder: (context, url) => Image.asset(
                                                Images.defaultProductImg,
                                                width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              ),
                                              width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              //  fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5,),
                        Column(
                          mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) + 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // Container(
                                          //   child: Row(
                                          //     children: <Widget>[
                                          //       Expanded(
                                          //         child: Text(
                                          //           productsdata[index].brand!,
                                          //           style: TextStyle(
                                          //               fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(height: 4,),
                                          Container(
                                            height:38,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    productsdata[index].itemName!,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      //fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),



                                          Container(
                                              child: Row(
                                                children: <Widget>[
                                                  new RichText(
                                                    text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
//
                                                        new TextSpan(
                                                            text: _price,
                                                            style: new TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: _checkmembership?ColorCodes.primaryColor:Colors.black,
                                                              fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                                        new TextSpan(
                                                            text: _mrp,
                                                            style: TextStyle(
                                                              decoration:
                                                              TextDecoration.lineThrough,
                                                              fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                          SizedBox(height: 4,),


                                        ],
                                      )),
                                  Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 4.5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          if(Features.isLoyalty)
                                            (double.parse(productsdata[index].loyalty.toString()) > 0)?
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(Images.coinImg,
                                                    height: 12.0,
                                                    width: 15.0,),
                                                  SizedBox(width: 2),
                                                  Text(productsdata[index].loyalty.toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize:11),),
                                                ],
                                              ),
                                            ):SizedBox(height: 10,),
                                          SizedBox(height: 4,),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            (Features.netWeight && productsdata[index].vegType == "fish")?
                            Container(
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2) + 70,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        Features.iscurrencyformatalign?
                                        /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                            productsdata[index].salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                                        /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                            productsdata[index].salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                                        style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                                productsdata[index].weight!,
                                                style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                            ),
                                          ),
                                          Container(
                                            child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                                productsdata[index].netWeight!,
                                                style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ): SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ):
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
                    child: Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ItemBadge(
                                outOfStock: productsdata[index].priceVariation![index].stock!<=0?OutOfStock(singleproduct: false,):null,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (productsdata[index].priceVariation![index].stock !>= 0)
                                          Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": productsdata[index].priceVariation![index].menuItemId.toString(),"productId": productsdata[index].priceVariation![index].menuItemId.toString()});
                                        else
                                          Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": productsdata[index].priceVariation![index].menuItemId.toString(),"productId": productsdata[index].priceVariation![index].menuItemId.toString()});

                                      },
                                      child:  Stack(
                                        children: [

                                          Container(
                                            margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: productsdata[index].priceVariation![index].images!.length<=0?productsdata[index].itemFeaturedImage:productsdata[index].priceVariation![index].images![0].image,
                                              errorWidget: (context, url, error) => Image.asset(
                                                Images.defaultProductImg,
                                                width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              ),
                                              placeholder: (context, url) => Image.asset(
                                                Images.defaultProductImg,
                                                width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                                height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              ),
                                              width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                              //  fit: BoxFit.fill,
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5,),
                        Column(
                          mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) + 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: Features.btobModule?(MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1.5):(MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          SizedBox(height: 5),
                                          Container(
                                            height:38,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    Features.btobModule?productsdata[index].itemName! + "-" + productsdata[index].priceVariation![0].variationName!:productsdata[index].itemName!,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      //fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          // ( productsdata[index].priceVariation!.length > 1)?
                                          // Container(
                                          //   width: (MediaQuery
                                          //       .of(context)
                                          //       .size
                                          //       .width / 3),
                                          //   child:   Row(
                                          //     children: [
                                          //       Container(
                                          //         width: (MediaQuery
                                          //             .of(context)
                                          //             .size
                                          //             .width /3),
                                          //         child: (productsdata[index].priceVariation!.length > 1)
                                          //             ? GestureDetector(
                                          //           onTap: () {
                                          //             setState(() {
                                          //               //showoptions1();
                                          //             });
                                          //           },
                                          //           child: Row(
                                          //             mainAxisAlignment: MainAxisAlignment.start,
                                          //             crossAxisAlignment: CrossAxisAlignment.start,
                                          //             children: [
                                          //               Container(
                                          //                 height: 20,
                                          //                 child: Text(
                                          //                   "${productsdata[index].priceVariation![index].variationName}"+" "+"${productsdata[index].priceVariation![index].unit}",
                                          //                   style:
                                          //                   TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
                                          //                 ),
                                          //               ),
                                          //               //SizedBox(width: 10,),
                                          //               Icon(
                                          //                 Icons.keyboard_arrow_down,
                                          //                 color: ColorCodes.darkgreen,
                                          //                 size: 20,
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         )
                                          //             : Row( mainAxisSize: MainAxisSize.max,
                                          //           children: [
                                          //             Expanded(
                                          //               child: Container(
                                          //                 height: 40,
                                          //                 child: Text(
                                          //                   "${productsdata[index].priceVariation![index].variationName}"+" "+"${productsdata[index].priceVariation![index].unit}",
                                          //                   style: TextStyle(color: ColorCodes.greyColor,fontWeight: FontWeight.bold),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //
                                          //     ],
                                          //   ),
                                          // ):SizedBox(height:20),
                                          SizedBox(
                                            height: 4,
                                          ),


                                          Container(
                                              child: Row(
                                                children: <Widget>[
                                                  if(!Features.btobModule)
                                                    if(!Features.btobModule)
                                                      new RichText(
                                                        text: new TextSpan(
                                                          style: new TextStyle(
                                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                                            color: Colors.black,
                                                          ),
                                                          children: <TextSpan>[
                                                            new TextSpan(
                                                                text: _price,
                                                                style: new TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: _checkmembership?ColorCodes.primaryColor:Colors.black,
                                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                                            new TextSpan(
                                                                text: _mrp,
                                                                style: TextStyle(
                                                                  decoration:
                                                                  TextDecoration.lineThrough,
                                                                  fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                                          ],
                                                        ),
                                                      ),

                                                ],
                                              )),

                                          SizedBox(
                                            height: 4,
                                          ),
                                          //:SizedBox.shrink(),

                                        ],
                                      )),
                                  !Features.btobModule?
                                  Spacer():SizedBox.shrink(),
                                  !Features.btobModule?
                                  Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width / 4.7),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          if(Features.isLoyalty)
                                            (double.parse(productsdata[index].priceVariation![index].loyalty.toString()) > 0)?
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(Images.coinImg,
                                                    height: 12.0,
                                                    width: 15.0,),
                                                  SizedBox(width: 2),
                                                  Text(productsdata[index].priceVariation![index].loyalty.toString(),
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                ],
                                              ),
                                            ):SizedBox(height: 10,),
                                          SizedBox(height: 4),

                                          SizedBox(height: 10,),

                                        ],
                                      )):SizedBox.shrink(),
                                ],
                              ),
                            ),
                            SizedBox(height: 3),

                            if(Features.netWeight && productsdata[index].vegType == "fish")
                              Container(
                                width: (MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2) + 70,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          Features.iscurrencyformatalign?
                                          /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
                                              productsdata[index].salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
                                          /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
                                              productsdata[index].salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
                                          style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
                                                  productsdata[index].priceVariation![index].weight!,
                                                  style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                              ),
                                            ),
                                            Container(
                                              child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
                                                  productsdata[index].priceVariation![index].netWeight!,
                                                  style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );

                },
              ):SizedBox.shrink(),

        ],
      );

    }),


//               FutureBuilder<List<SubscriptionBoxData>>(
//                   future: _subscription,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<List<SubscriptionBoxData>> snapshot) {
//                     final promoData = snapshot.data![0].boxProducts;
//                     print("promodata ...length..."+promoData!.length.toString());
//                     print("promo data ....initial"+promoData.where(
//                             (x) => x.label == promoData[0].label
//                     ).toList().length.toString());
//                     productsdata.clear();
//                     productsdata = promoData.where((map)=>map.label == promoData[0].label).first.products!.toList();
//                     print("dynamic21...."+productsdata.toString() +"length..."+productsdata.length.toString()) ;
//
//     switch(snapshot.connectionState) {
//       case ConnectionState.none:
//         return SizedBox.shrink();
//         // TODO: Handle this case.
//         break;
//       case ConnectionState.waiting:
//         return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
//             ? ItemListShimmerWeb()
//             : ItemListShimmer();
//     // TODO: Handle this case.
//       default:
//         if(promoData != null && promoData.length > 0) {
//           return SizedBox(
//             height: 50,
//             child: ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               controller: new ScrollController(keepScrollOffset: false),
//               itemCount: promoData.length,
//               itemBuilder: (_, i) {
//                 return GestureDetector(
//                   onTap: ()  {
//                     setState(()  {
//                           if(_selectedIndex == i){
//                           _selectedIndex= 0;
//                           }else{
//                           _selectedIndex= i;
//                           }
//                           print("promo data selected..."+promoData[i].label.toString());
//                           print("promo data ...."+promoData.where(
//                                   (x) => x.label == promoData[i].label
//                           ).toList().length.toString());
//
//
//                     });
//                      Future.delayed( Duration(seconds: 5), (){
//                       isLoading = true;
//                       productsdata.clear();
//                       productsdata = promoData
//                           .where((map) => map.label == promoData[i].label)
//                           .first
//                           .products!
//                           .toList();
//
//                       print("dynamic21...." + productsdata.toString() +
//                           "length..." + productsdata.length.toString());
//                       isLoading = false;
//                     });
//
//                   },
//                   child: Container(
//                     width: 100,
//                     padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
//                     margin: EdgeInsets.only(left: 8.0, top: 5.0, right: 2.0, bottom: 5.0),
//                     decoration: new BoxDecoration(
//                         color: i == _selectedIndex ? ColorCodes.primaryColor:ColorCodes.whiteColor,
//                         border: Border.all(color: i == _selectedIndex ? ColorCodes.primaryColor:ColorCodes.emailColor),
//                         borderRadius: new BorderRadius.all(
//                           const Radius.circular(5.0),)),
//                     child: Center(
//                       child: Text(promoData[i].label.toString(),
//                         maxLines: 2,
//                         style:
//                         TextStyle(
//                           color: i == _selectedIndex ? ColorCodes.whiteColor:ColorCodes.emailColor,
//                             fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 15, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }else {
//           return SizedBox.shrink();
//         }
//     }
//
//                   }
//               ),
//
//               isLoading?(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
//                             ? ItemListShimmerWeb()
//                             : ItemListShimmer():
//               (productsdata != null && productsdata.length > 0) ?
//               GridView.builder(
//                 shrinkWrap: true,
//                 itemCount:productsdata.length,
//                 controller: new ScrollController(keepScrollOffset: false),
//                 gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: widgetsInRow,
//                   crossAxisSpacing: 3,
//                   childAspectRatio: aspectRatio,
//                   mainAxisSpacing: 3,
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
// print("product data length.....grid,..."+productsdata.length.toString());
//                   double margins;
//
//                   margins = (productsdata[index].type == "1") ? Calculate().getmargin(
//                       productsdata[index].mrp.toString(),
//                       productsdata[index].price.toString()) :
//                   Calculate().getmargin(productsdata[index].priceVariation![index].mrp.toString(),
//                       productsdata[index].priceVariation![index].price.toString());
//
//                   if(_checkmembership) { //Membered user
//                     if(productsdata[index].type == "1") {  //SingleSku item
//                       if (productsdata[index].membershipDisplay!) { //Eligible to display membership price
//                         _price = productsdata[index].membershipPrice!.toString();
//                         _mrp = productsdata[index].mrp!.toString();
//                       } else if (productsdata[index].discointDisplay!) { //Eligible to display discounted price
//                         _price = productsdata[index].price!.toString();
//                         _mrp = productsdata[index].mrp!.toString();
//                       } else { //Otherwise display mrp
//                         _price = productsdata[index].mrp!.toString();
//                       }
//                     }
//                     else{ //multisku
//                       if (productsdata[index].priceVariation![index]
//                           .membershipDisplay!) { //Eligible to display membership price
//                         _price = productsdata[index].priceVariation![ index].membershipPrice!.toString();
//                         _mrp = productsdata[index].priceVariation![ index].mrp!.toString();
//                       } else if (productsdata[index].priceVariation![ index]
//                           .discointDisplay!) { //Eligible to display discounted price
//                         _price = productsdata[index].priceVariation![ index].price!.toString();
//                         _mrp = productsdata[index].priceVariation![index].mrp!.toString();
//                       } else { //Otherwise display mrp
//                         _price = productsdata[index].priceVariation![index].mrp!.toString();
//                       }
//                     }
//                   } else { //Non membered user
//
//                     if(productsdata[index].type == "1") { //singlesku
//                       if(productsdata[index].discointDisplay!){ //Eligible to display discounted price
//                         _price = productsdata[index].price!.toString();
//                         _mrp = productsdata[index].mrp!.toString();
//                       } else { //Otherwise display mrp
//                         _price = productsdata[index].mrp!.toString();
//                       }
//                     }
//                     else{ //multisku
//                       if(productsdata[index].priceVariation![index].discointDisplay!){ //Eligible to display discounted price
//                         _price = productsdata[index].priceVariation![index].price!.toString();
//                         _mrp = productsdata[index].priceVariation![index].mrp!.toString();
//                       } else { //Otherwise display mrp
//                         _price = productsdata[index].priceVariation![index].mrp!.toString();
//                       }
//                     }
//
//                   }
//                   if(Features.iscurrencyformatalign) {
//                     _price = '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
//                     if(_mrp != "")
//                       _mrp = '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
//                   } else {
//                     _price = IConstants.currencyFormat + '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ';
//                     if(_mrp != "")
//                       _mrp =  IConstants.currencyFormat + '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ';
//                   }
//                   return  productsdata[index].type=="1"?
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border(
//                         bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
//                       ),
//                     ),
//                     margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: (MediaQuery
//                               .of(context)
//                               .size
//                               .width / 2) - 75,
//
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Stack(
//                                 children: [
//                                   ItemBadge(
//                                     outOfStock: productsdata[index].stock!<=0?OutOfStock(singleproduct: false,):null,
//                                     child: Align(
//                                       alignment: Alignment.center,
//                                       child: MouseRegion(
//                                         cursor: SystemMouseCursors.click,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});
//
//                                           },
//                                           child: Container(
//                                             margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
//                                             child: CachedNetworkImage(
//                                               imageUrl: productsdata[index].itemFeaturedImage,
//                                               errorWidget: (context, url, error) => Image.asset(
//                                                 Images.defaultProductImg,
//                                                 width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                 height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               ),
//                                               placeholder: (context, url) => Image.asset(
//                                                 Images.defaultProductImg,
//                                                 width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                 height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               ),
//                                               width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               //  fit: BoxFit.fill,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.topLeft,
//                                     child: Row(
//                                       children: [
//                                         if(margins > 0)
//                                           Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(
//                                                   3.0),
//                                               color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
//                                               child: Text(
//                                                 margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     fontSize: 9,
//                                                     color: ColorCodes.whiteColor,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                           ),
//                                         if(margins > 0)
//                                           Spacer(),
//
//                                         (productsdata[index].eligibleForExpress == "0")?
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 3.0),
//                                             border: Border.all(
//                                                 color: ColorCodes.varcolor),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   S .of(context).express ,//"% OFF",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       fontSize: 9,
//                                                       color: ColorCodes.primaryColor,
//                                                       fontWeight: FontWeight.bold),
//                                                 ),
//                                                 SizedBox(width: 2),
//                                                 Image.asset(Images.express,
//                                                   color: ColorCodes.primaryColor,
//                                                   height: 11.0,
//                                                   width: 11.0,),
//
//                                               ],
//                                             ),
//                                           ),
//                                         ) : SizedBox.shrink(),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 5,),
//                         Column(
//                           mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: (MediaQuery.of(context).size.width / 2) + 55,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                       width: (MediaQuery
//                                           .of(context)
//                                           .size
//                                           .width / 2.5),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//
//                                           Container(
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Expanded(
//                                                   child: Text(
//                                                     productsdata[index].brand!,
//                                                     style: TextStyle(
//                                                         fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(height: 4,),
//                                           Container(
//                                             height:38,
//                                             child: Row(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Expanded(
//                                                   child: Text(
//                                                     productsdata[index].itemName!,
//                                                     overflow: TextOverflow.ellipsis,
//                                                     maxLines: 2,
//                                                     style: TextStyle(
//                                                       //fontSize: 16,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 35,
//                                           ),
//
//
//
//                                           Container(
//                                               child: Row(
//                                                 children: <Widget>[
//                                                   new RichText(
//                                                     text: new TextSpan(
//                                                       style: new TextStyle(
//                                                         fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
//                                                         color: Colors.black,
//                                                       ),
//                                                       children: <TextSpan>[
// //
//                                                         new TextSpan(
//                                                             text: _price,
//                                                             style: new TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               color: _checkmembership?ColorCodes.primaryColor:Colors.black,
//                                                               fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
//                                                         new TextSpan(
//                                                             text: _mrp,
//                                                             style: TextStyle(
//                                                               decoration:
//                                                               TextDecoration.lineThrough,
//                                                               fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
//                                                       ],
//                                                     ),
//                                                   )
//                                                 ],
//                                               )),
//                                           SizedBox(height: 4,),
//
//
//                                         ],
//                                       )),
//                                   Container(
//                                       width: (MediaQuery
//                                           .of(context)
//                                           .size
//                                           .width / 4.5),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           if(Features.isLoyalty)
//                                             (double.parse(productsdata[index].loyalty.toString()) > 0)?
//                                             Container(
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Image.asset(Images.coinImg,
//                                                     height: 12.0,
//                                                     width: 15.0,),
//                                                   SizedBox(width: 2),
//                                                   Text(productsdata[index].loyalty.toString(),
//                                                     style: TextStyle(fontWeight: FontWeight.bold, fontSize:11),),
//                                                 ],
//                                               ),
//                                             ):SizedBox(height: 10,),
//                                           SizedBox(height: 4,),
//                                           (productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")?
//                                           Container(
//                                             height: 20,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               children: [
//                                                 Text(productsdata[index].singleshortNote.toString(),
//                                                   overflow: TextOverflow.ellipsis,
// //                                  maxLines: 1,
//                                                   style: TextStyle(fontSize: 10,color: ColorCodes.greyColor,),),
//                                               ],
//                                             ),
//                                           ):SizedBox.shrink(),
//                                           if(productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")SizedBox(height: 4,),
//
//
//                                         ],
//                                       )),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             (Features.netWeight && productsdata[index].vegType == "fish")?
//                             Container(
//                               width: (MediaQuery
//                                   .of(context)
//                                   .size
//                                   .width / 2) + 70,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                         Features.iscurrencyformatalign?
//                                         /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
//                                             productsdata[index].salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
//                                         /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
//                                             productsdata[index].salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
//                                         style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
//                                     ],
//                                   ),
//                                   SizedBox(height: 3),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
//                                                 productsdata[index].weight!,
//                                                 style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                             ),
//                                           ),
//                                           Container(
//                                             child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
//                                                 productsdata[index].netWeight!,
//                                                 style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                             ),
//                                           ),
//
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ): SizedBox.shrink(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ):
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border(
//                         bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
//                       ),
//                     ),
//                     margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: (MediaQuery.of(context).size.width / 2) - 75,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ItemBadge(
//                                 outOfStock: productsdata[index].priceVariation![index].stock!<=0?OutOfStock(singleproduct: false,):null,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: MouseRegion(
//                                     cursor: SystemMouseCursors.click,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (productsdata[index].priceVariation![index].stock !>= 0)
//                                           Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": productsdata[index].priceVariation![index].menuItemId.toString(),"productId": productsdata[index].priceVariation![index].menuItemId.toString()});
//                                         else
//                                           Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": productsdata[index].priceVariation![index].menuItemId.toString(),"productId": productsdata[index].priceVariation![index].menuItemId.toString()});
//
//                                       },
//                                       child:  Stack(
//                                         children: [
//
//                                           Container(
//                                             margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
//                                             child: CachedNetworkImage(
//                                               imageUrl: productsdata[index].priceVariation![index].images!.length<=0?productsdata[index].itemFeaturedImage:productsdata[index].priceVariation![index].images![0].image,
//                                               errorWidget: (context, url, error) => Image.asset(
//                                                 Images.defaultProductImg,
//                                                 width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                 height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               ),
//                                               placeholder: (context, url) => Image.asset(
//                                                 Images.defaultProductImg,
//                                                 width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                 height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               ),
//                                               width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                               //  fit: BoxFit.fill,
//                                             ),
//                                           ),
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 if(margins > 0)
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(
//                                                           3.0),
//                                                       color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
//                                                       child: Text(
//                                                         margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
//                                                         textAlign: TextAlign.center,
//                                                         style: TextStyle(
//                                                             fontSize: 9,
//                                                             color: ColorCodes.whiteColor,
//                                                             fontWeight: FontWeight.bold),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 if(margins > 0)
//                                                   Spacer(),
//
//                                                 (productsdata[index].eligibleForExpress == "0")?
//                                                 Container(
//
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(
//                                                         3.0),
//                                                     border: Border.all(
//                                                         color: ColorCodes.varcolor),
//                                                   ),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                           S .of(context).express ,//"% OFF",
//                                                           textAlign: TextAlign.center,
//                                                           style: TextStyle(
//                                                               fontSize: 9,
//                                                               color: ColorCodes.primaryColor,
//                                                               fontWeight: FontWeight.bold),
//                                                         ),
//                                                         SizedBox(width: 2),
//                                                         Image.asset(Images.express,
//                                                           color: ColorCodes.primaryColor,
//                                                           height: 11.0,
//                                                           width: 11.0,),
//
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ) : SizedBox.shrink(),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 5,),
//                         Column(
//                           mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: (MediaQuery.of(context).size.width / 2) + 55,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                       width: Features.btobModule?(MediaQuery
//                                           .of(context)
//                                           .size
//                                           .width / 1.5):(MediaQuery
//                                           .of(context)
//                                           .size
//                                           .width / 2.5),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Features.btobModule?
//                                           Container(
//                                             height:20,
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Text(
//                                                   productsdata[index].brand!,
//                                                   style: TextStyle(
//                                                       fontSize: 9, color: Colors.black),
//                                                 ),
//                                                 Features.btobModule?
//                                                 (productsdata[index].eligibleForExpress == "0")?
//                                                 Container(
//                                                   height: 20,
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     children: [
//                                                       Image .asset(Images.express,
//                                                         height: 20.0,
//                                                         width: 25.0,),
//                                                     ],
//                                                   ),
//                                                 ):SizedBox.shrink():SizedBox.shrink(),
//                                                 if(Features.btobModule)
//                                                   SizedBox(width:MediaQuery.of(context).size.width*0.15),
//                                                 if(Features.btobModule)
//                                                   if(Features.isLoyalty)
//                                                     (double.parse(productsdata[index].priceVariation![index].loyalty.toString()) > 0)?
//                                                     Container(
//                                                       height:15,
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.end,
//                                                         children: [
//                                                           Image.asset(Images.coinImg,
//                                                             height: 15.0,
//                                                             width: 20.0,),
//                                                           SizedBox(width: 4),
//                                                           Text(productsdata[index].priceVariation![index].loyalty.toString()),
//                                                         ],
//                                                       ),
//                                                     ):SizedBox.shrink(),
//                                               ],
//                                             ),
//                                           ):
//                                           Container(
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Expanded(
//                                                   child: Text(
//                                                     productsdata[index].brand!,
//                                                     style: TextStyle(
//                                                         fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(height: 5),
//                                           Container(
//                                             height:38,
//                                             child: Row(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Expanded(
//                                                   child: Text(
//                                                     Features.btobModule?productsdata[index].itemName! + "-" + productsdata[index].priceVariation![0].variationName!:productsdata[index].itemName!,
//                                                     overflow: TextOverflow.ellipsis,
//                                                     maxLines: 2,
//                                                     style: TextStyle(
//                                                       //fontSize: 16,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 4,
//                                           ),
//                                           ( productsdata[index].priceVariation!.length > 1)?
//                                           Container(
//                                             width: (MediaQuery
//                                                 .of(context)
//                                                 .size
//                                                 .width / 3),
//                                             child:   Row(
//                                               children: [
//                                                 Container(
//                                                   width: (MediaQuery
//                                                       .of(context)
//                                                       .size
//                                                       .width /3),
//                                                   child: (productsdata[index].priceVariation!.length > 1)
//                                                       ? GestureDetector(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         //showoptions1();
//                                                       });
//                                                     },
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Container(
//                                                           height: 20,
//                                                           child: Text(
//                                                             "${productsdata[index].priceVariation![index].variationName}"+" "+"${productsdata[index].priceVariation![index].unit}",
//                                                             style:
//                                                             TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
//                                                           ),
//                                                         ),
//                                                         //SizedBox(width: 10,),
//                                                         Icon(
//                                                           Icons.keyboard_arrow_down,
//                                                           color: ColorCodes.darkgreen,
//                                                           size: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )
//                                                       : Row( mainAxisSize: MainAxisSize.max,
//                                                     children: [
//                                                       Expanded(
//                                                         child: Container(
//                                                           height: 40,
//                                                           child: Text(
//                                                             "${productsdata[index].priceVariation![index].variationName}"+" "+"${productsdata[index].priceVariation![index].unit}",
//                                                             style: TextStyle(color: ColorCodes.greyColor,fontWeight: FontWeight.bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//
//                                               ],
//                                             ),
//                                           ):SizedBox(height:20),
//                                           SizedBox(
//                                             height: 4,
//                                           ),
//
//
//                                           Container(
//                                               child: Row(
//                                                 children: <Widget>[
//                                                   if(!Features.btobModule)
//                                                     if(!Features.btobModule)
//                                                       new RichText(
//                                                         text: new TextSpan(
//                                                           style: new TextStyle(
//                                                             fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
//                                                             color: Colors.black,
//                                                           ),
//                                                           children: <TextSpan>[
//                                                             new TextSpan(
//                                                                 text: _price,
//                                                                 style: new TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   color: _checkmembership?ColorCodes.primaryColor:Colors.black,
//                                                                   fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
//                                                             new TextSpan(
//                                                                 text: _mrp,
//                                                                 style: TextStyle(
//                                                                   decoration:
//                                                                   TextDecoration.lineThrough,
//                                                                   fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
//                                                           ],
//                                                         ),
//                                                       ),
//
//                                                 ],
//                                               )),
//
//                                           SizedBox(
//                                             height: 4,
//                                           ),
//                                           //:SizedBox.shrink(),
//
//                                         ],
//                                       )),
//                                   !Features.btobModule?
//                                   Spacer():SizedBox.shrink(),
//                                   !Features.btobModule?
//                                   Container(
//                                       width: (MediaQuery
//                                           .of(context)
//                                           .size
//                                           .width / 4.7),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           if(Features.isLoyalty)
//                                             (double.parse(productsdata[index].priceVariation![index].loyalty.toString()) > 0)?
//                                             Container(
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Image.asset(Images.coinImg,
//                                                     height: 12.0,
//                                                     width: 15.0,),
//                                                   SizedBox(width: 2),
//                                                   Text(productsdata[index].priceVariation![index].loyalty.toString(),
//                                                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
//                                                 ],
//                                               ),
//                                             ):SizedBox(height: 10,),
//                                           SizedBox(height: 4),
//
//                                           SizedBox(height: 10,),
//                                           (productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")?
//                                           Container(
//                                             height: 15,
//                                             width:85,
//                                             child: Text(productsdata[index].singleshortNote.toString(),
//                                               overflow: TextOverflow.ellipsis,
//                                               maxLines: 1,
//                                               style: TextStyle(fontSize: 10,color: ColorCodes.greyColor,),),
//                                           ):SizedBox.shrink(),
//                                           if(productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")SizedBox(height: 4,),
//
//                                           SizedBox(
//                                             height: 4,
//                                           ),
//                                         ],
//                                       )):SizedBox.shrink(),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 3),
//
//                             if(Features.netWeight && productsdata[index].vegType == "fish")
//                               Container(
//                                 width: (MediaQuery
//                                     .of(context)
//                                     .size
//                                     .width / 2) + 70,
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           Features.iscurrencyformatalign?
//                                           /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
//                                               productsdata[index].salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
//                                           /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
//                                               productsdata[index].salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
//                                           style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     SizedBox(height: 3),
//                                     Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                               child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
//                                                   productsdata[index].priceVariation![index].weight!,
//                                                   style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                               ),
//                                             ),
//                                             Container(
//                                               child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
//                                                   productsdata[index].priceVariation![index].netWeight!,
//                                                   style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//
//                 },
//               ):SizedBox.shrink(),







//               FutureBuilder<List<SubscriptionBoxData>>(
//                   future: _subscription,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<List<SubscriptionBoxData>> snapshot) {
//                     final promoData = snapshot.data![0].boxProducts;
//                     print("promodata ...length..."+promoData!.length.toString());
//                     print("promo data ....initial"+promoData.where(
//                             (x) => x.label == promoData[0].label
//                     ).toList().length.toString());
//                     // productsdata.clear();
//                     // productsdata = promoData.where((map)=>map.label == promoData[0].label).first.products!.toList();
//                      print("dynamic21....product data ...."+productsdata.toString() +"length..."+productsdata.length.toString()) ;
//
//                     switch(snapshot.connectionState) {
//                       case ConnectionState.none:
//                         return SizedBox.shrink();
//                         // TODO: Handle this case.
//                         break;
//                       case ConnectionState.waiting:
//                         return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
//                             ? ItemListShimmerWeb()
//                             : ItemListShimmer();
//                     // TODO: Handle this case.
//                       default:
//                         if(productsdata != null && productsdata.length > 0) {
//                           return
//                             GridView.builder(
//                             shrinkWrap: true,
//                             itemCount:productsdata.length,
//                             controller: new ScrollController(keepScrollOffset: false),
//                             gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: widgetsInRow,
//                               crossAxisSpacing: 3,
//                               childAspectRatio: aspectRatio,
//                               mainAxisSpacing: 3,
//                             ),
//                             itemBuilder: (BuildContext context, int index) {
//
//                               double margins;
//
//                               margins = (productsdata[index].type == "1") ? Calculate().getmargin(
//                                   productsdata[index].mrp.toString(),
//                                   productsdata[index].price.toString()) :
//                               Calculate().getmargin(productsdata[index].priceVariation![index].mrp.toString(),
//                                   productsdata[index].priceVariation![index].price.toString());
//
//                               if(_checkmembership) { //Membered user
//                                 if(productsdata[index].type == "1") {  //SingleSku item
//                                   if (productsdata[index].membershipDisplay!) { //Eligible to display membership price
//                                     _price = productsdata[index].membershipPrice!.toString();
//                                     _mrp = productsdata[index].mrp!.toString();
//                                   } else if (productsdata[index].discointDisplay!) { //Eligible to display discounted price
//                                     _price = productsdata[index].price!.toString();
//                                     _mrp = productsdata[index].mrp!.toString();
//                                   } else { //Otherwise display mrp
//                                     _price = productsdata[index].mrp!.toString();
//                                   }
//                                 }
//                                 else{ //multisku
//                                   if (productsdata[index].priceVariation![index]
//                                       .membershipDisplay!) { //Eligible to display membership price
//                                     _price = productsdata[index].priceVariation![ index].membershipPrice!.toString();
//                                     _mrp = productsdata[index].priceVariation![ index].mrp!.toString();
//                                   } else if (productsdata[index].priceVariation![ index]
//                                       .discointDisplay!) { //Eligible to display discounted price
//                                     _price = productsdata[index].priceVariation![ index].price!.toString();
//                                     _mrp = productsdata[index].priceVariation![index].mrp!.toString();
//                                   } else { //Otherwise display mrp
//                                     _price = productsdata[index].priceVariation![index].mrp!.toString();
//                                   }
//                                 }
//                               } else { //Non membered user
//
//                                 if(productsdata[index].type == "1") { //singlesku
//                                   if(productsdata[index].discointDisplay!){ //Eligible to display discounted price
//                                     _price = productsdata[index].price!.toString();
//                                     _mrp = productsdata[index].mrp!.toString();
//                                   } else { //Otherwise display mrp
//                                     _price = productsdata[index].mrp!.toString();
//                                   }
//                                 }
//                                 else{ //multisku
//                                   if(productsdata[index].priceVariation![index].discointDisplay!){ //Eligible to display discounted price
//                                     _price = productsdata[index].priceVariation![index].price!.toString();
//                                     _mrp = productsdata[index].priceVariation![index].mrp!.toString();
//                                   } else { //Otherwise display mrp
//                                     _price = productsdata[index].priceVariation![index].mrp!.toString();
//                                   }
//                                 }
//
//                               }
//                               if(Features.iscurrencyformatalign) {
//                                 _price = '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
//                                 if(_mrp != "")
//                                   _mrp = '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
//                               } else {
//                                 _price = IConstants.currencyFormat + '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ';
//                                 if(_mrp != "")
//                                   _mrp =  IConstants.currencyFormat + '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ';
//                               }
//                               return  productsdata[index].type=="1"?
//                               Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border(
//                                     bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
//                                   ),
//                                 ),
//                                 margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: (MediaQuery
//                                           .of(context)
//                                           .size
//                                           .width / 2) - 75,
//
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Stack(
//                                             children: [
//                                               ItemBadge(
//                                                 outOfStock: productsdata[index].stock!<=0?OutOfStock(singleproduct: false,):null,
//                                                 child: Align(
//                                                   alignment: Alignment.center,
//                                                   child: MouseRegion(
//                                                     cursor: SystemMouseCursors.click,
//                                                     child: GestureDetector(
//                                                       onTap: () {
//                                                         // Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});
//
//                                                       },
//                                                       child: Container(
//                                                         margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
//                                                         child: CachedNetworkImage(
//                                                           imageUrl: productsdata[index].itemFeaturedImage,
//                                                           errorWidget: (context, url, error) => Image.asset(
//                                                             Images.defaultProductImg,
//                                                             width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                             height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           ),
//                                                           placeholder: (context, url) => Image.asset(
//                                                             Images.defaultProductImg,
//                                                             width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                             height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           ),
//                                                           width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           //  fit: BoxFit.fill,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: Row(
//                                                   children: [
//                                                     if(margins > 0)
//                                                       Container(
//                                                         decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(
//                                                               3.0),
//                                                           color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
//                                                         ),
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
//                                                           child: Text(
//                                                             margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
//                                                             textAlign: TextAlign.center,
//                                                             style: TextStyle(
//                                                                 fontSize: 9,
//                                                                 color: ColorCodes.whiteColor,
//                                                                 fontWeight: FontWeight.bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     if(margins > 0)
//                                                       Spacer(),
//
//                                                     (productsdata[index].eligibleForExpress == "0")?
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(
//                                                             3.0),
//                                                         border: Border.all(
//                                                             color: ColorCodes.varcolor),
//                                                       ),
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
//                                                         child: Row(
//                                                           children: [
//                                                             Text(
//                                                               S .of(context).express ,//"% OFF",
//                                                               textAlign: TextAlign.center,
//                                                               style: TextStyle(
//                                                                   fontSize: 9,
//                                                                   color: ColorCodes.primaryColor,
//                                                                   fontWeight: FontWeight.bold),
//                                                             ),
//                                                             SizedBox(width: 2),
//                                                             Image.asset(Images.express,
//                                                               color: ColorCodes.primaryColor,
//                                                               height: 11.0,
//                                                               width: 11.0,),
//
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ) : SizedBox.shrink(),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 5,),
//                                     Column(
//                                       mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           width: (MediaQuery.of(context).size.width / 2) + 55,
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                   width: (MediaQuery
//                                                       .of(context)
//                                                       .size
//                                                       .width / 2.5),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//
//                                                       Container(
//                                                         child: Row(
//                                                           children: <Widget>[
//                                                             Expanded(
//                                                               child: Text(
//                                                                 productsdata[index].brand!,
//                                                                 style: TextStyle(
//                                                                     fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 4,),
//                                                       Container(
//                                                         height:38,
//                                                         child: Row(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           children: <Widget>[
//                                                             Expanded(
//                                                               child: Text(
//                                                                 productsdata[index].itemName!,
//                                                                 overflow: TextOverflow.ellipsis,
//                                                                 maxLines: 2,
//                                                                 style: TextStyle(
//                                                                   //fontSize: 16,
//                                                                     fontWeight: FontWeight.bold),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 35,
//                                                       ),
//
//
//
//                                                       Container(
//                                                           child: Row(
//                                                             children: <Widget>[
//                                                               new RichText(
//                                                                 text: new TextSpan(
//                                                                   style: new TextStyle(
//                                                                     fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
//                                                                     color: Colors.black,
//                                                                   ),
//                                                                   children: <TextSpan>[
// //
//                                                                     new TextSpan(
//                                                                         text: _price,
//                                                                         style: new TextStyle(
//                                                                           fontWeight: FontWeight.bold,
//                                                                           color: _checkmembership?ColorCodes.primaryColor:Colors.black,
//                                                                           fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
//                                                                     new TextSpan(
//                                                                         text: _mrp,
//                                                                         style: TextStyle(
//                                                                           decoration:
//                                                                           TextDecoration.lineThrough,
//                                                                           fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           )),
//                                                       SizedBox(height: 4,),
//
//
//                                                     ],
//                                                   )),
//                                               Container(
//                                                   width: (MediaQuery
//                                                       .of(context)
//                                                       .size
//                                                       .width / 4.5),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                     children: [
//                                                       if(Features.isLoyalty)
//                                                         (double.parse(productsdata[index].loyalty.toString()) > 0)?
//                                                         Container(
//                                                           child: Row(
//                                                             mainAxisAlignment: MainAxisAlignment.end,
//                                                             children: [
//                                                               Image.asset(Images.coinImg,
//                                                                 height: 12.0,
//                                                                 width: 15.0,),
//                                                               SizedBox(width: 2),
//                                                               Text(productsdata[index].loyalty.toString(),
//                                                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize:11),),
//                                                             ],
//                                                           ),
//                                                         ):SizedBox(height: 10,),
//                                                       SizedBox(height: 4,),
//                                                       (productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")?
//                                                       Container(
//                                                         height: 20,
//                                                         child: Row(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           children: [
//                                                             Text(productsdata[index].singleshortNote.toString(),
//                                                               overflow: TextOverflow.ellipsis,
// //                                  maxLines: 1,
//                                                               style: TextStyle(fontSize: 10,color: ColorCodes.greyColor,),),
//                                                           ],
//                                                         ),
//                                                       ):SizedBox.shrink(),
//                                                       if(productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")SizedBox(height: 4,),
//
//
//                                                     ],
//                                                   )),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         (Features.netWeight && productsdata[index].vegType == "fish")?
//                                         Container(
//                                           width: (MediaQuery
//                                               .of(context)
//                                               .size
//                                               .width / 2) + 70,
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     Features.iscurrencyformatalign?
//                                                     /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
//                                                         productsdata[index].salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
//                                                     /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
//                                                         productsdata[index].salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
//                                                     style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
//                                                 ],
//                                               ),
//                                               SizedBox(height: 3),
//                                               Column(
//                                                 children: [
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Container(
//                                                         child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
//                                                             productsdata[index].weight!,
//                                                             style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                                         ),
//                                                       ),
//                                                       Container(
//                                                         child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
//                                                             productsdata[index].netWeight!,
//                                                             style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                                         ),
//                                                       ),
//
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ): SizedBox.shrink(),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ):
//                               Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border(
//                                     bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
//                                   ),
//                                 ),
//                                 margin: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 5),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: (MediaQuery.of(context).size.width / 2) - 75,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           ItemBadge(
//                                             outOfStock: productsdata[index].priceVariation![index].stock!<=0?OutOfStock(singleproduct: false,):null,
//                                             child: Align(
//                                               alignment: Alignment.center,
//                                               child: MouseRegion(
//                                                 cursor: SystemMouseCursors.click,
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     if (productsdata[index].priceVariation![index].stock !>= 0)
//                                                       Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": productsdata[index].priceVariation![index].menuItemId.toString(),"productId": productsdata[index].priceVariation![index].menuItemId.toString()});
//                                                     else
//                                                       Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": productsdata[index].priceVariation![index].menuItemId.toString(),"productId": productsdata[index].priceVariation![index].menuItemId.toString()});
//
//                                                   },
//                                                   child:  Stack(
//                                                     children: [
//
//                                                       Container(
//                                                         margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
//                                                         child: CachedNetworkImage(
//                                                           imageUrl: productsdata[index].priceVariation![index].images!.length<=0?productsdata[index].itemFeaturedImage:productsdata[index].priceVariation![index].images![0].image,
//                                                           errorWidget: (context, url, error) => Image.asset(
//                                                             Images.defaultProductImg,
//                                                             width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                             height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           ),
//                                                           placeholder: (context, url) => Image.asset(
//                                                             Images.defaultProductImg,
//                                                             width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                             height: ResponsiveLayout.isSmallScreen(context) ? 80 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           ),
//                                                           width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           height: ResponsiveLayout.isSmallScreen(context) ? 120 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
//                                                           //  fit: BoxFit.fill,
//                                                         ),
//                                                       ),
//                                                       Align(
//                                                         alignment: Alignment.topLeft,
//                                                         child: Row(
//                                                           children: [
//                                                             if(margins > 0)
//                                                               Container(
//                                                                 decoration: BoxDecoration(
//                                                                   borderRadius: BorderRadius.circular(
//                                                                       3.0),
//                                                                   color: ColorCodes.primaryColor,//Color(0xff6CBB3C),
//                                                                 ),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(left: 8, right: 8, top:4, bottom: 4),
//                                                                   child: Text(
//                                                                     margins.toStringAsFixed(0) + S .of(context).off ,//"% OFF",
//                                                                     textAlign: TextAlign.center,
//                                                                     style: TextStyle(
//                                                                         fontSize: 9,
//                                                                         color: ColorCodes.whiteColor,
//                                                                         fontWeight: FontWeight.bold),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             if(margins > 0)
//                                                               Spacer(),
//
//                                                             (productsdata[index].eligibleForExpress == "0")?
//                                                             Container(
//
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(
//                                                                     3.0),
//                                                                 border: Border.all(
//                                                                     color: ColorCodes.varcolor),
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(left: 2, right: 2, top:4, bottom: 4),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text(
//                                                                       S .of(context).express ,//"% OFF",
//                                                                       textAlign: TextAlign.center,
//                                                                       style: TextStyle(
//                                                                           fontSize: 9,
//                                                                           color: ColorCodes.primaryColor,
//                                                                           fontWeight: FontWeight.bold),
//                                                                     ),
//                                                                     SizedBox(width: 2),
//                                                                     Image.asset(Images.express,
//                                                                       color: ColorCodes.primaryColor,
//                                                                       height: 11.0,
//                                                                       width: 11.0,),
//
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ) : SizedBox.shrink(),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 5,),
//                                     Column(
//                                       mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           width: (MediaQuery.of(context).size.width / 2) + 55,
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                   width: Features.btobModule?(MediaQuery
//                                                       .of(context)
//                                                       .size
//                                                       .width / 1.5):(MediaQuery
//                                                       .of(context)
//                                                       .size
//                                                       .width / 2.5),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Features.btobModule?
//                                                       Container(
//                                                         height:20,
//                                                         child: Row(
//                                                           children: <Widget>[
//                                                             Text(
//                                                               productsdata[index].brand!,
//                                                               style: TextStyle(
//                                                                   fontSize: 9, color: Colors.black),
//                                                             ),
//                                                             Features.btobModule?
//                                                             (productsdata[index].eligibleForExpress == "0")?
//                                                             Container(
//                                                               height: 20,
//                                                               child: Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 children: [
//                                                                   Image .asset(Images.express,
//                                                                     height: 20.0,
//                                                                     width: 25.0,),
//                                                                 ],
//                                                               ),
//                                                             ):SizedBox.shrink():SizedBox.shrink(),
//                                                             if(Features.btobModule)
//                                                               SizedBox(width:MediaQuery.of(context).size.width*0.15),
//                                                             if(Features.btobModule)
//                                                               if(Features.isLoyalty)
//                                                                 (double.parse(productsdata[index].priceVariation![index].loyalty.toString()) > 0)?
//                                                                 Container(
//                                                                   height:15,
//                                                                   child: Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                                     children: [
//                                                                       Image.asset(Images.coinImg,
//                                                                         height: 15.0,
//                                                                         width: 20.0,),
//                                                                       SizedBox(width: 4),
//                                                                       Text(productsdata[index].priceVariation![index].loyalty.toString()),
//                                                                     ],
//                                                                   ),
//                                                                 ):SizedBox.shrink(),
//                                                           ],
//                                                         ),
//                                                       ):
//                                                       Container(
//                                                         child: Row(
//                                                           children: <Widget>[
//                                                             Expanded(
//                                                               child: Text(
//                                                                 productsdata[index].brand!,
//                                                                 style: TextStyle(
//                                                                     fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
//                                                               ),
//                                                             ),
//
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 5),
//                                                       Container(
//                                                         height:38,
//                                                         child: Row(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           children: <Widget>[
//                                                             Expanded(
//                                                               child: Text(
//                                                                 Features.btobModule?productsdata[index].itemName! + "-" + productsdata[index].priceVariation![0].variationName!:productsdata[index].itemName!,
//                                                                 overflow: TextOverflow.ellipsis,
//                                                                 maxLines: 2,
//                                                                 style: TextStyle(
//                                                                   //fontSize: 16,
//                                                                     fontWeight: FontWeight.bold),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 4,
//                                                       ),
//                                                       ( productsdata[index].priceVariation!.length > 1)?
//                                                       Container(
//                                                         width: (MediaQuery
//                                                             .of(context)
//                                                             .size
//                                                             .width / 3),
//                                                         child:   Row(
//                                                           children: [
//                                                             Container(
//                                                               width: (MediaQuery
//                                                                   .of(context)
//                                                                   .size
//                                                                   .width /3),
//                                                               child: (productsdata[index].priceVariation!.length > 1)
//                                                                   ? GestureDetector(
//                                                                 onTap: () {
//                                                                   setState(() {
//                                                                     //showoptions1();
//                                                                   });
//                                                                 },
//                                                                 child: Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                                   children: [
//                                                                     Container(
//                                                                       height: 20,
//                                                                       child: Text(
//                                                                         "${productsdata[index].priceVariation![index].variationName}"+" "+"${productsdata[index].priceVariation![index].unit}",
//                                                                         style:
//                                                                         TextStyle(color: ColorCodes.darkgreen,fontWeight: FontWeight.bold),
//                                                                       ),
//                                                                     ),
//                                                                     //SizedBox(width: 10,),
//                                                                     Icon(
//                                                                       Icons.keyboard_arrow_down,
//                                                                       color: ColorCodes.darkgreen,
//                                                                       size: 20,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                                   : Row( mainAxisSize: MainAxisSize.max,
//                                                                 children: [
//                                                                   Expanded(
//                                                                     child: Container(
//                                                                       height: 40,
//                                                                       child: Text(
//                                                                         "${productsdata[index].priceVariation![index].variationName}"+" "+"${productsdata[index].priceVariation![index].unit}",
//                                                                         style: TextStyle(color: ColorCodes.greyColor,fontWeight: FontWeight.bold),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//
//                                                           ],
//                                                         ),
//                                                       ):SizedBox(height:20),
//                                                       SizedBox(
//                                                         height: 4,
//                                                       ),
//
//
//                                                       Container(
//                                                           child: Row(
//                                                             children: <Widget>[
//                                                               if(!Features.btobModule)
//                                                                 if(!Features.btobModule)
//                                                                   new RichText(
//                                                                     text: new TextSpan(
//                                                                       style: new TextStyle(
//                                                                         fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
//                                                                         color: Colors.black,
//                                                                       ),
//                                                                       children: <TextSpan>[
//                                                                         new TextSpan(
//                                                                             text: _price,
//                                                                             style: new TextStyle(
//                                                                               fontWeight: FontWeight.bold,
//                                                                               color: _checkmembership?ColorCodes.primaryColor:Colors.black,
//                                                                               fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
//                                                                         new TextSpan(
//                                                                             text: _mrp,
//                                                                             style: TextStyle(
//                                                                               decoration:
//                                                                               TextDecoration.lineThrough,
//                                                                               fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//
//                                                             ],
//                                                           )),
//
//                                                       SizedBox(
//                                                         height: 4,
//                                                       ),
//                                                       //:SizedBox.shrink(),
//
//                                                     ],
//                                                   )),
//                                               !Features.btobModule?
//                                               Spacer():SizedBox.shrink(),
//                                               !Features.btobModule?
//                                               Container(
//                                                   width: (MediaQuery
//                                                       .of(context)
//                                                       .size
//                                                       .width / 4.7),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                     children: [
//                                                       if(Features.isLoyalty)
//                                                         (double.parse(productsdata[index].priceVariation![index].loyalty.toString()) > 0)?
//                                                         Container(
//                                                           child: Row(
//                                                             mainAxisAlignment: MainAxisAlignment.end,
//                                                             children: [
//                                                               Image.asset(Images.coinImg,
//                                                                 height: 12.0,
//                                                                 width: 15.0,),
//                                                               SizedBox(width: 2),
//                                                               Text(productsdata[index].priceVariation![index].loyalty.toString(),
//                                                                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
//                                                             ],
//                                                           ),
//                                                         ):SizedBox(height: 10,),
//                                                       SizedBox(height: 4),
//
//                                                       SizedBox(height: 10,),
//                                                       (productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")?
//                                                       Container(
//                                                         height: 15,
//                                                         width:85,
//                                                         child: Text(productsdata[index].singleshortNote.toString(),
//                                                           overflow: TextOverflow.ellipsis,
//                                                           maxLines: 1,
//                                                           style: TextStyle(fontSize: 10,color: ColorCodes.greyColor,),),
//                                                       ):SizedBox.shrink(),
//                                                       if(productsdata[index].singleshortNote != "" || productsdata[index].singleshortNote != "0")SizedBox(height: 4,),
//
//                                                       SizedBox(
//                                                         height: 4,
//                                                       ),
//                                                     ],
//                                                   )):SizedBox.shrink(),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(height: 3),
//
//                                         if(Features.netWeight && productsdata[index].vegType == "fish")
//                                           Container(
//                                             width: (MediaQuery
//                                                 .of(context)
//                                                 .size
//                                                 .width / 2) + 70,
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       Features.iscurrencyformatalign?
//                                                       /*"Whole Uncut:"*/S.of(context).whole_uncut +" " +
//                                                           productsdata[index].salePrice! + IConstants.currencyFormat +" / "+ /*"500 G"*/S.of(context).gram:
//                                                       /*"Whole Uncut:"*/S.of(context).whole_uncut +" "+ IConstants.currencyFormat +
//                                                           productsdata[index].salePrice! +" / "+ /*"500 G"*/S.of(context).gram,
//                                                       style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold),),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 3),
//                                                 Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                       MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Container(
//                                                           child: Text(/*"Gross Weight:"*/S.of(context).gross_weight +" "+
//                                                               productsdata[index].priceVariation![index].weight!,
//                                                               style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           child: Text(/*"Net Weight:"*/S.of(context).net_weight +" "+
//                                                               productsdata[index].priceVariation![index].netWeight!,
//                                                               style: new TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 11 : ResponsiveLayout.isMediumScreen(context) ? 12 : 16, fontWeight: FontWeight.bold)
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//
//                             },
//                           );
//                         }else {
//                           return SizedBox.shrink();
//                         }
//                     }
//
//                   }
//               )
            ],
          ),
        ),
    );
  }
}



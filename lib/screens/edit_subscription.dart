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
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/subscription_data.dart';
import '../models/newmodle/upcomingsubscription.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/header.dart';
import '../widgets/productWidget/item_badge.dart';
import '../widgets/simmers/loyality_wallet_shimmer.dart';


class EditSubscription extends StatefulWidget {
  String? itemname = "";
  String? itemimage = "";
  String? quantity = "";
  String? unit = "";
  String? box_id = "";
  String? minitem = "";
  String? maxitem = "";
  String? stock = "";
  String? price = "";
  String? mrp = "";
  String? membershiprice = "";
  String? membershipdisplay = "";
  String? discountdisplay = "";
  String? type = "";


  EditSubscription(Map<String, String> params){
    this.itemname = params["itemname"]??"";
    this.itemimage = params["itemimage"]??"";
    this.quantity = params["quantity"]??"";
    this.unit = params["unit"]??"";
    this.box_id = params["box_id"]??"";
    this.minitem = params["minitem"]??"";
    this.maxitem = params["maxitem"]??"";
    this.stock = params["stock"]??"";
    this.price = params["price"]??"";
    this.mrp = params["mrp"]??"";
    this.membershiprice = params["membershipprice"]??"";
    this.membershipdisplay = params["membershipdisplay"]??"";
    this.discountdisplay = params["discountdisplay"]??"";
    this.type = params["type"]??"";
  }
  @override
  State<EditSubscription> createState() => _EditSubscriptionState();
}

class _EditSubscriptionState extends State<EditSubscription> with Navigations{
  var promoData;
  List<Products> productsdata = [];
  int? selectedIndex = 0;
  int _selectedIndex = 0;
  int isselect = -1;
  String _price = "";
  String _mrp = "";
  String _priceinitial = "";
  String _mrpinitial  = "";
  bool _checkmembership = false;
  List<CartItem> productBox=[];
  bool _membershipdisplay = false;
  String? membershipprice;
  bool  discountdisplay = false;
  List<Map> data = [];
  int _itemCount = 0;
  int _count = 1;
  bool _isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    print("quantity ......."+widget.quantity.toString());
    _itemCount = int.parse(widget.quantity!);
    if(_checkmembership) { //Membered user
        if (widget.membershipdisplay  == "true") { //Eligible to display membership price
          _priceinitial = widget.membershiprice!.toString();
          _mrpinitial = widget.mrp!.toString();
        } else if (widget.discountdisplay! == "true") { //Eligible to display discounted price
          _priceinitial = widget.price!.toString();
          _mrpinitial = widget.mrp!.toString();
        } else { //Otherwise display mrp
          _priceinitial = widget.mrp!.toString();
        }
    } else { //Non membered user

        if(widget.discountdisplay! == "true"){ //Eligible to display discounted price
          _priceinitial = widget.price!.toString();
          _mrpinitial = widget.mrp!.toString();
        } else { //Otherwise display mrp
          _priceinitial = widget.mrp!.toString();
          _mrpinitial = "";
        }
    }

    print("mrp.....111111  ..... "+_mrpinitial.toString());
    if(Features.iscurrencyformatalign) {
      _priceinitial = '${double.parse(_priceinitial).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
      if(_mrpinitial != "")
        _mrpinitial = '${double.parse(_mrpinitial).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
    } else {
      print("mrp....."+_mrpinitial.toString());
      _priceinitial = IConstants.currencyFormat + '${double.parse(_priceinitial).toStringAsFixed(IConstants.decimaldigit)} ';
      if(_mrpinitial != "")
        _mrpinitial =  IConstants.currencyFormat + '${double.parse(_mrpinitial).toStringAsFixed(IConstants.decimaldigit)} ';
    }
    if(Features.issubscriptionbox)
      /*subscriptionApibox.getSubsctiptionBoxIDNew(ParamBodyDatabox( type: "all",
          branch: PrefUtils.prefs!.getString("branch"),
          languageid: IConstants.languageId,
          user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
              .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
          subscription_id: widget.box_id.toString()));*/


      SubscriptionBoxController(type: "all",
          branch: PrefUtils.prefs!.getString("branch"),
          languageid: IConstants.languageId,
          user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
              .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
          subscription_id: widget.box_id.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("boxid.....edit"+widget.box_id.toString());
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
        title: Text(S.of(context).edit_delivery/*"All Subscription Box"*/,
          style: TextStyle(color: ColorCodes.iconColor),),
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
             /* _isloading?LoyalityorWalletShimmer():*/_body(),
            ],
          ),
        ),
         bottomNavigationBar:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox.shrink(): _bottomNavigationBar(),
      ),
    );
  }


  _bottomNavigationBar() {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          //_saveForm();
        },
        child: Container(
          margin: EdgeInsets.all(20),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColor
          ),
          child: Center(
            child: Text(
              S .of(context).susbscription_update,
              // 'UPDATE PROFILE',
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

  _body(){
    return Padding(
      padding: const EdgeInsets.only(left:20.0,right: 20),
      child: Column(
        children: [
          Container(
            decoration: new BoxDecoration(
                color: ColorCodes.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.all(const Radius.circular(3.0),)),
            margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:5,right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:5,top: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?20:10),

            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.itemimage,
                        errorWidget: (context, url, error) => Image.asset(
                          Images.defaultProductImg,
                          width: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 70 : 70,
                          height: ResponsiveLayout.isSmallScreen(context) ? 50 : ResponsiveLayout.isMediumScreen(context) ? 60 : 60,
                        ),
                        placeholder: (context, url) => Image.asset(
                          Images.defaultProductImg,
                          width: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 70 : 70,
                          height: ResponsiveLayout.isSmallScreen(context) ? 50 : ResponsiveLayout.isMediumScreen(context) ? 60 : 60,
                        ),
                        width: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 70 : 70,
                        height: ResponsiveLayout.isSmallScreen(context) ? 50 : ResponsiveLayout.isMediumScreen(context) ? 60 : 60,
                        //  fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Text(widget.itemname!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: ColorCodes.blackColor,
                                fontSize: 15),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*Text(widget.quantity! + " " + widget.unit!,
                                style: TextStyle(fontWeight: FontWeight.w600,
                                    color: ColorCodes.blackColor,
                                    fontSize: 12),),*/
                              new RichText(
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
//
                                    new TextSpan(
                                        text: _priceinitial,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _checkmembership?ColorCodes.primaryColor:Colors.black,
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 15 : ResponsiveLayout.isMediumScreen(context) ? 15 : 16,)),
                                    new TextSpan(
                                        text: _mrpinitial,
                                        style: TextStyle(
                                          decoration:
                                          TextDecoration.lineThrough,
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 10 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,)),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  _itemCount!=0?
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      print("min itemm1111....."+widget.maxitem.toString() +"min item////"+widget.minitem.toString() + "cpount...."+_itemCount.toString());
                                      setState(() {
                                        if(_itemCount <= int.parse(widget.minitem!)){
                                          Fluttertoast.showToast(
                                              msg:
                                              S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                                              fontSize: MediaQuery.of(context).textScaleFactor * 13,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white);
                                        }
                                        else {
                                          _itemCount == 1
                                              ? _itemCount
                                              : _itemCount--;
                                        }
                                      });
                                      //setState(()=>_itemCount==1? _itemCount:_itemCount--);
                                    },
                                    child: new  Container(
                                      decoration: BoxDecoration(
                                        color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                          left: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                        ),
                                      ),
                                      width: 40,
                                      height: 30,
                                      child:Center(
                                        child: Text(
                                          "-",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorCodes.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                            //color: Theme.of(context).buttonColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      :
                                  new Container(),
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                          left: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                          right: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                        ),
                                      ),
                                      width: 40,
                                      height: 30,
                                      child:
                                      Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.primaryColor, fontSize: 14, fontWeight: FontWeight.bold),))
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      setState(() {
                                        print("min itemm....."+widget.minitem.toString()+"min item////"+widget.maxitem.toString());
                                      if(_itemCount >= int.parse(widget.maxitem!)){
                                            Fluttertoast.showToast(
                                            msg:
                                            S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                                            fontSize: MediaQuery.of(context).textScaleFactor * 13,
                                            backgroundColor: Colors.black87,
                                            textColor: Colors.white);
                                            }
                                      else {
                                        _itemCount++;
                                      }
                                      });

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                          bottom: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                          right: BorderSide(
                                              width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                        ),
                                      ),
                                      width: 40,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          "+",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorCodes.primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                            //color: Theme.of(context).buttonColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // GestureDetector(
                              //
                              //   onTap: (){
                              //     print("edit tap........");
                              //     Navigation(context, name: Routename.EditSubscription, navigatore: NavigatoreTyp.Push,
                              //         qparms: {
                              //           "itemname":widget.itemname,
                              //           "itemimage":widget.itemimage,
                              //           "quantity":widget.quantity,
                              //           "unit":widget.unit,
                              //         });
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Text(/*"View All"*/S.of(context).edit_address, style: TextStyle(
                              //           fontSize: 13,
                              //           fontWeight: FontWeight.bold,
                              //           color: ColorCodes.primaryColor),),
                              //       Icon(Icons.keyboard_arrow_right, color: ColorCodes.primaryColor,),
                              //     ],
                              //   ),
                              // ),

                            ],
                          ),
                        ),
                      ],
                    )
                  ],),
              ],
            ),
          ),

          VxBuilder(
              mutations: {SubscriptionBoxController},
              builder: (ctx, store,VxStatus? state) {
                if (VxStatus.success == state)
                  return loaddescriptionBox();
                else if (state == VxStatus.none) {
                  if ((VxState.store as GroceStore)
                      .subscriptionBoxData.toJson().isEmpty) {
                    if( Features.issubscriptionbox)
                    /*  subscriptionApibox.getSubsctiptionBoxIDNew(ParamBodyDatabox( type: "all",
                          branch: PrefUtils.prefs!.getString("branch"),
                          languageid: IConstants.languageId,
                          user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
                              .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
                          subscription_id: widget.box_id.toString()));*/
                      SubscriptionBoxController(type: "all",
                          branch: PrefUtils.prefs!.getString("branch"),
                          languageid: IConstants.languageId,
                          user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
                              .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
                          subscription_id: widget.box_id.toString());
                    return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                        ? LoyalityorWalletShimmer(): LoyalityorWalletShimmer();

                  }
                  else {
                    return loaddescriptionBox();
                  }

                }
                return (Vx.isWeb &&
                    !ResponsiveLayout.isSmallScreen(context))
                    ? LoyalityorWalletShimmer() : LoyalityorWalletShimmer();
              }),

        ],
      ),
    );
  }

  loaddescriptionBox(){
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
    double aspectRatio =   (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))? (!Features.ismultivendor) ?
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 335:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 150 :
    Features.btobModule?(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 150:(deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 140;

    promoData = (VxState.store as GroceStore).subscriptionboxlist[0].boxProducts;
    productsdata.clear();
    productsdata = promoData!
        .where((map) =>
    map.label == promoData[_selectedIndex].label)
        .first
        .products!
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if(productsdata != null && productsdata.length > 0)
          Padding(
            padding: const EdgeInsets.only(top:15.0,bottom: 10),
            child: Text(S.of(context).change_menu,
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
          ),
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
                        "length..." + productsdata.length.toString() );
                    isselect = -1;
                  });

                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 0.0, top: 5.0, right: 5.0, bottom: 5.0),
                  margin: EdgeInsets.only(left: 0.0, top: 10.0, right: 8.0, bottom: 5.0),
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

        if(productsdata != null && productsdata.length > 0)
          SizedBox(height:10),
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
            print("product data length.....grid,..."+productsdata.length.toString() +"....index data ...."+productsdata[index].itemName.toString());

            print("data product mrp...."+productsdata[index].type.toString());

            double margins;

            margins = (productsdata[index].type == "1") ? Calculate().getmargin(
                productsdata[index].mrp.toString(),
                productsdata[index].price.toString()) :
            Calculate().getmargin(productsdata[index].priceVariation![0].mrp.toString(),
                productsdata[index].priceVariation![0].price.toString());

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
                if (productsdata[index].priceVariation![0]
                    .membershipDisplay!) { //Eligible to display membership price
                  _price = productsdata[index].priceVariation![0].membershipPrice!.toString();
                  _mrp = productsdata[index].priceVariation![0].mrp!.toString();
                } else if (productsdata[index].priceVariation![0]
                    .discointDisplay!) { //Eligible to display discounted price
                  _price = productsdata[index].priceVariation![0].price!.toString();
                  _mrp = productsdata[index].priceVariation![0].mrp!.toString();
                } else { //Otherwise display mrp
                  _price = productsdata[index].priceVariation![0].mrp!.toString();
                }
              }
            } else { //Non membered user
              print("data product mrp....1"+productsdata[index].type.toString()+ "nanme...."+productsdata[index].itemName.toString());
              if(productsdata[index].type == "1") {
                //singlesku
                print("nanme....single"+productsdata[index].itemName.toString() + "disc dis..."+productsdata[index].discointDisplay!.toString()  + "mrp...."+_mrp.toString());
                if(productsdata[index].discointDisplay!){ //Eligible to display discounted price
                  _price = productsdata[index].price!.toString();
                  _mrp = productsdata[index].mrp!.toString();
                } else { //Otherwise display mrp
                  _price = productsdata[index].mrp!.toString();
                  _mrp = "";
                }
              }
              else{ //multisku
                print("data product mrp....2"+productsdata[index].type.toString());
                print("nanme....multisku"+productsdata[index].itemName.toString() + "disc dis..."+productsdata[index].discointDisplay!.toString()  + "mrp...."+_mrp.toString());
                if(productsdata[index].priceVariation![0].discointDisplay!){ //Eligible to display discounted price
                  _price = productsdata[index].priceVariation![0].price!.toString();
                  _mrp = productsdata[index].priceVariation![0].mrp!.toString();
                } else { //Otherwise display mrp
                  _price = productsdata[index].priceVariation![0].mrp!.toString();
                  _mrp = "";
                }
              }



            }

            print("mrp.....111111  ..... "+_mrp.toString());
            if(Features.iscurrencyformatalign) {
              _price = '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
              if(_mrp != "")
                _mrp = '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ' + IConstants.currencyFormat;
            } else {
              print("mrp....."+_mrp.toString());
              _price = IConstants.currencyFormat + '${double.parse(_price).toStringAsFixed(IConstants.decimaldigit)} ';
              if(_mrp != "")
                _mrp =  IConstants.currencyFormat + '${double.parse(_mrp).toStringAsFixed(IConstants.decimaldigit)} ';
            }
            print("image ...."+productsdata[index].itemFeaturedImage.toString());
            return  productsdata[index].type=="1"?
            Container(
              width: MediaQuery.of(context).size.width,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border(
              //     bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
              //   ),
              // ),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.50)),
                  ],
                  borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
              margin: EdgeInsets.only(left: 5.0, bottom: 10.0, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                        ItemBadge(
                          outOfStock: productsdata[index].stock!<=0?OutOfStock(singleproduct: false,):null,
                          child: Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                },
                                child:  Stack(
                                  children: [

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: productsdata[index].itemFeaturedImage,
                                        errorWidget: (context, url, error) => Image.asset(
                                          Images.defaultProductImg,
                                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                          height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        ),
                                        placeholder: (context, url) => Image.asset(
                                          Images.defaultProductImg,
                                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                          height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        ),
                                        width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        //  fit: BoxFit.fill,
                                      ),
                                    ),

                                  ],
                                ),

                              ),
                            ),
                          ),
                        ),
                        // Stack(
                        //   children: [
                        //     ItemBadge(
                        //       outOfStock: productsdata[index].stock!<=0?OutOfStock(singleproduct: false,):null,
                        //       child: Align(
                        //         alignment: Alignment.center,
                        //         child: MouseRegion(
                        //           cursor: SystemMouseCursors.click,
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               // Navigation(context, name: Routename.SingleProduct, navigatore: NavigatoreTyp.Push,parms: {"varid": widget.itemdata!.id.toString(),"productId": widget.itemdata!.id!});
                        //
                        //             },
                        //             child: Container(
                        //               margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                        //               child: CachedNetworkImage(
                        //                 imageUrl: productsdata[index].itemFeaturedImage,
                        //                 errorWidget: (context, url, error) => Image.asset(
                        //                   Images.defaultProductImg,
                        //                   width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        //                   height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                        //                 ),
                        //                 placeholder: (context, url) => Image.asset(
                        //                   Images.defaultProductImg,
                        //                   width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        //                   height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                        //                 ),
                        //                 width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                        //                 height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                        //                 //  fit: BoxFit.fill,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: Features.btobModule?MainAxisAlignment.start:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.4),
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
                                      height: 10,
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
                                            ),
                                            Spacer(),
                                            GestureDetector(

                                              onTap: (){

                                              },
                                              child: Container(
                                                width:100,
                                                decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey[300]!,
                                                          blurRadius: 10.0,
                                                          offset: Offset(0.0, 0.50)),
                                                    ],
                                                    borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
                                                child:
                                                Text(/*"View All"*/S.of(context).select_subscription, style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.primaryColor),),
                                              ),
                                            ),
                                          ],
                                        )),
                                    SizedBox(height: 4,),


                                  ],
                                )),

                          ],
                        ),
                      ),
                      //SizedBox(height: 4),

                    ],
                  ),
                ],
              ),
            ):
            Container(
              width: MediaQuery.of(context).size.width,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border(
              //     bottom: BorderSide(width: 2.0, color: ColorCodes.lightGreyWebColor),
              //   ),
              // ),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.50)),
                  ],
                  borderRadius: new BorderRadius.all(const Radius.circular(8.0),)),
              margin: EdgeInsets.only(left: 5.0, bottom: 10.0, right: 5),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ItemBadge(
                          outOfStock: productsdata[index].priceVariation![0].stock!<=0?OutOfStock(singleproduct: false,):null,
                          child: Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                },
                                child:  Stack(
                                  children: [

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: productsdata[index].priceVariation![0].images!.length<=0?productsdata[index].itemFeaturedImage:productsdata[index].priceVariation![0].images![0].image,
                                        errorWidget: (context, url, error) => Image.asset(
                                          Images.defaultProductImg,
                                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                          height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        ),
                                        placeholder: (context, url) => Image.asset(
                                          Images.defaultProductImg,
                                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                                          height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        ),
                                        width: ResponsiveLayout.isSmallScreen(context) ? 115 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
                                        height: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 80 : 80,
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
                        width: (MediaQuery.of(context).size.width / 1.8),
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
                                    .width / 1.9),
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

                                            Spacer(),
                                            index == isselect?
                                            Row(
                                              children: [
                                                _count!=0?
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    print("min itemm1111....."+widget.maxitem.toString() +"min item////"+widget.minitem.toString() + "cpount...."+_itemCount.toString());
                                                    setState(() {
                                                      if(_count <= int.parse(productsdata[index].priceVariation![0].minItem!)){
                                                        isselect = -1;
                                                        // Fluttertoast.showToast(
                                                        //     msg:
                                                        //     S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                                                        //     fontSize: MediaQuery.of(context).textScaleFactor * 13,
                                                        //     backgroundColor: Colors.black87,
                                                        //     textColor: Colors.white);
                                                      }
                                                      else {
                                                        _count == 1
                                                            ? _count
                                                            : _count--;
                                                      }
                                                    });
                                                    //setState(()=>_itemCount==1? _itemCount:_itemCount--);
                                                  },
                                                  child: new  Container(
                                                    decoration: BoxDecoration(
                                                      color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        left: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                      ),
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                    child:Center(
                                                      child: Text(
                                                        "-",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: ColorCodes.grey,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16
                                                          //color: Theme.of(context).buttonColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    :
                                                new Container(),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        left: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                                        right: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                                      ),
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                    child:
                                                    Center(child: new Text(_count.toString(),style: TextStyle(color: ColorCodes.primaryColor, fontSize: 14, fontWeight: FontWeight.bold),))
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    setState(() {
                                                      print("min itemm....."+productsdata[index].priceVariation![0].maxItem!.toString()+"min item////"+productsdata[index].priceVariation![0].minItem!.toString());
                                                      if(_count >= int.parse(productsdata[index].priceVariation![0].maxItem!)){
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            S.of(context).cant_add_more_item, //"Sorry, you can\'t add more of this item!",
                                                            fontSize: MediaQuery.of(context).textScaleFactor * 13,
                                                            backgroundColor: Colors.black87,
                                                            textColor: Colors.white);
                                                      }
                                                      else {
                                                        _count++;
                                                      }
                                                    });

                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        bottom: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                        right: BorderSide(
                                                            width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                                      ),
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                    child: Center(
                                                      child: Text(
                                                        "+",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: ColorCodes.primaryColor,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold
                                                          //color: Theme.of(context).buttonColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ):
                                            GestureDetector(

                                              onTap: (){
                                                setState(() {
                                                  /*print("product selected...."+index.toString() + "////"+productsdata[index].isselected.toString());
                                                  if(productsdata[index].isselected = true){
                                                    productsdata[index]
                                                        .isselected = !productsdata[index].isselected!;
                                                  }
                                                  else {
                                                    productsdata[index]
                                                        .isselected = true;
                                                  }//!productsdata[index].isselected!;*/
                                                  // _isloading = true;
                                                  if(isselect == index){
                                                    isselect= 0;
                                                  }else{
                                                    isselect= index;
                                                    _count = 1;
                                                  }


                                                  /*widget.itemname =  Features.btobModule?productsdata[index].itemName! + "-" + productsdata[index].priceVariation![0].variationName!:productsdata[index].itemName!;
                                                  widget.itemimage = productsdata[index].priceVariation![0].images!.length<=0?productsdata[index].itemFeaturedImage:productsdata[index].priceVariation![0].images![0].image;
                                                  widget.quantity = productsdata[index].type == "1"?productsdata[index].quantity:productsdata[index].priceVariation![0].quantity;
                                                  widget.unit = productsdata[index].type == "1"?productsdata[index].unit:productsdata[index].priceVariation![0].unit;
                                                  widget.minitem = productsdata[index].type == "1"?productsdata[index].minItem.toString():productsdata[index].priceVariation![0].minItem!;
                                                  widget.maxitem = productsdata[index].type == "1"?productsdata[index].maxItem.toString():productsdata[index].priceVariation![0].maxItem!;
                                                  widget.stock = productsdata[index].type == "1"?productsdata[index].stock.toString():productsdata[index].priceVariation![0].stock.toString();
                                                  widget.price = productsdata[index].type == "1"?productsdata[index].price.toString():productsdata[index].priceVariation![0].price.toString();
                                                  widget.mrp = productsdata[index].type == "1"?productsdata[index].mrp.toString():productsdata[index].priceVariation![0].mrp.toString();
                                                  widget.membershiprice = productsdata[index].type == "1"?productsdata[index].membershipPrice.toString():productsdata[index].priceVariation![0].membershipPrice.toString();
                                                  widget.membershipdisplay = productsdata[index].type == "1"?productsdata[index].membershipDisplay.toString():productsdata[index].priceVariation![0].membershipDisplay.toString();
                                                  widget.discountdisplay = productsdata[index].type == "1"?productsdata[index].discointDisplay.toString():productsdata[index].priceVariation![0].discointDisplay.toString();;
                                                  widget.type = productsdata[index].type;
                                                  subscriptionApibox.getSubsctiptionBoxIDNew(ParamBodyDatabox( type: "all",
                                                      branch: PrefUtils.prefs!.getString("branch"),
                                                      languageid: IConstants.languageId,
                                                      user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
                                                          .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible",
                                                      subscription_id: widget.box_id.toString())).then((value) {
                                                        setState(() {
                                                          _isloading = false;
                                                        });

                                                  });
*/

                                                });
                                              },
                                              child: Container(
                                                width:70,
                                                height:30,
                                                decoration: new BoxDecoration(
                                                    border: Border.all(
                                                      color: ColorCodes.varcolor,
                                                    ),
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.all(const Radius.circular(3.0),)),

                                                child:
                                                Center(
                                                  child: Text(/*"View All"*//*index == isselect?S.of(context).selected_subscription:*/S.of(context).select_subscription, style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorCodes.primaryColor),),
                                                ),
                                              ),
                                            )

                                          ],
                                        )),

                                    SizedBox(
                                      height: 4,
                                    ),
                                    //:SizedBox.shrink(),

                                  ],
                                )),

                          ],
                        ),
                      ),
                      SizedBox(height: 3),

                    ],
                  ),
                ],
              ),
            );

          },
        ):SizedBox.shrink(),

      ],
    );

  }
}

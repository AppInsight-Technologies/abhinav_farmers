import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../data/calculations.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/product_data.dart';
import '../../providers/membershipitems.dart';
import '../../rought_genrator.dart';
import '../../screens/customer_support_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../StoreBottomNavigationWidget.dart';
import '../badge.dart';
import '../simmers/loyality_wallet_shimmer.dart';


class MembershipComponent extends StatefulWidget {
  const MembershipComponent({Key? key}) : super(key: key);

  @override
  State<MembershipComponent> createState() => _MembershipComponentState();
}

class _MembershipComponentState extends State<MembershipComponent>  with Navigations{
  bool _checkmembership = false;
  var orderdate = "";
  var expirydate = "";
  var orderid = "";
  var ordertotal = "";
  var name = "";
  var duration = "";
  var paytype = "";
  var address = "";
  bool _loading = true;
  bool checkskip = false;
  bool memberMode = false;
  var _address = "";
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool _isAddToCart = false;
  bool iphonex = false;
  var email = "", photourl = "", phone = "";
  var postImage= "";
  GroceStore store = VxState.store;
  List<CartItem> productBox=[];
  String addedmembership = "";

  String selectedPlan= "";
  String price = "";
  bool selected = false;
  int _isselect = 0;

  @override
  void initState() {

    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      _isselect = -1;
      name = store.userData.username!;
      if (PrefUtils.prefs!.getString('Email') != null) {
        email = PrefUtils.prefs!.getString('Email')!;
      } else {
        email = "";
      }

      if (PrefUtils.prefs!.getString('mobile') != null) {
        phone = PrefUtils.prefs!.getString('mobile')!;
      } else {
        phone = "";
      }
      _address = PrefUtils.prefs!.getString("restaurant_address")!;
      if (!PrefUtils.prefs!.containsKey("apikey")) {
        setState(() {
          checkskip = true;
        });
      } else {
        checkskip = false;
      }

      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode == "1") {
          memberMode = true;
        }
      }
      if (memberMode) {
        Provider.of<MembershipitemsList>(context, listen: false).Getmembership().then((_) async {
          final membershipData = Provider.of<MembershipitemsList>(context, listen: false);
          if (membershipData.items.length > 0)
            await precacheImage(AssetImage(membershipData.items[0].avator!), context).then((_) {
              Future.delayed(Duration.zero, () async {
                setState(() {
                  _loading = false;
                  _checkmembership = false;
                });
              });
            }); else {
            setState(() {
              _loading = false;
              _checkmembership = false;
            });
          }


          for (int j = 0; j < membershipData.typesitems.length; j++) {
            for (int k = 0; k < (VxState.store as GroceStore).CartItemList.length; k++) {
              if ((VxState.store as GroceStore).CartItemList[k].membershipId == membershipData.typesitems[j].typesid.toString()) {
                _isselect = j;
                break;
              }
            }
          }

        });
      } else if (store.userData.membership! == "1") {
        _checkmembership = true;
        Provider.of<MembershipitemsList>(context,listen: false).Getmembershipdetails().then((_) async {
          setState(() {
            postImage =PrefUtils.prefs!.getString("post_image")!;
            orderdate = PrefUtils.prefs!.getString("orderdate")!;
            expirydate = PrefUtils.prefs!.getString("expirydate")!;
            orderid = PrefUtils.prefs!.getString("orderid")!;
            ordertotal = PrefUtils.prefs!.getString("membershipprice")!;
            duration = PrefUtils.prefs!.getString("duration")!;
            paytype = PrefUtils.prefs!.getString("memebershippaytype")!;
            address = PrefUtils.prefs!.getString("membershipaddress")!;
            _loading = false;
          });
        });
      } else {
        Provider.of<MembershipitemsList>(context, listen: false).Getmembership().then((_) async {
          final membershipData = Provider.of<MembershipitemsList>(context, listen: false);
          if (membershipData.items.length > 0)
            await precacheImage(AssetImage(membershipData.items[0].avator!), context).then((_) {
              Future.delayed(Duration.zero, () async {
                setState(() {
                  _loading = false;
                  _checkmembership = false;
                });
              });
            }); else {
            setState(() {
              _loading = false;
              _checkmembership = false;
            });
          }


        });
      }
    });
    super.initState();
  }

  _addtocart(String membershipid, String duration, String discountprice, String price) async {
    addedmembership = "yes";
    cartcontroller.addtoCart( itemdata: ItemData(type: "",eligibleForExpress: "1",vegType:"",delivery: "0",
        duration:"0",brand: "",id: "0",itemName: "Membership",mode: "1",
        membershipId: membershipid,
        deliveryDuration:DeliveryDurationData(duration:"",status: "",durationType: "",note: "", id: "",branch: "",blockFor: "") ), onload: (onload){
      setState(() {
        _isAddToCart = onload;
      });
    },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody: PriceVariation(quantity: 1,mode: "4",status: "0",discointDisplay: false,
        loyaltys:0,membershipDisplay:false,menuItemId: "",
        netWeight: "",weight:"",id: "0",variationName: duration,unit: S .of(context).membership_month ,minItem: "1",
        maxItem: "1",loyalty: 0,stock: 1,mrp:discountprice,
        price: discountprice,membershipPrice: discountprice),context: context);
  }

  _removefromcart(String discountprice) async {
    addedmembership = "No";
    cartcontroller.update((done){
      PrefUtils.prefs!.setString("membership", "0");
      CartCalculations.deleteMembershipItem();

      setState(() {
        _isAddToCart = false;
      });
    },price: double.parse(discountprice).toString(),var_id:"0",quantity: "0",weight: "0",cart_id: "",toppings: "",
      topping_id: "",);
  }

  _updatetocart(String membershipid, String duration, String discountprice, String price) async {

    CartCalculations.deleteMembershipItem();
    cartcontroller.addtoCart(itemdata:
    ItemData(type: "",eligibleForExpress: "1",vegType:"",delivery: "0",
        duration:"0",brand: "",id: "0",itemName: "Membership",mode: "1",
        membershipId: membershipid,
        deliveryDuration:DeliveryDurationData(duration:"",status: "",durationType: "",note: "", id: "",branch: "",blockFor: "") ), onload: (onload){
      setState(() {
        _isAddToCart = onload;
      });
    },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody: PriceVariation(quantity: 1,mode: "4",status: "0",discointDisplay: false,
        loyaltys:0,membershipDisplay:false,menuItemId: "",
        netWeight: "",weight:"",id: "0",variationName: duration,unit: S .of(context).membership_month ,
        minItem: "1",
        maxItem: "1",loyalty: 0,stock: 1,mrp: discountprice,
        price: discountprice,membershipPrice: discountprice),
        context: context);
  }

  void launchWhatsApp() async {
    String phone = IConstants.secondaryMobile;
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse('I want to order Grocery')}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse('I want to order Grocery')}";

      }
    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;

    bottomNavigationbar() {
      final membershipData = Provider.of<MembershipitemsList>(context,listen: false);
      return _checkmembership?
      SingleChildScrollView(
        child: Container(
          height: 65,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: ColorCodes.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            // shape: BoxShape.circle,
          ),
          child: Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigation(context,navigatore: NavigatoreTyp.homenav);
                },
                child: Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          Images.homeImg,
                          color: ColorCodes.whiteColor,
                          width: 30,
                          height: 25,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S.of(context).home,//"Home",
                          style: TextStyle(
                            color: ColorCodes.whiteColor,
                            fontSize: 10.0,
                          )),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigation(context, name:Routename.Category, navigatore: NavigatoreTyp.Push);
                },
                child: Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.categoriesImg,
                            width: 20,
                            height: 25,
                            color: ColorCodes.whiteColor),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S .of(context).categories,//"Categories",
                          style: TextStyle(
                              color: ColorCodes.whiteColor, fontSize: 10.0)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              if(Features.isWallet)
                Spacer(),
              if(Features.isWallet)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                    Navigation(context, name: Routename.Wallet, navigatore: NavigatoreTyp.Push,
                        qparms: {
                          "type":"wallet",
                        });
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.walletImg,
                              width: 20,
                              height: 25,
                              color: ColorCodes.whiteColor),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                            S .of(context).wallet,//"Wallet",
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(Features.isMembership)
                Spacer(),
              if(Features.isMembership)
                Container(
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      CircleAvatar(
                        radius: 13.0,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(Images.bottomnavMembershipImg,
                            width: 20,
                            height: 25,
                            color: IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                          S .of(context).membership,//"Membership",
                          style: TextStyle(
                              color: IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              if(!Features.isMembership)
                Spacer(),
              if(!Features.isMembership)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                    Navigation(context, name:Routename.MyOrders,navigatore: NavigatoreTyp.Push,
                    );
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                              Images.shoppinglistsImg,
                              width: 20,
                              height: 25,
                              color: IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                            S .of(context).my_orders,//"My Orders",
                            style: TextStyle(
                                color: IConstants.isEnterprise?ColorCodes.badgecolor:ColorCodes.maphome,
                                fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(Features.isShoppingList)
                Spacer(flex: 1),
              if(Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        :
                    Navigation(context, name: Routename.Shoppinglist, navigatore: NavigatoreTyp.Push);
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(Images.shoppinglistsImg,
                            width: 18,
                            height: 25,
                            color: ColorCodes.whiteColor,),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                            S .of(context).shopping_list,//"Shopping list",
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              if(!Features.isShoppingList)
                Spacer(),
              if(!Features.isShoppingList)
                GestureDetector(
                  onTap: () {
                    checkskip && Features.isLiveChat
                        ?
                    Navigation(context, name: Routename.SignUpScreen, navigatore: NavigatoreTyp.Push)
                        : (Features.isLiveChat && Features.isWhatsapp)?
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    }):
                    (!Features.isLiveChat && !Features.isWhatsapp)?
                    Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search)
                        :
                    Features.isWhatsapp?launchWhatsApp()/*launchWhatsapp(number: IConstants.countryCode + IConstants.secondaryMobile, message:"I want to order Grocery")*/:
                    Navigator.of(context)
                        .pushNamed(CustomerSupportScreen.routeName, arguments: {
                      'name': name,
                      'email': email,
                      'photourl': photourl,
                      'phone': phone,
                    });
                  },
                  child: Container(
                    width: 60,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        CircleAvatar(
                          radius: 13.0,
                          backgroundColor: Colors.transparent,
                          child: (!Features.isLiveChat && !Features.isWhatsapp)?
                          Icon(
                            Icons.search,
                            color: ColorCodes.whiteColor,

                          )
                              :
                          Image.asset(
                            Features.isLiveChat?Images.appCustomer: Images.whatsapp,
                            width: 20,
                            height: 25,
                            color: Features.isLiveChat?ColorCodes.whiteColor:null,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text((!Features.isLiveChat && !Features.isWhatsapp)? S .of(context).search//"Search"
                            : S .of(context).chat,//"Chat",
                            style: TextStyle(
                                color: ColorCodes.whiteColor, fontSize: 10.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              Spacer(),
            ],
          ),
        ),
      ):
      _loading
          ? Center(
        child: LoyalityorWalletShimmer(),
      )
          :
      VxBuilder(
          mutations: {ProductMutation},
          builder: (context, box, _) {
            for (int j = 0; j < membershipData.typesitems.length; j++) {
              if (!CartCalculations.checkmembershipexist) {
                membershipData.typesitems[j].text = "Select";
                membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

              } else {
                for (int k = 0; k < productBox.length; k++) {
                  if (productBox[k].membershipId.toString() == membershipData.typesitems[j].typesid) {
                    membershipData.typesitems[j].text = "Remove";
                    membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                    membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                    membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                  } else {
                    membershipData.typesitems[j].text = "Update";
                    membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                    membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                    membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                  }
                }
              }

            }
            return GestureDetector(
              onTap: () async {
                if( _isselect == -1 ){
                  Fluttertoast.showToast(msg: S .of(context).select_any_plan,//"Your order with Membership is processing!",
                      fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
                }
                else{
                  if((VxState.store as GroceStore).userData.membership! == "0" || memberMode ||
                      (VxState.store as GroceStore).userData.membership! == "1") {
                    Navigation(context, name: Routename.Cart,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {"afterlogin": addedmembership});
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 65,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: ColorCodes.primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  // shape: BoxShape.circle,
                ),
                child:

                _isAddToCart ? Center(
                  child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: new CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.whiteColor),)),
                )
                    :Center(
                  child: Text(
                    S.of(context).buy.toUpperCase() + " "+ IConstants.APP_NAME + " "+S.of(context).membership.toUpperCase(),
                    style: TextStyle(
                      color: ColorCodes.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            );
          }
      );
    }

    return WillPopScope(
      onWillPop: (){
        if(addedmembership == "yes"){
          if(Vx.isWeb){
            Navigator.of(context).pop();
          }else {
            HomeScreenController(
                user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("tokenid"),
                branch: (VxState.store as GroceStore).userData.branch ?? "999",
                rows: "0");
            Navigator.of(context).pop();
          }
        }else if(addedmembership == "No"){
          if(Vx.isWeb){
            Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
          }else {
            HomeScreenController(
                user: (VxState.store as GroceStore).userData.id ??
                    PrefUtils.prefs!.getString("tokenid"),
                branch: (VxState.store as GroceStore).userData.branch ?? "999",
                rows: "0");
            Navigator.of(context).pop();
          }
        }else {
          if(Vx.isWeb){
            Navigator.of(context).pop();
          }else {
            Navigator.of(context).pop();
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar:  ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            //if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) Header(false),
            _body(),
          ],
        ),
        bottomNavigationBar: Vx.isWeb ? SizedBox.shrink() : Padding(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
          child: (Features.ismultivendor)? StoreBottomNavigation() : bottomNavigationbar(),
        ),
      ),
    );
  }

  Widget _body(){
    final membershipData = Provider.of<MembershipitemsList>(context,listen: false);
    return _checkmembership
        ?  Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _loading
                ? Center(
              child: LoyalityorWalletShimmer(),
            )
                :
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,
                child: Column(
                  children: <Widget>[
                    Image.network(
                      postImage,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Divider(
                      color: ColorCodes.lightskybluecolor,
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: ColorCodes.yellowColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          S .of(context).plan,//"Plan:",
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          PrefUtils.prefs!.getString("membershipname")!,
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          Features.iscurrencyformatalign?
                          double.parse(ordertotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat :
                          IConstants.currencyFormat + " " + double.parse(ordertotal).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5.0),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Divider(
                      color: ColorCodes.lightskybluecolor,
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 45.0),
                        Icon(
                          Icons.star,
                          color: ColorCodes.yellowColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          S .of(context).renewal_payment,//"Renewal and Next Payment",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 5, 40, 10),
                      child: Text(
                        S .of(context).membership_expire//'Your membership will expire on '
                            + expirydate +
                            S .of(context).inform_via_sms, //'. You will be informed via email or SMS and can renew only after expiry.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 50),

                  ],
                ),

              ),
            ),
            SizedBox(height: 40,),
            // if (Vx.isWeb)
            //   Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        ),
      ),
    )
        : Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _loading
                ? Container(
              height: 100,
              child: Center(
                child: Container(),
              ),
            )
                :
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,
                child: Column(
                  children: <Widget>[
                    if(membershipData.items.length > 0)
                      CachedNetworkImage(
                        imageUrl: membershipData.items[0].avator,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    if(membershipData.items.length > 0)
                      SizedBox(height: 10.0),
                    VxBuilder(
                        mutations: {SetCartItem},
                        builder: (ctx,store,VxStatus? state)
                        {
                          return Container(
                            //height: 400,
                            padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                            color: ColorCodes.whiteColor,//Theme.of(context).primaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(left: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?5:10.0, right:Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?5: 10.0),
                                    child: Text(
                                      S .of(context).select_membership,//"Select the membership plan which suits your needs",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?20:22.0,
                                          color: ColorCodes.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),


                                SizedBox(
                                    height: ResponsiveLayout.isSmallScreen(context) ?
                                    80 :  80,
                                    child: new ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: membershipData.typesitems.length,
                                      itemBuilder: (_, i) {
                                        return VxBuilder(
                                            mutations: {ProductMutation},
                                            builder: (context, box, _) {
                                              for (int j = 0; j < membershipData.typesitems.length; j++) {
                                                if (!CartCalculations.checkmembershipexist) {
                                                  membershipData.typesitems[j].text = "Select";
                                                  membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                                                  membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                                                  membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                                                } else {
                                                  for (int k = 0; k < productBox.length; k++) {
                                                    if (productBox[k].membershipId.toString() == membershipData.typesitems[j].typesid) {
                                                      membershipData.typesitems[j].text = "Remove";
                                                      membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                                                      membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                                                      membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                                                    } else {
                                                      membershipData.typesitems[j].text = "Update";
                                                      membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                                                      membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                                                      membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                                                    }
                                                  }
                                                }

                                              }
                                              return GestureDetector(
                                                onTap: () {

                                                  if((VxState.store as GroceStore).userData.membership! == "0" || memberMode ||
                                                      (VxState.store as GroceStore).userData.membership! == "1") {
                                                    setState(() {
                                                      _isselect = i;
                                                      _isAddToCart = true;
                                                    });
                                                    if (membershipData.typesitems[i].text == "Select") {
                                                      selectedPlan = membershipData.typesitems[i].typesduration!;
                                                      price = membershipData.typesitems[i].typesdiscountprice!;
                                                      _addtocart(
                                                        membershipData.typesitems[i].typesid!,
                                                        membershipData.typesitems[i].typesduration!,
                                                        membershipData.typesitems[i].typesdiscountprice!,
                                                        membershipData.typesitems[i].typesprice!,
                                                      );
                                                    } else
                                                    if (membershipData.typesitems[i].text == "Remove") {
                                                      selectedPlan = "";
                                                      price = "";
                                                      _removefromcart(membershipData.typesitems[i].typesdiscountprice!);
                                                    } else {
                                                      selectedPlan = membershipData.typesitems[i].typesduration!;
                                                      price = membershipData.typesitems[i].typesdiscountprice!;
                                                      _updatetocart(
                                                        membershipData.typesitems[i].typesid!,
                                                        membershipData.typesitems[i].typesduration!,
                                                        membershipData.typesitems[i].typesdiscountprice!,
                                                        membershipData.typesitems[i].typesprice!,
                                                      );
                                                    }
                                                  }
                                                  else {
                                                    Fluttertoast.showToast(msg: S .of(context).membership_processing,//"Your order with Membership is processing!",
                                                        fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
                                                  }
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?MediaQuery.of(context).size.width/10:MediaQuery.of(context).size.width/3.2,
                                                      margin:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        color: _isselect == i?membershipData.typesitems[i].backgroundcolor:ColorCodes.whiteColor,
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color:  _isselect == i?membershipData.typesitems[i].borderColor!:ColorCodes.lightGreyWebColor),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                                        child:
                                                        ((membershipData.typesitems[i].typesdiscountprice == membershipData.typesitems[i].typesprice) || double.parse(membershipData.typesitems[i].typesdiscountprice!) <= 0)?
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                double.parse(membershipData.typesitems[i].typesdiscountprice!) <= 0?
                                                                Text(
                                                                  Features.iscurrencyformatalign?
                                                                  double.parse(membershipData.typesitems[i].typesprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat:
                                                                  IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: membershipData
                                                                        .typesitems[i]
                                                                        .textcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ):
                                                                Text(
                                                                  Features.iscurrencyformatalign?
                                                                  double.parse(membershipData.typesitems[i].typesdiscountprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat:
                                                                  IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesdiscountprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: membershipData
                                                                        .typesitems[i]
                                                                        .textcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                            Text(
                                                              membershipData.typesitems[i].typesduration! + S .of(context).membership_month,//" month",
                                                              style: TextStyle(
                                                                  color: membershipData.typesitems[i].textcolor,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.w600),
                                                            ),
                                                          ],
                                                        )
                                                            : Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  Features.iscurrencyformatalign?
                                                                  double.parse(membershipData.typesitems[i].typesdiscountprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat:
                                                                  IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesdiscountprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: membershipData
                                                                        .typesitems[i]
                                                                        .textcolor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4,),
                                                                Text(
                                                                  Features.iscurrencyformatalign?
                                                                  double.parse(membershipData.typesitems[i].typesprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat :
                                                                  IConstants.currencyFormat + " " + double.parse(membershipData.typesitems[i].typesprice!).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
                                                                  style: TextStyle(
                                                                      color: membershipData
                                                                          .typesitems[i]
                                                                          .textcolor,
                                                                      fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 12,
                                                                      decoration: TextDecoration.lineThrough,
                                                                      fontWeight: FontWeight.w400

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              membershipData.typesitems[i].typesduration !+ S .of(context).membership_month,//" month",
                                                              style: TextStyle(
                                                                  color: membershipData.typesitems[i].textcolor,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.w600),
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 8,
                                                      //top:0,
                                                      child: _isselect == i ?
                                                      Container(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        padding: EdgeInsets.only(right:3),
                                                        decoration: BoxDecoration(
                                                          color: ColorCodes.greenColor,
                                                          border: Border.all(
                                                            color: ColorCodes.greenColor,
                                                          ),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Container(
                                                          margin: EdgeInsets.all(1.5),
                                                          decoration: BoxDecoration(
                                                            color: ColorCodes.greenColor,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Icon(Icons.check,
                                                              color: ColorCodes.whiteColor,
                                                              size: 14.0),
                                                        ),
                                                      )
                                                          :
                                                      Icon(
                                                          Icons.radio_button_off_outlined,
                                                          color: ColorCodes.whiteColor),)
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    )),

                              ],
                            ),
                          );
                        }),
                    SizedBox(height: 10.0),

                    Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                    VxBuilder(
                        mutations: {ProductMutation},
                        builder: (context, box, _) {
                          for (int j = 0; j < membershipData.typesitems.length; j++) {
                            if (!CartCalculations.checkmembershipexist) {
                              membershipData.typesitems[j].text = "Select";
                              membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                              membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                              membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                            } else {
                              for (int k = 0; k < productBox.length; k++) {
                                if (productBox[k].membershipId.toString() == membershipData.typesitems[j].typesid) {
                                  membershipData.typesitems[j].text = "Remove";
                                  membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                                  membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                                  membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                                } else {
                                  membershipData.typesitems[j].text = "Update";
                                  membershipData.typesitems[j].backgroundcolor = ColorCodes.varcolor;
                                  membershipData.typesitems[j].textcolor = ColorCodes.primaryColor;
                                  membershipData.typesitems[j].borderColor = ColorCodes.primaryColor;

                                }
                              }
                            }

                          }
                          return GestureDetector(
                            onTap: (){
                              if( _isselect == -1 ){
                                Fluttertoast.showToast(msg: S .of(context).select_any_plan,//"Your order with Membership is processing!",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
                              }
                              else{
                                if((VxState.store as GroceStore).userData.membership! == "0" || memberMode ||
                                    (VxState.store as GroceStore).userData.membership! == "1") {
                                  Navigator.of(context).pop();
                                  Navigation(context, name: Routename.Cart,
                                      navigatore: NavigatoreTyp.Push,
                                      qparms: {"afterlogin": addedmembership});
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 65,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: ColorCodes.primaryColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                                // shape: BoxShape.circle,
                              ),
                              child:

                              _isAddToCart ? Center(
                                child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: new CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.whiteColor),)),
                              )
                                  :Center(
                                child: Text(
                                  S.of(context).buy.toUpperCase() + " "+ IConstants.APP_NAME + " "+S.of(context).membership.toUpperCase(),
                                  style: TextStyle(
                                    color: ColorCodes.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ):SizedBox.shrink(),


                  ],
                ),
              ),
            ),
            //if (Vx.isWeb)Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        ),
      ),
    );
  }
  gradientappbarmobile() {
    return AppBar(
      brightness: Brightness.dark,
      //toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: ()  {
            if(addedmembership == "yes"){
              HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                  PrefUtils.prefs!.getString("tokenid"),
                  branch: (VxState.store as GroceStore).userData.branch ?? "999",
                  rows: "0");
              Navigator.of(context).pop();
            }else if(addedmembership == "No"){
              HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                  PrefUtils.prefs!.getString("tokenid"),
                  branch: (VxState.store as GroceStore).userData.branch ?? "999",
                  rows: "0");
              Navigator.of(context).pop();
            }else {
              Navigator.of(context).pop();
            }
          }),
      title: Text(
        S .of(context).membership,//'Membership',
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
        Container(
          child: VxBuilder(
            mutations: {SetCartItem},
            builder: (context, box, index) {
              if (box.CartItemList.isEmpty)
                return GestureDetector(
                  onTap: () {
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":addedmembership});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15, right: 10, bottom: 15),
                    width: 25,
                    height: 25,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child:
                    Image.asset(
                      Images.header_cart,
                      height: 28,
                      width: 28,
                      color:IConstants.isEnterprise ?ColorCodes.blackColor: ColorCodes.mediumBlackWebColor,
                    ),
                  ),
                );


              return Consumer<CartCalculations>(
                builder: (_, cart, ch) => Badge(
                  child: ch!,
                  color: ColorCodes.badgecolor,
                  value: CartCalculations.itemCount.toString(),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":addedmembership});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10, bottom: 15),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child:
                    Image.asset(
                      Images.header_cart,
                      height: 28,
                      width: 28,
                      color: IConstants.isEnterprise && !Features.ismultivendor ?ColorCodes.blackColor: ColorCodes.mediumBlackWebColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

}

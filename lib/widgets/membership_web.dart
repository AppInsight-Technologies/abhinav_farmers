import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocbay/rought_genrator.dart';
import 'package:grocbay/widgets/simmers/loyality_wallet_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../controller/mutations/cart_mutation.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/product_data.dart';
import '../providers/membershipitems.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import 'footer.dart';

class MembershipWeb with Navigations{
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
  //SharedPreferences prefs;
  // bool _isWeb = false;
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
  StateSetter? setstate;


  MembershipWeb(context,{Function(bool)? result}){
    _dialogformembership(context);
  }


  _addtocart(BuildContext context,String membershipid, String duration, String discountprice, String price) async {
    // await Provider.of<CartItems>(context, listen: false).addToCart(
    //     "0", "0", duration, "1", "1", "1", "1", price, "Membership",
    //     "1", double.parse(discountprice).toString(), discountprice, Images.membershipImg, membershipid, "1", "","1","","","","","").then((_) {
    //
    //
    //   setState(() {
    //     _isAddToCart = false;
    //   });
    //   PrefUtils.prefs!.setString("membership", "1");
    //
    //   Product products = Product(
    //       itemId: 0,
    //       varId: 0,
    //       varName: duration,
    //       varMinItem: 1,
    //       varMaxItem: 1,
    //       varStock: 1,
    //       varMrp: double.parse(price),
    //       itemName: "Membership",
    //       itemQty: 1,
    //       itemPrice: double.parse(discountprice),
    //       membershipPrice: discountprice,
    //       itemActualprice: double.parse(price),
    //       itemImage: Images.membershipImg,
    //       membershipId: int.parse(membershipid),
    //       mode: 1,
    //       veg_type: "",
    //       type: "",
    //       eligible_for_express: "",
    //       delivery: "",
    //       duration: "",
    //       durationType: "",
    //       note: ""
    //   );
    //
    //   //productBox.add(products);
    // });
    addedmembership = "yes";
    debugPrint("addmembership...."+addedmembership);
    cartcontroller.addtoCart( itemdata: ItemData(type: "",eligibleForExpress: "1",vegType:"",delivery: "0",
        duration:"0",brand: "",id: "0",itemName: "Membership",mode: "1",
        membershipId: membershipid,
        deliveryDuration:DeliveryDurationData(duration:"",status: "",durationType: "",note: "", id: "",branch: "",blockFor: "") ), onload: (onload){
      setstate!(() {
        _isAddToCart = onload;
      });
    },topping_type: "",varid: "",toppings: "0",parent_id: "",newproduct: "0",toppingsList: [],itembody: PriceVariation(quantity: 1,mode: "4",status: "0",discointDisplay: false,
        loyaltys:0,membershipDisplay:false,menuItemId: "",
        netWeight: "",weight:"",id: "0",variationName: duration,unit: S.of(context).membership_month ,minItem: "1",
        maxItem: "1",loyalty: 0,stock: 1,mrp:discountprice,
        price: discountprice,membershipPrice: discountprice),context: context);
  }

  _removefromcart(String discountprice) async {
    addedmembership = "No";
    // await Provider.of<CartItems>(context, listen: false).updateCart(
    //     "0", "0", double.parse(discountprice).toString()).then((_) {
    //
    //   PrefUtils.prefs!.setString("membership", "0");
    //   CartCalculations.deleteMembershipItem();
    //
    //   setState(() {
    //     _isAddToCart = false;
    //   });
    // });

    cartcontroller.update((done){
      PrefUtils.prefs!.setString("membership", "0");
      CartCalculations.deleteMembershipItem();

      setstate!(() {
        _isAddToCart = false;
      });
    },price: double.parse(discountprice).toString(),var_id:"0",quantity: "0",weight: "0",cart_id: "",toppings: "",
      topping_id: "",);
  }

  _updatetocart(BuildContext context,String membershipid, String duration, String discountprice, String price) async {

    CartCalculations.deleteMembershipItem();
    cartcontroller.addtoCart(itemdata:
    ItemData(type: "",eligibleForExpress: "1",vegType:"",delivery: "0",
        duration:"0",brand: "",id: "0",itemName: "Membership",mode: "1",
        membershipId: membershipid,
        deliveryDuration:DeliveryDurationData(duration:"",status: "",durationType: "",note: "", id: "",branch: "",blockFor: "") ), onload: (onload){
      setstate!(() {
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


  _dialogformembership(context) {
    productBox = /*Hive.box<Product>(productBoxName);*/(VxState.store as GroceStore).CartItemList;
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
        setstate!(() {
          checkskip = true;
        });
      } else {
        checkskip = false;
      }

      for (int i = 0; i < productBox.length; i++) {
        debugPrint("mode...."+productBox[i].mode.toString());
        if (productBox[i].mode == "1") {
          memberMode = true;
        }
      }

      print("is loading....."+_loading.toString());
      //prefs = await SharedPreferences.getInstance();
      //  await Provider.of<BrandItemsList>(context,listen: false).userDetails().then((_) {

      //});
    });

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
        final membershipData = Provider.of<MembershipitemsList>(context,listen: false);
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

          });
        } else if (store.userData.membership! == "1") {
          _checkmembership = true;
          Provider.of<MembershipitemsList>(context,listen: false).Getmembershipdetails().then((_) async {
            setState(() {
              postImage = PrefUtils.prefs!.getString("post_image")!;
              orderdate = PrefUtils.prefs!.getString("orderdate")!;
              expirydate = PrefUtils.prefs!.getString("expirydate")!;
              orderid = PrefUtils.prefs!.getString("orderid")!;
              ordertotal = PrefUtils.prefs!.getString("membershipprice")!;
              // name = PrefUtils.prefs!.getString("membershipname");
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
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3,maxHeight: MediaQuery.of(context).size.height/2),
            child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: _checkmembership
                ?  SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _loading
                          ? Container(
                        //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3,maxHeight: MediaQuery.of(context).size.height/2),
                        width: MediaQuery.of(context).size.width/3,
                        height: MediaQuery.of(context).size.height/2,
                            child: Center(
                        child: LoyalityorWalletShimmer(),
                      ),
                          )
                          :
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width/3,
                          //constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,
                          child: Column(
                            children: <Widget>[
                              /*SizedBox(
                                  height: 50.0,
                                ),*/
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
                )
                : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _loading
                          ? Container(
                        //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3,maxHeight: MediaQuery.of(context).size.height/2),
                        width: MediaQuery.of(context).size.width/3,
                        height: MediaQuery.of(context).size.height/2,
                        child: Center(
                          child: Container(),
                        ),
                      )
                          :
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width/3,
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
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                              child: Text(
                                                S .of(context).select_membership,//"Select the membership plan which suits your needs",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: ColorCodes.primaryColor,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin:EdgeInsets.only(left:20,right: 20),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                // scrollDirection: Axis.vertical,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                membershipData.typesitems.length,
                                                itemBuilder: (ctx, i) {
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
                                                            debugPrint("select....."+(VxState.store as GroceStore).userData.membership!);
                                                            if((VxState.store as GroceStore).userData.membership! == "0" || memberMode ||
                                                                (VxState.store as GroceStore).userData.membership! == "1") {
                                                              debugPrint("select.....if");
                                                              setState(() {
                                                                _isselect = i;
                                                                _isAddToCart = true;
                                                              });
                                                              if (membershipData.typesitems[i].text == "Select") {
                                                                selectedPlan = membershipData.typesitems[i].typesduration!;
                                                                price = membershipData.typesitems[i].typesdiscountprice!;
                                                                debugPrint("select.....1");
                                                                _addtocart(
                                                                  context,
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
                                                                  context,
                                                                  membershipData.typesitems[i].typesid!,
                                                                  membershipData.typesitems[i].typesduration!,
                                                                  membershipData.typesitems[i].typesdiscountprice!,
                                                                  membershipData.typesitems[i].typesprice!,
                                                                );
                                                              }
                                                            }
                                                            else {
                                                              debugPrint("select.....else" + membershipData.typesitems[i].typesdiscountprice!.toString());
                                                              Fluttertoast.showToast(msg: S .of(context).membership_processing,//"Your order with Membership is processing!",
                                                                  fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
                                                            }
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 50,
                                                            //padding: EdgeInsets.all(10),
                                                            margin:
                                                            EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              /*horizontal: 10*/),
                                                            decoration: BoxDecoration(
                                                              color: membershipData.typesitems[i].backgroundcolor,
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(
                                                                  width: 1.0,
                                                                  color:  _isselect == i?membershipData.typesitems[i].borderColor!:ColorCodes.whiteColor),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              child: _isAddToCart ? Center(
                                                                child: SizedBox(
                                                                    width: 20.0,
                                                                    height: 20.0,
                                                                    child: new CircularProgressIndicator(
                                                                      strokeWidth: 2.0,
                                                                      valueColor: new AlwaysStoppedAnimation<Color>(ColorCodes.primaryColor),)),
                                                              )
                                                                  :
                                                              ((membershipData.typesitems[i].typesdiscountprice == membershipData.typesitems[i].typesprice) || double.parse(membershipData.typesitems[i].typesdiscountprice!) <= 0)?
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                  Text(
                                                                    membershipData.typesitems[i].typesduration! + S .of(context).membership_month,//" month",
                                                                    style: TextStyle(
                                                                        color: membershipData.typesitems[i].textcolor,
                                                                        fontSize: 18.0,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                ],
                                                              )
                                                                  : Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                            fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,
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
                                                        );
                                                      });
                                                }),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              SizedBox(height: 10.0),
                              (selectedPlan == "" && price == "")?SizedBox.shrink():
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                child: Center(
                                  child: Text(/*"You have selected Membership of price "*/S.of(context).selected_membership +
                                      IConstants.currencyFormat + " " + price+/*" for the duration of "*/S.of(context).for_duration+selectedPlan + S .of(context).membership_month,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: ColorCodes.primaryColor
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          );
      });
        }
    );

  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/api.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/product_data.dart';
import '../providers/myorderitems.dart';

import '../rought_genrator.dart';

import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/item_list_shimmer.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class PromocodeComponent extends StatefulWidget{
  static const routeName = '/promocode-screen';

  String? minimumOrderAmountNoraml="";
  String? deliveryChargeNormal ="";
  String? minimumOrderAmountPrime = "";
  String? deliveryChargePrime = "";
  String? minimumOrderAmountExpress ="";
  String? deliveryChargeExpress = "";
  String? deliveryType = "";
  String? addressId = "";
  String? note = "";
  String? deliveryCharge = "";
  String? deliveryDurationExpress = "";
  String? deliveryAmt = "";
  Map<String, String>? params1;
  PromocodeComponent(this.minimumOrderAmountNoraml,this.deliveryChargeNormal,this.minimumOrderAmountPrime,this.deliveryChargePrime,
    this.minimumOrderAmountExpress,this.deliveryChargeExpress,this.deliveryType,this.addressId,this.note,
    this.deliveryCharge,this.deliveryDurationExpress,this.deliveryAmt,this.params1);
  // PromocodeComponent(Map<String, String> params){
  //   this.params1= params;
  //   this.minimumOrderAmountNoraml = params["minimumOrderAmountNoraml"]??"" ;
  //   this.deliveryChargeNormal = params["deliveryChargeNormal"]??"";
  //   this.minimumOrderAmountPrime = params["minimumOrderAmountPrime"]??"";
  //   this.deliveryChargePrime = params["deliveryChargePrime"]??"";
  //   this.minimumOrderAmountExpress = params["minimumOrderAmountExpress"]??"";
  //   this.deliveryChargeExpress = params["deliveryChargeExpress"]??"";
  //   this.deliveryType = params["deliveryType"]??"";
  //   this.addressId = params["addressId"]??"";
  //   this.note = params["note"]??"";
  //   this.deliveryCharge = params["deliveryCharge"]??"";
  //   this.deliveryDurationExpress = params["deliveryDurationExpress"]??"";
  //   this.deliveryAmt = params["deliveryAmt"]??"";
  // }
  @override
  PromocodeComponentState createState() => PromocodeComponentState();
}

class PromocodeComponentState extends State<PromocodeComponent>
    with SingleTickerProviderStateMixin, Navigations{
  bool _isLoading = true;
  bool _isWeb = false;
  bool iphonex = false;
  var promocodeData;
  late double maxwid;
  late double wid;
  late MediaQueryData queryData;
  late Future<List<Promocode>> _future = Future.value([]);
  late Future<List<Promocode>> _futureNonavailable =  Future.value([]);
  final TextEditingController promocontroller = new TextEditingController();
  //  String promocontroller = "";
  String? membershipvx=(VxState.store as GroceStore).userData.membership;
  List<CartItem> productBox=[];
  late String promovarprice;
  double deliveryAmt = 0;
  var promoData;
  var promoDataanavilable;

  @override
  void initState() {
    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();

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
      /* Provider.of<MyorderList>(context,listen: false).GetPromoCode().then((_) {
        promocodeData = Provider.of<MyorderList>(context, listen: false);
        setState(() {
          _isLoading = false;
        });
      });*/
      debugPrint("promodata...."+widget.deliveryAmt.toString());
      MyorderList().GetPromoCode().then((value) {
        debugPrint("promodata...."+promoData.toString());
        setState(() {
          _future = Future.value(value);
          _isLoading = false;
        });
      });

      MyorderList().GetNonapplicableCoupon().then((value) {

        debugPrint("promoDataanavilable...."+promoDataanavilable.toString());
        setState(() {
          _futureNonavailable = Future.value(value);
          _isLoading = false;
        });
      });

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        /*   Navigator.of(context).pushReplacementNamed(
            PaymentScreen.routeName,
            arguments: {
              'minimumOrderAmountNoraml': routeArgs['minimumOrderAmountNoraml'],
              'deliveryChargeNormal': routeArgs['deliveryChargeNormal'],
              'minimumOrderAmountPrime': routeArgs['minimumOrderAmountPrime'],
              'deliveryChargePrime': routeArgs['deliveryChargePrime'],
              'minimumOrderAmountExpress': routeArgs['minimumOrderAmountExpress'],
              'deliveryChargeExpress': routeArgs['deliveryChargeExpress'],
              'deliveryType': routeArgs['deliveryType'],
              'addressId': PrefUtils.prefs!.getString("addressId"),
              'note': routeArgs['note'],
              'deliveryCharge': routeArgs['deliveryCharge'],
              'deliveryDurationExpress' : routeArgs['minimumOrderAmountNoraml'],
              'fromScreen':'',
              'responsejson':"",
            });*/

        debugPrint("deliveryyyyy......"+widget.deliveryCharge.toString());
        Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
            qparms: {
              'minimumOrderAmountNoraml': /*['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
              'deliveryChargeNormal':  /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
              'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
              'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
              'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress,
              'deliveryChargeExpress':  /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
              'deliveryType':/* routeArgs['deliveryType']*/widget.deliveryType,
              'addressId': PrefUtils.prefs!.getString("addressId"),
              'note':  /*routeArgs['note']*/widget.note,
              'deliveryCharge': /* routeArgs['deliveryCharge']*/widget.deliveryCharge,
              'deliveryDurationExpress' : /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress,
              'fromScreen':'',
              'responsejson':"",
            });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?ColorCodes.whiteColor:null,
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        body: _isLoading ? _isWeb?Center(
          child: CircularProgressIndicator(),
        ):ItemListShimmer()
            :
        _body(),
      ),
    );
  }
  _body(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
          //   Header(false),

          Container(
            color: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?ColorCodes.whiteColor:null,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Promocode>>(
              future: _future,
              builder: (BuildContext context,AsyncSnapshot<List<Promocode>> snapshot){
                final promoData = snapshot.data;


                return _isWeb?
                SingleChildScrollView(
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                                controller: promocontroller,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                  hintText: S.of(context).enter_couponcode,//"Enter Coupon Code",
                                  hintStyle: TextStyle(color: ColorCodes.greylight, fontWeight: FontWeight.w800, fontSize: 14,),
                                  hoverColor: ColorCodes.greenColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  suffixIcon:  Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap:() {
                                            checkPromo(promocontroller.text,widget.deliveryAmt!);
                                          },
                                          child: Text(
                                            S.of(context).apply,//"Apply",
                                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800, fontSize: 15,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ),
                                onSaved: (value) {
                                  //addFirstnameToSF(value);
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            (promoData !=null)? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: Text(/*"Available Coupons"*/S.of(context).available_coupon, style: TextStyle(color: ColorCodes.blackColor, fontSize: 15,fontWeight: FontWeight.bold),)
                            ):SizedBox.shrink(),
                            (promoData !=null)?SizedBox(height: 10,):SizedBox.shrink(),
                            (promoData !=null)? SizedBox(
                              //  height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: promoData.length,
                                  itemBuilder: (BuildContext context, int index) {


                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(

                                          children: [

                                            DottedBorder(
                                              padding: EdgeInsets.zero,
                                              color: ColorCodes.primaryColor,
                                              //strokeWidth: 1,
                                              // dashPattern: [3.0],
                                              dashPattern: [3, 3],
                                              // color: Colors.grey,
                                              strokeWidth: 2,
                                              child: Container(
                                                height:40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: ColorCodes.varcolor,
                                                  ),
                                                  color: ColorCodes.varcolor,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10.0,right: 5.0),
                                                      child: Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.blackColor),
                                                    ),
                                                    //VerticalDivider(color: ColorCodes.starColor,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 5.0,right: 10.0),
                                                      child: Text(promoData[index].promocode.toString().toUpperCase(), style: TextStyle(color: ColorCodes.blackColor, fontSize: 17,fontWeight: FontWeight.bold),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // SizedBox(width: 120,),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: (){
                                                //checkPromo(promoData[index].promocode);
                                                setState(() {
                                                  checkPromo(promoData[index].promocode.toString(),widget.deliveryAmt!);
                                                });

                                                // dialogforPopup(promoData[index].promocode);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                                child: Text(S.of(context).apply,//"APPLY",
                                                  style: TextStyle(color: ColorCodes.primaryColor, fontSize: 15,fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        (promoData[index].description.toString() != "")?
                                        Text(promoData[index].description.toString(),
                                          style: TextStyle(color: ColorCodes.blackColor, fontSize: 14,fontWeight: FontWeight.bold),):
                                        SizedBox.shrink(),
                                        (promoData[index].description.toString() != "")?SizedBox(height: 10,):
                                        SizedBox.shrink(),
                                        Divider(color: ColorCodes.grey,thickness: 1,),
                                        SizedBox(height: 5,),
                                      ],
                                    );
                                  }),
                            ):SizedBox.shrink(),
                          ],
                        ),
                      ),
                      // if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),

                    ],
                  ),
                )
                    :
                SingleChildScrollView(
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                color: ColorCodes.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                                controller: promocontroller,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                  hintText: S.of(context).enter_couponcode,//"Enter Coupon Code",
                                  hintStyle: TextStyle(color: ColorCodes.greylight, fontWeight: FontWeight.w800, fontSize: 14,),
                                  hoverColor: ColorCodes.greenColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: ColorCodes.whiteColor, width: 0.6),
                                  ),
                                  suffixIcon:  Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap:() {
                                            checkPromo(promocontroller.text,widget.deliveryAmt!);
                                          },
                                          child: Text(
                                            S.of(context).apply,//"Apply",
                                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800, fontSize: 15,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ),
                                onSaved: (value) {
                                  //addFirstnameToSF(value);
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            (promoData !=null)? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: Text(/*"Available Coupons"*/S.of(context).available_coupon, style: TextStyle(color: ColorCodes.blackColor, fontSize: 15,fontWeight: FontWeight.bold),)
                            ):SizedBox.shrink(),
                            (promoData !=null)?SizedBox(height: 10,):SizedBox.shrink(),
                            (promoData !=null)? SizedBox(
                              //  height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: promoData.length,
                                  itemBuilder: (BuildContext context, int index) {


                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(

                                          children: [

                                            DottedBorder(
                                              padding: EdgeInsets.zero,
                                              color: ColorCodes.primaryColor,
                                              //strokeWidth: 1,
                                              // dashPattern: [3.0],
                                              dashPattern: [3, 3],
                                              // color: Colors.grey,
                                              strokeWidth: 2,
                                              child: Container(
                                                height:40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: ColorCodes.varcolor,
                                                  ),
                                                  color: ColorCodes.varcolor,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10.0,right: 5.0),
                                                      child: Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.blackColor),
                                                    ),
                                                    //VerticalDivider(color: ColorCodes.starColor,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 5.0,right: 10.0),
                                                      child: Text(promoData[index].promocode.toString().toUpperCase(), style: TextStyle(color: ColorCodes.blackColor, fontSize: 17,fontWeight: FontWeight.bold),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // SizedBox(width: 120,),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: (){
                                                //checkPromo(promoData[index].promocode);
                                                setState(() {
                                                  checkPromo(promoData[index].promocode.toString(),widget.deliveryAmt!);
                                                });

                                                // dialogforPopup(promoData[index].promocode);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                                child: Text(S.of(context).apply,//"APPLY",
                                                  style: TextStyle(color: ColorCodes.primaryColor, fontSize: 15,fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        (promoData[index].description.toString() != "")?
                                        Text(promoData[index].description.toString(),
                                          style: TextStyle(color: ColorCodes.blackColor, fontSize: 14,fontWeight: FontWeight.bold),):
                                        SizedBox.shrink(),
                                        (promoData[index].description.toString() != "")?SizedBox(height: 10,):
                                        SizedBox.shrink(),
                                        Divider(color: ColorCodes.grey,thickness: 1,),
                                        SizedBox(height: 5,),
                                      ],
                                    );
                                  }),
                            ):SizedBox.shrink(),
                          ],
                        ),
                      ),

                    ],
                  ),
                );

              },
            ),
          ),
          Container(
            color: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?ColorCodes.whiteColor:null,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Promocode>>(
              future: _futureNonavailable,
              builder: (BuildContext context,AsyncSnapshot<List<Promocode>> snapshot){
                final promoData = snapshot.data;
                // if(promoData!.length > 0)
                if (promoData!=null)
                  return _isWeb?
                  SingleChildScrollView(
                    child:
                    Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 60.0,right: 60.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  child: Text(/*"Not Available Coupons"*/S.of(context).not_available_promo, style: TextStyle(color: ColorCodes.blackColor, fontSize: 20,fontWeight: FontWeight.bold),)
                              ),
                              SizedBox(height: 10,),
                              SizedBox(
                                //  height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: promoData.length,
                                    itemBuilder: (BuildContext context, int index) {


                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(

                                            children: [

                                              Container(
                                                height:40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: ColorCodes.starColor,
                                                  ),
                                                  color: ColorCodes.promocolor,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                                      child: Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.greyColor),
                                                    ),
                                                    VerticalDivider(color: ColorCodes.starColor,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                                      child: Text(promoData[index].promocode.toString(), style: TextStyle(color: ColorCodes.greyColor, fontSize: 15,fontWeight: FontWeight.bold),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          (promoData[index].description.toString() != "")?
                                          Text(promoData[index].description.toString(),
                                            style: TextStyle(color: ColorCodes.greyColor, fontSize: 15,fontWeight: FontWeight.bold),):
                                          SizedBox.shrink(),
                                          (promoData[index].description.toString() != "")?SizedBox(height: 10,):
                                          SizedBox.shrink(),
                                          Divider(color: ColorCodes.greyColor,thickness: 1,),
                                          SizedBox(height: 5,),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        if(_isWeb && ResponsiveLayout.isSmallScreen(context)) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                      ],
                    ),
                  ) :
                  SingleChildScrollView(
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  child: Text(/*"Not Available Coupons"*/S.of(context).not_available_promo, style: TextStyle(color: ColorCodes.blackColor, fontSize: 20,fontWeight: FontWeight.bold),)
                              ),
                              SizedBox(height: 10,),
                              SizedBox(
                                //  height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: promoData.length,
                                    itemBuilder: (BuildContext context, int index) {


                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(

                                            children: [

                                              Container(
                                                height:40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: ColorCodes.starColor,
                                                  ),
                                                  color: ColorCodes.promocolor,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                                      child: Image.asset(Images.appLoyalty, width: 24, height: 24, color: ColorCodes.greyColor),
                                                    ),
                                                    VerticalDivider(color: ColorCodes.starColor,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                                      child: Text(promoData[index].promocode.toString(), style: TextStyle(color: ColorCodes.greyColor, fontSize: 15,fontWeight: FontWeight.bold),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          (promoData[index].description.toString() != "")?
                                          Text(promoData[index].description.toString(),
                                            style: TextStyle(color: ColorCodes.greyColor, fontSize: 15,fontWeight: FontWeight.bold),):
                                          SizedBox.shrink(),
                                          (promoData[index].description.toString() != "")?SizedBox(height: 10,):
                                          SizedBox.shrink(),
                                          Divider(color: ColorCodes.greyColor,thickness: 1,),
                                          SizedBox(height: 5,),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                else
                  return SizedBox.shrink();

              },
            ),
          ),
        ],),
    );
  }
  gradientappbarmobile() {

    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation: (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),onPressed: (){
        final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
            qparms: {
              'minimumOrderAmountNoraml': /*['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
              'deliveryChargeNormal':  /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
              'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
              'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
              'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress,
              'deliveryChargeExpress':  /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
              'deliveryType':/* routeArgs['deliveryType']*/widget.deliveryType,
              'addressId': PrefUtils.prefs!.getString("addressId"),
              'note':  /*routeArgs['note']*/widget.note,
              'deliveryCharge': /* routeArgs['deliveryCharge']*/widget.deliveryCharge,
              'deliveryDurationExpress' : /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress,
              'fromScreen':'',
              'responsejson':"",
            });
      }),
      title: Text(S.of(context).apply_coupon,//"Apply Coupons",
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
                ]
            )
        ),
      ),
    );
  }

  dialogforPopup(String promocode, String amount, String responsejson) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(

          onWillPop: () {
            // SystemNavigator.pop();
            return Future.value(false);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.appLoyalty,
              height: 100,
              width: 138,
              color: ColorCodes.discountoff,
            ),
            content: Container(
              height: 180,
              child: Column(
                children: [
                  Text(" \'" + promocode + " \'"+ " "+/*"applied"*/S.of(context).applied,style: TextStyle(color: ColorCodes.blackColor, fontSize: 25,fontWeight: FontWeight.bold), ),
                  SizedBox(height: 5,),
                  Text(IConstants.currencyFormat+" "+ amount,style: TextStyle(color: ColorCodes.blackColor, fontSize: 40,fontWeight: FontWeight.bold), ),
                  SizedBox(height: 5,),
                  Text(/*"savings with this coupon"*/S.of(context).saving_with_this_coupon,style: TextStyle(color: ColorCodes.blackColor, fontSize: 14,fontWeight: FontWeight.bold), ),
                  SizedBox(height: 5,),
                  Text(/*"Keep using "*/S.of(context).keep_using+ promocode +/*"and save \n more with each order"*/S.of(context).save_more_order,style: TextStyle(color: ColorCodes.blackColor,
                      fontSize: 16), ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: (){

                  final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                  Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        'minimumOrderAmountNoraml': /*['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
                        'deliveryChargeNormal':  /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
                        'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
                        'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
                        'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress,
                        'deliveryChargeExpress':  /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
                        'deliveryType':/* routeArgs['deliveryType']*/widget.deliveryType,
                        'addressId': PrefUtils.prefs!.getString("addressId"),
                        'note':  /*routeArgs['note']*/widget.note,
                        'deliveryCharge': /* routeArgs['deliveryCharge']*/widget.deliveryCharge,
                        'deliveryDurationExpress' : /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress,
                        'fromScreen':'promocodeScreen',
                        'responsejson':responsejson.toString(),
                      });
                },
                child: Center(
                  child:  Text(/*"YAY!"*/S.of(context).yay,style: TextStyle(color: ColorCodes.discountoff, fontSize: 20,fontWeight: FontWeight.bold), ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkPromo(String promocode, String deliveryamt) async {

    var item = [];
    bool toppings = false;
    int count = 0;
    for (int i = 0; i < productBox.length; i++) {
      if(productBox[i].toppings_data!.length > 0){
        toppings = true;
        // count = count + 1;
      }
      if (membershipvx == "0") {
        if (double.parse(productBox[i].price.toString()) <= 0 ||
            productBox[i].price.toString() == "" ||
            productBox[i].price ==
                productBox[i].varMrp) {
          promovarprice = productBox[i].varMrp.toString();
        } else {
          promovarprice = productBox[i].price.toString();
        }
      } else {
        if (double.parse(productBox[i].membershipPrice.toString()) <=
            0 ||
            productBox[i].membershipPrice == "" ||
            double.parse(productBox[i].membershipPrice.toString()) ==
                productBox[i].varMrp) {
          promovarprice = productBox[i].varMrp.toString();
        } else {
          promovarprice = productBox[i].membershipPrice.toString();
        }
      }
      var item1 = {};
      if (productBox[i].mode == 1){

      }else {
        item1["\"itemid\""] =
        productBox[i].type == "1" ? "\"" + productBox[i].itemId.toString() +
            "\"" :
        "\"" + productBox[i].varId.toString() + "\"";
        item1["\"menuid\""] = "\"" + productBox[i].itemId.toString() + "\"";
        item1["\"type\""] = "\"" + productBox[i].type.toString() + "\"";
        item1["\"qty\""] = productBox[i].quantity.toString();
        item1["\"price\""] = promovarprice;
        item1["\"toppings\""] = "0";

        item.add(item1);
      }
      List ToppingsData = [];
      if(toppings) {
        ToppingsData.clear();
        //for (int i = 0; i < productBox.length; i++) {
        for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
          var item2 = {};
          debugPrint("price....." + productBox[i].toppings_data![j].price!);
          item2["\"itemid\""] =
          productBox[i].type == "1" ? "\"" + productBox[i].itemId.toString() +
              "\"" :
          "\"" + productBox[i].varId.toString() + "\"";
          item2["\"menuid\""] = "\"" + productBox[i].itemId.toString() + "\"";
          item2["\"type\""] = "\"" + productBox[i].type.toString() + "\"";
          item2["\"qty\""] = productBox[i].quantity.toString();
          item2["\"price\""] = productBox[i].toppings_data![j].price;
          item2["\"toppings\""] = "1";
          debugPrint(
              "item2..." +  item2.toString());
          // ToppingsData.add(item2);
          item.add(item2);
          debugPrint("ToppingsData....."+ToppingsData.toString());
        }
      }
    }


    double cartTotal = 0.0;
    double toppingAmount = 0.0;
    //List toppingAmount = [];
    if(toppings) {
      for (int i = 0; i < productBox.length; i++) {
        for (int j = 0; j < productBox[i].toppings_data!.length; j++) {
          toppingAmount=toppingAmount+double.parse(productBox[i].toppings_data![j].price.toString());

        }
      }
    }

    if ((VxState.store as GroceStore).userData.membership == "1") {
      cartTotal = CartCalculations.totalMember /*- toppingAmount*/;
    } else {
      cartTotal = CartCalculations.total /*- toppingAmount*/;
    }

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    deliveryAmt = Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?double.parse(deliveryamt):double.parse(routeArgs['deliveryAmt']);
    print("promo........");
    try {
      final response = await http.post(Api.checkPromocode, body: {
        "promocode": promocode,
        "items": item.toString(),
        "user": PrefUtils.prefs!.getString('apikey'),
        "total": cartTotal.toString(),
        "delivery":  deliveryAmt.toString(),
        "branch": PrefUtils.prefs!.getString('branch'),
      });
      final responseJson = json.decode(response.body);
      debugPrint("check promo resp...."+responseJson.toString());

      if (responseJson['status'].toString() == "done") {



        debugPrint("deliveryyyyy......"+widget.deliveryCharge.toString());

        Navigation(context, name: Routename.PaymentScreen, navigatore: NavigatoreTyp.Push,
            qparms: {
              'minimumOrderAmountNoraml': /*['minimumOrderAmountNoraml']*/widget.minimumOrderAmountNoraml,
              'deliveryChargeNormal':  /*routeArgs['deliveryChargeNormal']*/widget.deliveryChargeNormal,
              'minimumOrderAmountPrime': /*routeArgs['minimumOrderAmountPrime']*/widget.minimumOrderAmountPrime,
              'deliveryChargePrime': /*routeArgs['deliveryChargePrime']*/widget.deliveryChargePrime,
              'minimumOrderAmountExpress': /*routeArgs['minimumOrderAmountExpress']*/widget.minimumOrderAmountExpress,
              'deliveryChargeExpress':  /*routeArgs['deliveryChargeExpress']*/widget.deliveryChargeExpress,
              'deliveryType':/* routeArgs['deliveryType']*/widget.deliveryType,
              'addressId': PrefUtils.prefs!.getString("addressId"),
              'note':  /*routeArgs['note']*/widget.note,
              'deliveryCharge': /* routeArgs['deliveryCharge']*/widget.deliveryCharge,
              'deliveryDurationExpress' : /*routeArgs['deliveryDurationExpress']*/widget.deliveryDurationExpress,
              'fromScreen':'promocodeScreen',
              'prmocodeType':responseJson['prmocodeType'].toString(),
              'status':responseJson['status'].toString(),
              'msg':responseJson['msg'].toString(),
              'amount': responseJson['amount'].toString(),
              'promocode':promocode.toString(),
              'responsejson':"yes",
            });

      }else{
        Fluttertoast.showToast(
            msg: responseJson['msg'].toString(),
            fontSize: MediaQuery.of(context).textScaleFactor *13,
            backgroundColor: Colors.black87,
            textColor: Colors.white);;

      }
    } catch (error) {
      throw error;
    }

  }


}
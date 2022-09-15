import 'package:flutter/material.dart';
import '../../controller/mutations/cart_mutation.dart';
import '../../controller/mutations/cat_and_product_mutation.dart';
import '../../generated/l10n.dart';
import '../../helper/custome_checker.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../models/newmodle/product_data.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import 'package:velocity_x/velocity_x.dart';

import '../custome_stepper.dart';

class MembershipInfoWidget extends StatelessWidget {
  final ItemData itemdata;
   int? itemindex;
  final int itemindexs;
  int? groupValue;
  final Function() ontap;
  Function(int)? onChangeRadio;
   MembershipInfoWidget({Key? key,required this.itemdata,required String varid, required this.itemindexs, required this.ontap, this.groupValue,this.onChangeRadio}){
     this.itemindex = itemdata.priceVariation!.indexWhere((element) => element.id == varid);
   }

  List<CartItem> productBox = (VxState.store as GroceStore).CartItemList;

  @override
  Widget build(BuildContext context)  {

    String _membershipSavings = "";
    bool _isSingleSKU = itemdata.type == "1" ? true : false;
print("_membershipSavings...." + itemdata.discointDisplay!.toString());
    if(_isSingleSKU ? itemdata.membershipDisplay! : itemdata.priceVariation![itemindexs].membershipDisplay!) {
      _membershipSavings = (double.parse(_isSingleSKU ? itemdata.mrp! : itemdata.priceVariation![itemindexs].mrp!) - double.parse(_isSingleSKU ? itemdata.membershipPrice! : itemdata.priceVariation![itemindexs].membershipPrice!)).toStringAsFixed(IConstants.decimaldigit);
    } else if(_isSingleSKU ? itemdata.discointDisplay! : itemdata.priceVariation![itemindexs].discointDisplay!) {
      _membershipSavings = (double.parse(_isSingleSKU ? itemdata.mrp! : itemdata.priceVariation![itemindexs].mrp!) - double.parse(_isSingleSKU ? itemdata.price! : itemdata.priceVariation![itemindexs].price!)).toStringAsFixed(IConstants.decimaldigit);
    }

    if(Features.iscurrencyformatalign) {
      if(_membershipSavings != "")
        _membershipSavings = '${_membershipSavings} ' + IConstants.currencyFormat;
    } else {
      if(_membershipSavings != "")
        _membershipSavings =  IConstants.currencyFormat + '${_membershipSavings} ';
    }

      return (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) ? Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?10:0),
          child: _isSingleSKU ? VxBuilder(
              mutations: {ProductMutation},
              builder: (context, box, _) {
                return Check().checkmembership() ? _membershipSavings != "" ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                      MediaQuery.of(context).size.width / 4.5 : (MediaQuery.of(context).size.width / 3) + 20 ,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                        ),
                        color: ColorCodes.varcolor,
                      ),

                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 5),
                          Image.asset(
                            Images.bottomnavMembershipImg,
                            color: ColorCodes.primaryColor,
                            width: 15,
                            height: 11,),
                          SizedBox(width: 3),
                          Text( S.of(context).savings/*"Savings "*/,style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(top:10.0,bottom: 8),
                            child: Text(
                                _membershipSavings,
                                style: TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                          ),

                          SizedBox(width: 2),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: (Features.isSubscription) ? 45 : 55,
                      width: (MediaQuery.of(context).size.width / 3) + 5,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5.0),
                          child: _isSingleSKU ? CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", )
                              :
                          Features.btobModule ? CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,groupvalue: groupValue,onChange: (int value,int count){
                            groupValue = value;

                          })
                              :
                          CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,)                  ),
                    ),
                  ],
                ):SizedBox.shrink()
                    :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        if(Features.isMembership  && double.parse(itemdata.membershipPrice.toString()) > 0)
                          Row(
                            children: [
                              !Check().checkmembership()
                                  ? itemdata.membershipDisplay!
                                  ? GestureDetector(
                                onTap: () {
                                  ontap();

                                },
                                child: Container(
                                  height: 30,
                                  width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                  MediaQuery.of(context).size.width / 4.5 :(MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3) + 10 ,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: ColorCodes.primaryColor,
                                        width: 15,
                                        height: 11,),
                                      SizedBox(width: 5),
                                      Text(
                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                          S.of(context).price + " ",
                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0,bottom: 8),
                                        child: Text(
                                            Features.iscurrencyformatalign ?
                                            itemdata.membershipPrice
                                                .toString() + IConstants.currencyFormat :
                                            IConstants.currencyFormat +
                                                itemdata
                                                    .membershipPrice.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                ),
                              )
                                  : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          ),
                        !Check().checkmembership()
                            ? itemdata.membershipDisplay!
                            ? SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                    Spacer(),
                    _isSingleSKU ?
                    Container(
                      height:(Features.isSubscription)?45:55,
                      width:  (MediaQuery.of(context).size.width/3)+5,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5,right:5.0),
                        child: CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", ),
                      ),
                    )
                        :Container(
                      height:(Features.isSubscription)?45:55,
                      width:  (MediaQuery.of(context).size.width/3)+5,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5,right:5.0),
                        child: CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs),
                      ),
                    ),
                  ],
                );
              })
              :
          VxBuilder(
            mutations: {ProductMutation},
            builder: (context, box, _) {
              return Check().checkmembership() ? _membershipSavings != "" ?
              Container(
                height: 35,
                width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context) ?
                MediaQuery.of(context).size.width / 4.5 : (MediaQuery.of(context).size.width / 3) + 30 ,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                  ),
                  color: ColorCodes.varcolor,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 5),
                    Image.asset(
                      Images.bottomnavMembershipImg,
                      color: ColorCodes.primaryColor,
                      width: 15,
                      height: 11,),
                    SizedBox(width: 3),
                    Text( /*"Savings "*/S.of(context).savings,style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,bottom: 8),
                      child: Text(
                          _membershipSavings,
                          style: TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 2),
                  ],
                ),
              ):SizedBox.shrink()
                  :
              VxBuilder(
                  mutations: {SetCartItem,ProductMutation},
                  builder: (context, box, index)  {
                    return Column(
                      children: [
                        if(Features.isMembership)
                          Row(
                            children: [
                              !Check().checkmembership()
                                  ? itemdata.priceVariation![itemindexs].membershipDisplay!
                                  ? GestureDetector(
                                onTap: () {
                                  ontap();

                                },
                                child: Container(
                                  height: 30,
                                  width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                  MediaQuery.of(context).size.width / 4.5 :(MediaQuery.of(context).size.width / 3) + 15 ,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: ColorCodes.primaryColor,
                                        width: 15,
                                        height: 12,),
                                      SizedBox(width: 5),
                                      Text(
                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                          S.of(context).price + " ",
                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 14 : 16,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                                        child: Text(
                                            Features.iscurrencyformatalign ?
                                            itemdata.priceVariation![itemindexs].membershipPrice
                                                .toString() + IConstants.currencyFormat :
                                            IConstants.currencyFormat +
                                                itemdata.priceVariation![itemindexs]
                                                    .membershipPrice.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                ),
                              )
                                  : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          ),
                        !Check().checkmembership()
                            ? itemdata.priceVariation![itemindexs].membershipDisplay!
                            ? SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        ),
                      ],
                    );
                  }
              );
            },)
      ) :
      Padding(
          padding: EdgeInsets.symmetric(horizontal: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?30:0),
          child: _isSingleSKU ? VxBuilder(
              mutations: {ProductMutation},
              builder: (context, box, _) {
                return Check().checkmembership() ? _membershipSavings != "" ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                      MediaQuery.of(context).size.width / 4.5 : (MediaQuery.of(context).size.width / 3) + 20 ,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                        ),
                        color: ColorCodes.varcolor,
                      ),

                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 5),
                          Image.asset(
                            Images.bottomnavMembershipImg,
                            color: ColorCodes.primaryColor,
                            width: 15,
                            height: 11,),
                          SizedBox(width: 3),
                          Text( /*"Savings "*/S.of(context).savings,style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(top:10.0,bottom: 8),
                            child: Text(
                                _membershipSavings,
                                style: TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                          ),

                          SizedBox(width: 2),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: (Features.isSubscription) ? 45 : 55,
                      width: (MediaQuery.of(context).size.width / 3) + 5,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5.0),
                          child: _isSingleSKU ? CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", )
                              :
                          Features.btobModule ? CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,groupvalue: groupValue,onChange: (int value,int count){
                            groupValue = value;

                          })
                              :
                          CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,)                  ),
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        if(Features.isMembership  && double.parse(itemdata.membershipPrice.toString()) > 0)
                          Row(
                            children: [
                              !Check().checkmembership()
                                  ? itemdata.membershipDisplay!
                                  ? GestureDetector(
                                onTap: () {
                                  ontap();

                                },
                                child: Container(
                                  height: 30,
                                  width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                  MediaQuery.of(context).size.width /  4 :(MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3) + 10 ,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: ColorCodes.primaryColor,
                                        width: 15,
                                        height: 11,),
                                      SizedBox(width: 5),
                                      Text(
                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                          S.of(context).price + " ",
                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0,bottom: 8),
                                        child: Text(
                                            Features.iscurrencyformatalign ?
                                            itemdata.membershipPrice
                                                .toString() + IConstants.currencyFormat :
                                            IConstants.currencyFormat +
                                                itemdata
                                                    .membershipPrice.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                ),
                              )
                                  : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          ),
                        !Check().checkmembership()
                            ? itemdata.membershipDisplay!
                            ? SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                    Spacer(),
                    _isSingleSKU ?
                    Container(
                      height:(Features.isSubscription)?45:55,
                      width:  (MediaQuery.of(context).size.width/3)+5,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5,right:5.0),
                        child: CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", ),
                      ),
                    )
                        :Container(
                      height:(Features.isSubscription)?45:55,
                      width:  (MediaQuery.of(context).size.width/3)+5,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5,right:5.0),
                        child: CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs),
                      ),
                    ),
                  ],
                )
                    :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        if(Features.isMembership  && double.parse(itemdata.membershipPrice.toString()) > 0)
                          Row(
                            children: [
                              !Check().checkmembership()
                                  ? itemdata.membershipDisplay!
                                  ? GestureDetector(
                                onTap: () {
                                  ontap();

                                },
                                child: Container(
                                  height: 30,
                                  width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                  MediaQuery.of(context).size.width /  4 :(MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3) + 10 ,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                    ),
                                    color: ColorCodes.varcolor,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      Image.asset(
                                        Images.bottomnavMembershipImg,
                                        color: ColorCodes.primaryColor,
                                        width: 15,
                                        height: 11,),
                                      SizedBox(width: 5),
                                      Text(
                                        // S .of(context).membership_price+ " " +//"Membership Price "
                                          S.of(context).price + " ",
                                          style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0,bottom: 8),
                                        child: Text(
                                            Features.iscurrencyformatalign ?
                                            itemdata.membershipPrice
                                                .toString() + IConstants.currencyFormat :
                                            IConstants.currencyFormat +
                                                itemdata
                                                    .membershipPrice.toString(),
                                            style: TextStyle(
                                                fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                ),
                              )
                                  : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          ),
                        !Check().checkmembership()
                            ? itemdata.membershipDisplay!
                            ? SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        )
                            : SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                    Spacer(),
                    _isSingleSKU ?
                    Container(
                      height:(Features.isSubscription)?45:55,
                      width:  (MediaQuery.of(context).size.width/3)+5,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5,right:5.0),
                        child: CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", ),
                      ),
                    )
                        :Container(
                      height:(Features.isSubscription)?45:55,
                      width:  (MediaQuery.of(context).size.width/3)+5,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5,right:5.0),
                        child: CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs),
                      ),
                    ),
                  ],
                );
              })
              :
          VxBuilder(
            mutations: {ProductMutation},
            builder: (context, box, _) {
              return Check().checkmembership() ? _membershipSavings != "" ?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context) ?
                    MediaQuery.of(context).size.width / 4.5 : (MediaQuery.of(context).size.width / 3) + 30 ,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                      ),
                      color: ColorCodes.varcolor,
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 5),
                        Image.asset(
                          Images.bottomnavMembershipImg,
                          color: ColorCodes.primaryColor,
                          width: 15,
                          height: 11,),
                        SizedBox(width: 3),
                        Text( /*"Savings "*/S.of(context).savings,style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0,bottom: 8),
                          child: Text(
                              _membershipSavings,
                              style: TextStyle( fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 2),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    height:(Features.isSubscription) ? 45 : 55,
                    width: (MediaQuery.of(context).size.width / 3) + 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left:5,right:5.0),
                      child: _isSingleSKU ? CustomeStepper(
                        itemdata: itemdata, from: "item_screen", height: (Features.isSubscription) ? 90 : 60, addon: (itemdata.addon!.length > 0) ? itemdata.addon![0] : null, index: itemindexs, issubscription: "Add",)
                          : Features.btobModule ? CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,groupvalue: groupValue,onChange: (int value,int count){
                        groupValue = value;
                      })
                          :
                      CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,),
                    ),
                  ),
                ],
              ): VxBuilder(
                  mutations: {SetCartItem,ProductMutation},
                  builder: (context, box, index)  {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            if(Features.isMembership)
                              Row(
                                children: [
                                  !Check().checkmembership()
                                      ? itemdata.priceVariation![itemindexs].membershipDisplay!
                                      ? GestureDetector(
                                    onTap: () {
                                      ontap();

                                    },
                                    child: Container(
                                      height: 30,
                                      width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                      MediaQuery.of(context).size.width / 4.5 :(MediaQuery.of(context).size.width / 3) + 15 ,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                        ),
                                        color: ColorCodes.varcolor,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(width: 5),
                                          Image.asset(
                                            Images.bottomnavMembershipImg,
                                            color: ColorCodes.primaryColor,
                                            width: 15,
                                            height: 12,),
                                          SizedBox(width: 5),
                                          Text(
                                            // S .of(context).membership_price+ " " +//"Membership Price "
                                              S.of(context).price + " ",
                                              style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 14 : 16,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                                            child: Text(
                                                Features.iscurrencyformatalign ?
                                                itemdata.priceVariation![itemindexs].membershipPrice
                                                    .toString() + IConstants.currencyFormat :
                                                IConstants.currencyFormat +
                                                    itemdata.priceVariation![itemindexs]
                                                        .membershipPrice.toString(),
                                                style: TextStyle(
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                      : SizedBox.shrink()
                                      : SizedBox.shrink(),
                                ],
                              ),
                            !Check().checkmembership()
                                ? itemdata.priceVariation![itemindexs].membershipDisplay!
                                ? SizedBox(
                              height: 1,
                            )
                                : SizedBox(
                              height: 1,
                            )
                                : SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height:(Features.isSubscription)?45:45,
                          width:  (MediaQuery.of(context).size.width/3)+5,
                          child: Padding(
                              padding: const EdgeInsets.only(left:5,right:5.0),
                              child: _isSingleSKU ? CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", )
                                  :
                              Features.btobModule ? CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,groupvalue: groupValue,onChange: (int value,int count){groupValue = value;})
                                  :
                              CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,)                      ),
                        ),
                      ],
                    );
                  }
              )
                  :
              VxBuilder(
                  mutations: {SetCartItem,ProductMutation},
                  builder: (context, box, index)  {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            if(Features.isMembership)
                              Row(
                                children: [
                                  !Check().checkmembership()
                                      ? itemdata.priceVariation![itemindexs].membershipDisplay!
                                      ? GestureDetector(
                                    onTap: () {
                                      ontap();

                                    },
                                    child: Container(
                                      height: 30,
                                      width: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
                                      MediaQuery.of(context).size.width / 4.5 :(MediaQuery.of(context).size.width / 3) + 15 ,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(width: 3.0, color: ColorCodes.darkgreen),
                                        ),
                                        color: ColorCodes.varcolor,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(width: 5),
                                          Image.asset(
                                            Images.bottomnavMembershipImg,
                                            color: ColorCodes.primaryColor,
                                            width: 15,
                                            height: 12,),
                                          SizedBox(width: 5),
                                          Text(
                                            // S .of(context).membership_price+ " " +//"Membership Price "
                                              S.of(context).price + " ",
                                              style: TextStyle(fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 14 : 16,color: ColorCodes.darkgreen,fontWeight: FontWeight.bold)),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                                            child: Text(
                                                Features.iscurrencyformatalign ?
                                                itemdata.priceVariation![itemindexs].membershipPrice
                                                    .toString() + IConstants.currencyFormat :
                                                IConstants.currencyFormat +
                                                    itemdata.priceVariation![itemindexs]
                                                        .membershipPrice.toString(),
                                                style: TextStyle(
                                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 13 : 14,color: ColorCodes.greenColor,fontWeight: FontWeight.bold)),
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                      : SizedBox.shrink()
                                      : SizedBox.shrink(),
                                ],
                              ),
                            !Check().checkmembership()
                                ? itemdata.priceVariation![itemindexs].membershipDisplay!
                                ? SizedBox(
                              height: 1,
                            )
                                : SizedBox(
                              height: 1,
                            )
                                : SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height:(Features.isSubscription)?45:45,
                          width:  (MediaQuery.of(context).size.width/3)+5,
                          child: Padding(
                              padding: const EdgeInsets.only(left:5,right:5.0),
                              child: _isSingleSKU ? CustomeStepper(itemdata:itemdata,from:"item_screen",height: (Features.isSubscription)?90:60,addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,issubscription: "Add", )
                                  :
                              Features.btobModule ? CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,groupvalue: groupValue,onChange: (int value,int count){groupValue = value;})
                                  :
                              CustomeStepper(priceVariation:itemdata.priceVariation![itemindexs],itemdata: itemdata,from:"item_screen",height: (Features.isSubscription)?90:40,issubscription: "Add",addon:(itemdata.addon!.length > 0)?itemdata.addon![0]:null, index: itemindexs,)                      ),
                        ),
                      ],
                    );
                  }
              );
            },)
      );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/newmodle/search_data.dart';
import '../../../constants/features.dart';
import '../../../generated/l10n.dart';
import '../../../models/newmodle/product_data.dart';
import '../../../utils/ResponsiveLayout.dart';
import '../../../utils/prefUtils.dart';
import '../../../widgets/custome_stepper.dart';
import '../../assets/ColorCodes.dart';
import '../../constants/IConstants.dart';
import '../../rought_genrator.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemVariation extends StatelessWidget with Navigations{
  Function? onselect;
  bool? ismember;
  int selectedindex;
  StoreSearchData? searchdata;
  String? page;
  String? fromscreen;
  ItemVariation({this.itemdata,this.searchdata,this.onselect,this.selectedindex = 0,this.ismember,this.page,this.fromscreen});
  ItemData? itemdata;
  bool checkskip = false;

  Widget handler(int i) {
    if ((fromscreen == "search_item_multivendor" && Features.ismultivendor)?searchdata!.priceVariation![i].stock! >= 0:itemdata!.priceVariation![i].stock! >= 0) {
      return (selectedindex == i) ?
      Icon(
          Icons.radio_button_checked_outlined,
          color: ColorCodes.greenColor)
          :
      Icon(
          Icons.radio_button_off_outlined,
          color: ColorCodes.greenColor);

    } else {
      return (selectedindex == i) ?
      Icon(
          Icons.radio_button_checked_outlined,
          color: ColorCodes.grey)
          :
      Icon(
          Icons.radio_button_off_outlined,
          color: ColorCodes.greenColor);
    }
  }
  Widget build(BuildContext context) {
    checkskip = !PrefUtils.prefs!.containsKey('apikey');

    return Wrap(
      children: [
        StatefulBuilder(builder: (context, setState) {
          return Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child:
                  Column(
                    children: [
                    SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text( S.of(context).available_quantity,
                            style: TextStyle(
                              color: ColorCodes.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (page == "SingleProduct") ? SizedBox.shrink() :
                      Flexible(
                        child: Text( (fromscreen == "search_item_multivendor" && Features.ismultivendor)?searchdata!.itemName!:itemdata!.itemName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: ColorCodes.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox(
                        height: 5,
                      ):SizedBox(
                        height: 25,
                      ),
                      (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( S .of(context).please_select_any_option,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: ColorCodes.grey ,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ): Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( S .of(context).choose_variant,
                              style: TextStyle(
                                color: ColorCodes.blackColor ,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child:
                    SingleChildScrollView(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: (fromscreen == "search_item_multivendor" && Features.ismultivendor) ? searchdata!.priceVariation!.length : itemdata!.priceVariation!.length,
                          itemBuilder: (_, i) {
                            String _price = "";
                            String _mrp = "";
                            bool _searchMulti = (fromscreen == "search_item_multivendor" && Features.ismultivendor);

                            if(ismember!) { //Membered user
                              if(_searchMulti ? searchdata!.priceVariation![i].membershipDisplay! : itemdata!.priceVariation![i].membershipDisplay!){ //Eligible to display membership price
                                _price = _searchMulti ? searchdata!.priceVariation![i].membershipPrice!.toString() : itemdata!.priceVariation![i].membershipPrice!.toString();
                                _mrp = _searchMulti ? searchdata!.priceVariation![i].mrp! : itemdata!.priceVariation![i].mrp!;
                              } else if(_searchMulti ? searchdata!.priceVariation![i].discointDisplay! : itemdata!.priceVariation![i].discointDisplay!){ //Eligible to display discounted price
                                _price = _searchMulti ? searchdata!.priceVariation![i].price! : itemdata!.priceVariation![i].price!;
                                _mrp = _searchMulti ? searchdata!.priceVariation![i].mrp! : itemdata!.priceVariation![i].mrp!;
                              } else { //Otherwise display mrp
                                _price = _searchMulti ? searchdata!.priceVariation![i].mrp! : itemdata!.priceVariation![i].mrp!;
                              }
                            } else { //Non membered user
                              if(_searchMulti ? searchdata!.priceVariation![i].discointDisplay! : itemdata!.priceVariation![i].discointDisplay!){ //Eligible to display discounted price
                                _price = _searchMulti ? searchdata!.priceVariation![i].price! : itemdata!.priceVariation![i].price!;
                                _mrp = _searchMulti ? searchdata!.priceVariation![i].mrp! : itemdata!.priceVariation![i].mrp!;
                              } else { //Otherwise display mrp
                                _price = _searchMulti ? searchdata!.priceVariation![i].mrp! : itemdata!.priceVariation![i].mrp!;
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

                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: (){
                                setState((){
                                  selectedindex = i;
                                });
                                onselect!(i);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    handler(i),
                                    SizedBox(width: 10,),
                                    VariationListItem(variationName: (fromscreen == "search_item_multivendor" && Features.ismultivendor) ? searchdata!.priceVariation![i].variationName! : itemdata!.priceVariation![i].variationName!,
                                      mrp: _mrp,
                                      discount: _price,
                                      unit: (fromscreen == "search_item_multivendor" && Features.ismultivendor)?searchdata!.priceVariation![i].unit!:itemdata!.priceVariation![i].unit!, color:selectedindex==i? ColorCodes.mediumBlueColor: ColorCodes.blackColor,),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                      SizedBox(
                        height: 20,
                      ),
                      if(page!="SingleProduct")
                        (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (Features.isSubscription)?
                            Container(
                                height:70,
                                width: 150,
                                child:
                                (fromscreen == "search_item_multivendor" && Features.ismultivendor)?
                                CustomeStepper(priceVariationSearch:searchdata!.priceVariation![selectedindex],searchstoredata: searchdata,height:(Features.isSubscription)?90:60,issubscription: "Subscribe",index: selectedindex,) :
                                CustomeStepper(priceVariation:itemdata!.priceVariation![selectedindex],itemdata: itemdata,height:(Features.isSubscription)?90:60,issubscription: "Subscribe",index: selectedindex,)):
                            SizedBox(width: 150,),
                            Spacer(),
                            Container(
                                height:60,
                                width: 150,
                                child:
                                (fromscreen == "search_item_multivendor" && Features.ismultivendor)?
                                CustomeStepper(priceVariationSearch:searchdata!.priceVariation![selectedindex],searchstoredata: searchdata,height:(Features.isSubscription)?90:60,issubscription: "Add",index: selectedindex,) :
                                CustomeStepper(priceVariation:itemdata!.priceVariation![selectedindex],itemdata: itemdata,height:(Features.isSubscription)?90:60,issubscription: "Add",index: selectedindex,)),
                            SizedBox(width: 10,),
                          ],
                        )
                            :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            if(Features.isSubscription)

                              Container(
                                  height:70,
                                  width: 150,
                                  child:
                                  (fromscreen == "search_item_multivendor" && Features.ismultivendor)?
                                  CustomeStepper(priceVariationSearch:searchdata!.priceVariation![selectedindex],searchstoredata: searchdata,height:(Features.isSubscription)?90:60,issubscription: "Subscribe",index: selectedindex, from: "search_screen",) :
                                  CustomeStepper(priceVariation:itemdata!.priceVariation![selectedindex],itemdata: itemdata,height:(Features.isSubscription)?90:60,issubscription: "Subscribe",index: selectedindex,)),
                            Container(
                                height:60,
                                width: 150,
                                child:
                                (fromscreen == "search_item_multivendor" && Features.ismultivendor)?
                                CustomeStepper(priceVariationSearch:searchdata!.priceVariation![selectedindex],searchstoredata: searchdata,height:(Features.isSubscription)?90:60,issubscription: "Add",index: selectedindex,from: "search_screen",) :
                                CustomeStepper(priceVariation:itemdata!.priceVariation![selectedindex],itemdata: itemdata,height:(Features.isSubscription)?90:60,issubscription: "Add",index: selectedindex,)),
                          ],
                        )

                    ],
                  ),
              ),
          );

        }),
      ],
    );
  }
}

class VariationListItem extends StatelessWidget {
  String variationName = "";
  String unit;
  Color? color;
  String discount;
  String mrp;

  VariationListItem({Key? key,required this.variationName,required this.mrp, required this.discount,this.unit = "unit",this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: variationName + " " + unit + "  ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: ColorCodes.greenColor,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: discount,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: ColorCodes.blackColor,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                    text: mrp,
                    style: TextStyle(color: ColorCodes.blackColor,
                      decoration: TextDecoration.lineThrough,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
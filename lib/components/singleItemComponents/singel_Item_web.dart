import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/footer.dart';
import '../../widgets/productWidget/item_variation.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/api.dart';
import '../../generated/l10n.dart';
import '../../rought_genrator.dart';
import '../../widgets/simmers/singel_item_of_list_shimmer.dart';
import '../../widgets/header.dart';
import '../../components/ItemList/item_component.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import '../../widgets/productWidget/item_detais_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../repository/productandCategory/category_or_product.dart';
import '../../models/newmodle/product_data.dart';
import '../../widgets/productWidget/product_info_widget.dart';
import '../../widgets/productWidget/product_sliding_image_widget.dart';
import 'package:http/http.dart' as http;

class SingleItemWebComponent extends StatefulWidget {
  final Future<ItemModle>? similarProduct;
  final ItemData product;
  final String variationId;

  const SingleItemWebComponent({Key? key, this.similarProduct, required this.product,required this.variationId}) : super(key: key);

  @override
  _SingleItemWebComponentState createState() => _SingleItemWebComponentState();
}

class _SingleItemWebComponentState extends State<SingleItemWebComponent> with Navigations{
  int itemindex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _checkmembership = false;
  String page ="SingleProduct";
  String comment = S .current.good;
  double ratings = 3.0;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  final TextEditingController commentController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wid= queryData.size.width;
    maxwid=wid*0.90;
    if ((VxState.store as GroceStore).userData.membership=="1") {
      setState(() {
        _checkmembership = true;
      });
    } else {
      setState(() {
        _checkmembership = false;
      });
      for (int i = 0; i < (VxState.store as GroceStore).CartItemList.length; i++) {
        if ((VxState.store as GroceStore).CartItemList[i].mode == "1") {
          setState(() {
            _checkmembership = true;
          });
        }
      }
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorCodes.whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Header(false),
            SizedBox(
              height: 20.0,
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    constraints: (Vx.isWeb &&
                        !ResponsiveLayout.isSmallScreen(context))
                        ? BoxConstraints(maxWidth: maxwid)
                        : null,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: SlidingImage(productdata: widget.product,varid:widget.variationId,itemindexs:itemindex,ontap: (){},)),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ProductInfoWidget(itemdata: widget.product,varid:widget.variationId ,variationId:widget.variationId,itemindexs:itemindex,ontap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(builder: (context, setState) {
                                            return  Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(3.0)),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 2.9,
                                                padding: EdgeInsets.fromLTRB(30, 20, 20, 20),
                                                child:  ItemVariation(itemdata: widget.product,ismember: _checkmembership,selectedindex: itemindex,onselect: (i){
                                                  setState(() {
                                                    itemindex = i;
                                                  });
                                                },)
                                              ),
                                            );
                                          });
                                        }).then((_) => setState(() { }));
                                  },),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if(Features.isRateOrderProduct)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 15.0, bottom: 10.0, ),
                            color: ColorCodes.whiteColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10.0,right:10,bottom: 5),
                                      child: Text(
                                        S.of(context).rating_review,//"Ratings & Reviews",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    (widget.product.ratingCount != 0)?
                                    GestureDetector(
                                      onTap: (){
                                        Navigation(context, name: Routename.RateReviewScreen, navigatore: NavigatoreTyp.Push,
                                            parms: {"varid":widget.variationId});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color:  ColorCodes.primaryColor,
                                            ),
                                          )
                                        ),
                                        child: Text(
                                          S.of(context).see_all,//"Ratings & Reviews",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorCodes.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                        :SizedBox.shrink(),
                                  ],
                                ),
                                Container(
                                  padding:  EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10.0,right:0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.product.rating!.toStringAsFixed(2), style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: ColorCodes.greenColor),
                                          ),
                                          SizedBox(width: 5,),
                                          Image.asset(
                                            Images.starImg,
                                            width: 9,
                                            height: 9,
                                            color: ColorCodes.greenColor,
                                            fit: BoxFit.fill,
                                          ),
                                          Spacer(),
                                          if(Features.isRateOrderProduct)
                                            GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: (){

                                                showpopforRateorder();
                                              },
                                              child: Container(
                                                margin:  EdgeInsets.only(right: (Vx.isWeb)?0:10,),
                                                height: 30,
                                                decoration: new BoxDecoration(
                                                  color: ColorCodes.whiteColor,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right:0,left: 10,),
                                                  child: Center(
                                                    child: Text(
                                                      S.of(context).rate_product,//"Rate Product",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(widget.product.ratingCount.toString() + S.of(context).ratings + widget.product.ratingCount.toString() + S.of(context).review)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ItemDetailsWidget(itmdata: widget.product,ontap: (){},),

                        if(widget.similarProduct!=null)
                        FutureBuilder<ItemModle>(
                          future: widget.similarProduct, // async work
                          builder: (BuildContext context, AsyncSnapshot<ItemModle> snapshot) {
                            switch (snapshot.connectionState) {

                              case ConnectionState.waiting:
                                return  SingelItemOfList();
                            // TODO: Handle this case.

                              default:
                              // TODO: Handle this case.
                                if (snapshot.hasError)
                                  return SizedBox.shrink();
                                else
                                  return  snapshot.data!.data!.length > 0?Container(
                                    width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(top: 15.0, bottom: 10.0,),
                                    color: ColorCodes.whiteColor,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:  EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10.0,right:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10),
                                          child: Text(
                                            snapshot.data!.label!,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?ColorCodes.blackColor:Theme
                                                    .of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                            height: ResponsiveLayout.isSmallScreen(context) ?
                                            (Features.isSubscription)?410:310 :
                                            ResponsiveLayout.isMediumScreen(context) ?
                                            (Features.isSubscription)?380:350 : Features.btobModule?420:(Features.isSubscription) ? 280 : 270,
                                            child: new ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data!.data!.length,
                                              itemBuilder: (_, i) => Column(
                                                children: [
                                                  Itemsv2(
                                                    "Forget",
                                                    snapshot.data!.data![i],
                                                    (VxState.store as GroceStore).userData,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ):SizedBox.shrink();
                            }
                          },
                        ),


                      ],
                    ),
                  ),
                  if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  _dialogforProcessing(){
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }
  Future<void> RateProduct(var rating) async {
    try {
      final response = await http.post(Api.addRatingsProduct, body: {
        "user": PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("ftokenid")!,

        "itemId":widget.product.id.toString(),
        "star": rating.toString(),
        "comment": commentController.text.toString(),
        "branch": PrefUtils.prefs!.getString('branch').toString(),
        "ref": IConstants.refIdForMultiVendor.toString(),
      });
      final responseJson = json.decode(response.body);

      Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: S.of(context).review_added, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }

  showpopforRateorder() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).rate_our_product,//"Rate our Product",
                          style: TextStyle(fontSize: 14.0,color: ColorCodes.blackColor, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:120.0),
                          child: Divider(color: ColorCodes.darkgreen,thickness: 2,),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),

                        Text(
                          comment,
                          style: TextStyle(fontSize: 20.0,color: ColorCodes.greyColor),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        RatingBar.builder(

                          initialRating: ratings,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rate,
                            color: ColorCodes.primaryColor,
                          ),

                          onRatingUpdate: (rating) {
                            ratings = rating;
                            if(ratings == 5){
                              setState(() {
                                comment = S .of(context).excellent;//"Excellent";
                              });

                            }
                            else if(ratings == 4){
                              setState(() {
                                comment = S .of(context).good;//"Good";
                              });

                            }
                            else if(ratings == 3){
                              setState(() {
                                comment = S .of(context).average;//"Average";
                              });

                            }
                            else if(ratings == 2){
                              setState(() {
                                comment = S .of(context).bad;//"Bad";
                              });
                            }
                            else if(ratings == 1){
                              setState(() {
                                comment = S .of(context).verybad;//"Very Bad";
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          textAlign: TextAlign.left,
                          controller: commentController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: S.of(context).comment,
                            hoverColor: ColorCodes.primaryColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                              BorderSide(color: Colors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                              BorderSide(color: ColorCodes.primaryColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                              BorderSide(color: ColorCodes.primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                              BorderSide(color: ColorCodes.primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if(commentController.text == ""){
                                Fluttertoast.showToast(msg: S.of(context).enter_comment, fontSize: MediaQuery.of(context).textScaleFactor *13,);
                              }else{
                                _dialogforProcessing();
                                RateProduct(ratings);
                              }
                            },
                            child: Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width/1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: ColorCodes.greenColor,
                                border: Border.all(
                                    color: ColorCodes.greenColor),
                              ),
                              child: Center(
                                  child: Text(
                                    S .of(context).rate_order.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: ColorCodes
                                          .whiteColor,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          });
        });
  }
}

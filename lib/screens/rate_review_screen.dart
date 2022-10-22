
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../controller/mutations/cat_and_product_mutation.dart';
import '../generated/l10n.dart';
import '../helper/custome_checker.dart';
import '../models/VxModels/VxStore.dart';
import '../repository/productandCategory/category_or_product.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/eception_widget/product_not_found.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/singel_item_screen_shimmer.dart';

class RateReviewScreen extends StatefulWidget{
  String _varid;
  RateReviewScreen(this._varid);
  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> with Navigations{
  bool _isLoading = true;
  var items = [
    'Most Useful',
    'Most Helpful',
    'Most Recent',
    'Positive First',
    'Negative First'
  ];
  String dropdownvalue =  'Most Useful';
  String? _value;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ProductController().getprodut(widget._varid.toString(),"").whenComplete(() {
        setState(() {
          _isLoading= false;
        });

      });
    });

    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    queryData = MediaQuery.of(context);
    wid= queryData!.size.width;
    maxwid=wid!*0.90;

    return WillPopScope(
     onWillPop: () {
       Navigator.of(context).pop();
       return Future.value(false);
     },
     child: Scaffold(
       appBar: ResponsiveLayout.isSmallScreen(context)
           ? gradientappbarmobile()
           : null,
       backgroundColor: ColorCodes.whiteColor,
       body:  SingleChildScrollView(
         child: Column(
           children: <Widget>[
             if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
               Header(false),
             _isLoading? SingelItemScreenShimmer():  _body(),
           ],
         ),
       ),
     ),
   );
  }

  _body(){
    return Column(
      children: [
        Container(
          constraints: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,
          child: VxBuilder(builder: (context, store,state){
              return  Container(
                width:MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 15.0, bottom: 10.0 ),
                color:ColorCodes.whiteColor,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   /* Row(
                      children: [
                        Container(
                            color: Colors.white,
                            height: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? MediaQuery.of(context).size.height/5:100,
                            width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? MediaQuery.of(context).size.width/5:100,
                            margin:EdgeInsets.symmetric(
                                horizontal: 5.0,vertical: 10),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      5.0)),
                              child:
                              CachedNetworkImage(
                                  imageUrl:store.singelproduct!.itemFeaturedImage,
                                  placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                  errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                  fit: BoxFit.fill),
                              *//*],
                                                      )*//*
                            )),
                          SizedBox(width: 10,),
                          Column(mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 45,
                                width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))? MediaQuery.of(context).size.width/2.5:MediaQuery.of(context).size.width/1.5,
                                child: Text(
                                  store.singelproduct!.itemName.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColorCodes.black,
                                    fontWeight: FontWeight.bold
                                     ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              store.singelproduct!.type=="1"?
                              RichText(
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: Features.iscurrencyformatalign?
                                        '${Check().checkmembership()?store.singelproduct!.membershipPrice:store.singelproduct!.price} ' + IConstants.currencyFormat:
                                        IConstants.currencyFormat + '${Check().checkmembership()?store.singelproduct!.membershipPrice:store.singelproduct!.price} ',
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,)),
                                    new TextSpan(
                                        text: store.singelproduct!.price!=store.singelproduct!.mrp?
                                        Features.iscurrencyformatalign?
                                        '${store.singelproduct!.mrp} ' + IConstants.currencyFormat:
                                        IConstants.currencyFormat + '${store.singelproduct!.mrp} ':"",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                          TextDecoration.lineThrough,
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,)),
                                  ],
                                ),
                              ):
                              RichText(
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
//                            if(varmemberprice.toString() == varmrp.toString())

                                    new TextSpan(
                                        text: Features.iscurrencyformatalign?
                                        '${Check().checkmembership()?store.singelproduct!.priceVariation![0].membershipPrice:store.singelproduct!.priceVariation![0].price} ' + IConstants.currencyFormat:
                                        IConstants.currencyFormat + '${Check().checkmembership()?store.singelproduct!.priceVariation![0].membershipPrice:store.singelproduct!.priceVariation![0].price} ',
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 14 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,)),
                                    new TextSpan(
                                        text: store.singelproduct!.priceVariation![0].price!=store.singelproduct!.priceVariation![0].mrp?
                                        Features.iscurrencyformatalign?
                                        '${store.singelproduct!.priceVariation![0].mrp} ' + IConstants.currencyFormat:
                                        IConstants.currencyFormat + '${store.singelproduct!.priceVariation![0].mrp} ':"",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                          TextDecoration.lineThrough,
                                          fontSize: ResponsiveLayout.isSmallScreen(context) ? 12 : ResponsiveLayout.isMediumScreen(context) ? 18 : 20,)),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ],
                    ),*/
                   if(Vx.isWeb) SizedBox(height: 10,),
                    // Padding(
                    //   padding: const EdgeInsets.only(left:10.0,right:10,bottom: 5),
                    //   child: Text(
                    //     S.of(context).rating_review,//"Ratings & Reviews",
                    //     style: TextStyle(
                    //         fontSize: 18,
                    //         color: Theme
                    //             .of(context)
                    //             .primaryColor,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    Container(
                      padding:  EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10.0,right:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10),
                      width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                store.singelproduct!.rating!.toStringAsFixed(2), style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: ColorCodes.blackColor),
                              ),
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*Image.asset(
                                    Images.starImg,
                                    width: 15,
                                    height: 15,
                                    color: ColorCodes.yellowColor,
                                    fit: BoxFit.fill,
                                  ),*/
                                  RatingBar.builder(

                                    initialRating: store.singelproduct!.rating!,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 15,
                                    //this property will avoid touching of rating bar
                                    ignoreGestures: true,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star_rate,
                                      color: ColorCodes.yellowColor,
                                    ),

                                    onRatingUpdate: (rating) {

                                    },
                                  ),
                                  Text(store.singelproduct!.ratingCount.toString()+/*" ratings & "*/S.of(context).rating+store.singelproduct!.ratingCount.toString()+/*" reviews"*/S.of(context).review)
                                ],
                              ),
                              Spacer(),
                              if(Features.isreview_filter)
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorCodes.primaryColor,
                                  )
                                ),
                                // width: 100,
                                margin: EdgeInsets.only(left:8),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(

                                    // Initial Value
                                    value: dropdownvalue,

                                    // Down Arrow Icon
                                    icon:  Icon(Icons.keyboard_arrow_down,color: ColorCodes.primaryColor,),

                                    // Array list of items
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: Text(items,
                                            style: TextStyle(fontWeight: FontWeight.bold,color: ColorCodes.primaryColor),),
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;

                                      });
                                    },
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 35,),

                   /* Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10.0,right:10,bottom: 5),
                          child: Text(
                            S.of(context).product_review,//"Product Reviews",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorCodes.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Text(
                          store.singelproduct!.ratingCount.toString()+" Reviews",
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorCodes.black,
                              ),
                        ),
                        SizedBox(width: 10,),
                      ],
                    ),
                    Divider(color: ColorCodes.lightGreyWebColor,thickness: 1,),*/
                    Container(
                      width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(color: ColorCodes.lightGreyWebColor,thickness: 1,),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: store.singelproduct!.reviews!.length,
                          itemBuilder: (_, i) {
                            return Container(
                              padding: const EdgeInsets.only(left:10.0,right:10,top:10),
                              width: (Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height:25,
                                        decoration: BoxDecoration(
                                          color: store.singelproduct!.rating!.toStringAsFixed(0) == 1 ?ColorCodes.redColor:ColorCodes.primaryColor,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:5.0),
                                              child: Text(
                                                  store.singelproduct!.reviews![i].star!,
                                                style: TextStyle(color: ColorCodes.whiteColor),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color: ColorCodes.whiteColor,
                                            ),

                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(store.singelproduct!.reviews![i].user!,
                                          style: TextStyle(fontSize: 18.0,color: ColorCodes.blackColor,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text(store.singelproduct!.reviews![i].comment!,
                                      style: TextStyle(fontSize: 14.0,color: ColorCodes.blackColor)),
                                  SizedBox(height: 15,),
                                ],
                              ),
                            );
                          }
                      ),
                    ),
                    Divider(color: ColorCodes.lightGreyWebColor,thickness: 1,),
                    // SizedBox(height: 10,),

                  ],
                ),
              );

          }, mutations: {ProductMutation},),
        ),
        if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
      ],
    );
  }
  gradientappbarmobile() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: (IConstants.isEnterprise)?0:1,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () {
            Navigator.of(context).pop();

          }),
      titleSpacing: 0,
      title: Text(
        S.of(context).all_review,//"Product Review",
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
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
    );
  }
}
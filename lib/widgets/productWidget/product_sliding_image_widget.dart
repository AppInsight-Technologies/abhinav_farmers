
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/assets/images.dart';
import 'package:grocbay/data/calculations.dart';
import 'package:grocbay/generated/l10n.dart';
import 'package:grocbay/helper/custome_calculation.dart';
import 'package:grocbay/models/newmodle/product_data.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../badge_ofstock.dart';

class SlidingImage extends StatefulWidget {
  final Function() ontap;
  final ItemData productdata;
  final String varid;
  final int itemindexs;
  const SlidingImage({Key? key,required this.ontap,required this.productdata,required this.varid,required this.itemindexs}) : super(key: key);

  @override
  State<SlidingImage> createState() => _SlidingImageState();
}

class _SlidingImageState extends State<SlidingImage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("spppppp...."+widget.varid.toString());
    return Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?
    widget.productdata.type=="1"?
    widget.productdata.stock!<=0
        ? Consumer<CartCalculations>(
      builder: (_, cart, ch) => BadgeOfStock(
        child: ch!,
        value: "10",
        singleproduct: true,
      ),
      child: GestureDetector(
          onTap: () {
            widget.ontap();
          },
          child:
          Container(
              color: Colors.white,
              height: 200,
              margin: EdgeInsets.symmetric(
                  horizontal: 5.0,vertical: 10),
              child: ClipRRect(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        5.0)),
                child:
                CachedNetworkImage(
                    imageUrl:widget.productdata.itemFeaturedImage,
                    placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                    errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                    fit: BoxFit.fill),
                /*],
                                            )*/
              ))
      ),
    )
        : GestureDetector(
          onTap: () {
            widget.ontap();
          },
          child: Stack(
            children:[
              GFCarousel(
                autoPlay: true,
                viewportFraction: 1.0,
                height: 300,
                pagination: true,
                passiveIndicator: Colors.white,
                activeIndicator:
                Theme.of(context).accentColor,
                autoPlayInterval: Duration(seconds: 8),
                items: <Widget>[
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0,vertical: 40),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    5.0)),
                            child:
                            CachedNetworkImage(
                                imageUrl:widget.productdata.itemFeaturedImage,
                                placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                fit: BoxFit.fill),
                            /*],
                                                  )*/
                          )),
                    )
                ],
              ),
              widget.productdata.eligibleForExpress=="0"?Positioned(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                          color: ColorCodes.varcolor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:2.0),
                          child: Text(/*"Express"*/S.of(context).express,style: TextStyle(fontSize: 14,color: ColorCodes.primaryColor,fontWeight: FontWeight.w800),),
                        ),
                        Image.asset(Images.express,
                          height: 23.0,
                          width: 23.0,
                          color: ColorCodes.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ):SizedBox.shrink(),

            ],

          ),
        ):
    widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).stock!<=0
        ? Consumer<CartCalculations>(
      builder: (_, cart, ch) => BadgeOfStock(
        child: ch!,
        value: "10",
        singleproduct: true,
      ),
      child: GestureDetector(
        onTap: () {
          widget.ontap();
        },
        child: GFCarousel(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 173,
          pagination: true,
          passiveIndicator: Colors.white,
          activeIndicator:
          Theme.of(context).accentColor,
          autoPlayInterval: Duration(seconds: 8),
          items: <Widget>[
            if(widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.isNotEmpty)
              ... widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.map((e) =>  /*Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl: e.image,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        *//*],
                                            )*//*
                      )),
                );
              },
            )).toList()*/

              GestureDetector(
                onTap: () {

                },
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(
                        horizontal: 5.0,vertical: 10),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              5.0)),
                      child:
                      CachedNetworkImage(
                          imageUrl: e.image,
                          placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                          errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                          fit: BoxFit.fill),
                      /*],
                            )*/
                    )),
              )).toList()
            else
              GestureDetector(
                onTap: () {

                },
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(
                        horizontal: 5.0,vertical: 10),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              5.0)),
                      child:
                      CachedNetworkImage(
                          imageUrl:widget.productdata.itemFeaturedImage,
                          placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                          errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                          fit: BoxFit.fill),
                      /*],
                            )*/
                    )),
              ),

          ],
        ),
      ),
    )
        : Stack(
      children: [
        GestureDetector(
          onTap: () {
            widget.ontap();
          },
          child: Stack(
            children:[
              GFCarousel(
                autoPlay: true,
                viewportFraction: 1.0,
                height: 300,
                pagination: true,
                passiveIndicator: Colors.white,
                activeIndicator:
                Theme.of(context).accentColor,
                autoPlayInterval: Duration(seconds: 8),
                items: <Widget>[
                  // if(productdata.priceVariation!.length<0)
                  //
                  //   else
                  if(widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.isNotEmpty)
                    ... widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.map((e) =>  GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0,vertical: 10),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    5.0)),
                            child:
                            CachedNetworkImage(
                                imageUrl: e.image,
                                placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                fit: BoxFit.fill),
                            /*],
                                                  )*/
                          )),
                    )).toList()
                  else
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0,vertical: 40),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    5.0)),
                            child:
                            CachedNetworkImage(
                                imageUrl:widget.productdata.itemFeaturedImage,
                                placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                                errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                                fit: BoxFit.fill),
                            /*],
                                                  )*/
                          )),
                    )
                ],
              ),
              widget.productdata.eligibleForExpress=="0"?Positioned(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                          color: ColorCodes.varcolor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:2.0),
                          child: Text(/*"Express"*/S.of(context).express,style: TextStyle(fontSize: 14,color: ColorCodes.primaryColor,fontWeight: FontWeight.w800),),
                        ),
                        Image.asset(Images.express,
                          height: 23.0,
                          width: 23.0,
                          color: ColorCodes.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ):SizedBox.shrink(),

            ],

          ),
        ),
      ],
    ):




    widget.productdata.type=="1"?
    widget.productdata.stock!<=0
        ? Consumer<CartCalculations>(
      builder: (_, cart, ch) => BadgeOfStock(
        child: ch!,
        value: "10",
        singleproduct: true,
      ),
      child: GestureDetector(
          onTap: () {
            widget.ontap();
          },
          child: /*GFCarousel(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 173,
          pagination: true,
          passiveIndicator: Colors.white,
          activeIndicator:
          Theme.of(context).accentColor,
          autoPlayInterval: Duration(seconds: 8),
          items: <Widget>[
            ... productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.map((e) =>  Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl: productdata.itemFeaturedImage,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        *//*],
                                            )*//*
                      )),
                );
              },
            )).toList()
          ],
        ),*/
          Container(
              color: Colors.white,
              height: 200,
              margin: EdgeInsets.symmetric(
                  horizontal: 5.0,vertical: 10),
              child: ClipRRect(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        5.0)),
                child:
                CachedNetworkImage(
                    imageUrl:widget.productdata.itemFeaturedImage,
                    placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                    errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                    fit: BoxFit.fill),
                /*],
                                            )*/
              ))
      ),
    )
        : Stack(
          children: [

            GestureDetector(
      onTap: () {
            widget.ontap();
      },
      child:/* GFCarousel(
            autoPlay: true,
            viewportFraction: 1.0,
            height: 180,
            pagination: true,
            passiveIndicator: Colors.white,
            activeIndicator:
            Theme.of(context).accentColor,
            autoPlayInterval: Duration(seconds: 8),
            items: <Widget>[
              // if(productdata.priceVariation!.length<0)
              //
              //   else
              if(productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.isNotEmpty)
                ... productdata.priceVariation!.elementAt(productdata.priceVariation!.indexWhere((element) => element.id == varid)).images!.map((e) =>  GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl: e.image,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        *//*],
                                                )*//*
                      )),
                )).toList()
              else
                GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl:productdata.itemFeaturedImage,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        *//*],
                                                )*//*
                      )),
                )
            ],
      )*/
      GFCarousel(
        autoPlay: true,
        viewportFraction: 1.0,
        height: 300,
        pagination: true,
        passiveIndicator: Colors.white,
        activeIndicator:
        Theme.of(context).accentColor,
        autoPlayInterval: Duration(seconds: 8),
        items: <Widget>[
          Container(
              color: Colors.white,
              height: 10,
              margin: EdgeInsets.symmetric(
                  horizontal: 5.0,vertical: 10),
              child: ClipRRect(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        5.0)),
                child:
                CachedNetworkImage(
                    imageUrl:widget.productdata.itemFeaturedImage,
                    height: 10,
                    placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                    errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                ),
                /*],
                                                  )*/
              )),
        ],
      ),
    ),
            if(!Vx.isWeb)
              if (widget.productdata.type=="1"?Calculate().getmargin(widget.productdata.mrp,
                  VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                  widget.productdata.discointDisplay! ? widget.productdata.price : widget.productdata.mrp
                      : widget.productdata.membershipDisplay!? widget.productdata.membershipPrice: widget.productdata.price)>0:Calculate().getmargin(widget.productdata.priceVariation![widget.itemindexs].mrp,
                  VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                  widget.productdata.priceVariation![widget.itemindexs].discointDisplay! ? widget.productdata.priceVariation![widget.itemindexs].price : widget.productdata.priceVariation![widget.itemindexs].mrp
                      : widget.productdata.priceVariation![widget.itemindexs].membershipDisplay!? widget.productdata.priceVariation![widget.itemindexs].membershipPrice: widget.productdata.priceVariation![widget.itemindexs].price)>0)

                Align(
              alignment: Alignment.topRight,
              child: Container(
                //margin: EdgeInsets.only(right:5.0),
                padding: EdgeInsets.all(8.0),
                // color: Theme.of(context).accentColor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      3.0),
                  color: ColorCodes.greenColor,//Color(0xff6CBB3C),
                ),
                constraints: BoxConstraints(
                  minWidth: 28,
                  minHeight: 18,
                ),
                child: Text(
                  widget.productdata.type=="1"?  Calculate().getmargin(widget.productdata.mrp,
                      VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                      widget.productdata.discointDisplay! ? widget.productdata.price : widget.productdata.mrp
                          : widget.productdata.membershipDisplay!? widget.productdata.membershipPrice: widget.productdata.price).toStringAsFixed(2) + S .current.off:
                  Calculate().getmargin(widget.productdata.priceVariation![widget.itemindexs].mrp,
                      VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                      widget.productdata.priceVariation![widget.itemindexs].discointDisplay! ? widget.productdata.priceVariation![widget.itemindexs].price : widget.productdata.priceVariation![widget.itemindexs].mrp
                          : widget.productdata.priceVariation![widget.itemindexs].membershipDisplay!? widget.productdata.priceVariation![widget.itemindexs].membershipPrice: widget.productdata.priceVariation![widget.itemindexs].price).toStringAsFixed(0) + S .current.off,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color:ColorCodes.whiteColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            widget.productdata.eligibleForExpress=="0"?Positioned(
              bottom: 10.0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0,left: 0,bottom: 5),
                  child: Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                          color: ColorCodes.varcolor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:2.0),
                          child: Text(/*"Express"*/S.of(context).express,style: TextStyle(fontSize: 12,color: ColorCodes.primaryColor,fontWeight: FontWeight.w800),),
                        ),
                        Image.asset(Images.express,
                          height: 23.0,
                          width: 23.0,
                          color: ColorCodes.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ):SizedBox.shrink(),
          ],
        ):
    widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).stock!<=0
        ? Consumer<CartCalculations>(
      builder: (_, cart, ch) => BadgeOfStock(
        child: ch!,
        value: "10",
        singleproduct: true,
      ),
      child: GestureDetector(
        onTap: () {
          widget.ontap();
        },
        child: GFCarousel(
          autoPlay: true,
          viewportFraction: 1.0,
          height: 173,
          pagination: true,
          passiveIndicator: Colors.white,
          activeIndicator:
          Theme.of(context).accentColor,
          autoPlayInterval: Duration(seconds: 8),
          items: <Widget>[
            if(widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.isNotEmpty)
              ... widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.map((e) =>  /*Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl: e.image,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        *//*],
                                            )*//*
                      )),
                );
              },
            )).toList()*/

              GestureDetector(
                onTap: () {

                },
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(
                        horizontal: 5.0,vertical: 10),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              5.0)),
                      child:
                      CachedNetworkImage(
                          imageUrl: e.image,
                          placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                          errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                          fit: BoxFit.fill),
                      /*],
                            )*/
                    )),
              )).toList()
            else
              GestureDetector(
                onTap: () {

                },
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(
                        horizontal: 5.0,vertical: 10),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              5.0)),
                      child:
                      CachedNetworkImage(
                          imageUrl:widget.productdata.itemFeaturedImage,
                          placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                          errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                          fit: BoxFit.fill),
                      /*],
                            )*/
                    )),
              ),

          ],
        ),
      ),
    )
        : Stack(
          children: [
            if(!Vx.isWeb)
            if (widget.productdata.type=="1"?Calculate().getmargin(widget.productdata.mrp,
                VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                widget.productdata.discointDisplay! ? widget.productdata.price : widget.productdata.mrp
                    : widget.productdata.membershipDisplay!? widget.productdata.membershipPrice: widget.productdata.price)>0:Calculate().getmargin(widget.productdata.priceVariation![widget.itemindexs].mrp,
                VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                widget.productdata.priceVariation![widget.itemindexs].discointDisplay! ? widget.productdata.priceVariation![widget.itemindexs].price : widget.productdata.priceVariation![widget.itemindexs].mrp
                    : widget.productdata.priceVariation![widget.itemindexs].membershipDisplay!? widget.productdata.priceVariation![widget.itemindexs].membershipPrice: widget.productdata.priceVariation![widget.itemindexs].price)>0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  //margin: EdgeInsets.only(right:5.0),
                  padding: EdgeInsets.all(8.0),
                  // color: Theme.of(context).accentColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        3.0),
                    color: ColorCodes.greenColor,//Color(0xff6CBB3C),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 28,
                    minHeight: 18,
                  ),
                  child: Text(
                    widget.productdata.type=="1"?  Calculate().getmargin(widget.productdata.mrp,
                        VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                        widget.productdata.discointDisplay! ? widget.productdata.price : widget.productdata.mrp
                            : widget.productdata.membershipDisplay!? widget.productdata.membershipPrice: widget.productdata.price).toStringAsFixed(2) + S .current.off:
                    Calculate().getmargin(widget.productdata.priceVariation![widget.itemindexs].mrp,
                        VxState.store.userData.membership! == "0" || VxState.store.userData.membership! == "2" ?
                        widget.productdata.priceVariation![widget.itemindexs].discointDisplay! ? widget.productdata.priceVariation![widget.itemindexs].price : widget.productdata.priceVariation![widget.itemindexs].mrp
                            : widget.productdata.priceVariation![widget.itemindexs].membershipDisplay!? widget.productdata.priceVariation![widget.itemindexs].membershipPrice: widget.productdata.priceVariation![widget.itemindexs].price).toStringAsFixed(0) + S .current.off,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color:ColorCodes.whiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            GestureDetector(
      onTap: () {
            widget.ontap();
      },
      child: Stack(
        children:[
          GFCarousel(
            autoPlay: true,
            viewportFraction: 1.0,
            height: 300,
            pagination: true,
            passiveIndicator: Colors.white,
            activeIndicator:
            Theme.of(context).accentColor,
            autoPlayInterval: Duration(seconds: 8),
            items: <Widget>[
              // if(productdata.priceVariation!.length<0)
              //
              //   else
              if(widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.isNotEmpty)
                ... widget.productdata.priceVariation!.elementAt(widget.productdata.priceVariation!.indexWhere((element) => element.menuItemId == widget.varid)).images!.map((e) =>  GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 10),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl: e.image,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        /*],
                                                  )*/
                      )),
                )).toList()
              else
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.0,vertical: 40),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                5.0)),
                        child:
                        CachedNetworkImage(
                            imageUrl:widget.productdata.itemFeaturedImage,
                            placeholder: (context, url) => Image.asset(Images.defaultProductImg),
                            errorWidget: (context, url, error) => Image.asset(Images.defaultProductImg),
                            fit: BoxFit.fill),
                        /*],
                                                  )*/
                      )),
                )
            ],
          ),
          widget.productdata.eligibleForExpress=="0"?Positioned(
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 90,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                      color: ColorCodes.varcolor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:2.0),
                      child: Text(/*"Express"*/S.of(context).express,style: TextStyle(fontSize: 14,color: ColorCodes.primaryColor,fontWeight: FontWeight.w800),),
                    ),
                    Image.asset(Images.express,
                      height: 23.0,
                      width: 23.0,
                      color: ColorCodes.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ):SizedBox.shrink(),

    ],

      ),
    ),



          ],
        );
  }
}

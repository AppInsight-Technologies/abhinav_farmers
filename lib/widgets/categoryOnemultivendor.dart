import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/models/newmodle/home_store_modle.dart';

import '../constants/IConstants.dart';

import '../blocs/sliderbannerBloc.dart';
import '../models/categoriesModel.dart';
import 'package:shimmer/shimmer.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';

class CategoryOneMultiVendor extends StatefulWidget {
  Home_Store homedata;
  CategoryOneMultiVendor(this.homedata);

  @override
  _CategoryOneMultiVendorState createState() => _CategoryOneMultiVendorState();
}

class _CategoryOneMultiVendorState extends State<CategoryOneMultiVendor> with Navigations{
  var subcategoryData;
  bool _isWeb = false;
  var _categoryOne = false;
  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
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
    super.initState();
  }

  Widget _horizontalshimmerslider() {

    return _isWeb ?
    SizedBox.shrink()
        :
    Row(
      children: <Widget>[
        Expanded(
            child: Card(
              child: SizedBox(
                height: 100,
                child: Container(
                  padding:EdgeInsets.only(left: 28,right: 28),
                  child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, i) => Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Shimmer.fromColors(
                              baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
                              highlightColor: /*Color(0xffeeeeee)*/ColorCodes.shimmerColor,
                              child: Container(
                                width: 90.0,
                                height: 90.0,
                                color:/* Theme.of(context).buttonColor*/Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.homedata.data!.featuredCategoryTags!.length > 0) {
      _categoryOne = true;
    } else {
      _categoryOne = false;
    }
    // return StreamBuilder(
    //   stream: bloc.categoryOne,
    //   builder: (context, AsyncSnapshot<List<CategoriesModel>> snapshot) {
    if (_categoryOne) {
      double deviceWidth = MediaQuery.of(context).size.width;
      int widgetsInRow = 4;
      double aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 100;


      if (deviceWidth > 1200) {
        widgetsInRow = 8;
        aspectRatio =
        (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 165 :
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
      } else if (deviceWidth > 968) {
        widgetsInRow = 6;
        aspectRatio =
        (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
      } else if (deviceWidth > 768) {
        widgetsInRow = 6;
        aspectRatio =
        (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
      }
      return Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(widget.homedata.data!.featuredCategoryTags!.length.toString()),
           /* Container(
              padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:10,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:10 ),
              child:
              Text(
                widget.homedata.data!.categoryTagsLabel!,
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),*/
            MouseRegion(
              cursor: MouseCursor.uncontrolled,
              child: GridView.builder(
                  shrinkWrap: true,
                  controller: new ScrollController(keepScrollOffset: false),
                  itemCount: widget.homedata.data!.featuredCategoryTags!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widgetsInRow,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (_, i) =>
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigation(context, name: Routename.StoreHome,navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  "store_id":widget.homedata.data!.featuredCategoryTags![i].id.toString(),
                                  "fromScreen":"Category"
                                });

                          },
                          child: Container(
                            width: ResponsiveLayout.isSmallScreen(context)?170:150,
                            padding: EdgeInsets.only(right: 5),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  //padding: const EdgeInsets.only(left:20.0,right: 5.0,top: 5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.homedata.data!.featuredCategoryTags![i].iconImage,
                                    placeholder: (context, url) =>    Shimmer.fromColors(
                                        baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
                                        highlightColor: /*Color(0xffeeeeee)*/ColorCodes.shimmerColor,
                                        child: Image.asset(Images.defaultCategoryImg))/*_horizontalshimmerslider()*/,
                                    errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                    height: ResponsiveLayout.isSmallScreen(context)?85:130,
                                    width: ResponsiveLayout.isSmallScreen(context)?85:170,
                                    //fit: BoxFit.fill,
                                  ),
                                ),
                                // Spacer(),
                                SizedBox(height: 1,),
                                Container(height: 10,
                                  padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?12:10 ),
                                  child: Center(
                                    child: Text(widget.homedata.data!.featuredCategoryTags![i].name!,
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveLayout.isSmallScreen(context)?15.0:16.0,
                                          color: Features.ismultivendor ? ColorCodes.emailColor : ColorCodes.blackColor,

                                        )),
                                  ),
                                ),
                                //SizedBox(height: 5.0,),
                              ],
                            ) ,
                            // )
                          ),
                        ),
                      )
              ),
            ),
          ],
        ),
      );
    } /*else if (snapshot.hasError) {
          return SizedBox.shrink();
        } else if(snapshot.data.toString() == "null") {
          return SizedBox.shrink();
        }*/ else {
      return /*_horizontalshimmerslider()*/SizedBox.shrink();
    }
    //     },
    // );
  }
}


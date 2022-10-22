import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/rought_genrator.dart';
import '../models/newmodle/home_page_modle.dart';
import '../generated/l10n.dart';
import '../constants/IConstants.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/ColorCodes.dart';
import '../providers/categoryitems.dart';
import 'package:provider/provider.dart';

import 'categories_grid.dart';
import '../assets/images.dart';

class
ExpansionCategory extends StatefulWidget {
  HomePageData homedata;
  ExpansionCategory(this.homedata);

  @override
  _ExpansionCategoryState createState() => _ExpansionCategoryState();
}

class _ExpansionCategoryState extends State<ExpansionCategory> with Navigations {
  int selected = -1;
  bool _isWeb = false;

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
  @override
  Widget build(BuildContext context) {
    //final categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 160;

    return Container(
      color: ColorCodes.whiteColor,
      child: Column(
        children: <Widget>[
//          SizedBox(height:20.0),
          customCategories(context),
        ],
      ),
    );
  }

  Widget customCategories(context) {
    final categoriesData = Provider.of<CategoriesItemsList>(
        context, listen: false);
    return (IConstants.isEnterprise) ?
   /* StreamBuilder(
      stream: catbloc.catblostream,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
        }*/

        (widget.homedata.data!.allCategoryDetails!.length > 0)?
          ListView.builder(
            key: Key('builder ${selected.toString()}'),
            shrinkWrap: true,
            controller: new ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.all(5.0),
            itemCount: widget.homedata.data!.allCategoryDetails!.length,
            itemBuilder: (ctx, i)
            {
              //     widget.homedata.data
              //         .allCategoryDetails[i].iconImage+"  "+ widget
              //     .homedata
              //     .data
              //     .allCategoryDetails[i]
              //     .description+"  "+ widget
              //     .homedata
              //     .data
              //     .allCategoryDetails[i]
              //     .heading);
                    return  Container(
                        padding:  EdgeInsets.only(
                       bottom: ResponsiveLayout
                           .isSmallScreen(
                           context)
                           ? 0.0:25),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          // border: Border.all(color: ColorCodes.lightGreyWebColor),
                          color: /*Color(0xFFD2E8FE)*/ /*ColorCodes.lightBlueColor*/ Colors.white,
                        ),
                        // margin: EdgeInsets.all(5),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child:
                          Column(
                            children: [
                              (widget.homedata.data!.allCategoryDetails![i].categoryType == 0)?
                              GestureDetector(
                                onTap: (){
                                  Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                                      qparms: {
                                        'maincategory': widget.homedata.data!.allCategoryDetails![i].categoryName!,
                                        'catId': widget.homedata.data!.allCategoryDetails![i].id!,
                                        'catTitle': widget.homedata.data!.allCategoryDetails![i].categoryName!,
                                        'subcatId': widget.homedata.data!.allCategoryDetails![i].id!,
                                        'indexvalue': i.toString(),
                                        "nosub":"true",
                                        'prev': "category_item"
                                      });
                                },
                                child: Container(
                                    padding: EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: widget.homedata.data
                                          !.allCategoryDetails![i].iconImage,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                Images.defaultCategoryImg,
                                                /*height: ResponsiveLayout.isSmallScreen(
                                              context) ? 70 : 100,
                                          width: ResponsiveLayout.isSmallScreen(
                                              context) ? 100 : 130,
                                          fit: BoxFit.fill,*/
                                              ),
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                Images.defaultCategoryImg,
                                                /* height: ResponsiveLayout.isSmallScreen(
                                              context) ? 70 : 100,
                                          width: ResponsiveLayout.isSmallScreen(
                                              context) ? 100 : 130,
                                          fit: BoxFit.fill,*/
                                              ),
                                          height: ResponsiveLayout.isSmallScreen(
                                              context)
                                              ? 100
                                              : 100,
                                          width: ResponsiveLayout.isSmallScreen(
                                              context)
                                              ? 80
                                              : 130,
                                          // fit: BoxFit.fill,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.45,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  widget
                                                      .homedata
                                                      .data
                                                  !.allCategoryDetails![i]
                                                      .categoryName!,
                                                  style: TextStyle(
                                                      fontSize: ResponsiveLayout
                                                          .isSmallScreen(
                                                          context)
                                                          ? 14
                                                          : 17,
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme
                                                          .of(context)
                                                          .primaryColor),
                                                ),
                                                (widget
                                                    .homedata
                                                    .data
                                                !.allCategoryDetails![
                                                i]
                                                    .description ==
                                                    "null" ||
                                                    widget
                                                        .homedata
                                                        .data
                                                    !.allCategoryDetails![
                                                    i]
                                                        .description ==
                                                        "")
                                                    ? SizedBox.shrink()
                                                    : SizedBox(
                                                  height: 5,
                                                ),
                                                (widget.homedata.data!
                                                    .allCategoryDetails![i]
                                                    .description == "null" ||
                                                    widget.homedata.data!
                                                        .allCategoryDetails![i]
                                                        .description == "")
                                                    ? SizedBox.shrink()
                                                    : Text(
                                                  widget.homedata.data!
                                                      .allCategoryDetails![i]
                                                      .description!,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    (widget.homedata.data!
                                                        .allCategoryDetails![i]
                                                        .heading == "null" ||
                                                        widget.homedata
                                                            .data
                                                        !.allCategoryDetails![
                                                        i]
                                                            .heading ==
                                                            "")
                                                        ? SizedBox.shrink()
                                                        : Image.asset(
                                                      Images.home_offer,
                                                      height: 20,
                                                      width: 15,
                                                      color: ColorCodes.primaryColor,
                                                    ),
                                                    (widget
                                                        .homedata
                                                        .data
                                                    !.allCategoryDetails![
                                                    i]
                                                        .heading ==
                                                        "null" ||
                                                        widget
                                                            .homedata
                                                            .data
                                                        !.allCategoryDetails![
                                                        i]
                                                            .heading ==
                                                            "")
                                                        ? SizedBox.shrink()
                                                        : Text(
                                                      widget
                                                          .homedata
                                                          .data
                                                      !.allCategoryDetails![
                                                      i]
                                                          .heading!,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: ColorCodes
                                                              .darkgreen),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        /* VerticalDivider(
                                    color: Colors.white,
                                    thickness: 2,
                                    endIndent: 20,
                                    indent: 20,
                                  ),*/
                                      ],
                                    ),
                                  ),
                              )
                              :
                              ExpansionTile(
                                  key: Key(i.toString()),
                                  //attention
                                  initiallyExpanded: i == selected,
                                  backgroundColor: /*Color(0xFFA2E6BE)*/ Colors
                                      .white,
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Container(
                                          color: Colors.white,
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 30,
                                            color: ResponsiveLayout.isSmallScreen(context)?ColorCodes.darkgreen:ColorCodes.blackColor,
                                          )),
                                      if (ResponsiveLayout.isSmallScreen(context))
                                        SizedBox(
                                          height: 5,
                                        ),
                                    ],
                                  ),
                                  title: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: widget.homedata.data
                                             !.allCategoryDetails![i].iconImage,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            Images.defaultCategoryImg,
                                            /*height: ResponsiveLayout.isSmallScreen(
                                              context) ? 70 : 100,
                                          width: ResponsiveLayout.isSmallScreen(
                                              context) ? 100 : 130,
                                          fit: BoxFit.fill,*/
                                          ),
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            Images.defaultCategoryImg,
                                            /* height: ResponsiveLayout.isSmallScreen(
                                              context) ? 70 : 100,
                                          width: ResponsiveLayout.isSmallScreen(
                                              context) ? 100 : 130,
                                          fit: BoxFit.fill,*/
                                          ),
                                          height: ResponsiveLayout.isSmallScreen(
                                                  context)
                                              ? 100
                                              : 150,
                                          width: ResponsiveLayout.isSmallScreen(
                                                  context)
                                              ? 80
                                              : 150,
                                          // fit: BoxFit.fill,
                                        ),
                                        SizedBox(
                                          width:ResponsiveLayout
                                              .isSmallScreen(
                                              context)
                                              ?  20:60,
                                        ),
                                        Container(
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.45,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  widget
                                                      .homedata
                                                      .data
                                                      !.allCategoryDetails![i]
                                                      .categoryName!,
                                                  style: TextStyle(
                                                      fontSize: ResponsiveLayout
                                                              .isSmallScreen(
                                                                  context)
                                                          ? 14
                                                          : 24,
                                                      fontWeight: FontWeight.bold,
                                                      color: ResponsiveLayout
                                                          .isSmallScreen(
                                                          context)
                                                          ?/*Theme.of(context)
                                                          .primaryColor*/ColorCodes.blackColor:ColorCodes.blackColor),
                                                ),
                                                (widget
                                                                .homedata
                                                                .data
                                                                !.allCategoryDetails![
                                                                    i]
                                                                .description ==
                                                            "null" ||
                                                        widget
                                                                .homedata
                                                                .data
                                                                !.allCategoryDetails![
                                                                    i]
                                                                .description ==
                                                            "")
                                                    ? SizedBox.shrink()
                                                    : SizedBox(
                                                        height: 5,
                                                      ),
                                                (widget.homedata.data!.allCategoryDetails![i].description == "null" ||
                                                    widget.homedata.data!.allCategoryDetails![i].description == "")
                                                    ? SizedBox.shrink()
                                                    : Text(
                                                        widget.homedata.data!.allCategoryDetails![i].description!,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: ResponsiveLayout
                                                                .isSmallScreen(
                                                                context)
                                                                ? 12:13,
                                                            color: Colors.black),
                                                      ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    (widget.homedata.data!.allCategoryDetails![i].heading == "null" || widget.homedata
                                                                    .data
                                                                    !.allCategoryDetails![
                                                                        i]
                                                                    .heading ==
                                                                "")
                                                        ? SizedBox.shrink()
                                                        : Image.asset(
                                                            Images.home_offer,
                                                            height: 30,
                                                            width: 25,
                                                      color: ResponsiveLayout
                                                          .isSmallScreen(
                                                          context)
                                                          ? ColorCodes
                                                          .darkgreen:ColorCodes.ordergreen,
                                                          ),
                                                    SizedBox(width: 5,),
                                                    (widget
                                                                    .homedata
                                                                    .data
                                                                    !.allCategoryDetails![
                                                                        i]
                                                                    .heading ==
                                                                "null" ||
                                                            widget
                                                                    .homedata
                                                                    .data
                                                                    !.allCategoryDetails![
                                                                        i]
                                                                    .heading ==
                                                                "")
                                                        ? SizedBox.shrink()
                                                        : Text(
                                                            widget
                                                                .homedata
                                                                .data
                                                                !.allCategoryDetails![
                                                                    i]
                                                                .heading!,
                                                            style: TextStyle(
                                                                fontSize:ResponsiveLayout
                                                                    .isSmallScreen(
                                                                    context)
                                                                    ?  12:14,
                                                                fontWeight:
                                                                ResponsiveLayout
                                                                    .isSmallScreen(
                                                                    context)
                                                                    ? FontWeight.bold:null,
                                                                color:ResponsiveLayout
                                                                    .isSmallScreen(
                                                                    context)
                                                                    ? ColorCodes
                                                                    .darkgreen:ColorCodes.ordergreen),
                                                          ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        /* VerticalDivider(
                                    color: Colors.white,
                                    thickness: 2,
                                    endIndent: 20,
                                    indent: 20,
                                  ),*/
                                      ],
                                    ),
                                  ),
                                  children: [
                                    CategoriesGrid(widget.homedata.data!.allCategoryDetails![i]),
                                  ],
                                  onExpansionChanged: ((newState) {
                                    if (newState)
                                      setState(() {
                                        Duration(seconds: 20000);
                                        selected = i;
                                      });
                                    else
                                      setState(() {
                                        selected = -1;
                                      });
                                  }))

                            ],
                          ),
                        ),
                      );
                    }):
         _isWeb ? SizedBox.shrink() : /*expandebelCatShimmer()*/SizedBox.shrink()
      /*},
    )*/ : /*StreamBuilder(
      stream: catbloc.catblostream,
      builder: (context, snapshot) {*/
        (widget.homedata.data!.allCategoryDetails!.length > 0)?
         ListView.builder(
            shrinkWrap: true,
            controller: new ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.all(5.0),
            itemCount: widget.homedata.data!.allCategoryDetails!.length,
            itemBuilder: (ctx, i) {
               return  Container(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(widget.homedata.data!.allCategoryDetails![i].categoryName!,
                       style: TextStyle(
                           fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     SizedBox(height: 5,),
                     CategoriesGrid(widget.homedata.data!.allCategoryDetails![i]),
                     SizedBox(height: 10,),
                   ],
                 ),
               );
            }
          ): _isWeb ? SizedBox.shrink() : expandebelCatShimmer();/*SizedBox.shrink();*/
     /* },
    );*/
  }
  expandebelCatShimmer() {
    return Shimmer.fromColors(child: ListView.builder(
      key: Key('builder ${selected.toString()}'),
      shrinkWrap: true,
      controller: new ScrollController(keepScrollOffset: false),
      padding: const EdgeInsets.all(5.0),
      itemCount: 6,
      itemBuilder: (ctx, i) => Container(
        padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.grey[200]!),
        ),
        margin: EdgeInsets.all(5),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              key: Key(i.toString()), //attention
              initiallyExpanded : false,
              backgroundColor: ColorCodes.cyanlightColor,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      color: Colors.white, child: Icon(Icons.keyboard_arrow_down,color: Colors.grey[200],)),
                  //if(ResponsiveLayout.isSmallScreen(context))
                    SizedBox(height: 18,),

                ],
              ),
              title: IntrinsicHeight(
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "image",
                      errorWidget: (context, url, error) => Image.asset(
                        Images.defaultCategoryImg,
                        height: ResponsiveLayout.isSmallScreen(context)?70:100,
                        width: ResponsiveLayout.isSmallScreen(context)?100:130,
                        fit: BoxFit.fill,
                      ),
                      placeholder: (context, url) => Image.asset(
                        Images.defaultCategoryImg,
                        height: ResponsiveLayout.isSmallScreen(context)?70:100,
                        width: ResponsiveLayout.isSmallScreen(context)?100:130,
                        fit: BoxFit.fill,
                      ),
                      height: ResponsiveLayout.isSmallScreen(context)?70:100,
                      width: ResponsiveLayout.isSmallScreen(context)?100:130,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Text(
                          S .of(context).category,//"Category",
                          style: TextStyle(fontSize:ResponsiveLayout.isSmallScreen(context)? 13:17, fontWeight: FontWeight.bold),
                        )),
                    VerticalDivider(
                      color: Colors.white,
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                  ],
                ),
              ),
              children: [
                Container()],

          ),
        ),
      ),
    ),
      baseColor:/* Color(0xffd3d3d3)*/Colors.grey[200]!,
      highlightColor: ColorCodes.lightGreyWebColor,);
  }
}

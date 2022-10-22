import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/IConstants.dart';

import '../blocs/sliderbannerBloc.dart';
import '../models/categoriesModel.dart';
import 'package:shimmer/shimmer.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';

class CategoryOne extends StatefulWidget {
  HomePageData homedata;
  CategoryOne(this.homedata);

  @override
  _CategoryOneState createState() => _CategoryOneState();
}

class _CategoryOneState extends State<CategoryOne> with Navigations{
  var subcategoryData;
  var _categoryOne = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.homedata.data!.category1Details!.length > 0) {
      _categoryOne = true;
    } else {
      _categoryOne = false;
    }
        if (_categoryOne) {
          double deviceWidth = MediaQuery.of(context).size.width;
          int widgetsInRow = 4;
          double aspectRatio = (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 123;
          if (deviceWidth > 1200) {
            widgetsInRow = 8;
            aspectRatio =
            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 185 :
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
          } else if (deviceWidth > 968) {
            widgetsInRow = 6;
            aspectRatio =
            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
          } else if (deviceWidth > 768) {
            widgetsInRow = 6;
            aspectRatio =
            (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
            (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
          }
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                MouseRegion(
                   cursor: MouseCursor.uncontrolled,
                  child: GridView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(keepScrollOffset: false),
                      itemCount: widget.homedata.data!.category1Details!.length,
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
                                Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'maincategory': widget.homedata.data!.category1Details![i].categoryName,
                                  'catId':  widget.homedata.data!.category1Details![i].parentId,
                                  'catTitle': widget.homedata.data!.category1Details![i].categoryName,
                                  'indexvalue': i.toString(),
                                  'subcatId':  widget.homedata.data!.category1Details![i].id,
                                  'prev': "category_item"
                                });
                              },
                              child: Container(
                                width: ResponsiveLayout.isSmallScreen(context)?100:110,
                                child:  Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                  elevation: 0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(right:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                            ?10:0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              topRight: Radius.circular(4),
                                              bottomLeft: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: widget.homedata.data!.category1Details![i].iconImage,
                                              placeholder: (context, url) =>    Shimmer.fromColors(
                                                  baseColor: ColorCodes.shimmerColor,
                                                  highlightColor:ColorCodes.shimmerColor,
                                                  child: Image.asset(Images.defaultCategoryImg)),
                                              errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                              height: ResponsiveLayout.isSmallScreen(context)?90:130,
                                              width: ResponsiveLayout.isSmallScreen(context)?90:170,
                                              fit:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                                  ? BoxFit.fill:null,
                                            )
                                        ),
                                      ),
                                      // Spacer(),
                                      SizedBox(height: 5,),
                                      Container(height: 30,
                                      //  padding: EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?12:0 ),
                                        child: Center(
                                          child: Text(widget.homedata.data!.category1Details![i].categoryName!,
                                              overflow: TextOverflow.visible,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveLayout.isSmallScreen(context)?12.0:16.0,
                                                color: Features.ismultivendor ? ColorCodes.emailColor : ColorCodes.blackColor,
                                              )),
                                        ),
                                      ),
                                      //SizedBox(height: 5.0,),
                                    ],
                                  ),
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
        } else {
          return SizedBox.shrink();
        }
  }
}
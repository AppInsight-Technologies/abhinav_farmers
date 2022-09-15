import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/IConstants.dart';
import '../generated/l10n.dart';

import '../constants/features.dart';
import '../blocs/sliderbannerBloc.dart';
import '../models/categoriesModel.dart';
import 'package:shimmer/shimmer.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';

class CategoryTwo extends StatefulWidget {
  HomePageData homedata;
  CategoryTwo(this.homedata);


  @override
  _CategoryTwoState createState() => _CategoryTwoState();
}

class _CategoryTwoState extends State<CategoryTwo> with Navigations{
  bool _isLoading = true;
  bool _isWeb = false;
  var _categoryTwo = false;

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
    // bloc.CategoryTwo();
    super.initState();
  }




  Widget _horizontalshimmerslider() {
    return _isWeb ?
    SizedBox.shrink()
        :
    Row(
      children: <Widget>[
        Card(
          child: SizedBox(
            height: 100,
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
                        highlightColor: ColorCodes.shimmerColor,
                        child: Container(
                          width: 90.0,
                          height: 90.0,
                          color: Theme.of(context).buttonColor,
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
      ],
    );
  }

  @override
  Widget build(BuildContext? context) {
    double deviceWidth = MediaQuery.of(context!).size.width;
    int widgetsInRow = 4;
    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 141;



    if (deviceWidth > 1200) {
      widgetsInRow = 8;
      aspectRatio =
      (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 968) {
      widgetsInRow = 6;
      aspectRatio =
      (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 205:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    } else if (deviceWidth > 768) {
      widgetsInRow = 6;
      aspectRatio =
      (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 205:
      (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }
    if (widget.homedata.data!.category2Details!.length > 0) {
      _categoryTwo = true;
    } else {
      _categoryTwo = false;
    }

       /* return StreamBuilder(
      stream: bloc.categoryTwo,
      builder: (context, AsyncSnapshot<List<CategoriesModel>> snapshot) {*/
        if (Features.isCategoryTwo&&_categoryTwo) {
          return Container(
      //  padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                widget.homedata.data!.categoryTwoLabel!,
                style: TextStyle(
                    fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                    fontWeight: FontWeight.w900,
                  color:  (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?
                  ColorCodes.blackColor:Theme
                      .of(context)
                      .primaryColor,),
              ),
            ),

            GridView.builder(
                shrinkWrap: true,
                controller: new ScrollController(keepScrollOffset: false),
                // padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                itemCount: widget.homedata.data!.category2Details!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widgetsInRow,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemBuilder: (BuildContext ctx, i) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        /*Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                          'maincategory': widget.homedata.data!.category2Details![i].categoryName,
                          'catId': widget.homedata.data!.category2Details![i].parentId,
                          'catTitle': widget.homedata.data!.category2Details![i].categoryName,
                          'subcatId': widget.homedata.data!.category2Details![i].id,
                          'indexvalue': i.toString(),
                          'prev': "category_item"});*/
                        print("${{
                          'maincategory': widget.homedata.data!.category2Details![i].categoryName!,
                          'catId': widget.homedata.data!.category2Details![i].parentId!,
                          'catTitle': widget.homedata.data!.category2Details![i].categoryName!,
                          'subcatId': widget.homedata.data!.category2Details![i].id!,
                          'indexvalue': i.toString(),
                          'prev': "category_item"
                        }}");
                        Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              'maincategory': widget.homedata.data!.category2Details![i].categoryName!,
                              'catId': widget.homedata.data!.category2Details![i].parentId!,
                              'catTitle': widget.homedata.data!.category2Details![i].categoryName!,
                              'subcatId': widget.homedata.data!.category2Details![i].id!,
                              'indexvalue': i.toString(),
                              'prev': "category_item"
                            });
                      },
                      child:  SizedBox(
                        width: ResponsiveLayout.isSmallScreen(context)?100:110,
                        child: Card(
                          color: /*snapshot.data[i].featuredCategoryBColor*/Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                         // margin: EdgeInsets.all(5),
                          child:
                          Container(
                            padding: EdgeInsets.only(right:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                ?10:0),
                           // padding: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))? EdgeInsets.only(left: 20,right: 20):null,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (MediaQuery.of(context).size.width <= 600) ?
                                CachedNetworkImage(
                                  imageUrl: widget.homedata.data!.category2Details![i].iconImage,
                                  placeholder: (context, url) =>    Shimmer.fromColors(
                                      baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
                                      highlightColor: /*Color(0xffeeeeee)*/ColorCodes.shimmerColor,
                                      child: Image.asset(Images.defaultCategoryImg)),
                                  errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                  height: 100,
                                  width:100,
                                  //fit: BoxFit.fill,
                                ):
                                CachedNetworkImage(
                                  imageUrl: widget.homedata.data!.category2Details![i].iconImage,
                                  errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                                  //placeholder: (context, url) => Image.asset(Images.defaultCategoryImg),
                                  height: ResponsiveLayout.isSmallScreen(context)?100:130,
                                  width: ResponsiveLayout.isSmallScreen(context)?100:150,
                                  fit:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                      ? BoxFit.fill:null,
                                ) ,
                                SizedBox(
                                  height: 5.0,
                                ),
                                // Spacer(),
                        Container(height: 40,
                           // padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
                            child: Center(
                              child:
                                Text(widget.homedata.data!.category2Details![i].categoryName!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveLayout.isSmallScreen(context)?12.0:16.0)
                                ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      );

          /*if(snapshot.data.isEmpty) return SizedBox.shrink();
          else if(_isWeb) return Container(
            padding:EdgeInsets.only(left: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?18:0),
            child: child() );
          return child();*/

        }/* else if (snapshot.hasError) {
          return Text(S .of(context).snap_error + snapshot.error.toString());
        }else if(!snapshot.hasData){

        }*/else
        return /*_horizontalshimmerslider()*/SizedBox.shrink();
     /* },
    );*/

/*    return _isLoading ? SizedBox.shrink()
        :
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0, top: 12),
          child: Text(
            _label,
            style: TextStyle(
                fontSize: ResponsiveLayout.isSmallScreen(context)?18.0:24.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),

        itemsInCategoryTwo(),

      ],
    );*/
  }
}

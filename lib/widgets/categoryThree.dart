import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../models/newmodle/home_page_modle.dart';

import '../constants/IConstants.dart';

import 'package:shimmer/shimmer.dart';
import '../blocs/sliderbannerBloc.dart';
import '../models/categoriesModel.dart';
import 'package:provider/provider.dart';
import '../providers/featuredCategory.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../assets/images.dart';
import '../screens/items_screen.dart';

class   CategoryThree extends StatefulWidget {
  HomePageData homedata;
  CategoryThree(this.homedata);


  @override
  _CategoryThreeState createState() => _CategoryThreeState();
}

class _CategoryThreeState extends State<CategoryThree> with Navigations{
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
    // bloc.fetchCategoryThree();
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
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final subcategoryData = Provider.of<FeaturedCategoryList>(context,listen: false);

  /*  return StreamBuilder(
        stream: bloc.category,
        builder: (context, AsyncSnapshot<List<CategoriesModel>>snapshot) {*/
          if (widget.homedata.data!.category3Details!.length > 0) {
            double deviceWidth = MediaQuery.of(context).size.width;
            int widgetsInRow = 4;
            double aspectRatio =
                (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 131;



            if (deviceWidth > 1200) {
              widgetsInRow = 8;
              aspectRatio =
              (_isWeb && !ResponsiveLayout.isSmallScreen(context))?
              (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 190:
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
              return Container(
                  padding:EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?0:10,right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                       padding:EdgeInsets.only(bottom: 5),
                      //  padding: EdgeInsets.only(top: 15.0, bottom: 10.0,left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0,right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
                        child: Text(
                          widget.homedata.data!.categoryThreeLabel!,
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
                          itemCount: widget.homedata.data!.category3Details!.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widgetsInRow,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemBuilder: (_, i) {
                          //  if(snapshot.hasData)
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                    onTap: () =>
                                       /* Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
                                          'maincategory': widget.homedata.data!.category3Details![i].categoryName,
                                          'catId': widget.homedata.data!.category3Details![i].parentId,
                                          'catTitle': widget.homedata.data!.category3Details![i].categoryName,
                                          'subcatId': widget.homedata.data!.category3Details![i].id,
                                          'indexvalue': i.toString(),
                                          'prev': "category_item"
                                        }),*/
                                    Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                                        qparms: {
                                          'maincategory': widget.homedata.data!.category3Details![i].categoryName,
                                          'catId':  widget.homedata.data!.category3Details![i].parentId,
                                          'catTitle': widget.homedata.data!.category3Details![i].categoryName,
                                          'indexvalue': i.toString(),
                                          'subcatId':  widget.homedata.data!.category3Details![i].id,
                                          'prev': "category_item"
                                        }),
                                    child: SizedBox(
                                      width: ResponsiveLayout.isSmallScreen(context)?100:110,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        elevation: 0,
                                      //  margin: EdgeInsets.all(5),
                                        color: /*snapshot.data[i].featuredCategoryBColor*/Colors.white,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(right:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                                    ?10:0),
                                               /* padding:  EdgeInsets.only(
                                                    left: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?20: 5, top: 5.0, right: (_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20: 5.0, bottom: 5.0),*/
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight: Radius.circular(15),
                                                        bottomLeft: Radius.circular(15),
                                                        bottomRight: Radius.circular(15)
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:widget.homedata.data!.category3Details![i].iconImage,
                                                      placeholder: (context, url) =>    Shimmer.fromColors(
                                                          baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
                                                          highlightColor: /*Color(0xffeeeeee)*/ColorCodes.shimmerColor,
                                                          child: Image.asset(Images.defaultCategoryImg)),
                                                      errorWidget: (context, url, error) => Image.asset(
                                                        Images.defaultCategoryImg,
                                                        width: ResponsiveLayout.isSmallScreen(context) ? 100 :  100,
                                                        height: ResponsiveLayout.isSmallScreen(context) ? 100 : 150,
                                                      ),
                                                      height: ResponsiveLayout.isSmallScreen(context)?90:130,
                                                      width: ResponsiveLayout.isSmallScreen(context)?100:150,
                                                      fit:(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                                                          ? BoxFit.fill:null,
                                                    )),
                                              ),
                                              // Spacer(),
                                            //  SizedBox(height: 5,),
                                              Container(height: 40,
                                                //padding: EdgeInsets.only(left:(_isWeb&& !ResponsiveLayout.isSmallScreen(context))?20:0 ),
                                                child: Center(
                                                  child: Text(widget.homedata.data!.category3Details![i].categoryName!,
                                                      textAlign: TextAlign.center,
                                                      overflow:  TextOverflow.fade,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: ResponsiveLayout.isSmallScreen(context)?12.0:16.0)),
                                                ),
                                              ),
                                              //SizedBox(height: 5),
                                            ],
                                          ),
                                        ),

                                      ),
                                    )


                                ),
                              );
                           /* else{
                              return SizedBox.shrink();
                            }*/
                          }

                      ),
                    ],
                  ));
          } else{
            return /*_horizontalshimmerslider()*/SizedBox.shrink();
          }
    //     }
    // );
  }
}
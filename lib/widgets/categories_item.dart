import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/IConstants.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import 'package:provider/provider.dart';

import '../providers/notificationitems.dart';
import '../screens/items_screen.dart';
import '../models/categoriesfields.dart';
import '../screens/subcategory_screen.dart';
import '../assets/images.dart';

class CategoriesItem extends StatelessWidget with Navigations{
  final String previousScreen;
  final String maincategory;
  final String mainCategoryId;
  final String subCatId;
  final String subCatTitle;
  final int indexvalue;
  final String imageUrl;

  CategoriesItem(this.previousScreen, this.maincategory, this.mainCategoryId,
      this.subCatId, this.subCatTitle, this.indexvalue, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    var categoriesData;
    bool _isNotSubCategory = false;
    bool _isSubCategory = false;

    if (previousScreen == "NotSubcategoryScreen") {
      categoriesData = Provider.of<NotificationItemsList>(context, listen: false);
      _isNotSubCategory = true;
    } else {
      categoriesData = Provider.of<CategoriesFields>(context, listen: false);
      _isNotSubCategory = false;
    }

    if (previousScreen == "SubcategoryScreen") {
      _isSubCategory = true;
    } else {
      _isSubCategory = false;
    }

    return (IConstants.isEnterprise)? MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {

          if (previousScreen == "SubcategoryScreen") {
            /*Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
              'maincategory': maincategory,
              *//*'catId' : categoriesData.catid.toString(),
              'catTitle': categoriesData.title.toString(),
              'subcatId' : categoriesData.subcatid.toString(),*//*
              'catId': mainCategoryId,
              'catTitle': subCatTitle,
              'subcatId': subCatId,
              'indexvalue': (indexvalue).toString(),
              'prev': "category_item"
            });*/
            print("index value...."+indexvalue.toString());
            Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                qparms: {
                'maincategory': maincategory,
                'catTitle': categoriesData.title.toString(),
                'subcatId' : categoriesData.subcatid.toString(),
                'catId': mainCategoryId,
                'catTitle': subCatTitle,
                'subcatId': subCatId,
                'indexvalue': (indexvalue).toString(),
                'prev': "category_item"
                });
          } else if (previousScreen == "NotSubcategoryScreen") {
           /* Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
              'maincategory': maincategory,
              'catId': categoriesData.catitems[indexvalue].catid.toString(),
              'catTitle': categoriesData.catitems[indexvalue].title.toString(),
              'subcatId': categoriesData.catitems[indexvalue].subcatid.toString(),
              'indexvalue': (indexvalue).toString(),
              'prev': "category_item"
            });*/
            print("index value...."+indexvalue.toString());
            /*Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                parms: {
                  'maincategory': maincategory,
                  'catId': categoriesData.catitems![indexvalue].catid.toString(),
                  'catTitle': categoriesData.catitems[indexvalue].title.toString(),
                  'subcatId': categoriesData.catitems[indexvalue].subcatid.toString(),
                  'indexvalue': (indexvalue).toString(),
                  'prev': "category_item"
                });*/

            Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
                qparms: {
                  'maincategory': maincategory,
                  'catTitle': categoriesData.catitems[indexvalue].title.toString(),
                  'subcatId' : categoriesData.catitems![indexvalue].catid.toString(),
                  'catId':  categoriesData.catitems![indexvalue].catid.toString(),
                  'indexvalue': (indexvalue).toString(),
                  'prev': "category_item"
                });
          } else {
           /* Navigator.of(context)
                .pushNamed(SubcategoryScreen.routeName, arguments: {
              'catId': categoriesData.catid.toString(),
              'catTitle': categoriesData.title.toString(),
            });*/
            Navigation(context, name:Routename.SubcategoryScreen,navigatore: NavigatoreTyp.Push,
                parms:{
                  'catId': categoriesData.catid.toString(),
                  'catTitle': categoriesData.title.toString(),
            });

            //  Navigator.of(context).pushNamed(
            //   SubcategoryScreen.routeName,
            //  );
          }
        },
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              //padding: ResponsiveLayout.isLargeScreen(context)?const EdgeInsets.only(left: 5.0, top: 30.0, right: 5.0,bottom: 5.0):const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0,bottom: 5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: _isNotSubCategory
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Image.asset(Images.defaultCategoryImg),
                    errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                    height: ResponsiveLayout.isSmallScreen(context)?75:120,
                    width: ResponsiveLayout.isSmallScreen(context)?80:145,
                   // fit: BoxFit.fill,
                  )
                      : _isSubCategory
                      ?
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Image.asset(Images.defaultCategoryImg),
                    errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                    height:ResponsiveLayout.isSmallScreen(context)? 75:110,
                    width:ResponsiveLayout.isSmallScreen(context)? 80:140,
                    //fit: BoxFit.fill,
                  )
                      :
                  CachedNetworkImage(
                    imageUrl: categoriesData.imageUrl,
                    placeholder: (context, url) => Image.asset(Images.defaultCategoryImg),
                    errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                    height:ResponsiveLayout.isSmallScreen(context)? 75:110,
                    width:ResponsiveLayout.isSmallScreen(context)? 80:140,
                   // fit: BoxFit.fill,
                  )),
            ),
            SizedBox(
              height: 5,
            ),

            Flexible(
              child: Center(
                  child: _isNotSubCategory
                      ? Text(categoriesData.catitems[indexvalue].title,
                      textAlign: TextAlign.center,
                     // maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: ResponsiveLayout.isSmallScreen(context)?12:15))
                      : _isSubCategory
                      ? Text(subCatTitle,
                      textAlign: TextAlign.center,
                    //  maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveLayout.isSmallScreen(context)?12:15))
                      : Text(categoriesData.title,
                      textAlign: TextAlign.center,
                     // maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize:ResponsiveLayout.isSmallScreen(context)?12:15))),
            ),
          ],
        ),
      ),
    )
        :GestureDetector(
      onTap: () {
        if (previousScreen == "SubcategoryScreen") {
         /* Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
            'maincategory': maincategory,
            *//*'catId' : categoriesData.catid.toString(),
            'catTitle': categoriesData.title.toString(),
            'subcatId' : categoriesData.subcatid.toString(),*//*
            'catId': mainCategoryId,
            'catTitle': subCatTitle,
            'subcatId': subCatId,
            'indexvalue': indexvalue.toString(),
            'prev': "category_item"
          });*/
          print("index value...."+indexvalue.toString());

          Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
              qparms: {
              'maincategory': maincategory,
              'catTitle': categoriesData.title.toString(),
              'subcatId' : categoriesData.subcatid.toString(),
              'catId': mainCategoryId,
              'catTitle': subCatTitle,
              'subcatId': subCatId,
              'indexvalue': indexvalue.toString(),
              'prev': "category_item"
              });
        } else if (previousScreen == "NotSubcategoryScreen") {
          /*Navigator.of(context).pushNamed(ItemsScreen.routeName, arguments: {
            'maincategory': maincategory,
            'catId': categoriesData.catitems[indexvalue].catid.toString(),
            'catTitle': categoriesData.catitems[indexvalue].title.toString(),
            'subcatId': categoriesData.catitems[indexvalue].subcatid.toString(),
            'indexvalue': indexvalue.toString(),
            'prev': "category_item"
          });*/
          print("index value...."+indexvalue.toString());
          /*Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push, qparms: {
                'maincategory': maincategory,
                'catId': categoriesData.catitems[indexvalue].catid.toString(),
                'catTitle': categoriesData.catitems[indexvalue].title.toString(),
                'subcatId': categoriesData.catitems[indexvalue].subcatid.toString(),
                'indexvalue': indexvalue.toString(),
                'prev': "category_item"
              });*/
          Navigation(context, name: Routename.ItemScreen, navigatore: NavigatoreTyp.Push,
              qparms: {
                'maincategory': maincategory,
                'catTitle': categoriesData.catitems[indexvalue].title.toString(),
                'subcatId' : categoriesData.catitems![indexvalue].catid.toString(),
                'catId':  categoriesData.catitems![indexvalue].catid.toString(),
                'indexvalue': (indexvalue).toString(),
                'prev': "category_item"
              });
        } else {
        /*  Navigator.of(context)
              .pushNamed(SubcategoryScreen.routeName, arguments: {
            'catId': categoriesData.catid.toString(),
            'catTitle': categoriesData.title.toString(),
          });*/
          Navigation(context, name:Routename.SubcategoryScreen,navigatore: NavigatoreTyp.Push,
              parms:{
                'catId': categoriesData.catid.toString(),
                'catTitle': categoriesData.title.toString(),
              });
          //  Navigator.of(context).pushNamed(
          //   SubcategoryScreen.routeName,
          //  );
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                ),
                child: _isNotSubCategory
                    ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultCategoryImg),
                  errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                  height: 90,
                  width: 85,
                )
                    : _isSubCategory
                    ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultCategoryImg),
                  errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                  height: 90,
                  width: 85,
                )
                    : CachedNetworkImage(
                  imageUrl: categoriesData.imageUrl,
                  placeholder: (context, url) =>
                      Image.asset(Images.defaultCategoryImg),
                  errorWidget: (context, url, error) => Image.asset(Images.defaultCategoryImg),
                  height: 90,
                  width: 85,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Container(height: 30,
            padding: EdgeInsets.only(left:(Vx.isWeb&& !ResponsiveLayout.isSmallScreen(context))?12:10 ),
            child: Center(
                child: _isNotSubCategory
                    ? Text(categoriesData.catitems[indexvalue].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.0))
                    : _isSubCategory
                    ? Text(subCatTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.0))
                    : Text(categoriesData.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.0))
            ),
          ),
        ],
      ),
    );
  }
}
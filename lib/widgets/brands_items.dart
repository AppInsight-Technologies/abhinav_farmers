import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/models/newmodle/home_page_modle.dart';
import 'package:grocbay/rought_genrator.dart';

import '../screens/brands_screen.dart';
import '../assets/images.dart';


class BrandsItems extends StatelessWidget  with Navigations{

  AllBrands allBrand;
  final int indexvalue;

  BrandsItems(this.allBrand, this.indexvalue);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigation(context,name: Routename.BrandsScreen,navigatore: NavigatoreTyp.Push,qparms: {
              'brandId' : allBrand.id,
              'indexvalue' : indexvalue.toString(),
            });
            // Navigator.of(context).pushNamed(
            //     BrandsScreen.routeName,
            //     arguments: {
            //       'brandId' : allBrand.id,
            //       'indexvalue' : indexvalue.toString(),
            //     }
            // );
          },
          child: Column(
              children: <Widget>[
              Spacer(),
              Container(
                padding: EdgeInsets.all(5.0),
                width: 80.0,
                height: 50.0,
                margin: EdgeInsets.only(right: 5.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
                  border: new Border.all(
                    color: Colors.grey.shade300,
                    //width: 4.0,
                  ),
                ),
                child: CachedNetworkImage(imageUrl: allBrand.iconImage, width: 150.0, height: 50.0, fit:BoxFit.fitWidth, errorWidget: (context, url, error) => Image.asset(Images.defaultBrandImg, width: 80.0, height: 80.0, fit:BoxFit.fitWidth,), placeholder: (context, url) => Image.asset(Images.defaultBrandImg, width: 80.0, height: 80.0, fit:BoxFit.fitWidth,
                  ),),),
              Spacer(),
            ],
          ),
        ),
      )
    //),
    );
  }
}
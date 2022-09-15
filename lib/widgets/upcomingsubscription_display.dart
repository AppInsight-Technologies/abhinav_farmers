import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/models/newmodle/subscription_data.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/features.dart';
import '../generated/l10n.dart';
import '../models/myordersfields.dart';
import '../models/newmodle/upcomingsubscription.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';


extension StringCasingExtension on String {
  String toCapitalized() => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get toTitleCase => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.toCapitalized()).join(" ");
}

class UpcomingSubscriptionDisplay extends StatefulWidget {
  String itemname = "";
  String itemimage = "";
  String quantity = "";
  String unit = "";

  UpcomingSubscriptionDisplay(
      this.itemname,
      this.itemimage,
      this.quantity,
      this.unit
      );

  @override
  State<UpcomingSubscriptionDisplay> createState() => _UpcomingSubscriptionDisplayState();
}

class _UpcomingSubscriptionDisplayState extends State<UpcomingSubscriptionDisplay> with Navigations{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: new BoxDecoration(
              color: ColorCodes.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.all(const Radius.circular(3.0),)),
          margin: EdgeInsets.only(left: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:5,right: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?0:5,top: (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))?20:10),

          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 8.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.itemimage,
                      errorWidget: (context, url, error) => Image.asset(
                        Images.defaultProductImg,
                        width: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 70 : 70,
                        height: ResponsiveLayout.isSmallScreen(context) ? 50 : ResponsiveLayout.isMediumScreen(context) ? 60 : 60,
                      ),
                      placeholder: (context, url) => Image.asset(
                        Images.defaultProductImg,
                        width: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 70 : 70,
                        height: ResponsiveLayout.isSmallScreen(context) ? 50 : ResponsiveLayout.isMediumScreen(context) ? 60 : 60,
                      ),
                      width: ResponsiveLayout.isSmallScreen(context) ? 70 : ResponsiveLayout.isMediumScreen(context) ? 70 : 70,
                      height: ResponsiveLayout.isSmallScreen(context) ? 50 : ResponsiveLayout.isMediumScreen(context) ? 60 : 60,
                      //  fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.itemname,
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: ColorCodes.blackColor,
                      fontSize: 15),),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.quantity + " " + widget.unit,
                              style: TextStyle(fontWeight: FontWeight.w600,
                                  color: ColorCodes.blackColor,
                                  fontSize: 12),),
                            Spacer(),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Text(/*"View All"*/S.of(context).edit_address, style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                              color: ColorCodes.primaryColor),),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: ColorCodes.primaryColor,),
                          ],
                        ),
                      ),
                    ],
                  )
                ],),
            ],
          ),
        )

      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grocbay/constants/features.dart';
import '../constants/IConstants.dart';

class ColorCodes {
  static Color redColor = Color(0xffC70909);
  static Color banner = Color(0xFFFF7700);
  static Color backbutton = Color(0xFF2C2C2C);
  static Color lightred = Color(0xFFF44336);
  static Color orangeColor = Color(0xffFF9913);
  static Color greenColor = Color(0xff39827E);//Color(0xff32B847);
  static Color cartgreenColor = Color(0xff39827E);//Color(0xff1BA130);
  static Color checkmarginColor = Color(0xff39827E);//Color(0xff6CBB3C);
  static Color blackColor = Color(0xff000000);
  static Color lightBlack = Color(0xFF1D1D1D);
  static Color mediumBlackColor = Color(0xff2C2C2C);
  static Color mediumBlackWebColor = Color(0xff404040);
  static Color borderColor = Color(0xff4B4B4B);
  static Color borderdarkColor = Color(0xff585858);
  static Color emailColor = Color(0xFF929292);
  static Color borderdark = Color(0xFF6D6D6D);
  static Color darkGrey = Color(0xff535353);
  static Color greyColor = Color(0xff707070);
  static Color greyColord = Color(0xfff2f4f5);
  static Color grey = Color(0xffb1b1b1);
  static Color greylight = Color(0xFFBDBDBD);
  static Color greydark = Color(0xFFBD);
  static Color lightgrey = Color(0xffBFBFBF);
  static Color lightGreyColor = Color(0xffD4D4D4);
  static Color lightGreyWebColor = Color(0xffEEEEEE);
  static Color appdrawerColor = Color(0xffeff3f6);
  static Color itembackgroundColor =Color(0xFFEDF2F5);
  static Color darkthemeColor = Color(0xff213b77);
  static Color maphome = IConstants.isEnterprise?Color(0xff114475):Color(0xff114475); // Button color for addtocart buttons and all
  static Color indigo = Colors.indigo;
  static Color lightblue = Color(0xff38559E);
  static Color darkblue = Color(0xff012961);
  static Color mediumBlueColor = Color(0xff2966A2);
  static Color lightBlueColor = IConstants.isEnterprise?Color(0xffCAE5FC):Color(0xffCAE5FC); //bottomnavigation color change
  static Color lightskybluecolor = Color(0xFFC2E7F9);

  static Color lightColor = Color(0xffebf4ff);
  static Color fill = Color(0xffebf5ff);
  static Color whiteColor = Color(0xffffffff);
  static Color skygrey = Color(0xffCCCCCC);
  static Color searchwebColor= Color(0xffE9EBEC);
  static Color searchwebbackground= Color(0xffF5F5F5);
  static Color baseColor= Color(0xffd3d3d3);
  static Color baseColordark= Color(0x707070B8);
  static Color lightsteelblue	=Color(0xffF3F3F3);

  static Color baseColorlight= Color(0xffe8e8e8);

  static Color subscribeColor= Color(0xFFFFDBE9);
  static Color membershipColor= Color(0xffefef47);


  static Color slotTab = Color(0xFFF3F9FF);
  static Color backgroundcolor=Color(0xffF8F8F8);
  static Color darkestgreen = Color(0xff035733);
  static Color darkgreen = Color(0xff39827E);//Color(0xff32B847);
  static Color discount = Color(0xff32B847);
  static Color cyanColor = Color(0xffB9FFC4);
  static Color cyanlightColor = Color(0xFFA2E6BE);
  static Color cyanlight = Color(0xFFD0F0DE);
  static Color starColor = Color(0xffFF9400);
  static Color yellowColor = Color(0xffF2BF40);
  static Color beige = Color(0xffFCFCD5);
  static Color ratestarcolor = Color(0xffF5CF3C);
  static Color lightgreen = Color(0xffBBF3C4);
  static Color mediumgren = Color(0xffE4FBE8);
  static Color ordergreen = Color(0xff86E895);
  static Color discountbadgeBackgroundcolor = Color(0xffECF6FF);
  static Color locationColor=Color(0xff2C2C2C);
  static Color secondaryColor=Color(0xffcfd9e3);
  static Color mybasket= Color(0xffEBFBED);
  static Color footertext= Color(0xff5983F9);
  static Color footertitle= Color(0xff7D7D7D);

  static Color mainheaderColor1 = IConstants.isEnterprise ? Color(0xff009832) : Colors.white;
  static Color mainheaderColor2 = IConstants.isEnterprise ? Color(0xff009832) : Colors.white;
  static Color headerIconColor = IConstants.isEnterprise && !Features.ismultivendor?IConstants.isEnterprise && !Features.isWebTrail ? Colors.white : ColorCodes.greenColor:ColorCodes.blackColor;

  static Color primaryColor = IConstants.isEnterprise ? Color(0xff009832) : Colors.white;
  static Color accentColor = IConstants.isEnterprise ? Color(0xff009832) : Colors.white;
  static Color searchText = IConstants.isEnterprise ? Color(0xff5E9CC7) : blackColor;
  static Color searchIcon = IConstants.isEnterprise ? whiteColor :  blackColor;
  static Color menuColor = IConstants.isEnterprise ? blackColor : blackColor;
  static Color searchColor = IConstants.isEnterprise ? accentColor : whiteColor;
  static Color searchBoarder = IConstants.isEnterprise ? accentColor : blackColor;
  static Color deliveryLocation = IConstants.isEnterprise ? primaryColor : lightBlack;
  static Color appbarColor = IConstants.isEnterprise && !Features.ismultivendor?IConstants.isEnterprise && !Features.isWebTrail? ColorCodes.whiteColor : Colors.white:Colors.white;
  static Color appbarColor2 = IConstants.isEnterprise && !Features.ismultivendor?IConstants.isEnterprise && !Features.isWebTrail? ColorCodes.whiteColor : Colors.white:Colors.white;
  static Color iconColor = IConstants.isEnterprise && !Features.ismultivendor?IConstants.isEnterprise && !Features.isWebTrail? ColorCodes.menuColor:ColorCodes.blackColor:ColorCodes.blackColor;

  static Color signincolor=Color(0xFF3D3D3D);
  static Color supportbg = Color(0XFFF1F1F1);
  static Color varcolor =Color(0xFFE5F3F2);
  static Color varcolorlight =Color(0xffdbdbdb);

  static Color otptextcolor =Color(0xd2000631);
  static Color shimmercolor =Color(0xFFCFCFCF);
  static Color lightblack =Color(0xFF404040);
  static Color black =Color(0xFF070707);
  static Color darkgrey =Color(0xff808080);
  static Color lightblack1 =Color(0xff3B3B3B);
  static Color stepperColor = Color(0xff39827E);//Color(0xff32B847);
  static Color promocolor =Color(0xFFFFE3A4);
  static Color discountoff =Color(0xff722267);
  static Color badgecolor =Color(0xffEC7345);
  static Color light_red = Color(0xffFFE4E4);
  static Color redcolor = Color(0xffFF3B3B);
  static Color shimmerColor = Color(0xffF8F8F8);
  static Color headersearch = Color(0xffF3F4F7);
  static Color footerColor = Color(0xffF8F9FB);

  //Change color here for lite add primary color of color code
  static Color liteColor = Color(0xff39827E);
}

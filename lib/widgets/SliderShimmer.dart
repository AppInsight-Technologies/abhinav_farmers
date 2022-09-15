
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class SliderShimmer{
  bool isweb = true;


  sliderShimmer(BuildContext context,{required double height}) {

    return Vx.isWeb ?
    SizedBox.shrink()
        :
    Shimmer.fromColors(
        baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
        highlightColor: ColorCodes.shimmerColor,
        child:Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            height: height,
              width: MediaQuery.of(context).size.width - 20.0,
          color: Colors.white,
        ));
  }
}
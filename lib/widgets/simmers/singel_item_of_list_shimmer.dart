import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';

class SingelItemOfList extends StatelessWidget {
  const SingelItemOfList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,
      child: Column(children: [

        Icon(Icons.image,size: 60,),
        Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 80, height: 8, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
          SizedBox(height: 10,),
        Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 40, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(12.0), child: Container( height: 30, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(12.0), child: Container( height: 35, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(12.0), child: Container( height: 20, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),

      ],),
    );
  }
}

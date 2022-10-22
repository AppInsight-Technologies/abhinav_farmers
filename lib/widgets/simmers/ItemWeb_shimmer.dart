import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:shimmer/shimmer.dart';

class ItemListShimmerWeb extends StatelessWidget {
  const ItemListShimmerWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isWeb = true;



    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    int widgetsInRow = (_isWeb &&
        !ResponsiveLayout.isSmallScreen(context)) ? 1 : 5;
    if (deviceWidth > 1200) {
      widgetsInRow = 5;
    } else if (deviceWidth < 768) {
      widgetsInRow = 1;
    }
    double aspectRatio = (_isWeb &&
        !ResponsiveLayout.isSmallScreen(context)) ?
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
        400:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
        170;
    return  new
    GridView.builder(

      shrinkWrap: true,
      //controller: new ScrollController(keepScrollOffset: false),
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widgetsInRow,
          crossAxisSpacing: 4,
          childAspectRatio: aspectRatio
      ),
      itemCount: 10,

      itemBuilder: (_, i) => Shimmer.fromColors(
      baseColor: /*Color(0xffd3d3d3)*/ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,
    child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(2),
    border: Border.all(color: ColorCodes.shimmercolor),
    ),
    margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5),
      child: Column(children: [
        Icon(Icons.image,size: 60,),
        Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 80, height: 8, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
        SizedBox(height: 10,),
        Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 40, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(12.0), child: Container( height: 30, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(12.0), child: Container( height: 35, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
        Padding(padding: const EdgeInsets.all(12.0), child: Container( height: 20, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),

      ],),
    ),
    ),);
  }
}

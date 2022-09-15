import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';
class CheckOutShimmer extends StatelessWidget {
  const CheckOutShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 110, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 220, height: 8, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 220, height: 8, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 220, height: 8, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
           SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(height: 20,child: Row(children: [
                Icon(Icons.list_alt),
                Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 110, height: 8, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
              ],
              ),),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
           /* Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
               child: Column(
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage(Images.scooterImg),
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Loading..',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Please select a time slot as per your convience. Your order will be delivered during the time slot.',
                    style: TextStyle(
                      fontSize: 11,
                      color: ColorCodes.greyColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20),
                    child: Tab(text: 'SLOT BASED DELIVERY'),
                  ),
                 ],
              ),
            ),*/
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
            Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),

          ],
        ),
    ),
    );
  }
}

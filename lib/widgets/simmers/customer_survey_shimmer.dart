import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';
class CustomerSurveyShimmer extends StatelessWidget {
  const CustomerSurveyShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:30,),
            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 110, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
           SizedBox(height: 10,),
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      Container(width: MediaQuery.of(context).size.width, height:50, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),
                      SizedBox(height: 10,)
                    ],
                  );
                })

          ],
        ),
      ),
    );
  }
}

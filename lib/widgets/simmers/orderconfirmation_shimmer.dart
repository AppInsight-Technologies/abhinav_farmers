import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../utils/ResponsiveLayout.dart';
import 'package:shimmer/shimmer.dart';

class OrderConfirmationShimmer extends StatelessWidget {
  const OrderConfirmationShimmer({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(child: Column(
      children: [

        SizedBox(
          height: 40.0,
        ),
        /*Padding(
          padding: const EdgeInsets.only(left:20,right: 20,top:8.0,bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),*/
        Container(
            margin: EdgeInsets.symmetric(
                horizontal: 5.0),
            child: ClipRRect(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        5.0)),
                child: Shimmer.fromColors(child: Container(height: 200,child: Icon(Icons.image,size: 200,),),
                  baseColor: ColorCodes.shimmerColor,
                  highlightColor: ColorCodes.shimmerColor,

                ))),
        Padding(
          padding:  const EdgeInsets.only(left:20,right: 20,top:8.0,bottom: 8),
          child: Container(
            width: ResponsiveLayout.isLargeScreen(context)?MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width,
            height: 40,
            decoration: BoxDecoration(
              color: ColorCodes.shimmerColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Padding(
          padding:  const EdgeInsets.only(left:20,right: 20,top:8.0,bottom: 8),
          child: Container(
            width: ResponsiveLayout.isLargeScreen(context)?MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width,
            height: 40,
            decoration: BoxDecoration(
              color: ColorCodes.shimmerColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Padding(
          padding:  const EdgeInsets.only(left:20,right: 20,top:8.0,bottom: 8),
          child: Container(
            width: ResponsiveLayout.isLargeScreen(context)?MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width,
            height: 40,
            decoration: BoxDecoration(
              color: ColorCodes.shimmerColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    ),
      baseColor: ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,);

  }
}


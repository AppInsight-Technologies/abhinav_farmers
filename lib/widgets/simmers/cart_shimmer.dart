import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class CartScreenShimmer extends StatelessWidget {
  const CartScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(child: Column(
      children: [
        Container(
            width:MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 15, bottom: 15),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 7,
                ),
                Text(
                  S .of(context).bill_details,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Spacer(),
             Row(
               children: [
                 Container(
                     height: 15,
                     child: Image.asset(Images.addToListImg)),
                 SizedBox(
                   width: 5,
                 ),
                 Text(
                   S .of(context).add_to_list,
                   style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 13),
                 ),
                 SizedBox(
                   width: 10,
                 ),
               ],
             ),
                SizedBox(
                  width: 13,
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(0.0),
            itemCount: 3,
            itemBuilder: (_, i) => Container(
                margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Shimmer.fromColors(
                  baseColor:ColorCodes.shimmerColor,
                  highlightColor:ColorCodes.shimmerColor,
                  child: Container(
                    height: 100.0,
                    color: Theme.of(context).buttonColor,
                  ),
                )),
          ),
        ),
        new ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(0.0),
          itemCount: 2,
          itemBuilder: (_, i) => Container(
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Shimmer.fromColors(
                baseColor: ColorCodes.shimmerColor,
                highlightColor: ColorCodes.shimmerColor,
                child: Container(
                  height: 30.0,
                  color: Theme.of(context).buttonColor,
                ),
              )),
        ),
        new ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(0.0),
          itemCount: 2,
          itemBuilder: (_, i) => Container(
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Shimmer.fromColors(
                baseColor: ColorCodes.shimmerColor,
                highlightColor: ColorCodes.shimmerColor,
                child: Container(
                  height: 110.0,
                  color: Theme.of(context).buttonColor,
                ),
              )),
        )
      ],
    ),
      baseColor: ColorCodes.baseColor,
      highlightColor: ColorCodes.lightGreyWebColor,);
  }
}

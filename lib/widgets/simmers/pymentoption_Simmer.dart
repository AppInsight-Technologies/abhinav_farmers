import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:shimmer/shimmer.dart';

class PaymnetOption extends StatelessWidget {
  const PaymnetOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorCodes.shimmerColor,
      highlightColor: ColorCodes.lightGreyWebColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   margin: EdgeInsets.only(bottom: 16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Text(
          //         "Amount Payable",
          //         style: TextStyle(
          //             fontSize: 15.0,
          //             color: ColorCodes.blackColor,
          //             fontWeight: FontWeight.bold),
          //       ),
          //       Text(
          //         "(Incl. of all taxes)",
          //         style: TextStyle(
          //             fontSize: 10.0, color: ColorCodes.blackColor),
          //       ),
          //     ],
          //   ),
          // ),
          // IntrinsicHeight(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Your cart value",
          //             style: TextStyle(
          //                 fontSize: 12.0,
          //                 color: ColorCodes.mediumBlackColor),
          //           ),
          //           SizedBox(
          //             height: 10.0,
          //           ),
          //
          //             Text(
          //               "Delivery charges",
          //               style: TextStyle(
          //                   fontSize: 12.0,
          //                   color: ColorCodes.mediumBlackColor),
          //             ),
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //             Text(
          //               "Discount applied:",
          //               style: TextStyle(
          //                   fontSize: 12.0,
          //                   color: ColorCodes.mediumBlackColor),
          //             ),
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //             new RichText(
          //               text: new TextSpan(
          //                 style: TextStyle(
          //                     fontSize: 12.0,
          //                     color: ColorCodes.mediumBlackColor),
          //                 children: <TextSpan>[
          //                   new TextSpan(text: 'Promo ('),
          //                   new TextSpan(
          //                     text: "Loading...",
          //                     style: TextStyle(
          //                         fontSize: 12.0,
          //                         color: ColorCodes.orangeColor),
          //                   ),
          //                   new TextSpan(text: ')'),
          //                 ],
          //               ),
          //             ),
          //
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //             new RichText(
          //               text: new TextSpan(
          //                 style: TextStyle(
          //                     fontSize: 12.0,
          //                     color: ColorCodes.mediumBlackColor),
          //                 children: <TextSpan>[
          //                   new TextSpan(text: 'You saved ('),
          //                   new TextSpan(
          //                     text: 'Coins',
          //                     style: TextStyle(
          //                         fontSize: 12.0,
          //                         color: ColorCodes.orangeColor),
          //                   ),
          //                   new TextSpan(text: ')'),
          //                 ],
          //               ),
          //             ),
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //           Text(
          //             "Amount payable:",
          //             style: TextStyle(
          //                 fontSize: 12.0,
          //                 color: ColorCodes.mediumBlackColor),
          //           ),
          //         ],
          //       ),
          //       Container(
          //           child: VerticalDivider(
          //               color: ColorCodes.dividerColor)),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Text(
          //             "Loading...",
          //             style: TextStyle(
          //                 fontSize: 12.0,
          //                 color: ColorCodes.mediumBlackColor),
          //           ),
          //           SizedBox(
          //             height: 10.0,
          //           ),
          //             Text(
          //               "loading..",
          //               style: TextStyle(
          //                   fontSize: 12.0, color: ColorCodes.redColor),
          //             ),
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //             Text(
          //               "- " ,
          //               style: TextStyle(
          //                   fontSize: 12.0,
          //                   color: ColorCodes.mediumBlackColor),
          //             ),
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //             Text(
          //               "- " +
          //                  "Loading..",
          //               style: TextStyle(
          //                   fontSize: 10.0,
          //                   color: ColorCodes.greenColor),
          //             ),
          //
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //
          //             Text(
          //               "- " +
          //                  "Loading..",
          //               style: TextStyle(
          //                   fontSize: 12.0,
          //                   color: ColorCodes.greenColor),
          //             ),
          //
          //             SizedBox(
          //               height: 10.0,
          //             ),
          //           Text(
          //           "Loading...",
          //             style: TextStyle(
          //                 fontSize: 12.0,
          //                 fontWeight: FontWeight.bold,
          //                 color: ColorCodes.mediumBlackColor),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 10.0,
          // ),
          // Divider(
          //   color: ColorCodes.dividerColor,
          //   thickness: 0.8,
          // ),
          Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 100, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
          Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 100, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
          Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 100, decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),),),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
              ],
            ),),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
              ],
            ),),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
              ],
            ),),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
              ],
            ),),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
              ],
            ),),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(color: ColorCodes.shimmerColor, ),
                ),
              ],
            ),),
          // Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: Colors.black, ),),),
          // Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: Colors.black, ),),),
          // Padding(padding: const EdgeInsets.all(8.0), child: Container( height: 80, decoration: BoxDecoration(color: Colors.black, ),),),


        ],
      ),
    );
  }
}

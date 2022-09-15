import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import '../../generated/l10n.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

class SingelItemShimmer extends StatelessWidget {
  const SingelItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,
      child: Column(
        children: [
          Divider(),
          SizedBox(
            height: 60,
            child:  ScrollablePositionedList.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2.0,
                            ),
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(  S .of(context).item,
                              //"item",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              child:
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      child:  ScrollablePositionedList.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (_, i) => Column(
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2.0,
                                      ),
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(S .of(context).item,
                                      //  "item",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: ColorCodes.shimmerColor,
                      highlightColor: ColorCodes.shimmerColor,
                      child: Column(
                        children: [
                          new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(0.0),
                            itemCount: 6,
                            itemBuilder: (_, i) => Container(
                                margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Shimmer.fromColors(
                                  baseColor: ColorCodes.shimmerColor,
                                  highlightColor: ColorCodes.shimmerColor,
                                  child: Container(
                                    height: 90.0,
                                    color: Theme.of(context).buttonColor,
                                  ),
                                )),
                          ),
                        ],

                      ),
                    )
                  ],
                ),
              )

          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:grocbay/utils/ResponsiveLayout.dart';
import 'package:shimmer/shimmer.dart';

class ItemListShimmer extends StatelessWidget {
  const ItemListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  new
    ListView.builder(

      shrinkWrap: true,
      //controller: new ScrollController(keepScrollOffset: false),

      itemCount: 6,

      itemBuilder: (_, i) => Shimmer.fromColors(
        baseColor: ColorCodes.shimmerColor,
        highlightColor: ColorCodes.shimmerColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorCodes.shimmerColor),
          ),
          margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5),
          child: Row(
            children: [
              Icon(Icons.image,size: 100,),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        children: [
                          Container(

                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 60,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: ColorCodes.shimmerColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 60,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: ColorCodes.shimmerColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 60,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: ColorCodes.shimmerColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                       /*   Spacer(),*/
                          SizedBox(width: 80,),
                          Container(
                            width: 60,
                            height: 10,
                            decoration: BoxDecoration(
                              color: ColorCodes.shimmerColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(

                      child:   Row(
                        children: [
                          Container(
                            width: 60,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorCodes.shimmerColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          SizedBox(width: 80,),
                          Container(
                            width: 60,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorCodes.shimmerColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 160,
                      height: 20,
                      decoration: BoxDecoration(
                        color: ColorCodes.shimmerColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

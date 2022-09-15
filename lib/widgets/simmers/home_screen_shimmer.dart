

import 'package:flutter/material.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:velocity_x/velocity_x.dart';

import '../../utils/ResponsiveLayout.dart';

class HomeScreenShimmer extends StatefulWidget {

  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<HomeScreenShimmer> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          constraints: (Vx.isWeb &&
              !ResponsiveLayout.isSmallScreen(context))
              ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90)
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              shimmer.Shimmer.fromColors(child: Column(
                children:  [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorCodes.shimmerColor,
                    ),),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(height: 100,color: Colors.black,),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(height: 250,color: Colors.black,),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right:8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                            //  const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                             // const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        child: Column(
                          children:  [
                            const Icon(Icons.image,size: 100,),
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        child: Column(
                          children:  [
                            const Icon(Icons.image,size: 100,),
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        child: Column(
                          children:  [
                            const Icon(Icons.image,size: 100,),
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 100, height: 12, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),),),),

                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right:8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //  const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              // const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 70, height: 70, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                baseColor: ColorCodes.shimmerColor,
                highlightColor: ColorCodes.shimmerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

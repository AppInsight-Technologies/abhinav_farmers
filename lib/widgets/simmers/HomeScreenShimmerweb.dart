

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../assets/ColorCodes.dart';
import '../../utils/ResponsiveLayout.dart';

class HomeScreenShimmerWeb extends StatefulWidget {

  const HomeScreenShimmerWeb({Key? key}) : super(key: key);

  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<HomeScreenShimmerWeb> {

  @override
  void initState() {
    super.initState();

  }

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
        300:
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
        170;
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
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              // const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            children: [
                              //const Icon(Icons.image,size: 90,),
                              Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 90, height: 90, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                              //Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 50, height: 12, decoration: BoxDecoration(color: ColorCodes.shimmerColor, borderRadius: BorderRadius.circular(16),),),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(

                    shrinkWrap: true,
                    //controller: new ScrollController(keepScrollOffset: false),
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widgetsInRow,
                        crossAxisSpacing: 4,
                        childAspectRatio: aspectRatio
                    ),
                    itemCount: 5,

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
                    ),),
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

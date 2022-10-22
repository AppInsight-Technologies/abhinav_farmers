import 'package:flutter/material.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class SingelItemScreenShimmer extends StatelessWidget {
  const SingelItemScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Shimmer.fromColors(child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: ColorCodes.shimmerColor,//Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75))
              ],
              color: ColorCodes.shimmerColor,//Theme.of(context).buttonColor,
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(1.0),
            margin: EdgeInsets.only(
                left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
            height: 36,
            child: Row(children: [
              SizedBox(
                width: 6,
              ),
              CircleAvatar(
                  radius: 12.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.location_on,
                      color: ColorCodes.shimmerColor,//Theme.of(context).primaryColor,
                      size: (18))),
              SizedBox(
                width: 10,
              ),
              Text(
                S .of(context).loading,
              //  "Location...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: ColorCodes.shimmerColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                S .of(context).change,
                //"CHANGE",
                style: TextStyle(
                    color: ColorCodes.shimmerColor,//Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              )
            ])),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
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
              Container(
                margin: EdgeInsets.only(
                    left: 10.0, top: 20.0, right: 10.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (_, i) => Row(
                        children: [
                          Container(
                              padding:
                              EdgeInsets.all(10.0),
                              width:
                              MediaQuery.of(context)
                                  .size
                                  .width -
                                  20,
                              //height: 60.0,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  bottom: 10.0),
                              decoration: BoxDecoration(
                                color: ColorCodes.shimmerColor,
                                borderRadius:
                                BorderRadius
                                    .circular(5.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    S .of(context).loading,
                                   // "Loading..",
                                    textAlign:
                                    TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                      14,
                                    ),
                                  ),
                                  Container(
                                      child: Row(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: <
                                                Widget>[
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 25.0,
                                                        height: 25.0,
                                                        child: Image.asset(
                                                          Images.starImg,
                                                        ),
                                                      ),
                                                      Text(  S .of(context).loading
                                                        //  "Loading.."
                                                          , style: new TextStyle(fontWeight: FontWeight.bold, color: ColorCodes.shimmerColor, fontSize: 14.0)),
                                                    ],
                                                  ),
                                                  Text(S .of(context).loading
                                                      //"loading"
                                                      , style: TextStyle(decoration: TextDecoration.lineThrough, color: ColorCodes.shimmerColor, fontSize: 10.0)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 25.0,
                                                        height: 25.0,
                                                        child: Image.asset(
                                                          Images.starImg,
                                                        ),
                                                      ),
                                                      Text(S .of(context).loading
                                                          //"Loading.."
                                                          , style: new TextStyle(fontWeight: FontWeight.bold, color: ColorCodes.shimmerColor, fontSize: 14.0)),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(S .of(context).loading,
                                                  //"loading..",
                                                  style: new TextStyle(fontWeight: FontWeight.bold, color: ColorCodes.shimmerColor, fontSize: 14.0)),
                                            ],
                                          )
                                        ],
                                      )),
                                  Icon(
                                    Icons
                                        .radio_button_checked_outlined,
                                  )
                                ],
                              )),
                          //Divider(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    SizedBox(
                      height: 5.0,
                    ),
                    /*Row(
                      children: [
                        SizedBox(width: 10),

                        Spacer(),

                        GestureDetector(
                            child: Icon(
                              Icons.share_outlined,
                              color: Colors.grey,
                            )),
                        SizedBox(width: 5),
                        Text("SHARE"),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),*/
                    /*     Divider(
                          thickness: 5,
                        ),*/
                    SizedBox(
                      height: 25.0,
                    ),
                    Container(),
                  ],
                ),
              ),
              // footer comes here
            ],
          ),
        ),
      ],
    ),
      baseColor: ColorCodes.shimmerColor,
      highlightColor: ColorCodes.shimmerColor,);

  }
}

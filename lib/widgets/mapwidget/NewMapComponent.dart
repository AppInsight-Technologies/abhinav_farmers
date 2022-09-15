//app....


import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/api.dart';
import '../../constants/features.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import '../../controller/mutations/login.dart';
import '../../generated/l10n.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:location/location.dart' as loc;

import '../../models/newmodle/cartModle.dart';
import '../../models/swap_product.dart';
import '../../providers/cartItems.dart';
import '../../rought_genrator.dart';
import '../../screens/address_screen.dart';
import '../../screens/map_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';

import '../Address_display.dart';

import '../addresswidget/address_info.dart';


class NewMapComponent extends StatefulWidget {
  String? valnext = "";
  String? moveNext = "";
  Map<String,String>? mapscreen;
  NewMapComponent(this.valnext,this.moveNext,this.mapscreen);

  @override
  State<NewMapComponent> createState() => _NewMapComponentState();
}

class _NewMapComponentState extends State<NewMapComponent> with Navigations{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController? _controller;
  Position? position;
  Widget? _child;
  double? _lat, _lng;
  String _address = "",addressLine="";
  CameraPosition? cameraposition;
  Timer? timer;
  bool _serviceEnabled = false;
  bool _permissiongrant = false;
  int count = 0;
  List<CartItem> productBox=[];
  String? currentBranch;
  String confirmSwap="";
  List<SwapProduct> listswapprod =[];
  var addressdata;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey);

  BuildContext? navigatorecontext;
  @override
  initState()   {
    _child = Column(
      children: [
        _backbutton(),
        Padding(
          padding: const EdgeInsets.only(left:10.0,right:10.0),
          child: ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation, builder: (context, value, widget){
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                  // _dialogforaddress(context);
                  MapWeb(context, valnext: "",isdisplayprediction: "1");
                }
                else {
                  Navigation(
                      context, name: Routename.MapScreen, navigatore: NavigatoreTyp.Push,
                      qparms: {
                        "valnext": "",
                        "isdisplayprediction": 1
                      });
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width ,
                decoration: BoxDecoration(
                    color: Color(0xffF1F1F1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorCodes.lightGreyWebColor)
                ),
                padding: EdgeInsets.only(left: 7,right: 10,),

                child: Row(
                  children: [
                    Icon(
                        Icons.search,
                        color: ColorCodes.primaryColor,
                        size: 24
                    ),
                    SizedBox(width: 5),
                    Text(
                      S.current.search_for_area,
                      style: TextStyle(
                        color: ColorCodes.grey,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //SizedBox(width: MediaQuery.of(context).size.width),

                  ],
                ),
              ),
            );
          }),
        ),

        Padding(
          padding: const EdgeInsets.only(left:10.0,top:20),
          child: GestureDetector(
            onTap:(){
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                // _dialogforaddress(context);
                MapWeb(context, valnext: "");
              }
              else {
                Navigation(
                    context, name: Routename.MapScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      "valnext": "",
                    });
              }
            },
            child: Row(
              children: [
                Column(
                  children: [
                    Icon(
                        Icons.gps_fixed,
                        color: ColorCodes.badgecolor,
                        size: 32
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.current_location,//" Search From 10,000+ products",
                      style: TextStyle(
                        color: ColorCodes.badgecolor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      S.current.using_gps,//" Search From 10,000+ products",
                      style: TextStyle(
                        color: ColorCodes.blackColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        const Divider(
          color: Color(0xffdbdbdb),
          height: 50,
          thickness: 5,
          indent: 5,
          endIndent: 5,
        ),
        _bodymobile()


      ],
    );
    productBox = (VxState.store as GroceStore).CartItemList;
    super.initState();

    timer = Timer.periodic(
        Duration(seconds: 5),
            (Timer t) => _permissiongrant
            ? !_serviceEnabled ? getCurrentLocation() : closed()
            : "");
  }

  Widget printAddress(BuildContext context, i, String addressid) {
    if (addressdata.billingAddress[i].isdefault == '1') {
      return GestureDetector(
        onTap: () async {
          getAddress(double.parse(addressdata.billingAddress[i].lattitude), double.parse(addressdata.billingAddress[i].logingitude));
          var url = IConstants.API_PATH + 'add-primary-location';
          final response = await http.post(url, body: {
            // await keyword is used to wait to this operation is complete.
            "id": PrefUtils.prefs!.getString("apikey"),
            "latitude": addressdata.billingAddress[i].lattitude.toString(),
            "longitude": addressdata.billingAddress[i].logingitude.toString(),
            "area": _address,
            "branch": PrefUtils.prefs!.getString('branch'),
          });
          final responseJson = json.decode(response.body);
          if (responseJson["data"].toString() == "true") {
            (VxState.store as GroceStore).userData.branch =
                PrefUtils.prefs!.getString('branch');
            (VxState.store as GroceStore).userData.area = _address.toString();
          }
          Navigator.of(context).pop(true);
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              (addressdata.billingAddress[i].addressType == "home")? Image.asset(Images.homeConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):(addressdata.billingAddress[i].addressType == "Work")?Image.asset(Images.locationImage,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):Image.asset(Images.locationImage,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ),
              Padding(padding: EdgeInsets.only(left: 5)),
              Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /*Align(
                        alignment: Alignment.topLeft,
                        child:*/
                      /*Text(
                        S .of(context).default_address,//'Default Address:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: ColorCodes.mediumBlackWebColor,
                        ),
                      ),*/
                      // ),
                      Padding(padding: EdgeInsets.only(top: 5)),


                      new RichText(textAlign: TextAlign.start,
                        text: new TextSpan(

                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: /*addressitemsData.items[i]*/addressdata.billingAddress[i].addressType+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
                            new TextSpan(
                                text: addressdata.billingAddress[i].address,
                                style:new TextStyle(fontSize: 14)
                              // style: new TextStyle(color: ColorCodes.darkgreen),
                            ),

                          ],
                        ),
                      ),
                      /* Text(
                        addressitemsData.items[i].useraddtype+  "\n" +addressitemsData.items[i].useraddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorCodes.greyColor,
                        ),
                      ),*/
                    ],
                  )),
              // GestureDetector(
              //   onTap: (){
              //
              //   },
              //   child: PopupMenuButton(
              //     onSelected: (FilterOptions selectedValue) {
              //       if(selectedValue == FilterOptions.Edit/*"Edit"*//*S .of(context).edit*/){
              //         setState(() {
              //           PrefUtils.prefs!.setString(
              //               "addressbook",
              //               "AddressbookScreen");
              //           /*        Navigator.of(context).pushReplacementNamed(
              //                                       AddressScreen.routeName,
              //                                       arguments: {
              //                                         'addresstype': "edit",
              //                                         'addressid': addressdata.billingAddress[i].id
              //                                             .toString(),
              //                                         'delieveryLocation': deliverylocation,
              //                                         'latitude': addressdata.billingAddress[i].lattitude
              //                                             .toString(),//"",
              //                                         'longitude': addressdata.billingAddress[i].logingitude
              //                                             .toString(),//"",
              //                                         'branch': ""
              //                                       });*/
              //           Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
              //               qparms: {
              //                 'addresstype': "edit",
              //                 'addressid': addressdata.billingAddress[i].id.toString(),
              //                 'delieveryLocation': deliverylocation,
              //                 'latitude': addressdata.billingAddress[i].lattitude.toString(),
              //                 'longitude': addressdata.billingAddress[i].logingitude.toString(),
              //                 'branch': ""
              //               });
              //         });
              //       }
              //       else if(selectedValue ==  FilterOptions.Delete/*"Delete"*//*S .of(context).delete*/){
              //         _dialogforDeleteAdd(context,
              //             addressdata.billingAddress[i].id.toString());
              //       }
              //       // _dialogforRemoving(context);
              //       // removelist(
              //       //     shoplistData.itemsshoplist[i].listid);
              //     },
              //     // icon: Icon(
              //     //   Icons.more_horiz,
              //     // ),
              //     itemBuilder: (_) =>
              //     [
              //       PopupMenuItem(
              //         child: Text(  S .of(context).edit,
              //           style: TextStyle(fontSize: 10),
              //           // 'Remove'
              //         ),
              //         value: FilterOptions.Edit,
              //       ),
              //       PopupMenuItem(
              //         child: Text(  S .of(context).delete,
              //           style: TextStyle(fontSize: 10),
              //           // 'Remove'
              //         ),
              //         value: FilterOptions.Delete,
              //       ),
              //     ],
              //     child: Container(
              //       height: 30,
              //       width: 30,
              //       decoration: ShapeDecoration(
              //         color: ColorCodes.whiteColor,
              //         shape: StadiumBorder(
              //           side: BorderSide(color: ColorCodes.lightgrey, width: 1),
              //         ),
              //       ),
              //       child: Icon(Icons.more_horiz,color: ColorCodes.primaryColor,),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    }
    else {

      return GestureDetector(
        onTap: () async {
          AddressController addressController = AddressController();
          await addressController.setdefult(addressId: addressid,branch: PrefUtils.prefs!.getString('branch'));
          getAddress(double.parse(addressdata.billingAddress[i].lattitude), double.parse(addressdata.billingAddress[i].logingitude));
          var url = IConstants.API_PATH + 'add-primary-location';
          final response = await http.post(url, body: {
            // await keyword is used to wait to this operation is complete.
            "id": PrefUtils.prefs!.getString("apikey"),
            "latitude": addressdata.billingAddress[i].lattitude.toString(),
            "longitude": addressdata.billingAddress[i].logingitude.toString(),
            "area": _address,
            "branch": PrefUtils.prefs!.getString('branch'),
          });
          final responseJson = json.decode(response.body);
          if (responseJson["data"].toString() == "true") {
            (VxState.store as GroceStore).userData.branch =
                PrefUtils.prefs!.getString('branch');
            (VxState.store as GroceStore).userData.area = _address.toString();
          }
          Navigator.of(context).pop(true);
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              (addressdata.billingAddress[i].addressType == "home")? Image.asset(Images.homeConfirm,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):(addressdata.billingAddress[i].addressType == "Work")?Image.asset(Images.locationImage,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ):Image.asset(Images.locationImage,
                height: 25,
                width: 25,
                color: ColorCodes.blackColor,
              ),
              Padding(padding: EdgeInsets.only(left: 5)),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      new RichText(
                        textAlign: TextAlign.start,
                        text: new TextSpan(

                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: addressdata.billingAddress[i].addressType+"\n",
                              style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
                            new TextSpan(
                                text: addressdata.billingAddress[i].address,
                                style:new TextStyle(fontSize: 14)
                              // style: new TextStyle(color: ColorCodes.darkgreen),
                            ),

                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    }
  }

  _bodymobile(){
    return VxBuilder(
        mutations: {SetAddress,SetUserData},
        builder: (ctx,  store,VxStatus? state){
          addressdata = store!.userData;
          return (addressdata.billingAddress != null) ? Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (addressdata.billingAddress.length<=0)
                        ? SizedBox.shrink()
                        : Expanded(child:Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:10.0,top:10),
                          child: Row(
                            children: [
                              Text((S.current.saved_address).toUpperCase(),style:TextStyle(color:ColorCodes.blackColor,fontSize: 15,fontWeight: FontWeight.bold))
                            ],
                          ),

                        ),
                      //  SizedBox(height: 10),
                        Expanded(
                          child:
                          ListView.builder(
                            itemCount: addressdata.billingAddress.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                Container(
                                  width:MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10, ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    AddressDisplay(context:
                                                    context,
                                                      i: i,
                                                      billingAddressId: addressdata.billingAddress[i].id.toString(),
                                                      fromscreen: "Mapscreen",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.only(left:30.0),
                                  color: ColorCodes.whiteColor,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Divider(color: ColorCodes.lightGreyColor,),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          // ListView.builder(
                          //     itemCount: addressdata.billingAddress.length,/*snapshot.data.length*/
                          //     itemBuilder: (_, i){
                          //       var address = addressdata.billingAddress[i];
                          //       return
                          //         Column(
                          //         children: [
                          //           Container(
                          //             width:MediaQuery.of(context).size.width,
                          //             margin: const EdgeInsets.only( left: 10),
                          //             padding: const EdgeInsets.only(left: 10),
                          //             child: Container(
                          //               //height: 50,
                          //               margin: EdgeInsets.only(right: 10, ),
                          //               child: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.start,
                          //                 children: [
                          //                   Row(children: [Icon( address.addressicon,color: ColorCodes.lightGreyColor,),
                          //                     SizedBox(width: 5),
                          //                     Text(address.addressType.toString()),],),
                          //                   Text(address.address.toString()),
                          //                   // Padding(
                          //                   //   padding: const EdgeInsets.symmetric(horizontal:10.0),
                          //                   //   child: Row(
                          //                   //     children: [
                          //                   //       /* Icon( addressitemsData.items[i].addressicon,color: ColorCodes.lightGreyColor,),
                          //                   //   Padding(
                          //                   //     padding: const EdgeInsets.only(left:5.0),
                          //                   //     child: Text(addressitemsData.items[i].useraddtype.toString()),
                          //                   //   ),*/
                          //                   //
                          //                   //       /* CachedNetworkImage(
                          //                   //     imageUrl: addressitemsData.items[i].addressicon,
                          //                   //    *//* placeholder: (context, url) => Image.asset(
                          //                   //         Images.defaultCategoryImg),*//*
                          //                   //
                          //                   //     height: ResponsiveLayout.isSmallScreen(context)?100:120,
                          //                   //     width: ResponsiveLayout.isSmallScreen(context)?115:160,
                          //                   //     //fit: BoxFit.fill,
                          //                   //   ) ,*/
                          //                   //     ],
                          //                   //   ),
                          //                   // ),
                          //                   // Row(
                          //                   //   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   //   children: <Widget>[
                          //                   //     Expanded(
                          //                   //       child: Container(
                          //                   //         padding: EdgeInsets.only(top: 15),
                          //                   //         child: Column(
                          //                   //           crossAxisAlignment: CrossAxisAlignment.start,
                          //                   //           children: <Widget>[
                          //                   //           ],
                          //                   //         ),
                          //                   //       ),
                          //                   //     ),
                          //                   //   ],
                          //                   // ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           /* SizedBox(
                          //     height: 10.0,
                          //   ),*/
                          //           Padding(
                          //             padding: const EdgeInsets.only(left:30.0),
                          //             child: Column(
                          //               children: [
                          //                 //     Row(
                          //                 //       //crossAxisAlignment: CrossAxisAlignment.start,
                          //                 //       children: [
                          //                 //         FlatButton(
                          //                 //           child:Text(S .of(context).edit,//"EDIT",
                          //                 //             style: TextStyle(color:Theme.of(context).primaryColor,fontWeight: FontWeight.normal,fontSize: 14.0,),),
                          //                 //           padding: EdgeInsets.all(0),
                          //                 //           //  icon: Icon(Icons.edit, size: 20),
                          //                 //           // color: Colors.grey,
                          //                 //           onPressed: () {
                          //                 //             setState(() {
                          //                 //               PrefUtils.prefs!.setString("addressbook",
                          //                 //                   "AddressbookScreen");
                          //                 //             /*  Navigator.of(context).pushReplacementNamed(
                          //                 //                 AddressScreen.routeName,
                          //                 //                   arguments: {
                          //                 //                     'addresstype': "edit",
                          //                 //                     'addressid': addressdata.billingAddress[i].id
                          //                 //                         .toString(),
                          //                 //                     'delieveryLocation': deliverylocation,
                          //                 //                     'latitude': addressdata.billingAddress[i].lattitude
                          //                 //                         .toString(),//"",
                          //                 //                     'longitude': addressdata.billingAddress[i].logingitude
                          //                 //                         .toString(),//"",
                          //                 //                     'branch': ""
                          //                 //                   });*/
                          //                 //               Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                          //                 //                   qparms: {
                          //                 //                     'addresstype': "edit",
                          //                 //                     'addressid': addressdata.billingAddress[i].id.toString(),
                          //                 //                     'delieveryLocation': deliverylocation,
                          //                 //                     'latitude': addressdata.billingAddress[i].lattitude.toString(),
                          //                 //                     'longitude': addressdata.billingAddress[i].logingitude.toString(),
                          //                 //                     'branch': "",
                          //                 //                   });
                          //                 //             });
                          //                 //           },
                          //                 //         ),
                          //                 //         /* Container(
                          //                 //   height: 12,
                          //                 //   width: 1,
                          //                 //   child: VerticalDivider(
                          //                 //       color: Colors.black),
                          //                 // ),*/
                          //                 //         FlatButton(
                          //                 //             child:Text(S .of(context).delete,//"DELETE",
                          //                 //               style: TextStyle(color:ColorCodes.banner,fontWeight: FontWeight.normal,fontSize: 14.0,),),
                          //                 //             padding: EdgeInsets.all(0),
                          //                 //             /*icon: Icon(Icons.delete_outline,
                          //                 //       size: 20),*/
                          //                 //             // color: Colors.grey,
                          //                 //             onPressed: () {
                          //                 //              //  _dialogforSaveadd();
                          //                 //               _dialogforDeleteAdd(
                          //                 //                   context,
                          //                 //               addressdata.billingAddress[i].id.toString());
                          //                 //
                          //                 //             }),
                          //                 //
                          //                 //       ],
                          //                 //     ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(left:10.0,right:10),
                          //                   child: Divider(color: ColorCodes.lightGreyColor,),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //
                          //         ],
                          //       );
                          //     }
                          //
                          // ),

                        ),
                      ],
                    )),
                  ]
              )
          ):SizedBox.shrink();
        }
    );

  }

  void closed() {
    timer?.cancel();
  }



  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _backbutton(){
    return  Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 40),
            child: IconButton(
                icon: Icon(Icons.arrow_back, color:ColorCodes.blackColor),
                onPressed: () async{
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                  return Future.value(false);
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:40, left: 10 ),
            child: Text(S.current.set_delivery_location,style: TextStyle(color:ColorCodes.blackColor,fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          if(Vx.isWeb)
            SizedBox(height: 10)
        ],
      ),
    );
  }

  void getCurrentLocation() async {
    // PermissionStatus permission =
    // await LocationPermissions().requestPermissions();
    // permission = await LocationPermissions().checkPermissionStatus();
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }else{
      Permission.location.request();
    }

    if (await Permission.location.isGranted) {
      setState(() {
        _permissiongrant = true;

      });
      checkusergps();
    } else {
      setState(() {
        _permissiongrant = false;
      });

      // checkusergps();
      Prediction p = await PlacesAutocomplete.show(
          mode: Mode.overlay, context: context, apiKey:(Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey);
      displayPrediction(p);
    }
  }

  checkusergps() async {

    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;

    });
    if (!_serviceEnabled) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        setState(() {
          count++;
        });
        if (Features.ismultivendor) {
          if (count == 1) {
            _serviceEnabled = await location.requestService();
            if (_serviceEnabled) {
              Position res = await Geolocator.getCurrentPosition();
              setState(() {
                position = res;
                _lat = position!.latitude;
                _lng = position!.longitude;
                cameraposition = CameraPosition(
                  target: LatLng(_lat, _lng),
                  zoom: 16.0,
                );
                _child = mapWidget();
              });
              await getAddress(_lat!, _lng!);
            }
            else{
              _serviceEnabled = await location.requestService();
            }
          }
        } else {
          if (count == 1)
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S
                      .of(context)
                      .location_unavailable, //"Location unavailable"
                  ),
                  content: Text(
                    S
                        .of(context)
                        .location_enable, //'Please enable the location from device settings.'
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(S
                          .of(context)
                          .ok, //'Ok'
                      ),
                      onPressed: () async {
                        setState(() {
                          count = 0;
                        });
                        //await AppSettings.openLocationSettings();
                        Navigator.of(context, rootNavigator: true).pop();
                        //checkusergps();
                      },
                    ),
                  ],
                );
              },
            );
        }
      }
    } else {
      Position res = await Geolocator.getCurrentPosition();
      setState(() {
        position = res;
        _lat = position!.latitude;
        _lng = position!.longitude;
        cameraposition = CameraPosition(
          target: LatLng(_lat, _lng),
          zoom: 16.0,
        );
        _child = mapWidget();
      });
      await getAddress(_lat!, _lng!);
    }
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId(S .of(context).markerID,//"home"
          ),
          position: LatLng(_lat, _lng),
//          icon: BitmapDescriptor.,
          infoWindow:
          InfoWindow(title: S .of(context).product_delivered_here,//"Your Products will be delivered here"
          )),
    ].toSet();
  }

  List<Placemark>? placemark;

  getAddress(double latitude, double longitude) async {
    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;
    });
    if (!_serviceEnabled) {
      checkusergps();
    }
    placemark =
    await placemarkFromCoordinates(latitude, longitude);

    // setState(() async {
    // _address=_deliverylocation;

    if (placemark![0].subLocality.toString() == "") {
      if (placemark![0].locality.toString() == "") {
        _address = "";
        addressLine="";
        _child = mapWidget();
      } else {
        final coordinates = new Coordinates(latitude, longitude);
        var addresses;
        addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        setState(() {
          addressLine = (first.subLocality != null) ? (first.subLocality + "," +
              first.locality + "," + first.adminArea)
              : (first.locality + "," + first.adminArea);
          _address = (first.subLocality != null) ? (first.subLocality) : (first.locality);
          addressLine=first.addressLine;
        });

        _child = mapWidget();
      }
    } else {
      var addresses;
      addresses = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(latitude, longitude));
      var first = addresses.first;
      setState(() {
        addressLine = (first.subLocality != null) ? (first.subLocality + "," +
            first.locality + "," + first.adminArea)
            : (first.locality + "," + first.adminArea);
        _address = (first.subLocality != null) ? (first.subLocality) : (first.locality);
        addressLine = first.addressLine;
      });
      _child = mapWidget();
    }
  }

  Future<void> _onCameraMove(CameraPosition position) async {
    setState(() {
      _lat = position.target.latitude;
      _lng = position.target.longitude;
      _createMarker();
    });
  }

  Future<void> _onCameraIdle() async {
    await getAddress(_lat!, _lng!);
  }

  changelocation(Place place) async {
    Navigator.of(context).pop();

    var addresses =
    await Geocoder.local.findAddressesFromQuery(place.description);
    var first = addresses.first;

    setState(() {
      _lat = first.coordinates.latitude;
      _lng = first.coordinates.longitude;
    });
    await getAddress(first.coordinates.latitude, first.coordinates.longitude);

    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        _lat = detail.result.geometry.location.lat;
        _lng = detail.result.geometry.location.lng;
        if (_controller == null) {
          _child = mapWidget();
        } else {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
            ),
          );
          _child = mapWidget();
        }
      });
      await getAddress(_lat!, _lng!);
    }
  }

  checkusergps1() async {
    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;
    });

    if (!_serviceEnabled) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        setState(() {
          count++;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S .of(context).location_unavailable,//"Location unavailable"
              ),
              content: Text(
                S .of(context).location_enable,//'Please enable the location from device settings.'
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(S .of(context).ok,//'Ok'
                  ),
                  onPressed: () async {
                    setState(() {
                      count = 0;
                    });
                    //await AppSettings.openLocationSettings();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      await getAddress(_lat!, _lng!);

      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
        ),
      );
    }
  }

  _dialogforProcessing() {
    return showDialog(context: context,
        builder: (context) {
          navigatorecontext = context;
          return StatefulBuilder(
              builder: (context, setState) {
                return AbsorbPointer(
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop:() async{
          Navigation(context, navigatore: NavigatoreTyp.homenav);
          return Future.value(false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false, key: _scaffoldKey, body: _child),
      ),
    );
  }

  Widget mapWidget() {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 7,
            child:   Stack(children: <Widget>[
              GoogleMap(
                  mapType: MapType.normal,
                  // markers: _createMarker(),
                  mapToolbarEnabled: true,
                  onCameraIdle: _onCameraIdle,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  padding: (Platform.isAndroid)?EdgeInsets.only(bottom: 85, top: 110/*MediaQuery.of(context).size.height/3*/, right: 0, left: 0) : null,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_lat, _lng),
                    zoom: 16.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  }
              ),
              //This is your marker
              Container(
                padding: (Platform.isAndroid)?EdgeInsets.only(bottom: 85, top: 110/*MediaQuery.of(context).size.height/3*/, right: 0, left: 0) : null,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.location_pin,color: Colors.redAccent,size: 30,),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:  EdgeInsets.only(top: 30),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back, color:ColorCodes.blackColor),
                      onPressed: () {
                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                      }
                  ),
                ),
              ),
            ])

        ),
        Expanded(
          flex: 3,
          child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        S .of(context).select_delivery_location,//'Select delivery location',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        S .of(context).your_location,//'YOUR LOCATION',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
//                    _settingModalBottomSheet(context);

                      Prediction p = await PlacesAutocomplete.show(
                          mode: Mode.overlay,
                          context: context,
                          apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey);
                      displayPrediction(p);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 16.0,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          _address,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                            S .of(context).change_caps,//'CHANGE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor)),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                  /*    GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
//                    _settingModalBottomSheet(context);

                      Prediction p = await PlacesAutocomplete.show(
                          mode: Mode.overlay,
                          context: context,
                          apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey);
                      displayPrediction(p);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 16.0,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          _address,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                            S .of(context).change_caps,//'CHANGE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor)),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),*/
                  Divider(),
                  GestureDetector(
                    onTap: () async {
                      _dialogforProcessing();
                      checkLocation();
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        margin: EdgeInsets.only(
                            left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border(
                              top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S .of(context).confirm_location_proceed,//'Confirm location & Proceed',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ],
                        )),
                  ),
                ],
              )),
        ),
      ],
    );
  }


  Future<void> checkLocation() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = /*IConstants.isEnterprise &&*/ Features.ismultivendor?Api.checkLocationmultivendor:IConstants.API_PATH + 'check-location';
    try {
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "lat": _lat.toString(),
        "long": _lng.toString(),
        "branch" : PrefUtils.prefs!.getString("branch"),

        "ref": IConstants.refIdForMultiVendor.toString(),
        "branchtype": IConstants.branchtype.toString(),
      });
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseJson = json.decode(response.body);
      bool _isCartCheck = false;
      if (responseJson['status'].toString() == "yes") {
        PrefUtils.prefs!.setString('defaultlocation', "true");
        PrefUtils.prefs!.setString("isdelivering","true");
        currentBranch = responseJson['branch'].toString();
        if(PrefUtils.prefs!.getString("branch") == responseJson['branch'].toString()) {
          IConstants.deliverylocationmain.value = addressLine;
          IConstants.currentdeliverylocation.value = S .of(context).location_available;
          if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
            final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
            Navigator.of(context).pop();
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
              AddressWeb(context,
                addresstype: "new",
                addressid: "",
                delieveryLocation: _address,
                latitude: _lat.toString(),
                longitude: _lng.toString(),
                branch: responseJson['branch'].toString(),
                houseNo: routeArgs['houseNo'],
                apartment: routeArgs['apartment'],
                street: routeArgs['street'],
                landmark: routeArgs['landmark'],
                area: routeArgs['area'],
                pincode: routeArgs['pincode'],);
            }
            else {
              Navigation(context, name: Routename.AddressScreen,
                  navigatore: NavigatoreTyp.Push,
                  qparms: {
                    'addresstype': "new",
                    'addressid': "",
                    'delieveryLocation': _address,
                    'latitude': _lat.toString(),
                    'longitude': _lng.toString(),
                    'branch': responseJson['branch'].toString(),
                    'houseNo': routeArgs['houseNo'],
                    'apartment': routeArgs['apartment'],
                    'street': routeArgs['street'],
                    'landmark': routeArgs['landmark'],
                    'area': routeArgs['area'],
                    'pincode': routeArgs['pincode'],
                  });
            }
          } else {
            PrefUtils.prefs!.setString('branch', responseJson['branch'].toString());
            PrefUtils.prefs!.setString('deliverylocation', addressLine);
            PrefUtils.prefs!.setString("latitude", _lat.toString());
            PrefUtils.prefs!.setString("longitude", _lng.toString());
            if (PrefUtils.prefs!.getString("skip") == "no") {
              addprimarylocation("","","");
            } else {
              (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
              (VxState.store as GroceStore).userData.area = _address.toString();
              (VxState.store as GroceStore).userData.delevrystatus = responseJson["status"].toString() == "yes"?true:false;
              Navigator.of(context).pop();
              if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                  PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                if (PrefUtils.prefs!.containsKey("fromcart")) {
                  if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                    PrefUtils.prefs!.remove("fromcart");
                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      // _dialogforaddress(context);
                      MapWeb(context);
                    }
                    else {
                      Navigation(context, name: Routename.MapScreen,
                          navigatore: NavigatoreTyp.Push);
                    }
                    Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                  } else {
                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                  }
                } else {
                  HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                      PrefUtils.prefs!.getString("tokenid"),
                      branch: (VxState.store as GroceStore).userData.branch ?? "999",
                      rows: "0");
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                }
              }
            }
          }
        } else {
          if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
            final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
            Navigator.of(context).pop();
            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
              AddressWeb(context,
                addresstype: "new",
                addressid: "",
                delieveryLocation: _address,
                latitude: _lat.toString(),
                longitude: _lng.toString(),
                branch: responseJson['branch'].toString(),
                houseNo: routeArgs['houseNo'],
                apartment: routeArgs['apartment'],
                street: routeArgs['street'],
                landmark: routeArgs['landmark'],
                area: routeArgs['area'],
                pincode: routeArgs['pincode'],);
            }
            else {
              Navigation(context, name: Routename.AddressScreen,
                  navigatore: NavigatoreTyp.Push,
                  qparms: {
                    'addresstype': "new",
                    'addressid': "",
                    'delieveryLocation': _address,
                    'latitude': _lat.toString(),
                    'longitude': _lng.toString(),
                    'branch': responseJson['branch'].toString(),
                    'houseNo': routeArgs['houseNo'],
                    'apartment': routeArgs['apartment'],
                    'street': routeArgs['street'],
                    'landmark': routeArgs['landmark'],
                    'area': routeArgs['area'],
                    'pincode': routeArgs['pincode'],
                  });
            }
          } else {
            if (productBox.length > 0) { //Suppose cart is not empty
              _dialogforAvailability(
                  PrefUtils.prefs!.getString("branch")!,
                  responseJson['branch'].toString(),
                  PrefUtils.prefs!.getString("deliverylocation")!,
                  PrefUtils.prefs!.getString("latitude")!,
                  PrefUtils.prefs!.getString("longitude")!);
            } else {
              PrefUtils.prefs!.setString('branch', responseJson['branch'].toString());
              PrefUtils.prefs!.setString('deliverylocation', addressLine);
              PrefUtils.prefs!.setString("latitude", _lat.toString());
              PrefUtils.prefs!.setString("longitude", _lng.toString());
              if (PrefUtils.prefs!.getString("skip") == "no") {
                addprimarylocation("","","");
              } else {
                (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
                (VxState.store as GroceStore).userData.area = _address.toString();
                (VxState.store as GroceStore).userData.delevrystatus = responseJson["status"].toString() == "yes"?true:false;
                Navigator.of(context).pop();
                if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                    PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                  if (PrefUtils.prefs!.containsKey("fromcart")) {
                    if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                      PrefUtils.prefs!.remove("fromcart");
                      if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                        // _dialogforaddress(context);
                        MapWeb(context);
                      }
                      else {
                        Navigation(context, name: Routename.MapScreen,
                            navigatore: NavigatoreTyp.Push);
                      }
                      Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                    } else {
                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                    }
                  } else {
                    HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                        PrefUtils.prefs!.getString("tokenid"),
                        branch: (VxState.store as GroceStore).userData.branch ?? "999",
                        rows: "0");
                    Navigation(context, navigatore: NavigatoreTyp.homenav);
                  }
                } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
                  if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    AddressWeb(context,
                      addresstype: "new",
                      addressid: "",);
                  }
                  else {
                    Navigation(context, name: Routename.AddressScreen,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {
                          'addresstype': "new",
                          'addressid': "",
                        });
                  }
                }
              }
            }
          }
        }
      } else {
        Navigator.of(context).pop();
        PrefUtils.prefs!.setString("isdelivering","false");
        IConstants.currentdeliverylocation.value = S .of(context).not_available_location;
        showInSnackBar();
      }
    } catch (error) {
      throw error;
    }
  }

  _dialogforAvailability(String prevBranch, String currentBranch, String deliveryLocation, String latitude, String longitude) async {
    String itemCount = "";
    itemCount = "   " + productBox.length.toString() + " " + S .of(context).items;//"items"
    var similarlistData;
    var _checkitem = false;
    bool _checkMembership = false;
    if(PrefUtils.prefs!.getString("membership") == "1"){
      _checkMembership = true;
    } else {
      _checkMembership = false;
    }

    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  insetPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 85 / 100,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10.0,),
                          new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: S .of(context).Availability_Check,//"Availability Check",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),),
                                new TextSpan(text: itemCount, style: TextStyle(color: Colors.grey, fontSize: 12.0)
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(S .of(context).changing_area,//"Changing area",
                            style: TextStyle(color: Colors.red, fontSize: 12.0,),),
                          SizedBox(height: 10.0,),
                          Text(S .of(context).product_price_availability,//"Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.",
                            style: TextStyle(fontSize: 12.0),),
                          Spacer(),
                          SizedBox(height: 5.0,),
                          Divider(),
                          SizedBox(height: 5.0,),

                          Row(
                            children: <Widget>[
                              Container(
                                width: 53.0,
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(S .of(context).items,//"Items",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),),

                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 15.0,),
                                    Text(S .of(context).reason,//"Reason",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 30 / 100,
                            child: new ListView.builder(
                              //physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productBox.length,
                                itemBuilder: (_, i)
                                {

                                  return Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          FadeInImage(
                                            image: NetworkImage(productBox[i].itemImage!),
                                            placeholder: AssetImage(
                                                Images.defaultProductImg),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    (productBox[i].itemName!),
                                                    style:
                                                    TextStyle(fontSize: 12.0)),
                                                SizedBox(
                                                  height: 3.0,
                                                ),
                                                _checkMembership
                                                    ? productBox[i].membershipPrice ==
                                                    '-' ||
                                                    (productBox[i]
                                                        .membershipPrice ==
                                                        "0")
                                                    ? (double.parse(productBox[i].price!)) <= 0 ||
                                                    (double.parse(productBox[i].price!).toString() ==
                                                        "" ||
                                                        productBox[i].price ==
                                                            productBox[i].varMrp)
                                                    ? Text(
                                                    Features.iscurrencyformatalign?
                                                    productBox[i].varMrp.toString() + " " + IConstants.currencyFormat:
                                                    IConstants.currencyFormat + " " + productBox[i].varMrp.toString(),
                                                    style: TextStyle(
                                                        fontSize: 12.0))
                                                    : Text(
                                                    Features.iscurrencyformatalign?
                                                    productBox[i].price
                                                        .toString() +
                                                        " " + IConstants.currencyFormat :
                                                    IConstants.currencyFormat +
                                                        " " +
                                                        productBox[i].price
                                                            .toString(),
                                                    style: TextStyle(fontSize: 12.0))
                                                    : Text(
                                                    Features.iscurrencyformatalign?productBox[i].membershipPrice! + " " + IConstants.currencyFormat:
                                                    IConstants.currencyFormat + " " + productBox[i].membershipPrice!, style: TextStyle(fontSize: 12.0))
                                                    : (double.parse(productBox[i].price.toString()) <= 0 || productBox[i].price.toString() == "" || productBox[i].price == productBox[i].varMrp)
                                                    ? Text(
                                                    Features.iscurrencyformatalign?
                                                    productBox[i].varMrp! + " " +IConstants.currencyFormat :
                                                    IConstants.currencyFormat + " " + productBox[i].varMrp.toString(), style: TextStyle(fontSize: 12.0))
                                                    : Text(Features.iscurrencyformatalign?
                                                productBox[i].price.toString() + " " + IConstants.currencyFormat :IConstants.currencyFormat + " " + productBox[i].price.toString(), style: TextStyle(fontSize: 12.0))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                  S
                                                      .of(context)
                                                      .not_available, //"Not available",
                                                  style:
                                                  TextStyle(fontSize: 12.0))),
                                        ],
                                      ),
                                      /*  Column(
                                        children: [
                                          Items(
                                            "home_screen",
                                            snapshot.data[i].id,
                                            snapshot.data[i].title,
                                            snapshot.data[i].imageUrl,
                                            snapshot.data[i].brand,
                                            snapshot.data[i].veg_type,
                                            snapshot.data[i].type,
                                            snapshot
                                                .data[i].eligible_for_express,
                                            snapshot.data[i].delivery,
                                            snapshot.data[i].duration,
                                            snapshot.data[i].durationType,
                                            snapshot.data[i].note,
                                            snapshot.data[i].subscribe,
                                            snapshot.data[i].paymentmode,
                                            snapshot.data[i].cronTime,
                                            snapshot.data[i].name,

                                            //sellingitemData.items[i].brand,
                                          ),
                                        ],
                                      )*/
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(height: 10.0,),
                          Divider(),
                          SizedBox(height: 20.0,),
                          new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                new TextSpan(text: S .of(context).note,//'Note: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, )),
                                new TextSpan(text: S .of(context).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                                      PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                                    if (PrefUtils.prefs!.containsKey("fromcart")) {
                                      if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                                        PrefUtils.prefs!.remove("fromcart");
                                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                          // _dialogforaddress(context);
                                          MapWeb(context);
                                        }
                                        else {
                                          Navigation(context, name: Routename.MapScreen,
                                              navigatore: NavigatoreTyp.Push);
                                        }
                                        Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                      } else {
                                        Navigation(context, navigatore: NavigatoreTyp.homenav);
                                      }
                                    } else {
                                      Navigation(context, navigatore: NavigatoreTyp.homenav);
                                    }
                                  } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
                                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                      AddressWeb(context,
                                        addresstype: "new",
                                        addressid: "",);
                                    }
                                    else {
                                      Navigation(context,
                                          name: Routename.AddressScreen,
                                          navigatore: NavigatoreTyp.Push,
                                          qparms: {
                                            'addresstype': "new",
                                            'addressid': "",
                                          });
                                    }
                                  }                               },
                                child: new Container(
                                  width: MediaQuery.of(context).size.width * 35 / 100,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: new Center(
                                    child: Text(S .of(context).map_cancel,//"CANCEL"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0,),
                              GestureDetector(
                                onTap: () async {

                                  PrefUtils.prefs!.setString('branch', currentBranch);
                                  PrefUtils.prefs!.setString('deliverylocation', addressLine);
                                  PrefUtils.prefs!.setString("latitude", _lat.toString());
                                  PrefUtils.prefs!.setString("longitude", _lng.toString());

                                  if (PrefUtils.prefs!.getString("skip") == "no") {
                                    var com ="";
                                    String val = "";
                                    String item = "";
                                    for(int i = 0; i < productBox.length; i++){
                                      val = val+com+productBox[i].itemId.toString();
                                      if(productBox[i].mode == "3"){
                                        item = item +com+productBox[i].itemId.toString();
                                      }
                                      com = ",";
                                    }
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                                      setState(() {
                                        confirmSwap = "confirmSwap";
                                      });
                                      addprimarylocation(currentBranch,val,item);
                                    });

                                  } else {
                                    var com ="";
                                    String val = "";
                                    String item = "";
                                    for(int i = 0; i < productBox.length; i++){
                                      val = val+com+productBox[i].itemId.toString();
                                      if(productBox[i].mode == "3"){
                                        item = item + com + productBox[i].itemId.toString();
                                      }
                                      com = ",";
                                    }
                                    Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
                                      Navigator.of(context).pop();
                                      if (PrefUtils.prefs!.getString("formapscreen") == "" ||
                                          PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
                                        if (PrefUtils.prefs!.containsKey("fromcart")) {
                                          if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
                                            PrefUtils.prefs!.remove("fromcart");
                                            if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                              // _dialogforaddress(context);
                                              MapWeb(context);
                                            }
                                            else {
                                              Navigation(context, name: Routename.MapScreen,
                                                  navigatore: NavigatoreTyp.Push);
                                            }
                                            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                          } else {
                                            Navigation(context, navigatore: NavigatoreTyp.homenav);
                                          }
                                        } else {
                                          Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                                              qparms: {
                                                "val" : val,
                                                "currentbranch": currentBranch,
                                                "item":item

                                              });
                                        }
                                      } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {

                                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                                          AddressWeb(context,
                                            addresstype: "new",
                                            addressid: "",);
                                        }
                                        else {
                                          Navigation(context,
                                              name: Routename.AddressScreen,
                                              navigatore: NavigatoreTyp.Push,
                                              qparms: {
                                                'addresstype': "new",
                                                'addressid': "",
                                              });
                                        }
                                      }
                                    });
                                  }
                                },
                                child: new Container(
                                    height: 30.0,
                                    width: MediaQuery.of(context).size.width * 35 / 100,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(color: Theme.of(context).primaryColor,)
                                    ),
                                    child: new Center(
                                      child: Text(S .of(context).confirm,//"CONFIRM",
                                        style: TextStyle(color: Colors.white),),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                        ],
                      )
                  ),
                );
              }
          );
        });
  }

  Future<void> addprimarylocation(String currentBranch, String val, String item) async {

    var url = IConstants.API_PATH + 'add-primary-location';
    try {
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": PrefUtils.prefs!.getString("apikey"),
        "latitude": _lat.toString(),
        "longitude": _lng.toString(),
        "area": _address,
        "branch": PrefUtils.prefs!.getString('branch'),
      });
      final responseJson = json.decode(response.body);
      if (responseJson["data"].toString() == "true") {
        (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
        (VxState.store as GroceStore).userData.area = _address.toString();
        (VxState.store as GroceStore).userData.delevrystatus = responseJson["data"].toString() == "true"?true:false;
        Navigator.of(context).pop();
        if (PrefUtils.prefs!.getString("formapscreen") == "" ||
            PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
          if (PrefUtils.prefs!.containsKey("fromcart")) {
            if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
              PrefUtils.prefs!.remove("fromcart");
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                // _dialogforaddress(context);
                MapWeb(context);
              }
              else {
                Navigation(context, name: Routename.MapScreen,
                    navigatore: NavigatoreTyp.Push);
              }
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            } else {
              Navigation(context, navigatore: NavigatoreTyp.homenav);
            }
          } else if(confirmSwap == "confirmSwap" ){
            Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                qparms: {
                  "val" : val,
                  "currentbranch": currentBranch,
                  "item":item

                });
          }else {
            HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                PrefUtils.prefs!.getString("tokenid"),
                branch: (VxState.store as GroceStore).userData.branch ?? "999",
                rows: "0");
            Navigation(context, navigatore: NavigatoreTyp.homenav);
          }
        }
        else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
            AddressWeb(context,
              addresstype: "new",
              addressid: "",);
          }
          else {
            Navigation(context, name: Routename.AddressScreen,
                navigatore: NavigatoreTyp.Push,
                qparms: {
                  'addresstype': "new",
                  'addressid': "",
                });
          }
        }

      }
    } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }
  }

  void showInSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
        content: new Text(IConstants.APP_NAME +
            S .of(context).not_yet_available,//" is not yet available at you current location!!!"
        )));
  }
}




//web......

// import 'package:flutter/material.dart';
//
// import '../../assets/ColorCodes.dart';
// import '../../assets/images.dart';
// import '../../constants/IConstants.dart';
// import '../../constants/api.dart';
// import '../../constants/features.dart';
// import '../../controller/mutations/home_screen_mutation.dart';
// import '../../controller/mutations/login.dart';
// import '../../data/hiveDB.dart';
// import '../../generated/l10n.dart';
// import '../../main.dart';
// import '../../models/newmodle/cartModle.dart';
// import '../../providers/cartItems.dart';
// import '../../rought_genrator.dart';
// import 'dart:async';
// import 'dart:convert';
// // import 'FakeUi.dart' if (dart.library.html) 'RealUi.dart' as ui;
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' hide Point, Events;
// import 'dart:io' as Platform;
//
// import 'package:geolocator/geolocator.dart';
// import '../../controller/mutations/address_mutation.dart';
// import '../../models/VxModels/VxStore.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import 'package:flutter_google_places_web/flutter_google_places_web.dart';
// import 'package:google_maps/google_maps.dart' hide Icon;
// import 'package:hive/hive.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:flutter/rendering.dart';
//
// import '../../screens/address_screen.dart';
// import '../../screens/map_screen.dart';
// import '../../utils/ResponsiveLayout.dart';
// import '../../utils/prefUtils.dart';
// import '../Address_display.dart';
//
//
// class NewMapComponent extends StatefulWidget {
//   String? valnext = "";
//   String? moveNext = "";
//   Map<String,String>? mapscreen;
//   NewMapComponent(this.valnext,this.moveNext,this.mapscreen);
//
//   @override
//   State<NewMapComponent> createState() => _NewMapComponentState();
// }
//
// class _NewMapComponentState extends State<NewMapComponent> with Navigations{
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   List<CartItem> productBox=[];
//   double? _lat, _lng;
//   String _address = "";
//   String _fullAddress = "";
//   bool _permissiongrant = false;
//   int count = 0;
//   //int htmlId = 1;
//   bool _isWeb =false;
//   bool _isSpinkit = true;
//   //SharedPreferences prefs;
//   static String kGoogleApiKey = IConstants.googleApiKey;//"AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E";
//   MediaQueryData? queryData;
//   double? wid;
//   double? maxwid;
//   LatLng? myLatlng ;
//
//   Marker? marker;
//   String confirmSwap="";
//   GMap? map;
//   String? currentBranch;
//   var addressdata;
//   BuildContext? navigatorecontext;
//   void initState() {
//     // productBox = Hive.box<Product>(productBoxName);
//     //PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.getInt("htmlId") + 1);
//     PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.containsKey("htmlId") ? PrefUtils.prefs!.getInt("htmlId")! : 1 + 1);
//     try {
//       // String os = Platform.operatingSystem;
//       if (Platform.Platform.isIOS) {
//         setState(() {
//           _isWeb = false;
//         });
//       } else {
//         setState(() {
//           _isWeb = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isWeb = true;
//       });
//
//     }
//
//     Future.delayed(Duration.zero, () async {
//       //prefs  = await SharedPreferences.getInstance();
//       PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.containsKey("htmlId") ? PrefUtils.prefs!.getInt("htmlId")! + 1 : 1 + 1);
//       setState(() {
//         // _child = SpinKitPulse(
//         //   color: Colors.grey,
//         //   size: 100.0,
//         // );
//         success1(
//             double.parse(PrefUtils.prefs!.getString("latitude")!),
//             double.parse(PrefUtils.prefs!.getString("longitude")!)
//         );
//       });
//
//
//     });
//
//
//     getCurrentLocation();
//     productBox = (VxState.store as GroceStore).CartItemList;
//     super.initState();
//   }
//
//
//   Widget printAddress(BuildContext context, i, String addressid) {
//     print("adress type"+addressdata.billingAddress[i].addressType.toString());
//     if (addressdata.billingAddress[i].isdefault == '1') {
//
//       return GestureDetector(
//         onTap: () async {
//           debugPrint("inside isdefalut");
//           success1(double.parse(addressdata.billingAddress[i].lattitude), double.parse(addressdata.billingAddress[i].logingitude));
//           debugPrint("_address in printaddress"+_address.toString());
//           var url = IConstants.API_PATH + 'add-primary-location';
//           debugPrint("value,,,"+{
//             // await keyword is used to wait to this operation is complete.
//             "id": PrefUtils.prefs!.getString("apikey"),
//             "latitude":addressdata.billingAddress[i].lattitude.toString(),
//             "longitude": addressdata.billingAddress[i].logingitude.toString(),
//             "area": _address,
//             "branch": PrefUtils.prefs!.getString('branch'),
//             "ref": IConstants.isEnterprise && Features.ismultivendor ? IConstants.refIdForMultiVendor : IConstants.refIdForMultiVendor,
//             "branchtype": IConstants.isEnterprise && Features.ismultivendor ? IConstants.branchtype.toString() : IConstants.branchtype.toString(),    }.toString());
//           final response = await http.post(url, body: {
//             // await keyword is used to wait to this operation is complete.
//             "id": PrefUtils.prefs!.getString("apikey"),
//             "latitude": addressdata.billingAddress[i].lattitude.toString(),
//             "longitude": addressdata.billingAddress[i].logingitude.toString(),
//             "area": _address,
//             "branch": PrefUtils.prefs!.getString('branch'),
//           });
//           final responseJson = json.decode(response.body);
//           print("response add primary..."+responseJson.toString()+ (VxState.store as GroceStore).userData.branch.toString() + currentBranch.toString());
//
//           debugPrint("confirmSwap..."+ confirmSwap);
//           if (responseJson["data"].toString() == "true") {
//             // debugPrint("address tapped"+addressdata.billingAddress[i].latitude.toString());
//
//             (VxState.store as GroceStore).userData.branch =
//                 PrefUtils.prefs!.getString('branch');
//             (VxState.store as GroceStore).userData.area = _address.toString();
//             // (VxState.store as GroceStore).userData.delevrystatus =
//             //responseJson["data"].toString() == "true" ? true : false;
//           }
//
//           Navigator.of(context).pop(true);
//         },
//         child: Container(
//           //height: 100,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(width: 20,),
//               (addressdata.billingAddress[i].addressType == "home")? Image.asset(Images.homeConfirm,
//                 height: 20,
//                 width: 20,
//                 color: ColorCodes.blackColor,
//               ):(addressdata.billingAddress[i].addressType == "Work")?Image.asset(Images.locationImage,
//                 height: 20,
//                 width: 20,
//                 color: ColorCodes.blackColor,
//               ):Image.asset(Images.locationImage,
//                 height: 20,
//                 width: 20,
//                 color: ColorCodes.blackColor,
//               ),
//               SizedBox(width: 5,),
//               Flexible(
//                   fit: FlexFit.loose,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       // Padding(padding: EdgeInsets.only(top: 5)),
//                       SizedBox(height: 5,),
//
//                       new RichText(textAlign: TextAlign.start,
//                         text: new TextSpan(
//
//                           // Note: Styles for TextSpans must be explicitly defined.
//                           // Child text spans will inherit styles from parent
//                           style: new TextStyle(
//                             fontSize: 15.0,
//                             color: Colors.grey,
//                           ),
//                           children: <TextSpan>[
//                             new TextSpan(text: /*addressitemsData.items[i]*/addressdata.billingAddress[i].addressType+"\n",
//                               style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
//                             new TextSpan(
//                                 text: addressdata.billingAddress[i].address,
//                                 style:new TextStyle(fontSize: 14)
//                               // style: new TextStyle(color: ColorCodes.darkgreen),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   )),
//             ],
//           ),
//         ),
//       );
//     }
//     else {
//
//       return GestureDetector(
//         onTap: () async {
//           debugPrint("inside else isdefalut");
//           AddressController addressController = AddressController();
//           await addressController.setdefult(addressId: addressid,branch: PrefUtils.prefs!.getString('branch'));
//           success1(double.parse(addressdata.billingAddress[i].lattitude), double.parse(addressdata.billingAddress[i].logingitude));
//           debugPrint("_address in printaddress"+_address.toString());
//           var url = IConstants.API_PATH + 'add-primary-location';
//           debugPrint("value,,,"+{
//             // await keyword is used to wait to this operation is complete.
//             "id": PrefUtils.prefs!.getString("apikey"),
//             "latitude":addressdata.billingAddress[i].lattitude.toString(),
//             "longitude": addressdata.billingAddress[i].logingitude.toString(),
//             "area": _address,
//             "branch": PrefUtils.prefs!.getString('branch'),
//             "ref": IConstants.isEnterprise && Features.ismultivendor ? IConstants.refIdForMultiVendor : IConstants.refIdForMultiVendor,
//             "branchtype": IConstants.isEnterprise && Features.ismultivendor ? IConstants.branchtype.toString() : IConstants.branchtype.toString(),    }.toString());
//           final response = await http.post(url, body: {
//             // await keyword is used to wait to this operation is complete.
//             "id": PrefUtils.prefs!.getString("apikey"),
//             "latitude": addressdata.billingAddress[i].lattitude.toString(),
//             "longitude": addressdata.billingAddress[i].logingitude.toString(),
//             "area": _address,
//             "branch": PrefUtils.prefs!.getString('branch'),
//           });
//           final responseJson = json.decode(response.body);
//           print("response add primary..."+responseJson.toString()+ (VxState.store as GroceStore).userData.branch.toString() + currentBranch.toString());
//
//           debugPrint("confirmSwap..."+ confirmSwap);
//           if (responseJson["data"].toString() == "true") {
//             // debugPrint("address tapped"+addressdata.billingAddress[i].latitude.toString());
//
//             (VxState.store as GroceStore).userData.branch =
//                 PrefUtils.prefs!.getString('branch');
//             (VxState.store as GroceStore).userData.area = _address.toString();
//             // (VxState.store as GroceStore).userData.delevrystatus =
//             //responseJson["data"].toString() == "true" ? true : false;
//           }
//           Navigator.of(context).pop(true);
//         },
//         child: Container(
//           // height: 100,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(width: 20,),
//               (addressdata.billingAddress[i].addressType == "home")? Image.asset(Images.homeConfirm,
//                 height: 20,
//                 width: 20,
//                 color: ColorCodes.blackColor,
//               ):(addressdata.billingAddress[i].addressType == "Work")?Image.asset(Images.locationImage,
//                 height: 20,
//                 width: 20,
//                 color: ColorCodes.blackColor,
//               ):Image.asset(Images.locationImage,
//                 height: 20,
//                 width: 20,
//                 color: ColorCodes.blackColor,
//               ),
//               SizedBox(width: 5,),
//               Flexible(
//                   fit: FlexFit.tight,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       new RichText(
//                         textAlign: TextAlign.start,
//                         text: new TextSpan(
//
//                           // Note: Styles for TextSpans must be explicitly defined.
//                           // Child text spans will inherit styles from parent
//                           style: new TextStyle(
//                             fontSize: 15.0,
//                             color: Colors.grey,
//                           ),
//                           children: <TextSpan>[
//                             new TextSpan(text: addressdata.billingAddress[i].addressType+"\n",
//                               style:new TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: ColorCodes.blackColor), ),
//                             new TextSpan(
//                                 text: addressdata.billingAddress[i].address,
//                                 style:new TextStyle(fontSize: 14)
//                               // style: new TextStyle(color: ColorCodes.darkgreen),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   )),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   success(Position pos) {
//     try {
//       setState(() {
//         PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.getInt("htmlId")! + 1);
//         // success1(_lat, _lng);
//         success1(pos.latitude, pos.longitude,);
//       });
//
//     } catch (ex) {}
//   }
// //AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E
//   Future<void> success1(
//       double latitude,
//       double longitude,
//       ) async {
//     const _host = 'https://maps.google.com/maps/api/geocode/json';
//     String apiKey = IConstants.googleApiKey+"&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";
//
//     final uri = await Uri.parse('$_host?key=$apiKey&latlng=$latitude,$longitude');
//     http.Response response = await http.get(uri);
//
//
//     final responseJson = json.decode(utf8.decode(response.bodyBytes));
//
//     final resultJson = json.encode(responseJson['results']);
//     final resultJsondecode = json.decode(resultJson);
//
//     List data = []; //list for categories
//
//     resultJsondecode.asMap().forEach((index, value) =>
//         data.add(resultJsondecode[index] as Map<String, dynamic>));
//
//     final addressJson = json.encode(data[0]['address_components']);
//     final addressJsondecode = json.decode(addressJson);
//
//     List dataAddress = []; //list for categories
//
//     addressJsondecode.asMap().forEach((index, value) =>
//         dataAddress.add(addressJsondecode[index] as Map<String, dynamic>));
//     setState(() {
//       for (int i = 1; i < dataAddress.length; i++) {
//         setState(() {
//           if (i == 1) {
//             if (i == dataAddress.length - 1) {
//               _fullAddress = dataAddress[i]["long_name"];
//             } else {
//               _fullAddress = dataAddress[i]["long_name"] + ", ";
//             }
//           } else {
//             if (i == dataAddress.length - 1) {
//               _fullAddress = _fullAddress + dataAddress[i]["long_name"];
//             } else {
//               _fullAddress = _fullAddress + dataAddress[i]["long_name"] + ", ";
//             }
//           }
//
//           setState(() {
//             _address = dataAddress[dataAddress.length - 4]["long_name"];
//
//           });
//           // _addresstoLatLong(_address);
//         });
//       }
//     });
//
//
//     setState(() {
//
//       _permissiongrant = true;
//       _lat = latitude;
//       _lng = longitude;
//       myLatlng = new LatLng(latitude, longitude);
//       _isSpinkit = false;
//       //_child = mapWidget( LatLng(latitude, longitude));
//     });
//   }
//
//
//
//   void getCurrentLocation() async {
//     // getCurrentPosition(allowInterop((pos) => success(pos.coords)));
//     //  getCurrentPosition(allowInterop((pos) => ));
//     Geolocator.getCurrentPosition().then((value) {
//       success(value);
//     });
//
//   }
//   Future<void> _addresstoLatLong(String address) async {
//     String createdViewUpdate = "7";
//
//     const _host = 'https://maps.google.com/maps/api/geocode/json';
//     String apiKey =
//         IConstants.googleApiKey + "&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";
//
//     final uri = Uri.parse('$_host?key=$apiKey&address=$address');
//     http.Response response = await http.get(uri);
//     final responseJson = json.decode(utf8.decode(response.bodyBytes));
//
//     final resultJson = json.encode(responseJson['results']);
//     final resultJsondecode = json.decode(resultJson);
//
//     final geometryJson = json.encode(resultJsondecode[0]["geometry"]);
//     final geometryJsondecode = json.decode(geometryJson);
//
//     final locationJson = json.encode(geometryJsondecode['location']);
//     final locationJsondecode = json.decode(locationJson);
//     Navigator.pop(context);
//     setState(() {
//       setState(() {
//         _lat = locationJsondecode["lat"];
//         _lng = locationJsondecode["lng"];
//       });
//
//       setState(() {
//         // ++htmlId;
//         PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.getInt("htmlId")! + 1);
//       });
//       success1(_lat!, _lng!);
//       // _child = mapWidget();
//       myLatlng = new LatLng(_lat, _lng);
//       final mapOptions = new MapOptions()
//         ..zoom = 18
//         ..center = new LatLng(_lat, _lng);
//
//       final elem = DivElement()
//       // ..id = htmlId as String
//         ..id = PrefUtils.prefs!.getInt("htmlId") as String
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';
//
//       final map = new GMap(elem, mapOptions);
//
//       final marker = Marker(MarkerOptions()
//         ..position = myLatlng
//         ..clickable = true
//         ..draggable = true
//         ..map = map
//         ..title = S .of(context).product_delivered_here,//'Your Products will be delivered here'
//       );
//
//       marker.onDragend.listen((position) async {
//         var latttt = position.latLng.lat;
//         var longgg = position.latLng.lng;
//         success1(position.latLng.lat.toDouble(), position.latLng.lng.toDouble());
//       });
//       //this.htmlId = createdViewUpdate as int;
//       PrefUtils.prefs!.setInt("htmlId", createdViewUpdate as int);
//       setState(() {
//         _lat = MapOptions().center.lat! as double?;
//         _lng = MapOptions().center.lng as double?;
//         // myLatlng = MapOptions().center;
//       });
//       // return elem;
//     }
//     );
//   }
//
//
//   _dialogforProcessing() {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AbsorbPointer(
//               child: Container(
//                 color: Colors.transparent,
//                 height: double.infinity,
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           });
//         });
//   }
//
//   _dialogforChangeLocation() {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(3.0)),
//               child: Container(
//                 height: 250.0,
//                 width: 300.0,
//                 margin: EdgeInsets.only(
//                     left: 50.0, top: 20.0, right: 50.0, bottom: 20.0),
//                 child: GestureDetector(
//                   onTap: () async {
//
//                     setState(() {
//                       _fullAddress = FlutterGooglePlacesWeb.value['name']!;
//                       _address = FlutterGooglePlacesWeb.value['streetAddress']!;
//                     });
//                     _addresstoLatLong(FlutterGooglePlacesWeb.value['name']!);
//                   },
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         flex: 9,
//                         child: Container(
//                           height: 250.0,
//                           width: 300.0,
//                           margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
//                           child: FlutterGooglePlacesWeb(
//                             apiKey: kGoogleApiKey,
//                             proxyURL: "https://groce-bay.herokuapp.com/",
//                             // apiKey: "AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E",
//                             //proxyURL: 'https://cors-anywhere.herokuapp.com/',
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 5,),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         margin: EdgeInsets.only(top: 40,),
//                         height: 30,
//                         width: 60,
//                         child: Center(child: Text(S .of(context).submit,//'SUBMIT',
//                           style: TextStyle(fontSize: 13,color: Colors.white),)),
//                       )
//                       /* Flexible(
//                         flex: 1,
//                         child: Container(
//                           margin: EdgeInsets.only(
//                             top: 58,
//                           ),
//                           child: Icon(
//                             Icons.arrow_forward,
//                             size: 20.0,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),*/
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     queryData = MediaQuery.of(context);
//     wid= queryData!.size.width;
//     maxwid=wid!*0.90;
//
//     return Scaffold(
//       backgroundColor: ColorCodes.whiteColor,
//       resizeToAvoidBottomInset: false,
//       key: _scaffoldKey,
//       //bottomNavigationBar: _bottemnavigation(),
//       body:   Stack(
//
//         children: [
//
//           // //Text("Testing....."),
//           // _isSpinkit ?
//           // SpinKitPulse(
//           //   color: Colors.grey,
//           //   size: 100.0,
//           // )
//           //     :
//           // mapWidget(LatLng(_lat,_lng)),
//           // //_child,
//           //
//           // //mapWidget(),
//
//           Column(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 50.0,
//                 color: ColorCodes.whiteColor,
//                 padding: EdgeInsets.only(left: 20.0,top:30),
//                 child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       S .of(context).set_delivery_locations,//"Sign in",
//                       style: TextStyle(
//                           color: ColorCodes.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0),
//                     )),
//               ),
//               ValueListenableBuilder(valueListenable: IConstants.currentdeliverylocation, builder: (context, value, widget){
//                 return GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () async {
//
//
//                     // Prediction p = await PlacesAutocomplete.show(
//                     //     context: context,  mode:Mode.overlay, apiKey:(Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey);
//                     // displayPrediction(p);
//
//                     if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                       // _dialogforaddress(context);
//                       MapWeb(context,valnext: "",isdisplayprediction: "1");
//                     }
//                     else {
//                       Navigation(context, name: Routename.MapScreen,
//                           navigatore: NavigatoreTyp.Push,
//                           qparms: {
//                             "valnext": "",
//                             "isdisplayprediction": 1
//                           });
//                     }
//
//
//                   },
//                   child: Container(
//                     height: 50,
//                     margin: const EdgeInsets.only(left:10.0,right:10.0,top:30),
//                     width: MediaQuery.of(context).size.width ,
//                     decoration: BoxDecoration(
//                         color: ColorCodes.whiteColor,//Color(0xffF1F1F1),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: ColorCodes.lightGreyWebColor)
//                     ),
//                     padding: EdgeInsets.only(left: 7,right: 10,),
//
//                     child: Row(
//                       children: [
//                         SizedBox(width: 7,),
//                         Icon(
//                             Icons.search,
//                             color: ColorCodes.primaryColor,
//                             size: 24
//                         ),
//                         SizedBox(width: 5),
//                         Text(
//                           S.current.search_for_area,
//                           style: TextStyle(
//                             color: ColorCodes.grey,
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         //SizedBox(width: MediaQuery.of(context).size.width),
//
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//               SizedBox(height:20),
//
//               GestureDetector(
//                 onTap:(){
//                   if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                     // _dialogforaddress(context);
//                     MapWeb(context,valnext: "");
//                   }
//                   else {
//                     Navigation(
//                         context, name: Routename.MapScreen, navigatore: NavigatoreTyp.Push,
//                         qparms: {
//                           "valnext": "",
//                         });
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     SizedBox(width:30),
//                     Column(
//                       children: [
//                         Icon(
//                             Icons.gps_fixed,
//                             color: ColorCodes.badgecolor,
//                             size: 20
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 5),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           S.current.use + " " + S.current.current_location,//" Search From 10,000+ products",
//                           style: TextStyle(
//                             color: ColorCodes.black,
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         // Text(
//                         //   S.current.using_gps,//" Search From 10,000+ products",
//                         //   style: TextStyle(
//                         //     color: ColorCodes.blackColor,
//                         //     fontSize: 12.0,
//                         //     fontWeight: FontWeight.w600,
//                         //   ),
//                         // ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//
//               _bodymobile(),
//             ],
//           ),
//
//           Positioned(
//             right: 10,
//             top: 5,
//             child: GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: CircleAvatar(
//                 radius: 14.0,
//                 backgroundColor: ColorCodes.whiteColor,
//                 child: Icon(Icons.close, color: ColorCodes.black),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget mapWidget(LatLng latLng) {
//
//     // ignore: undefined_prefixed_name
//     bool val = ui.platformViewRegistry.registerViewFactory(String.fromCharCode(PrefUtils.prefs!.getInt("htmlId")!), (int viewId) {
//       // myLatlng = new LatLng(_lat, _lng);
//       final mapOptions = new MapOptions()
//         ..zoom = 18
//         ..center = latLng;
//
//       final elem = DivElement()
//         ..id = String.fromCharCode(PrefUtils.prefs!.getInt("htmlId")!)
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';
//
//       map = new GMap(elem, mapOptions);
//       map!.onCenterChanged.listen((event) {
//         success1(map!.center.lat.toDouble(), map!.center.lng.toDouble());
//         setState(() {
//           myLatlng = map!.center;
//         });
//         marker = Marker(MarkerOptions()
//           ..position = myLatlng
//           ..clickable = true
//           ..draggable = true
//           ..map = map
//           ..visible = false
//           ..title = S .of(context).product_delivered_here,//'Your Products will be delivered here'
//         );
//         marker!.onDragend.listen((position) async {
//           var latttt = position.latLng.lat;
//           var longgg = position.latLng.lng;
//
//           success1(position.latLng.lat.toDouble(), position.latLng.lng.toDouble());
//         });
//
//       });
//
//
//       return elem;
//     });
//
//
//     return Column(
//       children: <Widget>[
//         Container(
//           // flex: 7,
//           child: Expanded(
//             child: Stack(children: <Widget>[
//               HtmlElementView(
//                 viewType: String.fromCharCode(PrefUtils.prefs!.getInt("htmlId")!),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Icon(Icons.location_pin,color: Colors.redAccent,size: 30,),
//               ),
//             ]
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> checkLocation() async {
//     // imp feature in adding async is the it automatically wrap into Future.
//     // var url = IConstants.API_PATH + 'check-location';
//   //  var url = IConstants.isEnterprise && Features.ismultivendor?Api.checkLocationmultivendor:IConstants.API_PATH + 'check-location';
//     try {
//       /*final response = await http.post(url, body: {
//         // await keyword is used to wait to this operation is complete.
//         "lat": _lat.toString(),
//         "long": _lng.toString(),
//         "branch" : PrefUtils.prefs!.getString("branch"),
//       });
// */
//
//       final response = await http.post(Api.checkLocationmultivendor, body: {
//         "lat": _lat.toString(),
//         "long": _lng.toString(),
//         "branch" : PrefUtils.prefs!.getString("branch"),
//         "ref": /*IConstants.isEnterprise && Features.ismultivendor?*/IConstants.refIdForMultiVendor.toString()/*:""*/,
//         "branchtype": /*IConstants.isEnterprise && Features.ismultivendor?*/IConstants.branchtype.toString()/*:""*/,
//       });
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       final responseJson = json.decode(response.body);
//       bool _isCartCheck = false;
//       if (responseJson['status'].toString() == "yes") {
//         PrefUtils.prefs!.setString('defaultlocation', "true");
//         PrefUtils.prefs!.setString("isdelivering","true");
//         currentBranch = responseJson['branch'].toString();
//         if(PrefUtils.prefs!.getString("branch") == responseJson['branch'].toString()) {
//           IConstants.deliverylocationmain.value = _address;
//           IConstants.currentdeliverylocation.value = S .of(context).location_available;
//           if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
//             final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//             Navigator.of(context).pop();
//             Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
//               'addresstype': "new",
//               'addressid': "",
//               'delieveryLocation': _address,
//               'latitude': _lat.toString(),
//               'longitude': _lng.toString(),
//               'branch': responseJson['branch'].toString(),
//               'houseNo' : routeArgs['houseNo'],
//               'apartment' : routeArgs['apartment'],
//               'street' :  routeArgs['street'],
//               'landmark' : routeArgs['landmark'],
//               'area' : routeArgs['area'],
//               'pincode' : routeArgs['pincode'],
//             });
//           } else {
//             PrefUtils.prefs!.setString('branch', responseJson['branch'].toString());
//             PrefUtils.prefs!.setString('deliverylocation', _address);
//             PrefUtils.prefs!.setString("latitude", _lat.toString());
//             PrefUtils.prefs!.setString("longitude", _lng.toString());
//             if (PrefUtils.prefs!.getString("skip") == "no") {
//               addprimarylocation("","");
//             } else {
//               Navigator.of(context).pop();
//               if (PrefUtils.prefs!.getString("formapscreen") == "" ||
//                   PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
//                 if (PrefUtils.prefs!.containsKey("fromcart")) {
//                   if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
//                     PrefUtils.prefs!.remove("fromcart");
//                     /*Navigator.of(context).pushNamedAndRemoveUntil(
//                         MapScreen.routeName,
//                         ModalRoute.withName(CartScreen.routeName));*/
//
//                     if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                       // _dialogforaddress(context);
//                       MapWeb(context);
//                     }
//                     else {
//                       Navigation(context, name: Routename.MapScreen,
//                           navigatore: NavigatoreTyp.Push);
//                     }
//                     /* Navigator.of(context).pushReplacementNamed(
//                       CartScreen.routeName,
//                     );*/
//                     Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
//                   } else {
//                     //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                     Navigation(context, navigatore: NavigatoreTyp.homenav);
//                   }
//                 } else {
//                   HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
//                       PrefUtils.prefs!.getString("tokenid"),
//                       branch: (VxState.store as GroceStore).userData.branch ?? "999",
//                       rows: "0");
//                   Navigation(context, navigatore: NavigatoreTyp.homenav);
//                   //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                 }
//               }
//             }
//           }
//         } else {
//           if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
//             final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//             Navigator.of(context).pop();
//             Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
//               'addresstype': "new",
//               'addressid': "",
//               'delieveryLocation': _address,
//               'latitude': _lat.toString(),
//               'longitude': _lng.toString(),
//               'branch': responseJson['branch'].toString(),
//               'houseNo' : routeArgs['houseNo'],
//               'apartment' : routeArgs['apartment'],
//               'street' :  routeArgs['street'],
//               'landmark' : routeArgs['landmark'],
//               'area' : routeArgs['area'],
//               'pincode' : routeArgs['pincode'],
//             });
//           } else {
//             if (productBox.length > 0) { //Suppose cart is not empty
//               _dialogforAvailability(
//                   PrefUtils.prefs!.getString("branch")!,
//                   responseJson['branch'].toString(),
//                   PrefUtils.prefs!.getString("deliverylocation")!,
//                   PrefUtils.prefs!.getString("latitude")!,
//                   PrefUtils.prefs!.getString("longitude")!);
//             } else {
//               PrefUtils.prefs!.setString('branch', responseJson['branch'].toString());
//               PrefUtils.prefs!.setString('deliverylocation', _address);
//               PrefUtils.prefs!.setString("latitude", _lat.toString());
//               PrefUtils.prefs!.setString("longitude", _lng.toString());
//               if (PrefUtils.prefs!.getString("skip") == "no") {
//
//                 final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//                 String val = "";
//                 val = widget.valnext!;//routeArgs['valnext']!;
//                 addprimarylocation(responseJson['branch'].toString(),val);
//               } else {
//                 (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
//                 (VxState.store as GroceStore).userData.area = _address.toString();
//                 (VxState.store as GroceStore).userData.delevrystatus = responseJson["status"].toString() == "yes"?true:false;
//                 Navigator.of(context).pop();
//                 if (PrefUtils.prefs!.getString("formapscreen") == "" ||
//                     PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
//                   if (PrefUtils.prefs!.containsKey("fromcart")) {
//                     if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
//                       PrefUtils.prefs!.remove("fromcart");
//                       /* Navigator.of(context).pushNamedAndRemoveUntil(
//                           MapScreen.routeName,
//                           ModalRoute.withName(CartScreen.routeName));*/
//                       if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                         // _dialogforaddress(context);
//                         MapWeb(context);
//                       }
//                       else {
//                         Navigation(context, name: Routename.MapScreen,
//                             navigatore: NavigatoreTyp.Push);
//                       }
//
//                       /*Navigator.of(context).pushReplacementNamed(
//                         CartScreen.routeName,
//                       );*/
//                       Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
//                     } else {
//                       Navigation(context, navigatore: NavigatoreTyp.homenav);
//                       //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                     }
//                   } else {
//                     HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
//                         PrefUtils.prefs!.getString("tokenid"),
//                         branch: (VxState.store as GroceStore).userData.branch ?? "999",
//                         rows: "0");
//                     Navigation(context, navigatore: NavigatoreTyp.homenav);
//                     //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                   }
//                 } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
//                   Navigator.of(context)
//                       .pushReplacementNamed(
//                       AddressScreen.routeName, arguments: {
//                     'addresstype': "new",
//                     'addressid': "",
//                   });
//                 }
//               }
//             }
//           }
//         }
//       } else {
//         Navigator.of(context).pop();
//         PrefUtils.prefs!.setString("isdelivering","false");
//         IConstants.currentdeliverylocation.value = S .of(context).not_available_location;
//         showInSnackBar();
//       }
//     } catch (error) {
//       throw error;
//     }
//   }
//
//   _dialogforAvailability(String prevBranch, String currentBranch, String deliveryLocation, String latitude, String longitude) async {
//     String itemCount = "";
//     itemCount = "   " + productBox.length.toString() + " " + S .of(context).items;//"items";
//     bool _checkMembership = false;
//     //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if(PrefUtils.prefs!.getString("membership") == "1"){
//       _checkMembership = true;
//     } else {
//       _checkMembership = false;
//     }
//
//     return showDialog(context: context,
//         builder: (context) {
//           return StatefulBuilder(
//               builder: (context, setState) {
//                 return Dialog(
//                   insetPadding: EdgeInsets.only(left: 20.0, right: 20.0),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0)
//                   ),
//                   child: Container(
//                       height: MediaQuery.of(context).size.height * 85 / 100,
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.only(left: 10.0, right: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           SizedBox(height: 10.0,),
//                           new RichText(
//                             text: new TextSpan(
//                               // Note: Styles for TextSpans must be explicitly defined.
//                               // Child text spans will inherit styles from parent
//                               style: new TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(text: S .of(context).Availability_Check,//"Availability Check",
//                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),),
//                                 new TextSpan(text: itemCount, style: TextStyle(color: Colors.grey, fontSize: 12.0)
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10.0,),
//                           Text(S .of(context).changing_area,//"Changing area",
//                             style: TextStyle(color: Colors.red, fontSize: 12.0,),),
//                           SizedBox(height: 10.0,),
//                           Text(S .of(context).product_price_availability,//"Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.",
//                             style: TextStyle(fontSize: 12.0),),
//                           Spacer(),
//                           SizedBox(height: 5.0,),
//                           Divider(),
//                           SizedBox(height: 5.0,),
//
//                           Row(
//                             children: <Widget>[
//                               Container(
//                                 width: 53.0,
//                               ),
//                               Expanded(
//                                 flex: 4,
//                                 child: Text(S .of(context).items,//"Items",
//                                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),),
//
//                               Expanded(
//                                 flex: 4,
//                                 child: Row(
//                                   children: <Widget>[
//                                     SizedBox(width: 15.0,),
//                                     Text(S .of(context).reason,//"Reason",
//                                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5.0,),
//                           Divider(),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 30 / 100,
//                             child: new ListView.builder(
//                               //physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: productBox.length,
//                                 itemBuilder: (_, i) => Row(
//                                   children: <Widget>[
//                                     FadeInImage(
//                                       image: NetworkImage(productBox[i].itemImage!),
//                                       placeholder: AssetImage(Images.defaultProductImg),
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     SizedBox(
//                                       width: 3.0,
//                                     ),
//                                     Expanded(
//                                       flex: 4,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(productBox[i].itemName!, style: TextStyle(fontSize: 12.0)),
//                                           SizedBox(height: 3.0,),
//                                           _checkMembership ?
//                                           (productBox[i].membershipPrice == '-' || productBox[i].membershipPrice! == "0")
//                                               ?
//                                           (double.parse(productBox[i].price!)) <= 0 ||
//                                               (double.parse(productBox[i].price!).toString() == "" ||
//                                                   productBox[i].price ==
//                                                       productBox[i].varMrp)
//                                               ?
//                                           Text(IConstants.currencyFormat + " " + productBox[i].varMrp.toString(), style: TextStyle(fontSize: 12.0))
//                                               :
//                                           Text(IConstants.currencyFormat + " " + productBox[i].price.toString(), style: TextStyle(fontSize: 12.0))
//                                               :
//                                           Text(IConstants.currencyFormat + " " + productBox[i].membershipPrice!, style: TextStyle(fontSize: 12.0))
//                                               :
//
//                                           (double.parse(productBox[i].price!) <= 0 ||
//                                               productBox[i].price.toString() == "" ||
//                                               productBox[i].price == productBox[i].varMrp)
//                                               ?
//                                           Text(IConstants.currencyFormat + " " + productBox[i].varMrp.toString(), style: TextStyle(fontSize: 12.0))
//                                               :
//                                           Text(IConstants.currencyFormat + " " + productBox[i].price.toString(), style: TextStyle(fontSize: 12.0))
//                                         ],
//                                       ),
//                                     ),
//
//                                     Expanded(
//                                         flex: 4,
//                                         child: Text(S .of(context).not_available,//"Not available",
//                                             style: TextStyle(fontSize: 12.0))),
//                                   ],
//                                 )
//                             ),
//                           ),
//                           SizedBox(height: 10.0,),
//                           Divider(),
//                           SizedBox(height: 20.0,),
//                           new RichText(
//                             text: new TextSpan(
//                               // Note: Styles for TextSpans must be explicitly defined.
//                               // Child text spans will inherit styles from parent
//                               style: new TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                               children: <TextSpan>[
//                                 new TextSpan(text: S .of(context).note,//'Note: ',
//                                     style: TextStyle(fontWeight: FontWeight.bold, )),
//                                 new TextSpan(text: S .of(context).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20.0,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).pop();
//                                   if (PrefUtils.prefs!.getString("formapscreen") == "" ||
//                                       PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
//                                     if (PrefUtils.prefs!.containsKey("fromcart")) {
//                                       if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
//                                         PrefUtils.prefs!.remove("fromcart");
//                                         /*Navigator.of(context).pushNamedAndRemoveUntil(
//                                             MapScreen.routeName,
//                                             ModalRoute.withName(CartScreen.routeName));*/
//                                         if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                                           // _dialogforaddress(context);
//                                           MapWeb(context);
//                                         }
//                                         else {
//                                           Navigation(context, name: Routename.MapScreen,
//                                               navigatore: NavigatoreTyp.Push);
//                                         }
//
//                                         /* Navigator.of(context).pushReplacementNamed(
//                                           CartScreen.routeName,
//                                         );*/
//                                         Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
//                                       } else {
//                                         Navigation(context, navigatore: NavigatoreTyp.homenav);
//                                         //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                       }
//                                     } else {
//                                       Navigation(context, navigatore: NavigatoreTyp.homenav);
//                                       //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                     }
//                                   } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
//                                     Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
//                                       'addresstype': "new",
//                                       'addressid': "",
//                                     });
//                                   }                               },
//                                 child: new Container(
//                                   width: MediaQuery.of(context).size.width * 35 / 100,
//                                   height: 30.0,
//                                   decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey)
//                                   ),
//                                   child: new Center(
//                                     child: Text(S .of(context).map_cancel,//"CANCEL"
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 20.0,),
//                               GestureDetector(
//                                 onTap: () async {
//
//                                   PrefUtils.prefs!.setString('branch', currentBranch);
//                                   PrefUtils.prefs!.setString('deliverylocation', _address);
//                                   PrefUtils.prefs!.setString("latitude", _lat.toString());
//                                   PrefUtils.prefs!.setString("longitude", _lng.toString());
//                                   if (PrefUtils.prefs!.getString("skip") == "no") {
//                                     //Hive.box<Product>(productBoxName).deleteFromDisk();
//
//                                     var com ="";
//                                     String val = "";
//                       String item = "";
//                                     for(int i = 0; i < productBox.length; i++){
//                                       val = val+com+productBox[i].itemId.toString();
//                      if(productBox[i].mode == "3"){
//                          item = item + com + productBox[i].itemId.toString();
//                                   }
//                                       com = ",";
//                                     }
//                                     Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
//                                       Hive.box<Product>(productBoxName).clear();
//                                       setState(() {
//                                         confirmSwap = "confirmSwap";
//                                       });
//                                       addprimarylocation(currentBranch,val);
//                                     });
//                                   } else {
//                                     var com ="";
//                                     String val = "";
//                                      String item = "";
//                                     for(int i = 0; i < productBox.length; i++){
//                                       val = val+com+productBox[i].itemId.toString();
//                                      if(productBox[i].mode == "3"){
//                                         item = item + com + productBox[i].itemId.toString();
//                                        }
//                                       com = ",";
//                                     }
//                                     Provider.of<CartItems>(context, listen: false).emptyCart().then((_) {
//                                       //Hive.box<Product>(productBoxName).deleteFromDisk();
//                                       //Hive.box<Product>(productBoxName).clear();
//                                       Navigator.of(context).pop();
//                                       if (PrefUtils.prefs!.getString("formapscreen") == "" ||
//                                           PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
//                                         if (PrefUtils.prefs!.containsKey("fromcart")) {
//                                           if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
//                                             PrefUtils.prefs!.remove("fromcart");
//                                             /*Navigator.of(context).pushNamedAndRemoveUntil(
//                                                 MapScreen.routeName,
//                                                 ModalRoute.withName(CartScreen.routeName));*/
//                                             if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                                               // _dialogforaddress(context);
//                                               MapWeb(context);
//                                             }
//                                             else {
//                                               Navigation(context, name: Routename.MapScreen,
//                                                   navigatore: NavigatoreTyp.Push);
//                                             }
//
//                                             /*Navigator.of(context).pushReplacementNamed(
//                                               CartScreen.routeName,
//                                             );*/
//                                             Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
//                                           } else {
//                                             Navigation(context, navigatore: NavigatoreTyp.homenav);
//                                             //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                           }
//                                         } else {
//                                           /* Navigator.of(context)
//                                               .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
//                                             "currentBranch": currentBranch,
//                                             "val" : val
//                                           });*/
//                                           Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
//                                               parms: {
//                                                 "val" : val,
//                                                 "currentbranch": currentBranch,
//
//                                               });
//                                           // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                                         }
//                                       } else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
//                                         /*Navigator.of(context)
//                                             .pushReplacementNamed(AddressScreen.routeName, arguments: {
//                                           'addresstype': "new",
//                                           'addressid': "",
//                                         });*/
//                                         Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
//                                             qparms: {
//                                               'addresstype': "new",
//                                               'addressid': "",
//                                             });
//                                       }
//                                     });
//                                   }
//                                 },
//                                 child: new Container(
//                                     height: 30.0,
//                                     width: MediaQuery.of(context).size.width * 35 / 100,
//                                     decoration: BoxDecoration(
//                                         color: Theme.of(context).primaryColor,
//                                         border: Border.all(color: Theme.of(context).primaryColor,)
//                                     ),
//                                     child: new Center(
//                                       child: Text(S .of(context).confirm,//"CONFIRM",
//                                         style: TextStyle(color: Colors.white),),
//                                     )),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 20.0,),
//                         ],
//                       )
//                   ),
//                 );
//               }
//           );
//         });
//   }
//   Future<void> addprimarylocation(String currentBranch, String val) async {
//     // String moveNext = "";
//     // String valnext ;
//     // final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//     // /*if(/*routeArgs['moveNext']*/widget.moveNext == null || /*routeArgs['moveNext']*/widget.moveNext == ""){
//     //   moveNext = "";
//     //   valnext = "";
//     // }else{
//     //   moveNext = widget.moveNext;//routeArgs['moveNext'] ;
//     //   valnext = widget.valnext;//routeArgs['valnext'];
//     // }*/
//
//     var url = IConstants.API_PATH + 'add-primary-location';
//     try {
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//       final response = await http.post(url, body: {
//         // await keyword is used to wait to this operation is complete.
//         /* "id": PrefUtils.prefs!.getString("userID"),
//         "latitude": _lat.toString(),
//         "longitude": _lng.toString(),
//         "area": _address,
//         "branch": PrefUtils.prefs!.getString('branch'),*/
//         "id": PrefUtils.prefs!.getString("apikey"),
//         "latitude": _lat.toString(),
//         "longitude": _lng.toString(),
//         "area": _address,
//         "branch": PrefUtils.prefs!.getString('branch'),
//         "ref": IConstants.refIdForMultiVendor,
//         "branchtype": IConstants.branchtype.toString(),
//       });
//       final responseJson = json.decode(response.body);
//       if (responseJson["data"].toString() == "true") {
//         (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
//         (VxState.store as GroceStore).userData.area = _address.toString();
//         (VxState.store as GroceStore).userData.delevrystatus = responseJson["data"].toString() == "true"?true:false;
//         Navigator.of(context).pop();
//         if (PrefUtils.prefs!.getString("formapscreen") == "" ||
//             PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
//           if (PrefUtils.prefs!.containsKey("fromcart")) {
//             if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
//               PrefUtils.prefs!.remove("fromcart");
//               /*Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
//                   ModalRoute.withName(CartScreen.routeName));*/
//               if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                 // _dialogforaddress(context);
//                 MapWeb(context);
//               }
//               else {
//                 Navigation(context, name: Routename.MapScreen,
//                     navigatore: NavigatoreTyp.Push);
//               }
//               /*Navigator.of(context).pushReplacementNamed(
//                 CartScreen.routeName,
//               );*/
//               Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
//             } else {
//               Navigation(context, navigatore: NavigatoreTyp.homenav);
//               // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//             }
//           } else if(confirmSwap == "confirmSwap" ){
//             /* Navigator.of(context)
//                 .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
//               "currentBranch": currentBranch,
//               "val": val
//             });*/
//             Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
//                 parms: {
//                   "val" : val,
//                   "currentbranch": currentBranch,
//
//                 });
//           }/*else if(moveNext == "confirmSwap" && PrefUtils.prefs!.getString("formapscreen") == "homescreen"){
//             Navigator.of(context)
//                 .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
//               "currentBranch": currentBranch,
//               "val": valnext
//             });
//          }*/
//           else {
//             if( val == ""){
//               HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
//                   PrefUtils.prefs!.getString("tokenid"),
//                   branch: (VxState.store as GroceStore).userData.branch ?? "999",
//                   rows: "0");
//               Navigation(context, navigatore: NavigatoreTyp.homenav);
//               //Navigation(context, navigatore: NavigatoreTyp.homenav);
//               //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//             }else {
//
//               /* Navigator.of(context)
//                   .pushReplacementNamed(
//                   NotavailabilityProduct.routeName, arguments: {
//                 "currentBranch": currentBranch,
//                 "val": val
//               });*/
//               Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
//                   parms: {
//                     "val" : val,
//                     "currentbranch": currentBranch,
//
//                   });
//             }
//           }
//         }
//         else if (PrefUtils.prefs!.getString("formapscreen") == "addressscreen") {
//           Navigator.of(context)
//               .pushReplacementNamed(AddressScreen.routeName, arguments: {
//             'addresstype': "new",
//             'addressid': "",
//           });
//         }
//
//       }
//     } catch (error) {
//       Navigator.of(context).pop();
//       throw error;
//     }
//   }
//
//
//   void showInSnackBar() {
//     _scaffoldKey.currentState!.showSnackBar(new SnackBar(
//         content: new Text(IConstants.APP_NAME +
//             S .of(context).not_yet_available,//" is not yet available at you current location!!!"
//         )));
//   }
//
//   _bottemnavigation() {
//     return Container(
//       // flex: 3,
//         constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,
//         height: MediaQuery.of(context).size.height * 0.30,
//         //child: Container(
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 10.0,
//                 ),
//                 Text(
//                   S .of(context).select_delivery_location,//'Select delivery location',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//               ],
//             ),
//             Divider(),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 10.0,
//                 ),
//                 Text(
//                   S .of(context).your_location,//'YOUR LOCATION',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey, fontSize: 10.0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 3.0,
//             ),
//             GestureDetector(
//               onTap: () {
//                 _dialogforChangeLocation();
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Flexible(
//                     child: Row(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                         Icon(
//                           Icons.location_on,
//                           size: 20.0,
//                           color: Colors.green,
//                         ),
//                         SizedBox(
//                           width: 3.0,
//                         ),
//                         Flexible(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 _address,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 _fullAddress,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontSize: 14.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   //Spacer(),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Text(S .of(context).change_caps,//'CHANGE',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Theme.of(context).primaryColor)),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             GestureDetector(
//               onTap: () async {
//                 _dialogforProcessing();
//                 //  checkL ocation();
//                 // PrefUtils.prefs!.setString("latitude",_lat.toString());
//                 // PrefUtils.prefs!.setString("latitude", _lng.toString());
//                 /*PrimeryLocation().setDeleveryLocation(gmap.LatLng(_lat, _lng)).then((value) {
//                   if(value){
//                     // Navigator.of(context).pop();
//                     if (PrefUtils.prefs!.getString("formapscreen") == "" ||
//                         PrefUtils.prefs!.getString("formapscreen") == "homescreen") {
//                       if (PrefUtils.prefs!.containsKey("fromcart")) {
//                         if (PrefUtils.prefs!.getString("fromcart") == "cart_screen") {
//                           PrefUtils.prefs!.remove("fromcart");
//                           *//*Navigator.of(context).pushNamedAndRemoveUntil(
//                               MapScreen.routeName,
//                               ModalRoute.withName(CartScreen.routeName),arguments: {
//                             "afterlogin": ""
//                           });*//*
//                           Navigation(context, name:Routename.MapScreen,navigatore: NavigatoreTyp.Push);
//                           Navigator.of(context).pushReplacementNamed(
//                               CartScreen.routeName,arguments: {
//                             "afterlogin": ""
//                           }
//                           );
//                         } else {
//                           (VxState.store as GroceStore).homescreen.data = null;
//                           Navigation(context, navigatore: NavigatoreTyp.homenav);
//                          // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
//                         }
//                       } else {
//                         (VxState.store as GroceStore).homescreen.data = null;
//                         Navigation(context, navigatore: NavigatoreTyp.homenav);
//                         //Navigator.pushReplacementNamed(context, HomeScreen.routeName);
//                       }
//                     }
//                   }else{
//                     Navigator.of(context).pop();
//                     showInSnackBar();
//                   }
//                 });*/
//                 checkLocation();
//               },
//               child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 50.0,
//                   margin: EdgeInsets.only(
//                       left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).accentColor,
//                       borderRadius: BorderRadius.circular(3.0),
//                       border: Border(
//                         top: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         bottom: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         left: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                         right: BorderSide(
//                           width: 1.0,
//                           color: Theme.of(context).accentColor,
//                         ),
//                       )),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         S .of(context).confirm_location_proceed,//'Confirm location & Proceed',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: 18.0),
//                       ),
//                     ],
//                   )),
//             ),
//           ],
//         )
//       //  ),
//     );
//   }
//
//   _bodymobile(){
//     return VxBuilder(
//         mutations: {SetAddress,SetUserData},
//         builder: (ctx, GroceStore? store,VxStatus? state){
//           addressdata = store!.userData;
//
//           return (addressdata.billingAddress != null) ? Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     (addressdata.billingAddress.length<=0)
//                         ? SizedBox.shrink()
//                         : Expanded(child:Column(
//                       children: <Widget>[
//                         SizedBox(height:30),
//                         Row(
//                           children: [
//
//                             Text((S.current.saved_address).toUpperCase(),style:TextStyle(color:ColorCodes.blackColor,fontSize: 14,fontWeight: FontWeight.w600))
//                           ],
//                         ),
//                         SizedBox(height:10),
//                         // Expanded(
//                         //   child:
//                         //   ListView.builder(
//                         //     itemCount: addressdata.billingAddress.length,/*snapshot.data.length*/
//                         //     itemBuilder: (_, i) => Column(
//                         //       children: [
//                         //         Container(
//                         //           width:MediaQuery.of(context).size.width,
//                         //           margin: EdgeInsets.only( right: 10),
//                         //           //padding: EdgeInsets.only(right: 10),
//                         //           decoration: BoxDecoration(
//                         //             color: Colors.white,
//                         //           ),
//                         //           child: Container(
//                         //             //height: 50,
//                         //             margin: EdgeInsets.only(right: 10, ),
//                         //             child: Column(
//                         //               mainAxisAlignment: MainAxisAlignment.start,
//                         //               children: [
//                         //                 Row(
//                         //                   crossAxisAlignment: CrossAxisAlignment.start,
//                         //                   children: <Widget>[
//                         //                     Expanded(
//                         //                       child: Container(
//                         //                         padding: EdgeInsets.only(top: 15),
//                         //                         child: Column(
//                         //                           crossAxisAlignment: CrossAxisAlignment.start,
//                         //                           children: <Widget>[
//                         //                             printAddress(context, i,
//                         //                                 /*snapshot.data[i].userid*/addressdata.billingAddress[i].id.toString()),
//                         //                           ],
//                         //                         ),
//                         //                       ),
//                         //                     ),
//                         //                   ],
//                         //                 ),
//                         //               ],
//                         //             ),
//                         //           ),
//                         //         ),
//                         //         SizedBox(width:20),
//                         //         Divider(color: ColorCodes.lightGreyColor,),
//                         //         SizedBox(width:20),
//                         //         // Column(
//                         //         //     children: [
//                         //         //       SizedBox(width:20),
//                         //         //       Divider(color: ColorCodes.lightGreyColor,),
//                         //         //       SizedBox(width:20),
//                         //         //     ],
//                         //         //   ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//
//                       Expanded(
//                           child:
//                           ListView.builder(
//                             itemCount: addressdata.billingAddress.length,
//                             itemBuilder: (_, i) => Column(
//                               children: [
//                                 Container(
//                                   width:MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(left: 10, right: 10),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 10, ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//
//                                         Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: <Widget>[
//                                             Expanded(
//                                               child: Container(
//                                                 padding: EdgeInsets.only(top: 5),
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     AddressDisplay(context:
//                                                     context,
//                                                       i: i,
//                                                       billingAddressId: addressdata.billingAddress[i].id.toString(),
//                                                       fromscreen: "Mapscreen",
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//
//                                 Container(
//                                   padding: const EdgeInsets.only(left:30.0),
//                                   color: ColorCodes.whiteColor,
//                                   child: Column(
//                                     children: [
//                                       Divider(color: ColorCodes.lightGreyColor,),
//                                     ],
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                       ),
//                       ],
//                     )),
//                   ]
//               )
//           ):SizedBox.shrink();
//         }
//     );
//
//   }
//
// }

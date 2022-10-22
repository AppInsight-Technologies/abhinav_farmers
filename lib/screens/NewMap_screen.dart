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
import 'package:grocbay/widgets/mapwidget/NewMapComponent.dart';
import '../../constants/features.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../models/VxModels/VxStore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../constants/api.dart';
import '../controller/mutations/home_screen_mutation.dart';
import '../controller/mutations/login.dart';
import '../generated/l10n.dart';
import '../models/newmodle/cartModle.dart';
import '../models/swap_product.dart';
import '../rought_genrator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:location/location.dart' as loc;
import '../constants/IConstants.dart';
import '../assets/images.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../providers/cartItems.dart';
import '../widgets/addresswidget/address_info.dart';
import 'map_screen.dart';


class NewMapWeb with Navigations{
  String? valnext = "";
  String? moveNext = "";
  String? isdisplayprediction = "";
  Map<String,String>? mapscreen;
  NewMapWeb(context,{this.mapscreen,this.valnext,this.moveNext,this.isdisplayprediction}){
    _dialogfornewmap(context);
  }
  _dialogfornewmap(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/3,maxHeight: MediaQuery.of(context).size.height/2),
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: Container(
                    width: MediaQuery.of(context).size.width/3,
                    height:  MediaQuery.of(context).size.height/1.2,
                    child: NewMapComponent(valnext,moveNext,mapscreen)),
              ),
            );
          });
        }
    );

  }
}
class NewMapScreen extends StatefulWidget {
  static const routeName = '/map-screen';
  String? valnext = "";
  String? moveNext = "";
  Map<String,String>? mapscreen;
  //NewMapScreen(context,{this.mapscreen,this.valnext,this.moveNext}){}
  NewMapScreen(Map<String, String> params){
    this.mapscreen= params;
    this.valnext = params["valnext"]??"" ;
    this.moveNext = params["moveNext"]??"" ;
  }

  @override
  NewMapScreenState createState() => NewMapScreenState();
}

class NewMapScreenState extends State<NewMapScreen> with Navigations{

  @override
  Widget build(BuildContext context) {
    return NewMapComponent(widget.valnext, widget.moveNext, widget.mapscreen);
  }
}




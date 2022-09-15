

//app...............................


import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import '../../constants/features.dart';
import '../../controller/mutations/address_mutation.dart';
import '../../controller/mutations/home_screen_mutation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/cartModle.dart';
import '../../models/newmodle/user.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../providers/sellingitems.dart';
import '../../constants/api.dart';
import '../../generated/l10n.dart';
import '../../rought_genrator.dart';
import '../../assets/ColorCodes.dart';
import '../../providers/cartItems.dart';
import '../../constants/IConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../screens/map_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../data/hiveDB.dart';
import '../../main.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:search_map_place/search_map_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import '../../assets/images.dart';
import '../../models/newmodle/address.dart'as newaddress;

class AddressInfo extends StatefulWidget {
  static const routeName = '/address-screen';
  String? addresstype;
  String? addressid="";
  String? delieveryLocation="";
  String? latitude="";
  String? longitude="";
  String? branch="";
  String? houseNo="";
  String? apartment="";
  String? street="";
  String? landmark="";
  String? area="";
  String? pincode="";
  String? orderid= "";
  String? title= "";
  String? itemid="";
  String? itemname ="";
  String? itemimg ="";
  String? varname ="";
  String? varmrp = "";
  String? varprice="";
  String? paymentMode="";
  String? cronTime="";
  String? name="";
  String? varid="";
  String? brand="";
  String? deliveriesarry ="";
  String? daily="";
  String? dailyDays="";
  String? weekend="";
  String? weekendDays="";
  String? weekday="";
  String? weekdayDays="";
  String? custom="";
  String? customDays="";
  String? weight="";
  String? alternativeDays = "";
    AddressInfo(this.addresstype,this.addressid,this.delieveryLocation,this.latitude,
  this.longitude,this.branch,this.houseNo,this.apartment,this.street,this.landmark,this.area,this.pincode,
  this.orderid,this.title,this.itemid,this.itemname,this.itemimg,this.varname,this.varmrp,this.varprice,this.paymentMode,
  this.cronTime,this.name,this.varid,this.brand,this.deliveriesarry,this.daily,this.dailyDays,this.weekday,this.weekend,
  this.weekendDays,this.weekdayDays,this.custom,this.customDays,this.weight, this.alternativeDays);

  @override
  _AddressInfoState createState() => _AddressInfoState();

}

class _AddressInfoState extends State<AddressInfo> with Navigations{
  //SharedPreferences prefs;
  var _home = ColorCodes.primaryColor;
  Color _work = Colors.grey;
  Color _other = Colors.grey;
  Color _homecolor = ColorCodes.varcolor;
  Color _workcolor = ColorCodes.whiteColor;
  Color _othercolor = ColorCodes.whiteColor;
  var _addresstag = S.current.home;//"home";
  double _homeWidth = 2.0;
  double _workWidth = 1.0;
  double _otherWidth = 1.0;
  bool _isLoading = false;
  String addresstype = "";
  String addressid = "";
  String pn = "";
  final _form = GlobalKey<FormState>();
  bool _isChecked = false;
  String _deliverylocation = "";
  String _latitude = "";
  String _longitude = "";
  String _branch = "";
  var _isWeb= false;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  String fulladdress="";

  TextEditingController _controllerHouseno = new TextEditingController();
  TextEditingController _controllerApartment = new TextEditingController();
  TextEditingController _controllerStreet = new TextEditingController();
  TextEditingController _controllerLandmark = new TextEditingController();
  TextEditingController _controllerArea = new TextEditingController();
  TextEditingController _controllerPincode = new TextEditingController();
  TextEditingController _address = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController? _controller;
  Position? position;
  Widget? _child;
  double? _lat, _lng;
  String /*_address = "",*/addressLine="";
  String confirmSwap="";
  CameraPosition? cameraposition;
  Timer? timer;
  bool _serviceEnabled = false;
  bool _permissiongrant = false;
  bool _isinit = true;
  int count = 0;
  // Box<Product> productBox;
  List<CartItem> productBox=[];
  bool isKeyboardOpen = false;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey
  );

  UserData? userdata;
  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        setState(() {
          _isWeb = false;
        });
      } else {
        setState(() {
          _isWeb = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWeb = true;
      });
    }

    userdata = (VxState.store as GroceStore).userData;

    Future.delayed(Duration.zero, () async {
      //prefs = await SharedPreferences.getInstance();
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      addresstype=/*routeArgs['addresstype']*/widget.addresstype!;
      addressid = /*routeArgs['addressid']*/widget.addressid!;
      if(/*routeArgs['delieveryLocation']*/ widget.delieveryLocation== "") {

        setState(() {
          _deliverylocation = PrefUtils.prefs!.getString("deliverylocation")!;
          _latitude = PrefUtils.prefs!.getString('latitude')!;
          _longitude = PrefUtils.prefs!.getString('longitude')!;
          _branch = PrefUtils.prefs!.getString("branch")!;
        });
      } else {

        setState(() {
          _deliverylocation = /*routeArgs['delieveryLocation']*/widget.delieveryLocation!;
          _latitude = /*routeArgs['latitude']*/widget.latitude!;
          _longitude = /*routeArgs['longitude']*/widget.longitude!;
          _branch = /*routeArgs['branch']*/widget.branch!;

          _controllerHouseno.text =/* routeArgs['houseNo']*/widget.houseNo!;
          _controllerApartment.text =/* routeArgs['apartment']*/widget.apartment!;
          _controllerStreet.text = /*routeArgs['street']*/widget.street!;
          _controllerLandmark.text = /*routeArgs['landmark']*/widget.landmark!;
          _controllerArea.text = /*routeArgs['area']*/widget.area!;
          _controllerPincode.text = /*routeArgs['pincode']*/widget.pincode!;
        });
      }

      setState(() {
        _lat = double.parse(_latitude);
        _lng =  double.parse(_longitude);
        if (_controller == null) {
          _child = mapWidget();
        } else {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
            ),
          );
          getAddress(_lat, _lng);
          _child = mapWidget();
        }
      });
    });
    productBox = (VxState.store as GroceStore).CartItemList;
    _child = Column(
      children: [
        _backbutton(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinKitPulse(
                color: Colors.grey,
                size: 100.0,
              ),
            ],
          ),
        ),
      ],
    );
    timer = Timer.periodic(
        Duration(seconds: 5),
            (Timer t) => _permissiongrant
            ? !_serviceEnabled ? getCurrentLocation() : closed()
            : "");
    super.initState();
  }


  void closed() {
    timer!.cancel();
  }

  _backbutton(){
    //  final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    return  Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding:  EdgeInsets.only(top: 30),
        child: IconButton(
            icon: Icon(Icons.arrow_back, color:ColorCodes.blackColor),
            onPressed: () {
              /*if(PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen"){
                Navigator.of(context).pushReplacementNamed(
                    SubscribeScreen.routeName,arguments: {
                  "itemname": routeArgs['itemname'].toString(),
                  "itemid": routeArgs['itemid'].toString(),
                  "itemimg":routeArgs['itemimg'].toString(),
                  "varname": routeArgs['varname'].toString(),
                  "varprice": routeArgs['varprice'].toString(),
                  "paymentMode":routeArgs['paymentMode'].toString(),
                });
              }*/
              //  Navigator.of(context).pop();// Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              // return Future.value(false);
              //Navigator.of(context, rootNavigator: true).pop(context);
              Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
            }
        ),
      ),
    );
  }



  void mapForAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var addresses;
    try {
      addresses = await Geocoder.local.findAddressesFromQuery(
          prefs.getString('newaddress').toString());
    }
    catch(e){
      addresses = await Geocoder.local.findAddressesFromQuery(
          prefs.getString('deli'));
    }
    var first = addresses.first;

    setState(() {
      _lat = first.coordinates.latitude;
      _lng = first.coordinates.longitude;
      getAddress(_lat, _lng);
    });

  }

  @override
  void dispose() {
    timer!.cancel();
    _controllerHouseno.dispose();
    _controllerApartment.dispose();
    _controllerStreet.dispose();
    _controllerLandmark.dispose();
    _controllerArea.dispose();
    _controllerPincode.dispose();
    super.dispose();
  }

  _dialogforSaveadd(BuildContext context) {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: 100.0,
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(width: 40.0,),
                          Text(
                            S .of(context).saving,//'Saving...'
                          ),
                        ],
                      )
                  ),
                );
              }
          );
        });
  }



  void getCurrentLocation() async {
    // PermissionStatus permission =
    // await Premissio().requestPermissions();
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
          mode: Mode.overlay, context: context, apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey
      );
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
        if (count == 1)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  S .of(context).location_unavailable,//"Location unavailable"
                ),
                content: Text(
                  S .of(context).location_enable,//'Please enable the location from device settings.'
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      S .of(context).ok,//'Ok'
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
    } else {
      Position res = await Geolocator.getCurrentPosition();
      setState(() {
        position = res;
        _lat = position!.latitude;
        _lng = position!.longitude;

        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(_lat, _lng), zoom: 16.0),
          ),
        );
        _child = mapWidget();
      });
      await getAddress(_lat, _lng);
    }
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId(
            S .of(context).markerID,//"home"
          ),
          position: LatLng(_lat, _lng),
          draggable: false,
//          icon: BitmapDescriptor.,
          infoWindow:
          InfoWindow(title: S .of(context).product_delivered_here,//"Your Products will be delivered here"
          )),
    ].toSet();
  }

  List<Placemark>? placemark;

  getAddress( double? latitude, double? longitude) async {
    loc.Location location = new loc.Location();
    var temp = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = temp;
    });
    if (!_serviceEnabled) {
      checkusergps();
    }
    placemark =
    await placemarkFromCoordinates(latitude!, longitude!);

    setState(() async {
      // _address=_deliverylocation;
      if (placemark![0].subLocality.toString() == "") {
        if (placemark![0].locality.toString() == "") {
          // _address = "";
          addressLine="";
          _child = mapWidget();
        } else {
          // _address = placemark[0].locality.toString();
          final coordinates = new Coordinates(_lat, _lng);
          var addresses;
          addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

          var first = addresses.first;


          setState(() {


            _address.text = (first.featureName!=null)?(first.featureName):first.featureName;
            addressLine=first.addressLine;
          });

          _child = mapWidget();
        }
      } else {
        var addresses;
        addresses = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(_lat, _lng));

        var first = addresses.first;
        setState(() {
          _address.text = (first.featureName!=null)?(first.featureName):first.featureName;
          addressLine=first.addressLine;
        });
        _child = mapWidget();
      }
    });
  }

  Future<void> _onCameraMove(CameraPosition position) async {
    setState(() {
      _lat = position.target.latitude;
      _lng = position.target.longitude;

    });
  }

  Future<void> _onCameraIdle() async {
    await getAddress(_lat, _lng);
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

          getAddress(_lat, _lng);
          _child = mapWidget();
        }
      });

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
              title: Text(
                S .of(context).location_unavailable,//"Location unavailable"
              ),
              content: Text(
                S .of(context).location_enable,//'Please enable the location from device settings.'
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    S .of(context).ok,//'Ok'
                  ),
                  onPressed: () async {
                    setState(() {
                      count = 0;
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      await getAddress(_lat, _lng);

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


  _saveaddress() async {
    print("lat long......"+_lat.toString()+"hgfhdsjdsd"+_lng.toString());
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    PrefUtils.prefs!.setString('newaddresstype', _addresstag);
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _dialogforSaveadd(context);
      setState(() {
        _isLoading = true;
      });

      String apartment;
      String street;
      String landmark;
      String pincode;

      if(_controllerApartment.text == "") {
        apartment = "";
      } else {
        apartment = "," + _controllerApartment.text;
      }

      if(_controllerStreet.text == "") {
        street = "";
      } else {
        street = ", " + _controllerStreet.text;
      }

      if(_controllerLandmark.text == "") {
        landmark = "";
      } else {
        landmark = ", " + _controllerLandmark.text;
      }

      if(_controllerPincode.text == "") {
        pincode = "";
      } else {
        pincode = ", " + _controllerPincode.text;
      }

      PrefUtils.prefs!.setString('newaddress', (_controllerHouseno.text + apartment + street + landmark + ", " + _controllerArea.text + ", " + addressLine + " - " + pincode));
      fulladdress=(_controllerHouseno.text + _controllerArea.text + ", " + addressLine);
      print("addressLine...."+addressLine.toString());
      bool _checkmembership = false;
      final cartItemList =(VxState.store as GroceStore).CartItemList;
      for (int i = 0; i < cartItemList.length; i++) {
        if (cartItemList[i].mode == "1") {
          _checkmembership = true;
        }
      }
      if(addresstype == "edit") {
        AddressController addressController = AddressController();
        await addressController.update(newaddress.Address(id: int.parse(addressid),customer: PrefUtils.prefs!.getString("apikey"),pincode: pincode,fullName: userdata!.username,address: fulladdress,addressType: _addresstag,lattitude:_lat.toString(),logingitude: _lng.toString(),isdefault: "1",),(value){
          //Provider.of<AddressItemsList>(context,listen: false).UpdateAddress(addressid, _lat.toString(), _lng.toString(), _branch).then((_) {
          // Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_)
          if(value){
            _isLoading = false;
            Navigator.of(context).pop();
            if (PrefUtils.prefs!.containsKey("addressbook")) {
              if (PrefUtils.prefs!.getString("addressbook") == "AddressbookScreen") {
                PrefUtils.prefs!.setString("addressbook", "");
                Navigator.of(context).pop();
                /* Navigator.of(context).pushReplacementNamed(
                    AddressbookScreen.routeName);*/
                Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.PushReplacment);
              }else if (PrefUtils.prefs!.getString("addressbook") == "returnscreen") {
                /*Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                  'orderid': routeArgs['orderid'],
                  'title':routeArgs['title'],
                });*/
                Navigation(context, name:Routename.Return,navigatore: NavigatoreTyp.Push,
                    parms: {
                      'orderid': /*routeArgs['orderid']!*/widget.orderid!,
                      'title':/*routeArgs['title']*/widget.title!,
                    }
                );

              } else if (PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen") {
                PrefUtils.prefs!.setString("addressbook", "");
                /*  Navigator.of(context).pushReplacementNamed(
                    SubscribeScreen.routeName,arguments: {
                  "itemname": routeArgs['itemname'].toString(),
                  "itemid": routeArgs['itemid'].toString(),
                  "itemimg":routeArgs['itemimg'].toString(),
                  "varname": routeArgs['varname'].toString(),
                  "varprice": routeArgs['varprice'].toString(),
                  "paymentMode":routeArgs['paymentMode'].toString(),
                  "cronTime": routeArgs['cronTime'].toString(),
                  "name": routeArgs['name'].toString(),
                  "varid": routeArgs['varid'].toString(),
                  "varmrp":routeArgs['varmrp'].toString(),
                  "brand": routeArgs['brand'].toString()
                  //"varid": routeArgs['varid'].toString(),
                });*/
                Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      "itemname": widget.itemname,
                      "itemid": widget.itemid,
                      "itemimg":widget.itemimg,
                      "varname": widget.varname,
                      "varprice": widget.varprice,
                      "paymentMode":widget.paymentMode,
                      "cronTime": widget.cronTime,
                      "name": widget.name,
                      "varid": widget.varid,
                      "varmrp":widget.varmrp,
                      "brand": widget.brand,
                      "deliveriesarray":widget.deliveriesarry,
                      "daily":widget.daily,
                      "dailyDays":widget.dailyDays,
                      "weekend": widget.weekend,
                      "weekendDays": widget.weekendDays,
                      "weekday": widget.weekday,
                      "weekdayDays":widget.weekdayDays,
                      "custom": widget.custom,
                      "customDays": widget.customDays,
                      "weight": widget.weight
                      //"varid": routeArgs['varid'].toString(),
                    });
              }else {
                Navigator.of(context).pop();
                /*   Navigator.of(context).pushReplacementNamed(
                    ConfirmorderScreen.routeName,
                    arguments: {
                      "prev": "address_screen",
                    }
                );*/
                Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                    parms:{"prev": "address_screen"});
              }
            }
            else {
              Navigator.of(context).pop();
              /*    Navigator.of(context).pushReplacementNamed(
                  ConfirmorderScreen.routeName,
                  arguments: {
                    "prev": "address_screen",
                  }
              );*/
              Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                  parms:{"prev": "address_screen"});
            }
          }
        });
      }
      else {
        print('helooo,,,,,');
        AddressController addressController = AddressController();
        await addressController.add(newaddress.Address(customer: PrefUtils.prefs!.getString("apikey"),pincode: pincode,fullName: userdata!.username,address: fulladdress,addressType: _addresstag,lattitude:_lat.toString(),logingitude: _lng.toString(),isdefault: "1",),(value){
          if(value){
            print('helooo1,,,,,');
            Navigator.of(context).pop();
            if (PrefUtils.prefs!.containsKey("addressbook")) {
              if (PrefUtils.prefs!.getString("addressbook") == "AddressbookScreen") {
                PrefUtils.prefs!.setString("addressbook", "");
                Navigator.of(context).pop();
                /*  Navigator.of(context).pushReplacementNamed(
                    AddressbookScreen.routeName);*/
                Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.PushReplacment);
              }else if (PrefUtils.prefs!.getString("addressbook") == "returnscreen") {
                /* Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
                  'orderid': routeArgs['orderid'],
                  'title':routeArgs['title'],
                });*/
                Navigation(context, name:Routename.Return,navigatore: NavigatoreTyp.Push,
                    parms: {
                      'orderid': /*routeArgs['orderid']*/widget.orderid!,
                      'title':/*routeArgs['title']*/widget.title!,
                    }
                );
              }  else if (PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen") {
                PrefUtils.prefs!.setString("addressbook", "");
                /*      Navigator.of(context).pushReplacementNamed(
                    SubscribeScreen.routeName,arguments: {
                  "itemname": routeArgs['itemname'].toString(),
                  "itemid": routeArgs['itemid'].toString(),
                  "itemimg":routeArgs['itemimg'].toString(),
                  "varname": routeArgs['varname'].toString(),
                  "varprice": routeArgs['varprice'].toString(),
                  "paymentMode":routeArgs['paymentMode'].toString(),
                  "cronTime": routeArgs['cronTime'].toString(),
                  "name": routeArgs['name'].toString(),
                  "varid": routeArgs['varid'].toString(),
                  "varmrp":routeArgs['varmrp'].toString(),
                  "brand": routeArgs['brand'].toString()
                  //"varid": routeArgs['varid'].toString(),
                });*/
                Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      "itemname": widget.itemname,
                      "itemid": widget.itemid,
                      "itemimg":widget.itemimg,
                      "varname": widget.varname,
                      "varprice": widget.varprice,
                      "paymentMode":widget.paymentMode,
                      "cronTime": widget.cronTime,
                      "name": widget.name,
                      "varid": widget.varid,
                      "varmrp":widget.varmrp,
                      "brand": widget.brand,
                      "deliveriesarray":widget.deliveriesarry,
                      "daily":widget.daily,
                      "dailyDays":widget.dailyDays,
                      "weekend": widget.weekend,
                      "weekendDays": widget.weekendDays,
                      "weekday": widget.weekday,
                      "weekdayDays":widget.weekdayDays,
                      "custom": widget.custom,
                      "customDays": widget.customDays,
                      "weight": widget.weight
                      //"varid": routeArgs['varid'].toString(),
                    });
              }else {
                //  Navigator.of(context).pop();
                /*  Navigator.of(context).pushReplacementNamed(
                    ConfirmorderScreen.routeName,
                    arguments: {
                      "prev": "address_screen",
                    }
                );*/
                Features.ismultivendor?
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.PushReplacment,qparms: {"afterlogin":"AftercartScreen"}):
                _checkmembership?
                Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.PushReplacment,qparms: {"afterlogin":"AftercartScreen"}):
                Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                    parms:{"prev": "address_screen"});
              }
            }else {
              if (productBox.length > 0) {
                if (/*PrefUtils.prefs!.getString("mobile").toString()*/VxState.store.userData.mobileNumber != "null") {
                  PrefUtils.prefs!.setString("isPickup", "no");

                  /* Navigator.of(context).pushReplacementNamed(
                      ConfirmorderScreen.routeName,
                      arguments: {"prev": "cart_screen"});*/
                  // Navigation(context, navigatore: NavigatoreTyp.Pop);
                  Features.ismultivendor?
                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.PushReplacment,qparms: {"afterlogin":"AftercartScreen"}):
                  _checkmembership?
                  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.PushReplacment,qparms: {"afterlogin":"AftercartScreen"}):
                  Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
                      parms:{"prev": "cart_screen"});
                }
                else {


                  /*Navigator.of(context)
                      .pushNamed(LoginScreen.routeName,
                      arguments: {
                        "prev": "addressScreen"
                      });*/
                  Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push,
                      qparms: {
                        "prev": "addressScreen"
                      });
                }

              } else {
                /*Navigator.of(context).pushReplacementNamed(
                  HomeScreen.routeName,
                );*/
                Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
              }
            }
          }
        });

        // Provider.of<AddressItemsList>(context, listen: false).NewAddress(
        //     _lat.toString(), _lng.toString(), _branch).then((_) {
        //   Provider.of<AddressItemsList>(context, listen: false)
        //       .fetchAddress()
        //       .then((_) {
        //     Navigator.of(context).pop();
        //     if (PrefUtils.prefs!.containsKey("addressbook")) {
        //       if (PrefUtils.prefs!.getString("addressbook") == "AddressbookScreen") {
        //         PrefUtils.prefs!.setString("addressbook", "");
        //         Navigator.of(context).pop();
        //         Navigator.of(context).pushReplacementNamed(
        //             AddressbookScreen.routeName);
        //       }else if (PrefUtils.prefs!.getString("addressbook") == "returnscreen") {
        //         Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
        //           'orderid': routeArgs['orderid'],
        //           'title':routeArgs['title'],
        //         });
        //       }  else if (PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen") {
        //         PrefUtils.prefs!.setString("addressbook", "");
        //         Navigator.of(context).pushReplacementNamed(
        //             SubscribeScreen.routeName,arguments: {
        //           "itemname": routeArgs['itemname'].toString(),
        //           "itemid": routeArgs['itemid'].toString(),
        //           "itemimg":routeArgs['itemimg'].toString(),
        //           "varname": routeArgs['varname'].toString(),
        //           "varprice": routeArgs['varprice'].toString(),
        //           "paymentMode":routeArgs['paymentMode'].toString(),
        //           "cronTime": routeArgs['cronTime'].toString(),
        //           "name": routeArgs['name'].toString(),
        //           "varid": routeArgs['varid'].toString(),
        //           "varmrp":routeArgs['varmrp'].toString(),
        //           "brand": routeArgs['brand'].toString()
        //           //"varid": routeArgs['varid'].toString(),
        //         });
        //       }else {
        //         Navigator.of(context).pop();
        //         Navigator.of(context).pushReplacementNamed(
        //             ConfirmorderScreen.routeName,
        //             arguments: {
        //               "prev": "address_screen",
        //             }
        //         );
        //       }
        //     }else {
        //       if (productBox.length > 0) {
        //         if (PrefUtils.prefs!.getString("mobile").toString() != "null") {
        //           PrefUtils.prefs!.setString("isPickup", "no");
        //
        //           Navigator.of(context).pushReplacementNamed(
        //               ConfirmorderScreen.routeName,
        //               arguments: {"prev": "cart_screen"});
        //         }
        //         else {
        //
        //
        //           Navigator.of(context)
        //               .pushNamed(LoginScreen.routeName,
        //               arguments: {
        //                 "prev": "addressScreen"
        //               });
        //         }
        //
        //       } else {
        //         Navigator.of(context).pushReplacementNamed(
        //           HomeScreen.routeName,
        //         );
        //       }
        //     }
        //   });
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return WillPopScope(
      onWillPop: (){
        if(PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen"){
/*          Navigator.of(context).pushReplacementNamed(
              SubscribeScreen.routeName,arguments: {
            "itemname": routeArgs['itemname'].toString(),
            "itemid": routeArgs['itemid'].toString(),
            "itemimg":routeArgs['itemimg'].toString(),
            "varname": routeArgs['varname'].toString(),
            "varprice": routeArgs['varprice'].toString(),
            "paymentMode":routeArgs['paymentMode'].toString(),
            "cronTime": routeArgs['cronTime'].toString(),
            "name": routeArgs['name'].toString(),
            "varid": routeArgs['varid'].toString(),
            "varmrp":routeArgs['varmrp'].toString(),
            "brand": routeArgs['brand'].toString()
            // "varid": routeArgs['varid'].toString(),
          });*/
          Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
              qparms: {
                "itemname": widget.itemname,
                "itemid": widget.itemid,
                "itemimg":widget.itemimg,
                "varname": widget.varname,
                "varprice": widget.varprice,
                "paymentMode":widget.paymentMode,
                "cronTime": widget.cronTime,
                "name": widget.name,
                "varid": widget.varid,
                "varmrp":widget.varmrp,
                "brand": widget.brand,
                "deliveriesarray":widget.deliveriesarry,
                "daily":widget.daily,
                "dailyDays":widget.dailyDays,
                "weekend": widget.weekend,
                "weekendDays": widget.weekendDays,
                "weekday": widget.weekday,
                "weekdayDays":widget.weekdayDays,
                "custom": widget.custom,
                "customDays": widget.customDays,
                "weight": widget.weight
                // "varid": routeArgs['varid'].toString(),
              });
        }else{
          //  Navigator.of(context).pop();// Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
          Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
        }
        return Future.value(false);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,key: _scaffoldKey,bottomNavigationBar: _bottomnavigation(), body:

        Stack(
          children: [
            _child!,
            /*Positioned(
                top: 50,
                right: 5,
                child: Column(
                  children: [

                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        getCurrentLocation();
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Text(
                              'Locate me',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )),
                      ),
                    ),
                  ],
                )),*/
          ],
        ),

        ),
      ),
    );

  }

  _bottomnavigation(){
    var iskeyboardopen = false;
    setState(() {
      if(MediaQuery.of(context).viewInsets.bottom != 0){
        iskeyboardopen = true;
      }
      else{
        iskeyboardopen = false;
      }
    });
    return Container(
      // height: MediaQuery.of(context).size.height*0.48,
        height:(!iskeyboardopen)?MediaQuery.of(context).size.height*0.46:MediaQuery.of(context).size.height*0.90,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: (!iskeyboardopen)?20.0:15.0,
                ),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,bottom: 10),
                  child: Text(S.of(context).set_delivery_location.toUpperCase(),
                    style: TextStyle(fontSize: 12,color: ColorCodes.blackColor,fontWeight: FontWeight.w500),),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
//                    _settingModalBottomSheet(context);

                    Prediction p = await PlacesAutocomplete.show(
                        mode: Mode.overlay,
                        context: context,
                        apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey
                    );
                    displayPrediction(p);
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.location_on_outlined,
                        size: 20.0,
                        color: ColorCodes.blackColor,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        _address.text.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),

                      Container(
                        width: 80.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                            color: ColorCodes.varcolor,
                            border: Border(
                              top: BorderSide(width: 1, color: ColorCodes.primaryColor,),
                              bottom: BorderSide(width: 1, color: ColorCodes.primaryColor,),
                              left: BorderSide(width: 1, color: ColorCodes.primaryColor,),
                              right: BorderSide(width: 1, color: ColorCodes.primaryColor,),
                            )),
                        height: 30.0,
                        child: Center(
                          child: Text(
                              S .of(context).change_caps.toUpperCase(),//'CHANGE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left:15.0,right: 15,bottom: (iskeyboardopen) ? 4:10),
                  child: Text(addressLine.toString(),
                    style: TextStyle(fontSize: 12,color: ColorCodes.blackColor,fontWeight: FontWeight.w500),),
                ),
                Form(
                  key: _form,
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // TextFormField(
                        //   onTap: () async {
                        //     Prediction p = await PlacesAutocomplete.show(
                        //         mode: Mode.overlay,
                        //         context: context,
                        //         apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey
                        //     );
                        //     displayPrediction(p);
                        //   },
                        //   textAlign: TextAlign.left,
                        //   style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                        //   controller: _address,
                        //   decoration: InputDecoration(
                        //     labelText: "Complete Address",
                        //     labelStyle: TextStyle(color: ColorCodes.grey, fontWeight: FontWeight.w800, fontSize: 15,),
                        //     contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(6),
                        //       borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        //     ),
                        //     errorBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(6),
                        //       borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        //     ),
                        //     focusedErrorBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(6),
                        //       borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(6),
                        //       borderSide:
                        //       BorderSide(color: ColorCodes.lightgrey, width: 1.2),
                        //     ),
                        //     suffixText: S.of(context).change,
                        //     suffixStyle: TextStyle(color: ColorCodes.primaryColor, fontWeight: FontWeight.w600, fontSize: 15,),
                        //
                        //   ),
                        // ),
                        SizedBox(height: (iskeyboardopen) ? 3 : 8,),
                        Text(
                          pn,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.red),
                        ),
                        TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                          controller: _controllerHouseno,
                          decoration: InputDecoration(
                            labelText: S.of(context).address_one,//"Address 1",
                            labelStyle: TextStyle(color: ColorCodes.grey, fontWeight: FontWeight.w800, fontSize: 15,),
                            hintText: S.of(context).building_flat,//"Building / Flat Name",
                            hintStyle: TextStyle(color: ColorCodes.lightGreyColor, fontWeight: FontWeight.w600, fontSize: 15,),
                            contentPadding: EdgeInsets.only(top: 15, bottom: 0, left: 10, right: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                              BorderSide(color: ColorCodes.lightgrey, width: 1.2),
                            ),

                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                pn = "This field is required";
                              });
                              return '';
                            }
                            setState(() {
                              pn = "";
                            });
                            return null;
                          },
                          // onChanged: (value){
                          //   debugPrint("inside onchanged");
                          //   setState(() {
                          //     if(MediaQuery.of(context).viewInsets.bottom != 0){
                          //       iskeyboardopen = true;
                          //     }
                          //     else{
                          //       iskeyboardopen = false;
                          //     }
                          //   });
                          //   debugPrint("keyboard value"+iskeyboardopen.toString());
                          // },
                          onSaved: (value) {
                            //addEmailToSF(value);
                          },

                        ),

                        SizedBox(height: 10,),
                        TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.w800, fontSize: 17,),
                          controller: _controllerArea,
                          minLines: 2, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelText: S.of(context).how_to_reach,//"How to reach (optional)",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: ColorCodes.grey, fontWeight: FontWeight.w800, fontSize: 15,),
                            contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: ColorCodes.lightGreyColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                              BorderSide(color: ColorCodes.lightgrey, width: 1.2),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: (iskeyboardopen)?10:15.0,),
                      Text(
                        S .of(context).save_as,//"Save As",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: ColorCodes.grey,
                          fontWeight: FontWeight.w600,
                        ),),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20.0,bottom:5),
                  child: Row(
                    children: <Widget>[
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              _addresstag = S.current.home;//"Home";
                              _home = Theme.of(context).primaryColor;
                              _work = Colors.grey;
                              _other = Colors.grey;
                              _homecolor = ColorCodes.varcolor;
                              _workcolor = ColorCodes.whiteColor;
                              _othercolor = ColorCodes.whiteColor;
                              _homeWidth = 2.0;
                              _workWidth = 1.0;
                              _otherWidth = 1.0;
                            });
                          },
                          child: Container(
                            width: 80.0,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                color: _homecolor,
                                border: Border(
                                  top: BorderSide(width: _homeWidth, color: _home,),
                                  bottom: BorderSide(width: _homeWidth, color: _home,),
                                  left: BorderSide(width: _homeWidth, color: _home),
                                  right: BorderSide(width: _homeWidth, color: _home),
                                )),
                            height: 30.0,
                            child: Center(
                              child: Text(
                                S .of(context).home,//"Home",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              _addresstag = S.current.work;//"Work";
                              _home = Colors.grey;
                              _work = Theme.of(context).primaryColor;
                              _other = Colors.grey;

                              _homecolor = ColorCodes.whiteColor;
                              _workcolor = ColorCodes.varcolor;
                              _othercolor = ColorCodes.whiteColor;
                              _homeWidth = 1.0;
                              _workWidth = 2.0;
                              _otherWidth = 1.0;
                            });
                          },
                          child: Container(
                            width: 80.0,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                color: _workcolor,
                                border: Border(
                                  top: BorderSide(width: _workWidth, color: _work,),
                                  bottom: BorderSide(width: _workWidth, color: _work,),
                                  left: BorderSide(width: _workWidth, color: _work,),
                                  right: BorderSide(width: _workWidth, color: _work,),
                                )),
                            height: 30.0,
                            child: Center(
                              child: Text(
                                S .of(context).office,//"Office",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              _addresstag = S.current.other;//"Other";
                              _home = Colors.grey;
                              _work = Colors.grey;
                              _other = Theme.of(context).primaryColor;

                              _homecolor = ColorCodes.whiteColor;
                              _workcolor = ColorCodes.whiteColor;
                              _othercolor = ColorCodes.varcolor;
                              _homeWidth = 1.0;
                              _workWidth = 1.0;
                              _otherWidth = 2.0;
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 30.0,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                color: _othercolor,
                                border: Border(
                                  top: BorderSide(width: _otherWidth, color: _other,),
                                  bottom: BorderSide(width: _otherWidth, color: _other,),
                                  left: BorderSide(width: _otherWidth, color: _other,),
                                  right: BorderSide(width: _otherWidth, color: _other,),
                                )),
                            child: Center(
                              child: Text(
                                S .of(context).other,//"Other",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.0,
                ),
                // GestureDetector(
                //   onTap: () async {
                //
                //     Prediction p = await PlacesAutocomplete.show(
                //         mode: Mode.overlay,
                //         context: context,
                //         apiKey: (Features.ismultivendor) ? IConstants.googleApiKeyroot : IConstants.googleApiKey
                //     );
                //     displayPrediction(p);
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //       Icon(
                //         Icons.location_pin,
                //         size: 18.0,
                //         color: Colors.black,
                //       ),
                //       SizedBox(
                //         width: 3.0,
                //       ),
                //       /*Expanded(
                //         child: Text(
                //
                //           _address,
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //
                //           style: TextStyle(
                //               fontSize: 17.0, fontWeight: FontWeight.bold),
                //         ),
                //       ),*/
                //
                //       Text(S .of(context).change_caps,//'CHANGE',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontSize: 14.0,
                //
                //               color: Theme.of(context).primaryColor)),
                //       // ),
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: (iskeyboardopen)?3:10.0,
                ),
                // Divider(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal:18.0),
                //   child: Text(
                //
                //     addressLine,
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //
                //     style: TextStyle(
                //         fontSize: 14.0, fontWeight: FontWeight.normal),
                //   ),
                // ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     // Form(
                //     //   key: _form,
                //     //   child: Container(
                //     //     margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20),
                //     //     child: Column(
                //     //       children: <Widget>[
                //     //         Container(
                //     //           width: MediaQuery.of(context).size.width ,
                //     //           child: TextFormField(
                //     //             controller: _controllerHouseno,
                //     //             textAlign: TextAlign.left,
                //     //             decoration: InputDecoration(
                //     //                 labelText: S .of(context).house_flat_no,//"House /Flat /Block No.",
                //     //                 labelStyle: new TextStyle(
                //     //                   fontSize: 14.0,
                //     //                   color: Colors.black54,
                //     //                 )
                //     //             ),
                //     //             onFieldSubmitted: (_) {
                //     //
                //     //             },
                //     //             validator: (value) {
                //     //               if(value!.isEmpty) {
                //     //                 return S .of(context).please_enter_houseno;//"Please enter House no";
                //     //               }
                //     //               return null; //it means user entered a valid input
                //     //             },
                //     //           ),
                //     //         ),
                //     //
                //     //         SizedBox(height: 5.0,),
                //     //         SizedBox(height: 5.0,),
                //     //       ],
                //     //     ),
                //     //   ),
                //     // ),
                //     Container(
                //       margin: EdgeInsets.only(left: 20.0),
                //       child: Column(
                //         children: [
                //           SizedBox(height: 20.0,),
                //           Text(
                //             S .of(context).save_as,//"Save As",
                //             style: TextStyle(
                //               fontSize: 14.0,
                //               color: Colors.black54,
                //             ),),
                //           SizedBox(height: 10.0,),
                //         ],
                //       ),
                //     ),
                //
                //     Container(
                //       margin: EdgeInsets.only(left: 20.0,bottom:10),
                //       child: Row(
                //         children: <Widget>[
                //           MouseRegion(
                //             cursor: SystemMouseCursors.click,
                //             child: GestureDetector(
                //               behavior: HitTestBehavior.translucent,
                //               onTap: () {
                //                 setState(() {
                //                   _addresstag = "Home";
                //                   _home = Theme.of(context).primaryColor;
                //                   _work = Colors.grey;
                //                   _other = Colors.grey;
                //                   _homeWidth = 2.0;
                //                   _workWidth = 1.0;
                //                   _otherWidth = 1.0;
                //                 });
                //               },
                //               child: Container(
                //                 width: 60.0,
                //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),
                //                     border: Border(
                //                       top: BorderSide(width: _homeWidth, color: _home,),
                //                       bottom: BorderSide(width: _homeWidth, color: _home,),
                //                       left: BorderSide(width: _homeWidth, color: _home),
                //                       right: BorderSide(width: _homeWidth, color: _home),
                //                     )),
                //                 height: 35.0,
                //                 child: Center(
                //                   child: Text(
                //                     S .of(context).home,//"Home",
                //                     style: TextStyle(
                //                       fontSize: 14.0,
                //                       color: Colors.black54,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //           SizedBox(width: 15.0,),
                //           MouseRegion(
                //             cursor: SystemMouseCursors.click,
                //             child: GestureDetector(
                //               behavior: HitTestBehavior.translucent,
                //               onTap: () {
                //                 setState(() {
                //                   _addresstag = "Work";
                //                   _home = Colors.grey;
                //                   _work = Theme.of(context).primaryColor;
                //                   _other = Colors.grey;
                //                   _homeWidth = 1.0;
                //                   _workWidth = 2.0;
                //                   _otherWidth = 1.0;
                //                 });
                //               },
                //               child: Container(
                //                 width: 60.0,
                //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),
                //                     border: Border(
                //                       top: BorderSide(width: _workWidth, color: _work,),
                //                       bottom: BorderSide(width: _workWidth, color: _work,),
                //                       left: BorderSide(width: _workWidth, color: _work,),
                //                       right: BorderSide(width: _workWidth, color: _work,),
                //                     )),
                //                 height: 35.0,
                //                 child: Center(
                //                   child: Text(
                //                     S .of(context).office,//"Office",
                //                     style: TextStyle(
                //                       fontSize: 14.0,
                //                       color: Colors.black54,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //           SizedBox(width: 15.0,),
                //           MouseRegion(
                //             cursor: SystemMouseCursors.click,
                //             child: GestureDetector(
                //               behavior: HitTestBehavior.translucent,
                //               onTap: () {
                //                 setState(() {
                //                   _addresstag = "Other";
                //                   _home = Colors.grey;
                //                   _work = Colors.grey;
                //                   _other = Theme.of(context).primaryColor;
                //                   _homeWidth = 1.0;
                //                   _workWidth = 1.0;
                //                   _otherWidth = 2.0;
                //                 });
                //               },
                //               child: Container(
                //                 width: 60,
                //                 height: 35.0,
                //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),
                //                     border: Border(
                //                       top: BorderSide(width: _otherWidth, color: _other,),
                //                       bottom: BorderSide(width: _otherWidth, color: _other,),
                //                       left: BorderSide(width: _otherWidth, color: _other,),
                //                       right: BorderSide(width: _otherWidth, color: _other,),
                //                     )),
                //                 child: Center(
                //                   child: Text(
                //                     S .of(context).other,//"Other",
                //                     style: TextStyle(
                //                       fontSize: 14.0,
                //                       color: Colors.black54,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //
                //     SizedBox(height: 5,),
                //
                //   ],
                // ),

                GestureDetector(
                  onTap: () async {
                    _dialogforProcessing();
                    checkLocation();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:5.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        margin: EdgeInsets.only(
                          left: 10.0, top: (iskeyboardopen)?2:5.0, right: 10.0, ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12.0),
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
                              S .of(context).save_address,//'Save & Proceed',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ],
                        )),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
  Widget mapWidget() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Container(
      height:(isKeyboardOpen)?MediaQuery.of(context).size.height/4:MediaQuery.of(context).size.height/2,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 7,
              child:

              Stack(children: <Widget>[
                GoogleMap(
                    mapType: MapType.normal,
                    // markers: _createMarker(),
                    mapToolbarEnabled: true,
                    onCameraIdle: _onCameraIdle,
                    onCameraMove: _onCameraMove,
                    myLocationEnabled: true,
                    padding: (Platform.isAndroid) ? EdgeInsets.only(bottom: 10, top: MediaQuery.of(context).size.height/3, right: 0, left: 0) : null,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_lat, _lng),
                      zoom: 18.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    }
                ),
                //This is your marker
                Container(
                  padding: (Platform.isAndroid) ? EdgeInsets.only(bottom: 10, top: MediaQuery.of(context).size.height/3, right: 0, left: 0) : null,
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.location_pin,color: Colors.redAccent,size: 40,),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:  EdgeInsets.only(top: 30),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back, color:ColorCodes.blackColor),
                        onPressed: () async{
                          if(PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen"){
                            /*      Navigator.of(context).pushReplacementNamed(
                                SubscribeScreen.routeName,arguments: {
                              "itemname": routeArgs['itemname'].toString(),
                              "itemid": routeArgs['itemid'].toString(),
                              "itemimg":routeArgs['itemimg'].toString(),
                              "varname": routeArgs['varname'].toString(),
                              "varprice": routeArgs['varprice'].toString(),
                              "paymentMode":routeArgs['paymentMode'].toString(),
                              "cronTime": routeArgs['cronTime'].toString(),
                              "name": routeArgs['name'].toString(),
                              "varid": routeArgs['varid'].toString(),
                              "varmrp":routeArgs['varmrp'].toString(),
                              "brand": routeArgs['brand'].toString()
                              //"varid": routeArgs['varid'].toString(),
                            });*/
                            Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  "itemname": widget.itemname,
                                  "itemid": widget.itemid,
                                  "itemimg":widget.itemimg,
                                  "varname": widget.varname,
                                  "varprice": widget.varprice,
                                  "paymentMode":widget.paymentMode,
                                  "cronTime": widget.cronTime,
                                  "name": widget.name,
                                  "varid": widget.varid,
                                  "varmrp":widget.varmrp,
                                  "brand": widget.brand,
                                  "deliveriesarray":widget.deliveriesarry,
                                  "daily":widget.daily,
                                  "dailyDays":widget.dailyDays,
                                  "weekend": widget.weekend,
                                  "weekendDays": widget.weekendDays,
                                  "weekday": widget.weekday,
                                  "weekdayDays":widget.weekdayDays,
                                  "custom": widget.custom,
                                  "customDays": widget.customDays,
                                  "weight": widget.weight
                                  //"varid": routeArgs['varid'].toString(),
                                });
                          }else{
                            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});// Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
                          }
                          return Future.value(false);
                        }
                    ),
                  ),
                ),
              ])

          ),

        ],
      ),
    );
  }

  Future<void> checkLocation() async {

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      Navigator.of(context).pop();
      return;
    }else {
      try {
        final response = await http.post(Api.checkLocationmultivendor, body: {
          "lat": _lat.toString(),
          "long": _lng.toString(),
          "branch" : PrefUtils.prefs!.getString("branch"),
          "ref": /*IConstants.isEnterprise && Features.ismultivendor?*/IConstants.refIdForMultiVendor.toString()/*:""*/,
          "branchtype": /*IConstants.isEnterprise && Features.ismultivendor?*/IConstants.branchtype.toString()/*:""*/,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final responseJson = json.decode(response.body);
        debugPrint("checkLocation . . . ." + _lat.toString() + "......" + _lng.toString() + "........" + responseJson.toString());
        bool _isCartCheck = false;
        if (responseJson['status'].toString() == "yes") {
          if (IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor == responseJson['ref'].toString():prefs.getString("branch") == responseJson['branch'].toString()) {
            IConstants.deliverylocationmain.value = addressLine;
            IConstants.currentdeliverylocation.value = S .of(context).location_available;
            _saveaddress();

          }
          else {
            // location();
            if (prefs.getString("formapscreen") == "addressscreen") {
              final routeArgs = ModalRoute
                  .of(context)!
                  .settings
                  .arguments as Map<String, String>;
              Navigator.of(context).pop();
              /*        Navigator.of(context).pushReplacementNamed(
                  AddressScreen.routeName, arguments: {
                'addresstype': "new",
                'addressid': "",
                'delieveryLocation': addressLine,
                'latitude': _lat.toString(),
                'longitude': _lng.toString(),
                'branch': responseJson['branch'].toString(),
                'houseNo': *//*routeArgs['houseNo']*//*widget.houseNo,
                'apartment': *//*routeArgs['apartment']*//*widget.apartment,
                'street': *//*routeArgs['street']*//*widget.street,
                'landmark': *//*routeArgs['landmark']*//*widget.landmark,
                'area': *//*routeArgs['area']*//*widget.area,
                'pincode': *//*routeArgs['pincode']*//*widget.pincode,
              });*/
              Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                  qparms: {
                    'addresstype': "new",
                    'addressid': "",
                    'delieveryLocation': addressLine,
                    'latitude': _lat.toString(),
                    'longitude': _lng.toString(),
                    'branch': responseJson['branch'].toString(),
                    'houseNo': widget.houseNo,
                    'apartment':widget.apartment,
                    'street': widget.street,
                    'landmark': widget.landmark,
                    'area': widget.area,
                    'pincode': widget.pincode,
                  });
            } else {
              if (productBox.length > 0) { //Suppose cart is not empty
                _dialogforAvailability(
                    prefs.getString("branch")!,
                    responseJson['branch'].toString(),
                    prefs.getString("deliverylocation")!,
                    prefs.getString("latitude")!,
                    prefs.getString("longitude")!);
              } else {
                prefs.setString('branch', responseJson['branch'].toString());
                IConstants.deliverylocationmain.value = addressLine;
                prefs.setString('deliverylocation', addressLine);
                prefs.setString("latitude", _lat.toString());
                prefs.setString("longitude", _lng.toString());
                if (prefs.getString("skip") == "no") {
                  addprimarylocation("","","");
                } else {
                  Navigator.of(context).pop();
                  if (prefs.getString("formapscreen") == "" ||
                      prefs.getString("formapscreen") == "homescreen") {
                    if (prefs.containsKey("fromcart")) {
                      if (prefs.getString("fromcart") == "cart_screen") {
                        prefs.remove("fromcart");
                        /*Navigator.of(context).pushNamedAndRemoveUntil(
                            MapScreen.routeName,
                            ModalRoute.withName(CartScreen.routeName,),arguments: {
                          "after_login": ""
                        });*/
                        Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
                        Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                      } else {
                        /*Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);*/
                        Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                      }
                    } else {
                      /*Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routeName, (route) => false);*/
                      Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                    }
                  } else
                  if (prefs.getString("formapscreen") == "addressscreen") {
                    /* Navigator.of(context)
                        .pushReplacementNamed(
                        AddressScreen.routeName, arguments: {
                      'addresstype': "new",
                      'addressid': "",
                    });*/
                    Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
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
        else {
          Navigator.of(context).pop();
          showInSnackBar();
        }
      }
      catch (error) {
        throw error;
      }
    }
  }
  _dialogforAvailability(String prevBranch, String currentBranch, String deliveryLocation, String latitude, String longitude) async {
    String itemCount = "";
    itemCount = "   " + productBox.length.toString() + " " + S .of(context).items;//"items";
    bool _checkMembership = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("membership") == "1"){
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
                                itemBuilder: (_, i) => Row(
                                  children: <Widget>[
                                    FadeInImage(
                                      image: NetworkImage(productBox[i].itemImage!),
                                      placeholder: AssetImage(Images.defaultProductImg),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(productBox[i].itemName!, style: TextStyle(fontSize: 12.0)),
                                          SizedBox(height: 3.0,),
                                          _checkMembership ?
                                          (productBox[i].membershipPrice == '-' || productBox[i].membershipPrice == "0")
                                              ?
                                          (double.parse(productBox[i].price!) <= 0 ||
                                              productBox[i].price.toString() == "" ||
                                              productBox[i].price == productBox[i].varMrp)
                                              ?
                                          Text(Features.iscurrencyformatalign?
                                          productBox[i].varMrp.toString() + " " +  IConstants.currencyFormat :
                                          IConstants.currencyFormat + " " + productBox[i].varMrp.toString(),
                                              style: TextStyle(fontSize: 12.0))
                                              :
                                          Text(Features.iscurrencyformatalign?
                                          productBox[i].price.toString() + " " + IConstants.currencyFormat :
                                          IConstants.currencyFormat + " " + productBox[i].price.toString(),
                                              style: TextStyle(fontSize: 12.0))
                                              :
                                          Text(Features.iscurrencyformatalign?
                                          productBox[i].membershipPrice! + " " +  IConstants.currencyFormat :
                                          IConstants.currencyFormat + " " + productBox[i].membershipPrice!,
                                              style: TextStyle(fontSize: 12.0))
                                              :

                                          (double.parse(productBox[i].price!) <= 0 ||
                                              productBox[i].price.toString() == "" ||
                                              productBox[i].price == productBox[i].varMrp)
                                              ?
                                          Text(
                                              Features.iscurrencyformatalign?
                                              productBox[i].varMrp.toString() + " " + IConstants.currencyFormat :
                                              IConstants.currencyFormat + " " + productBox[i].varMrp.toString(),
                                              style: TextStyle(fontSize: 12.0))
                                              :
                                          Text(
                                              Features.iscurrencyformatalign?
                                              productBox[i].price.toString() + " " + IConstants.currencyFormat:
                                              IConstants.currencyFormat + " " + productBox[i].price.toString(), style: TextStyle(fontSize: 12.0))
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                        flex: 4,
                                        child: Text(S .of(context).not_available,//"Not available",
                                            style: TextStyle(fontSize: 12.0))),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Divider(),
                          SizedBox(height: 20.0,),
                          new RichText(
                            text: new TextSpan(

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
                                  if (prefs.getString("formapscreen") == "" ||
                                      prefs.getString("formapscreen") == "homescreen") {
                                    if (prefs.containsKey("fromcart")) {
                                      if (prefs.getString("fromcart") == "cart_screen") {
                                        prefs.remove("fromcart");
                                        /* Navigator.of(context).pushNamedAndRemoveUntil(
                                            MapScreen.routeName,
                                            ModalRoute.withName(CartScreen.routeName),arguments: {
                                          "after_login": ""
                                        });*/
                                        Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);

                                        Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
                                      } else {
                                        Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                                        // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                      }
                                    } else {
                                      Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                                      //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                    }
                                  } else if (prefs.getString("formapscreen") == "addressscreen") {
                                    /*  Navigator.of(context).pushReplacementNamed(AddressScreen.routeName, arguments: {
                                      'addresstype': "new",
                                      'addressid': "",
                                    });*/
                                    Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                        qparms: {
                                          'addresstype': "new",
                                          'addressid': "",
                                        });
                                  }                               },
                                child: new Container(
                                  width: MediaQuery.of(context).size.width * 35 / 100,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: new Center(
                                    child: Text(
                                      S .of(context).map_cancel,//"CANCEL"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0,),
                              GestureDetector(
                                onTap: () async {
                                  prefs.setString('branch', currentBranch);
                                  prefs.setString('deliverylocation', addressLine);
                                  prefs.setString("latitude", _lat.toString());
                                  prefs.setString("longitude", _lng.toString());
                                  if (prefs.getString("skip") == "no") {
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
                                      //Hive.box<Product>(productBoxName).deleteFromDisk();

                                      /* try {
                                        Hive.box<Product>(productBoxName).clear();
                                        if (Platform.isIOS || Platform.isAndroid) {
                                          //Hive.openBox<Product>(productBoxName);
                                        }
                                      } catch (e) {
                                        Hive.registerAdapter(ProductAdapter());
                                        //Hive.openBox<Product>(productBoxName);
                                      }*/
                                      setState(() {
                                        confirmSwap = "confirmSwap";
                                      });
                                      addprimarylocation(currentBranch,val,item);
                                    });
                                    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
                                    for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
                                      sellingitemData.featuredVariation[i].varQty = 0;
                                    }

                                    for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
                                      sellingitemData.itemspricevarOffer[i].varQty = 0;
                                      break;
                                    }
                                    for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
                                      sellingitemData.itemspricevarSwap[i].varQty = 0;
                                      break;
                                    }

                                    for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
                                      sellingitemData.discountedVariation[i].varQty = 0;
                                      break;
                                    }

                                    final cartItemsData = Provider.of<CartItems>(context, listen: false);
                                    for(int i = 0; i < cartItemsData.items.length; i++) {
                                      cartItemsData.items[i].itemQty = 0;
                                    }
                                  } else {
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
                                      //Hive.box<Product>(productBoxName).deleteFromDisk();
                                      Hive.box<Product>(productBoxName).clear();
                                      try {
                                        if (Platform.isIOS || Platform.isAndroid) {
                                          //await Hive.openBox<Product>(productBoxName);

                                        }
                                      } catch (e) {
                                        //await Hive.openBox<Product>(productBoxName);
                                      }
                                      Navigator.of(context).pop();
                                      if (prefs.getString("formapscreen") == "" ||
                                          prefs.getString("formapscreen") == "homescreen") {
                                        if (prefs.containsKey("fromcart")) {
                                          if (prefs.getString("fromcart") == "cart_screen") {
                                            prefs.remove("fromcart");
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
                                            Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
                                            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                          }
                                        } else {
                                          // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                                          /* Navigator.of(context)
                                              .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
                                            "currentBranch": currentBranch,
                                            "val" : val
                                          });*/
                                          Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
                                              qparms: {
                                                "val" : val,
                                                "currentbranch": currentBranch,
                                                "item":item

                                              });
                                          /* HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
                                              PrefUtils.prefs!.getString("tokenid"),
                                              branch: (VxState.store as GroceStore).userData.branch ?? "999",
                                              rows: "0");
                                          Navigation(context, *//*name:Routename.Home,*//*navigatore: NavigatoreTyp.homenav);*/
                                        }
                                      } else if (prefs.getString("formapscreen") == "addressscreen") {
                                        /*   Navigator.of(context)
                                            .pushReplacementNamed(AddressScreen.routeName, arguments: {
                                          'addresstype': "new",
                                          'addressid': "",
                                        });*/
                                        Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
                                            qparms: {
                                              'addresstype': "new",
                                              'addressid': "",
                                            });
                                      }
                                    });
                                    final sellingitemData = Provider.of<SellingItemsList>(context, listen: false);
                                    for(int i = 0; i < sellingitemData.featuredVariation.length; i++) {
                                      sellingitemData.featuredVariation[i].varQty = 0;
                                    }

                                    for (int i = 0; i < sellingitemData.itemspricevarOffer.length; i++) {
                                      sellingitemData.itemspricevarOffer[i].varQty = 0;
                                      break;
                                    }
                                    for(int i = 0; i < sellingitemData.itemspricevarSwap.length; i++) {
                                      sellingitemData.itemspricevarSwap[i].varQty = 0;
                                      break;
                                    }

                                    for(int i = 0; i < sellingitemData.discountedVariation.length; i++) {
                                      sellingitemData.discountedVariation[i].varQty = 0;
                                      break;
                                    }

                                    final cartItemsData = Provider.of<CartItems>(context, listen: false);
                                    for(int i = 0; i < cartItemsData.items.length; i++) {
                                      cartItemsData.items[i].itemQty = 0;
                                    }
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
                                      child: Text(
                                        S .of(context).confirm,//"CONFIRM",
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
    // try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("data addresss...."+{
      "id": PrefUtils.prefs!.getString("apikey"),
      "latitude": _lat.toString(),
      "longitude": _lng.toString(),
      "area": addressLine,
      "branch": prefs.getString('branch'),
    }.toString());
    final response = await http.post(Api.addPrimaryLocation, body: {
      // await keyword is used to wait to this operation is complete.
      "id": PrefUtils.prefs!.getString("apikey"),
      "latitude": _lat.toString(),
      "longitude": _lng.toString(),
      "area": addressLine,
      "branch": prefs.getString('branch'),
    });
    final responseJson = json.decode(response.body);

    if (responseJson["data"].toString() == "true") {
      (VxState.store as GroceStore).userData.branch = PrefUtils.prefs!.getString('branch');
      (VxState.store as GroceStore).userData.area = _address.toString();
      (VxState.store as GroceStore).userData.delevrystatus = responseJson["data"].toString() == "true"?true:false;
      Navigator.of(context).pop();
      if (prefs.getString("formapscreen") == "" ||
          prefs.getString("formapscreen") == "homescreen") {
        if (prefs.containsKey("fromcart")) {
          if (prefs.getString("fromcart") == "cart_screen") {
            prefs.remove("fromcart");
            /*Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
                  ModalRoute.withName(CartScreen.routeName),arguments: {
                    "after_login": ""
                  });*/
            Navigation(context,name: Routename.MapScreen, navigatore: NavigatoreTyp.Push);
            /*    Navigator.of(context).pushReplacementNamed(
                  CartScreen.routeName,arguments: {
                "afterlogin": ""
              }
              );*/
            Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
          } else {
            Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
            //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
          }
        }
        else if(confirmSwap == "confirmSwap" ){
          debugPrint("confirm swap....entered");
          /* Navigator.of(context)
                .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
              "currentBranch": currentBranch,
              "val": val
            });*/
          Navigation(context, name:Routename.NotAvailability,navigatore: NavigatoreTyp.Push,
              qparms: {
                "val" : val,
                "currentbranch": currentBranch,
                "item":item

              });
        }else {
          /* Navigator.of(context)
                .pushReplacementNamed(NotavailabilityProduct.routeName, arguments: {
              "currentBranch": currentBranch,
              "val": val
            });*/


          HomeScreenController(user: (VxState.store as GroceStore).userData.id ??
              PrefUtils.prefs!.getString("tokenid"),
              branch: (VxState.store as GroceStore).userData.branch ?? "999",
              rows: "0");
          Navigation(context, name:Routename.Home,navigatore: NavigatoreTyp.homenav);
          //  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
        }
      } else if (prefs.getString("formapscreen") == "addressscreen") {
        /*   Navigator.of(context)
              .pushReplacementNamed(AddressScreen.routeName, arguments: {
            'addresstype': "new",
            'addressid': "",
          });*/
        Navigation(context, name: Routename.AddressScreen, navigatore: NavigatoreTyp.Push,
            qparms: {
              'addresstype': "new",
              'addressid': "",
            });
      }
    }
    /* } catch (error) {
      Navigator.of(context).pop();
      throw error;
    }*/
  }

  void showInSnackBar() {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
        content: new Text(IConstants.APP_NAME +
            S .of(context).not_yet_available,//" is not yet available at you current location!!!"
        )));
  }
}

//
// webb--------------------------------------------------
//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:html' hide Point, Events;
// import 'dart:io' as Platform;
// import 'package:geolocator/geolocator.dart';
// import '../../assets/ColorCodes.dart';
// import '../../controller/mutations/address_mutation.dart';
// import '../../models/VxModels/VxStore.dart';
// import '../../models/newmodle/cartModle.dart';
// import '../../models/newmodle/user.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../constants/api.dart';
// import '../../generated/l10n.dart';
// import '../../rought_genrator.dart';
// import '../../screens/address_screen.dart';
// import '../../screens/subscribe_screen.dart';
// import '../../utils/prefUtils.dart';
// import '../../assets/images.dart';
// import '../../providers/addressitems.dart';
// import '../../screens/map_screen.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_google_places_web/flutter_google_places_web.dart';
// import 'package:google_maps/google_maps.dart' hide Icon;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hive/hive.dart';
// import 'dart:ui' as ui;
// import 'package:js/js.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../../screens/return_screen.dart';
// import '../../data/hiveDB.dart';
// import '../../main.dart';
// import '../../utils/ResponsiveLayout.dart';
// import '../../screens/login_screen.dart';
// import '../../constants/IConstants.dart';
// import '../../screens/home_screen.dart';
// import '../../screens/cart_screen.dart';
// import '../../screens/addressbook_screen.dart';
// import '../../screens/confirmorder_screen.dart';
// import '../../handler/locationJs.dart';
// import '../../models/newmodle/address.dart'as newaddress;
//
//
//
// class AddressInfo extends StatefulWidget with Navigations{
//
//   String? addresstype;
//   String? addressid="";
//   String? delieveryLocation="";
//   String? latitude="";
//   String? longitude="";
//   String? branch="";
//   String? houseNo="";
//   String? apartment="";
//   String? street="";
//   String? landmark="";
//   String? area="";
//   String? pincode="";
//   String? orderid= "";
//   String? title= "";
//   String? itemid="";
//   String? itemname ="";
//   String? itemimg ="";
//   String? varname ="";
//   String? varmrp = "";
//   String? varprice="";
//   String? paymentMode="";
//   String? cronTime="";
//   String? name="";
//   String? varid="";
//   String? brand="";
//   String? deliveriesarry ="";
//   String? daily="";
//   String? dailyDays="";
//   String? weekend="";
//   String? weekendDays="";
//   String? weekday="";
//   String? weekdayDays="";
//   String? custom="";
//   String? customDays="";
//   String? weight="";
//   String? alternativeDays = "";
//
//
//   AddressInfo(this.addresstype,this.addressid,this.delieveryLocation,this.latitude,
//   this.longitude,this.branch,this.houseNo,this.apartment,this.street,this.landmark,this.area,this.pincode,
//   this.orderid,this.title,this.itemid,this.itemname,this.itemimg,this.varname,this.varmrp,this.varprice,this.paymentMode,
//   this.cronTime,this.name,this.varid,this.brand,this.deliveriesarry,this.daily,this.dailyDays,this.weekday,this.weekend,
//   this.weekendDays,this.weekdayDays,this.custom,this.customDays,this.weight, this.alternativeDays);
//   @override
//   _AddressInfoState createState() => _AddressInfoState();
//
// }
// class _AddressInfoState extends State<AddressInfo> with Navigations{
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   //Box<Product>? productBox;
//   Widget? _child;
//   bool _isSpinkit = true;
//   double? _lat, _lng;
//   String _address = "";
//   String _fullAddress = "";
//   bool _permissiongrant = false;
//   int count = 0;
//   //int htmlId = 1;
//   bool _isWeb = false;
//   String pn = "";
//   Color _homecolor = ColorCodes.varcolor;
//   Color _workcolor = ColorCodes.whiteColor;
//   Color _othercolor = ColorCodes.whiteColor;
//   //SharedPreferences prefs;
//   static String kGoogleApiKey = /*"AIzaSyBSR3pigsWMH7goi_CthGQFckfb5QPOH8E"*/ IConstants.googleApiKey;
//   MediaQueryData? queryData;
//   double? wid;
//   double? maxwid;
//   LatLng? myLatlng;
//
//   bool _isLoading = false;
//   Marker? marker;
//   String addressid = "";
//   GMap? map;
//   String addresstype = "";
//   String _addresses = " ";
//   String orderid =" ";
//   String title =" ";
//
//   String latitude = "";
//   String _deliverylocation = "";
//   String longitude = "";
//   String branch = "";
//   Color _home = ColorCodes.primaryColor;
//   Color _work = ColorCodes.lightGreyColor;
//   Color _other =  ColorCodes.lightGreyColor;
//   var _addresstag = S.current.home;//"home";
//   double _homeWidth = 1.0;
//   double _workWidth = 1.0;
//   double _otherWidth = 1.0;
//   String addressLine = "";
//   String fulladdress="";
//
//   String _latitude = "";
//   String _longitude = "";
//   String _branch = "";
//
//   final _form = GlobalKey<FormState>();
//   TextEditingController _controllerHouseno = new TextEditingController();
//   TextEditingController _controllerApartment = new TextEditingController();
//   TextEditingController _controllerStreet = new TextEditingController();
//   TextEditingController _controllerLandmark = new TextEditingController();
//   TextEditingController _controllerArea = new TextEditingController();
//   TextEditingController _controllerPincode = new TextEditingController();
//
//   UserData? userdata;
//   List<CartItem> productBox=[];
//
//   @override
//   void initState() {
//     // productBox = Hive.box<Product>(productBoxName);
//     productBox = (VxState.store as GroceStore).CartItemList;
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
//     }
//     userdata = (VxState.store as GroceStore).userData;
//     Future.delayed(Duration.zero, () async {
//       //prefs  = await SharedPreferences.getInstance();
//       PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.getInt("htmlId")! + 1);
//       PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.containsKey("htmlId") ? PrefUtils.prefs!.getInt("htmlId")! + 1 : 1 + 1);
//       setState(() {
//         final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//         try {
//           addresstype= widget.addresstype!;//routeArgs['addresstype'];
//           addressid = widget.addressid!;//routeArgs['addressid'];
//           orderid = widget.orderid!;//routeArgs['orderid'];
//           title= widget.title!;//routeArgs['title'];
//
//
//                 if(widget.addresstype== "edit") {
//                   setState(() {
//             _deliverylocation = widget.delieveryLocation!;
//             _latitude = widget.latitude!;
//             _longitude = widget.longitude!;
//             _branch =  widget.branch!;
//
//             _controllerHouseno.text =  widget.houseNo!;
//             _controllerApartment.text =  widget.apartment!;
//             _controllerStreet.text = widget.street!;
//             _controllerLandmark.text =  widget.landmark!;
//             _controllerArea.text =  widget.area!;
//             _controllerPincode.text = widget.pincode!;
//         });
//       }
//         }catch (e){};
//       });
//       setState(() {
//         _child = SpinKitPulse(
//           color: Colors.grey,
//           size: 100.0,
//         );
//         success1(
//
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
//     super.initState();
//   }
//
//   success(pos) {
//     try {
//       setState(() {
//         PrefUtils.prefs!.setInt("htmlId", PrefUtils.prefs!.getInt("htmlId")! + 1);
//         success1(_lat!.toDouble(), _lng!.toDouble());
//         success1(pos.latitude, pos.longitude,);
//       });
//
//     } catch (ex) {}
//   }
//
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
//       _child = mapWidget( LatLng(latitude, longitude));
//     });
//   }
//
//
//
//   void getCurrentLocation() async {
//     //getCurrentPosition(allowInterop((pos) => success(pos)));
//     //Geolocator.getCurrentPosition().then((pos) => success(pos));
//     getCurrentPosition(allowInterop((pos) => success(pos)));
//   }
//
//   Future<void> _addresstoLatLong(String? address) async {
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
//
//         ..zoom = 16
//
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
//         _lng = MapOptions().center.lng! as double?;
//         // myLatlng = MapOptions().center;
//       });
//       //return elem;
//     }
//     );
//   }
//
//   _saveaddress(String _addressLine) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('newaddresstype', _addresstag);
//     // latitude = prefs.getString('latitude');
//     //longitude = prefs.getString('longitude');
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return;
//     } else {
//       _dialogforSaveadd(context);
//       setState(() {
//         _isLoading = true;
//       });
//       String apartment;
//       String street;
//       String landmark;
//       String pincode;
//       if (_controllerApartment.text == "") {
//         apartment = "";
//       } else {
//         apartment = ", " + _controllerApartment.text;
//       }
//       if (_controllerStreet.text == "") {
//         street = "";
//       } else {
//         street = ", " + _controllerStreet.text;
//       }
//       if (_controllerLandmark.text == "") {
//         landmark = "";
//       } else {
//         landmark = ", " + _controllerLandmark.text;
//       }
//       if (_controllerPincode.text == "") {
//         pincode = "";
//       } else {
//         pincode = ", " + _controllerPincode.text;
//       }
//
//       (_controllerHouseno.text.isEmpty)?
//       prefs.setString('newaddress',
//           (_controllerHouseno.text + apartment + street + landmark + " "+
//               _controllerArea.text +" "+ _addressLine.toString() + " - " +
//               pincode)):
//       prefs.setString('newaddress',
//           (_controllerHouseno.text + apartment + street + landmark + ", " +
//               _controllerArea.text + ", " + _addressLine.toString() + " - " +
//               pincode));
//       PrefUtils.prefs!.setString('newaddress', (_controllerHouseno.text + apartment + street + landmark + ", " + _controllerArea.text + ", " + addressLine + " - " + pincode));
//       fulladdress=(_controllerHouseno.text + _controllerArea.text + ", " + addressLine);
//
//       if (addresstype == "edit") {
//         AddressController addressController = AddressController();
//         await addressController.update(newaddress.Address(id: int.parse(addressid),customer: PrefUtils.prefs!.getString("apikey"),pincode: pincode,fullName: userdata!.username,address: fulladdress,addressType: _addresstag,lattitude:_lat.toString(),logingitude: _lng.toString(),isdefault: "1",),(value){
//           //Provider.of<AddressItemsList>(context,listen: false).UpdateAddress(addressid, _lat.toString(), _lng.toString(), _branch).then((_) {
//           // Provider.of<AddressItemsList>(context,listen: false).fetchAddress().then((_)
//           if(value){
//             _isLoading = false;
//             Navigator.of(context).pop();
//             if (PrefUtils.prefs!.containsKey("addressbook")) {
//               if (PrefUtils.prefs!.getString("addressbook") == "AddressbookScreen") {
//                 PrefUtils.prefs!.setString("addressbook", "");
//                 Navigator.of(context).pop();
//                 /* Navigator.of(context).pushReplacementNamed(
//                     AddressbookScreen.routeName);*/
//                 Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.PushReplacment);
//               }else if (PrefUtils.prefs!.getString("addressbook") == "returnscreen") {
//                 /*Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
//                   'orderid': routeArgs['orderid'],
//                   'title':routeArgs['title'],
//                 });*/
//                 Navigation(context, name:Routename.Return,navigatore: NavigatoreTyp.Push,
//                     parms: {
//                       'orderid': /*routeArgs['orderid']!*/orderid,
//                       'title':/*routeArgs['title']*/title,
//                     }
//                 );
//
//               } else if (PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen") {
//                 PrefUtils.prefs!.setString("addressbook", "");
//                 /*  Navigator.of(context).pushReplacementNamed(
//                     SubscribeScreen.routeName,arguments: {
//                   "itemname": routeArgs['itemname'].toString(),
//                   "itemid": routeArgs['itemid'].toString(),
//                   "itemimg":routeArgs['itemimg'].toString(),
//                   "varname": routeArgs['varname'].toString(),
//                   "varprice": routeArgs['varprice'].toString(),
//                   "paymentMode":routeArgs['paymentMode'].toString(),
//                   "cronTime": routeArgs['cronTime'].toString(),
//                   "name": routeArgs['name'].toString(),
//                   "varid": routeArgs['varid'].toString(),
//                   "varmrp":routeArgs['varmrp'].toString(),
//                   "brand": routeArgs['brand'].toString()
//                   //"varid": routeArgs['varid'].toString(),
//                 });*/
//                 Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
//                     qparms: {
//                       "itemname": widget.itemname,
//                       "itemid": widget.itemid,
//                       "itemimg":widget.itemimg,
//                       "varname": widget.varname,
//                       "varprice": widget.varprice,
//                       "paymentMode":widget.paymentMode,
//                       "cronTime": widget.cronTime,
//                       "name": widget.name,
//                       "varid": widget.varid,
//                       "varmrp":widget.varmrp,
//                       "brand": widget.brand,
//                       "deliveries":widget.deliveriesarry,
//                       "daily":widget.daily,
//                       "dailyDays":widget.dailyDays,
//                       "weekend": widget.weekend,
//                       "weekendDays": widget.weekendDays,
//                       "weekday": widget.weekday,
//                       "weekdayDays":widget.weekdayDays,
//                       "custom": widget.custom,
//                       "customDays": widget.customDays,
//                       //"varid": routeArgs['varid'].toString(),
//                     });
//               }else {
//                 Navigator.of(context).pop();
//                 /*   Navigator.of(context).pushReplacementNamed(
//                     ConfirmorderScreen.routeName,
//                     arguments: {
//                       "prev": "address_screen",
//                     }
//                 );*/
//                 Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
//                     parms:{"prev": "address_screen"});
//               }
//             }
//             else {
//               Navigator.of(context).pop();
//               /*    Navigator.of(context).pushReplacementNamed(
//                   ConfirmorderScreen.routeName,
//                   arguments: {
//                     "prev": "address_screen",
//                   }
//               );*/
//               Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
//                   parms:{"prev": "address_screen"});
//             }
//           }
//         });
//       }
//       else {
//         AddressController addressController = AddressController();
//         await addressController.add(newaddress.Address(customer: PrefUtils.prefs!.getString("apikey"),pincode: pincode,fullName: userdata!.username,address: fulladdress,addressType: _addresstag,lattitude:_lat.toString(),logingitude: _lng.toString(),isdefault: "1",),(value){
//           if(value){
//             Navigator.of(context).pop();
//             if (PrefUtils.prefs!.containsKey("addressbook")) {
//               if (PrefUtils.prefs!.getString("addressbook") == "AddressbookScreen") {
//                 PrefUtils.prefs!.setString("addressbook", "");
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 /*  Navigator.of(context).pushReplacementNamed(
//                     AddressbookScreen.routeName);*/
//                 Navigation(context, name: Routename.AddressBook, navigatore: NavigatoreTyp.PushReplacment);
//               }else if (PrefUtils.prefs!.getString("addressbook") == "returnscreen") {
//                 /* Navigator.of(context).pushNamed(ReturnScreen.routeName, arguments: {
//                   'orderid': routeArgs['orderid'],
//                   'title':routeArgs['title'],
//                 });*/
//                 Navigation(context, name:Routename.Return,navigatore: NavigatoreTyp.Push,
//                     parms: {
//                       'orderid': /*routeArgs['orderid']*/orderid,
//                       'title':/*routeArgs['title']*/title,
//                     }
//                 );
//               }  else if (PrefUtils.prefs!.getString("addressbook") == "SubscriptionScreen") {
//                 PrefUtils.prefs!.setString("addressbook", "");
//                 /*      Navigator.of(context).pushReplacementNamed(
//                     SubscribeScreen.routeName,arguments: {
//                   "itemname": routeArgs['itemname'].toString(),
//                   "itemid": routeArgs['itemid'].toString(),
//                   "itemimg":routeArgs['itemimg'].toString(),
//                   "varname": routeArgs['varname'].toString(),
//                   "varprice": routeArgs['varprice'].toString(),
//                   "paymentMode":routeArgs['paymentMode'].toString(),
//                   "cronTime": routeArgs['cronTime'].toString(),
//                   "name": routeArgs['name'].toString(),
//                   "varid": routeArgs['varid'].toString(),
//                   "varmrp":routeArgs['varmrp'].toString(),
//                   "brand": routeArgs['brand'].toString()
//                   //"varid": routeArgs['varid'].toString(),
//                 });*/
//                 Navigation(context, name: Routename.SubscribeScreen, navigatore: NavigatoreTyp.Push,
//                     qparms: {
//                       "itemname": widget.itemname,
//                       "itemid": widget.itemid,
//                       "itemimg":widget.itemimg,
//                       "varname": widget.varname,
//                       "varprice": widget.varprice,
//                       "paymentMode":widget.paymentMode,
//                       "cronTime": widget.cronTime,
//                       "name": widget.name,
//                       "varid": widget.varid,
//                       "varmrp":widget.varmrp,
//                       "brand": widget.brand,
//                       "deliveries":widget.deliveriesarry,
//                       "daily":widget.daily,
//                       "dailyDays":widget.dailyDays,
//                       "weekend": widget.weekend,
//                       "weekendDays": widget.weekendDays,
//                       "weekday": widget.weekday,
//                       "weekdayDays":widget.weekdayDays,
//                       "custom": widget.custom,
//                       "customDays": widget.customDays,
//                       //"varid": routeArgs['varid'].toString(),
//                     });
//               }else {
//                 //  Navigator.of(context).pop();
//                 /*  Navigator.of(context).pushReplacementNamed(
//                     ConfirmorderScreen.routeName,
//                     arguments: {
//                       "prev": "address_screen",
//                     }
//                 );*/
//                 Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null})
//                 :Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
//                     parms:{"prev": "address_screen"});
//               }
//             }else {
//               if (productBox.length > 0) {
//                 if (/*PrefUtils.prefs!.getString("mobile").toString()*/VxState.store.userData.mobileNumber!= "null") {
//                   PrefUtils.prefs!.setString("isPickup", "no");
//
//                   /* Navigator.of(context).pushReplacementNamed(
//                       ConfirmorderScreen.routeName,
//                       arguments: {"prev": "cart_screen"});*/
//                   /* Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
//                       parms:{"prev": "cart_screen"});*/
//                   Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?  Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null})
//                   :Navigation(context, name:Routename.ConfirmOrder,navigatore: NavigatoreTyp.Push,
//                       parms:{"prev": "cart_screen"});
//                 }
//                 else {
//
//
//                   /*Navigator.of(context)
//                       .pushNamed(LoginScreen.routeName,
//                       arguments: {
//                         "prev": "addressScreen"
//                       });*/
//                   Navigation(context, name:Routename.Login,navigatore: NavigatoreTyp.Push,
//                       qparms: {
//                         "prev": "addressScreen"
//                       });
//                 }
//
//               } else {
//                 Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                 /*Navigator.of(context).pushReplacementNamed(
//                   HomeScreen.routeName,
//                 );*/
//               }
//             }
//           }
//         });
//
//       }
//     }
//   }
//
//   _dialogforSaveadd(BuildContext context) {
//     return showDialog(context: context,
//         builder: (context) {
//           return StatefulBuilder(
//               builder: (context, setState) {
//                 return Dialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0)
//                   ),
//                   child: Container(
//                       height: 100.0,
//                       width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.20:MediaQuery.of(context).size.width,
//                       child:
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           CircularProgressIndicator(),
//                           SizedBox(width: 40.0,),
//                           Text(S .of(context).saving,//'Saving...'
//                           ),
//                         ],
//                       )
//                   ),
//                 );
//               }
//           );
//         });
//   }
//
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
//                 height: 340.0,
//                 width: 300.0,
//                 margin: EdgeInsets.only(
//                     left: 50.0, top: 20.0, right: 50.0, bottom: 20.0),
//                 child: GestureDetector(
//                   onTap: () async {
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
//                       Container(
//                         //height: 250.0,
//
//                         width:  200.0,
//
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text(
//                               S .of(context).enter_address,//'Enter Address',
//                             ),
//                             FlutterGooglePlacesWeb(
//                               apiKey: kGoogleApiKey,
//                               proxyURL: "https://groce-bay.herokuapp.com/",
//                               /*components: 'country:GU',*/
//                             ),
//
//                           ],
//                         ),
//                       ),
//
//                       SizedBox(width: 5,),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: Theme
//                               .of(context)
//                               .primaryColor,
//                         ),
//                         margin: EdgeInsets.only(top: 40,),
//                         height: 30,
//                         width: 60,
//                         child: Center(child: Text(
//                           S .of(context).submit,//'SUBMIT',
//                           style: TextStyle(
//                               fontSize: 13, color: Colors.white),)),
//                       )
//
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
//     // _lat = double.parse(prefs.getString("latitude").toString()) ;
//     // _lng = double.parse(prefs.getString("longitude").toString());
//     queryData = MediaQuery.of(context);
//     wid = queryData!.size.width;
//     maxwid = wid! * 0.90;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: gradientappbarmobile(),
//         resizeToAvoidBottomInset: true,
//         key: _scaffoldKey,
//         bottomNavigationBar: _bottemnavigation(),
//         body:
//
//         Stack(
//           children: [
//             //Text("Testing....."),
//
//             _isSpinkit ?
//             SpinKitPulse(
//               color: Colors.grey,
//               size: 100.0,
//             )
//                 :
//             mapWidget(LatLng(_lat,_lng)),
//             //_child,
//
//             //mapWidget(),
//
//           /*  Positioned(
//               top: -20,
//               child: Row(
//               children: [
//                 IconButton(icon: Icon(Icons.arrow_back,size: 20, color: ColorCodes.blackColor),onPressed: ()=>
//                     Navigator.of(context).pop(),
//                 ),
//                 Text(S .of(context).select_delivery_location,//'My Addresses',
//                   style: TextStyle(color: ColorCodes.blackColor, fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ],
//             ),),*/
//             Positioned(
//                 top: 50,
//                 right: 5,
//                 child: Column(
//                   children: [
//
//                     SizedBox(
//                       height: 5,
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         getCurrentLocation();
//                       },
//                       child: Container(
//                         height: 40,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           color: Theme
//                               .of(context)
//                               .primaryColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Center(
//                             child: Text(
//                               S .of(context).locate_me,//'Locate me',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                               ),
//                             )),
//                       ),
//                     ),
//                   ],
//                 )),
//           ],
//         ),
//
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
//           success1(position.latLng.lat.toDouble(), position.latLng.lng.toDouble());
//         });
//
//       });
//
//
//
//       return elem;
//     });
//
//
//
//     return Column(
//       children: <Widget>[
//         Container(
//            //flex: 7,
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
//   Future<void> checkLocation(String _addressLine) async {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       Navigator.of(context).pop();
//       return;
//     } else {
//       // imp feature in adding async is the it automatically wrap into Future.
//       try {
//         final response = await http.post(Api.checkLocationmultivendor, body: {
//           "lat": _lat.toString(),
//           "long": _lng.toString(),
//           "branch" : PrefUtils.prefs!.getString("branch"),
//           "ref": /*IConstants.isEnterprise && Features.ismultivendor?*/IConstants.refIdForMultiVendor.toString()/*:""*/,
//           "branchtype": /*IConstants.isEnterprise && Features.ismultivendor?*/IConstants.branchtype.toString()/*:""*/,
//         });
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         final responseJson = json.decode(response.body);
//         bool _isCartCheck = false;
//         if (responseJson['status'].toString() == "yes") {
//           if (prefs.getString("branch") == responseJson['branch'].toString()) {
//
//             prefs.setString('deliverylocation', _addressLine);
//             prefs.setString("latitude", _lat.toString());
//             prefs.setString("longitude", _lng.toString());
//             IConstants.deliverylocationmain.value = addressLine;
//             IConstants.currentdeliverylocation.value = S .of(context).location_available;
//             _saveaddress(_addressLine);
//
//           } else {
//             // location();
//             if (prefs.getString("formapscreen") == "addressscreen") {
//               final routeArgs = ModalRoute
//                   .of(context)!
//                   .settings
//                   .arguments as Map<String, String>;
//               Navigator.of(context).pop();
//               /*      Navigator.of(context).pushReplacementNamed(
//                   AddressbookScreen.routeName, arguments: {
//                 'addresstype': "new",
//                 'addressid': "",
//                 'delieveryLocation': addressLine.toString(),
//                 'latitude': _lat.toString(),
//                 'longitude': _lng.toString(),
//                 'branch': responseJson['branch'].toString(),
//                 'houseNo': routeArgs['houseNo'].toString(),
//                 'apartment': routeArgs['apartment'].toString(),
//                 'street': routeArgs['street'].toString(),
//                 'landmark': routeArgs['landmark'].toString(),
//                 'area': routeArgs['area'].toString(),
//                 'pincode': routeArgs['pincode'].toString(),
//               });*/
//               if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                 // _dialogforaddress(context);
//                 AddressWeb(context,
//                     addresstype: "new",
//                     addressid: "",
//                     delieveryLocation: addressLine,
//                     latitude: _lat.toString(),
//                     longitude: _lng.toString(),
//                     branch: responseJson['branch'].toString(),
//                     houseNo: widget.houseNo,
//                     apartment: widget.apartment,
//                     street: widget.street,
//                     landmark: widget.landmark,
//                     area: widget.area,
//                     pincode: widget.pincode,);
//               }
//               else {
//                 Navigation(context, name: Routename.AddressScreen,
//                     navigatore: NavigatoreTyp.Push,
//                     qparms: {
//                       'addresstype': "new",
//                       'addressid': "",
//                       'delieveryLocation': addressLine,
//                       'latitude': _lat.toString(),
//                       'longitude': _lng.toString(),
//                       'branch': responseJson['branch'].toString(),
//                       'houseNo': widget.houseNo,
//                       'apartment': widget.apartment,
//                       'street': widget.street,
//                       'landmark': widget.landmark,
//                       'area': widget.area,
//                       'pincode': widget.pincode,
//                     });
//               }
//             } else {
//               if (productBox.length > 0) { //Suppose cart is not empty
//                 _dialogforAvailability(
//                     prefs.getString("branch")!,
//                     responseJson['branch'].toString(),
//                     prefs.getString("deliverylocation")!,
//                     prefs.getString("latitude")!,
//                     prefs.getString("longitude")!);
//               } else {
//                 prefs.setString('branch', responseJson['branch'].toString());
//                 IConstants.deliverylocationmain.value = addressLine;
//                 prefs.setString('deliverylocation', addressLine);
//                 prefs.setString("latitude", _lat.toString());
//                 prefs.setString("longitude", _lng.toString());
//                 if (prefs.getString("skip") == "no") {
//                   addprimarylocation();
//                 } else {
//                   Navigator.of(context).pop();
//                   if (prefs.getString("formapscreen") == "" ||
//                       prefs.getString("formapscreen") == "homescreen") {
//                     if (prefs.containsKey("fromcart")) {
//                       if (prefs.getString("fromcart") == "cart_screen") {
//                         prefs.remove("fromcart");
//                         /* Navigator.of(context).pushNamedAndRemoveUntil(
//                             MapScreen.routeName,
//                             ModalRoute.withName(CartScreen.routeName));*/
//                         if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
//                           // _dialogforaddress(context);
//                           MapWeb(context);
//                         }
//                         else {
//                           Navigation(context, name: Routename.MapScreen,
//                               navigatore: NavigatoreTyp.Push);
//                         }
//                         Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
//                       } else {
//                         /*Navigator.pushNamedAndRemoveUntil(
//                             context, HomeScreen.routeName, (route) => false);*/
//                         Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                       }
//                     } else {
//                       /*Navigator.pushNamedAndRemoveUntil(
//                           context, HomeScreen.routeName, (route) => false);*/
//                       Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                     }
//                   } else
//                   if (prefs.getString("formapscreen") == "addressscreen") {
//                     /* Navigator.of(context)
//                         .pushReplacementNamed(
//                         AddressScreen.routeName, arguments: {
//                       'addresstype': "new",
//                       'addressid': "",
//                     });*/
//                     if (Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)) {
//                       // _dialogforaddress(context);
//                       AddressWeb(context,
//                         addresstype: "new",
//                         addressid: "",);
//                     }
//                     else {
//                       Navigation(context, name: Routename.AddressScreen,
//                           navigatore: NavigatoreTyp.Push,
//                           qparms: {
//                             'addresstype': "new",
//                             'addressid': "",
//                           });
//                     }
//                   }
//                 }
//               }
//             }
//           }
//         }
//         else {
//            Navigator.of(context).pop();
//           showInSnackBar();
//         }
//       }
//       catch (error) {
//         throw error;
//       }
//     }
//   }
//
//   _dialogforAvailability(String prevBranch, String currentBranch,
//       String deliveryLocation, String latitude, String longitude) async {
//     String itemCount = "";
//     itemCount = "   " + productBox.length.toString() + " " + S .of(context).items;//"items";
//     bool _checkMembership = false;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if (prefs.getString("membership") == "1") {
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
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height * 85 / 100,
//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width,
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
//                                   style: TextStyle(color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.0),),
//                                 new TextSpan(text: itemCount,
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 12.0)
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10.0,),
//                           Text(S .of(context).changing_area,//"Changing area",
//                             style: TextStyle(
//                               color: Colors.red, fontSize: 12.0,),),
//                           SizedBox(height: 10.0,),
//                           Text(
//                             S .of(context).product_price_availability,//"Product prices, availability and promos are area specific and may change accordingly. Confirm if you wish to continue.",
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
//                               Text(S .of(context).items,//"Items",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12.0),),
//
//                               Row(
//                                 children: <Widget>[
//                                   SizedBox(width: 15.0,),
//                                   Text(S .of(context).reason,//"Reason",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12.0),),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5.0,),
//                           Divider(),
//                           SizedBox(
//                             height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height * 30 / 100,
//                             child: new ListView.builder(
//                               //physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: productBox.length,
//                                 itemBuilder: (_, i) =>
//                                     Row(
//                                       children: <Widget>[
//                                         FadeInImage(
//                                           image: NetworkImage(productBox[i].itemImage!),
//                                           placeholder: AssetImage(
//                                               Images.defaultProductImg),
//                                           width: 50,
//                                           height: 50,
//                                           fit: BoxFit.cover,
//                                         ),
//                                         SizedBox(
//                                           width: 3.0,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment
//                                               .start,
//                                           mainAxisAlignment: MainAxisAlignment
//                                               .start,
//                                           children: <Widget>[
//                                             Text(productBox[i].itemName.toString(), style: TextStyle(
//                                                 fontSize: 12.0)),
//                                             SizedBox(height: 3.0,),
//                                             _checkMembership ?
//                                             (productBox[i].membershipPrice == '-' ||
//                                                 productBox[i]
//                                                     .membershipPrice == "0")
//                                                 ?
//                                             (double.parse(productBox[i].price.toString())<= 0 ||
//                                                 productBox[i].price
//                                                     .toString() == "" ||
//                                                 productBox[i].price ==
//                                                     productBox[i]
//                                                         .varMrp)
//                                                 ?
//                                             Text(IConstants.currencyFormat + " " +
//                                                 productBox[i]
//                                                     .varMrp
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 12.0))
//                                                 :
//                                             Text(IConstants.currencyFormat + " " +
//                                                 productBox[i]
//                                                     .price
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 12.0))
//                                                 :
//                                             Text(IConstants.currencyFormat + " " +
//                                                 productBox[i]
//                                                     .membershipPrice.toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 12.0))
//                                                 :
//
//                                             (double.parse(productBox[i]
//                                                 .price.toString()) <= 0 ||
//                                                 productBox[i]
//                                                     .price
//                                                     .toString() == "" ||
//                                                 productBox[i]
//                                                     .price ==
//                                                     productBox[i]
//                                                         .varMrp)
//                                                 ?
//                                             Text(IConstants.currencyFormat + " " +
//                                                 productBox[i]
//                                                     .varMrp
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 12.0))
//                                                 :
//                                             Text(IConstants.currencyFormat + " " +
//                                                 productBox[i]
//                                                     .price
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 12.0))
//                                           ],
//                                         ),
//
//                                         Text(S .of(context).not_available,//"Not available",
//                                             style: TextStyle(
//                                                 fontSize: 12.0)),
//                                       ],
//                                     )
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
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,)),
//                                 new TextSpan(
//                                   text: S .of(context).by_clicking_confirm,//'By clicking on confirm, we will remove the unavailable items from your basket.',
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
//                                   if (prefs.getString("formapscreen") == "" ||
//                                       prefs.getString("formapscreen") ==
//                                           "homescreen") {
//                                     if (prefs.containsKey("fromcart")) {
//                                       if (prefs.getString("fromcart") ==
//                                           "cart_screen") {
//                                         prefs.remove("fromcart");
//                                         Navigator.of(context)
//                                             .pushNamedAndRemoveUntil(
//                                             MapScreen.routeName,
//                                             ModalRoute.withName(
//                                                 CartScreen.routeName));
//
//                                         Navigator.of(context)
//                                             .pushReplacementNamed(
//                                           CartScreen.routeName,
//                                         );
//                                       } else {
//                                         /*  Navigator.pushNamedAndRemoveUntil(
//                                             context, HomeScreen.routeName, (
//                                             route) => false);*/
//                                         Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                                       }
//                                     } else {
//                                       /*  Navigator.pushNamedAndRemoveUntil(
//                                           context, HomeScreen.routeName, (
//                                           route) => false);*/
//                                       Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                                     }
//                                   } else if (prefs.getString("formapscreen") ==
//                                       "addressscreen") {
//                                     Navigator.of(context).pushReplacementNamed(
//                                         AddressScreen.routeName, arguments: {
//                                       'addresstype': "new",
//                                       'addressid': "",
//                                     });
//                                   }
//                                 },
//                                 child: new Container(
//                                   width: MediaQuery
//                                       .of(context)
//                                       .size
//                                       .width * 35 / 100,
//                                   height: 30.0,
//                                   decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey)
//                                   ),
//                                   child: new Center(
//                                     child: Text(
//                                       S .of(context).map_cancel,//"CANCEL"
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 20.0,),
//                               GestureDetector(
//                                 onTap: () async {
//                                   prefs.setString('branch', currentBranch);
//                                   prefs.setString(
//                                       'deliverylocation', addressLine);
//                                   prefs.setString("latitude", _lat.toString());
//                                   prefs.setString("longitude", _lng.toString());
//                                   if (prefs.getString("skip") == "no") {
//                                     //Hive.box<Product>(productBoxName).deleteFromDisk();
//                                     Hive.box<Product>(productBoxName).clear();
//                                     try {
//                                       // *//*if (Platform.isIOS || Platform.isAndroid) {
//                                       //   //Hive.openBox<Product>(productBoxName);
//                                       // }*//*
//                                     } catch (e) {
//                                       Hive.registerAdapter(ProductAdapter());
//                                       //Hive.openBox<Product>(productBoxName);
//                                     }
//                                     addprimarylocation();
//                                   } else {
//                                     //Hive.box<Product>(productBoxName).deleteFromDisk();
//                                     Hive.box<Product>(productBoxName).clear();
//                                     try {
//
//                                     } catch (e) {
//                                       //await Hive.openBox<Product>(productBoxName);
//                                     }
//                                     Navigator.of(context).pop();
//                                     if (prefs.getString("formapscreen") == "" ||
//                                         prefs.getString("formapscreen") ==
//                                             "homescreen") {
//                                       if (prefs.containsKey("fromcart")) {
//                                         if (prefs.getString("fromcart") ==
//                                             "cart_screen") {
//                                           prefs.remove("fromcart");
//                                           Navigator.of(context)
//                                               .pushNamedAndRemoveUntil(
//                                               MapScreen.routeName,
//                                               ModalRoute.withName(
//                                                   CartScreen.routeName));
//
//                                           Navigator.of(context)
//                                               .pushReplacementNamed(
//                                             CartScreen.routeName,
//                                           );
//                                         } else {
//                                           /* Navigator.pushNamedAndRemoveUntil(
//                                               context, HomeScreen.routeName, (
//                                               route) => false);*/
//                                           Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                                         }
//                                       } else {
//                                         /*Navigator.pushNamedAndRemoveUntil(
//                                             context, HomeScreen.routeName, (
//                                             route) => false);*/
//                                         Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//                                       }
//                                     } else
//                                     if (prefs.getString("formapscreen") ==
//                                         "addressscreen") {
//                                       Navigator.of(context)
//                                           .pushReplacementNamed(
//                                           AddressScreen.routeName, arguments: {
//                                         'addresstype': "new",
//                                         'addressid': "",
//                                       });
//                                     }
//                                   }
//                                 },
//                                 child: new Container(
//                                     height: 30.0,
//                                     width: MediaQuery
//                                         .of(context)
//                                         .size
//                                         .width * 35 / 100,
//                                     decoration: BoxDecoration(
//                                         color: Theme
//                                             .of(context)
//                                             .primaryColor,
//                                         border: Border.all(color: Theme
//                                             .of(context)
//                                             .primaryColor,)
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
//
//
//   Future<void> addprimarylocation() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final response = await http.post(Api.addPrimaryLocation, body: {
//         // await keyword is used to wait to this operation is complete.
//         "id": prefs.getString("userID"),
//         "latitude": _lat.toString(),
//         "longitude": _lng.toString(),
//         "area": _address,
//         "branch": prefs.getString('branch'),
//       });
//       final responseJson = json.decode(response.body);
//
//       if (responseJson["data"].toString() == "true") {
//         Navigator.of(context).pop();
//         if (prefs.getString("formapscreen") == "" ||
//             prefs.getString("formapscreen") == "homescreen") {
//           if (prefs.containsKey("fromcart")) {
//             if (prefs.getString("fromcart") == "cart_screen") {
//               prefs.remove("fromcart");
//               Navigator.of(context).pushNamedAndRemoveUntil(MapScreen.routeName,
//                   ModalRoute.withName(CartScreen.routeName));
//               Navigator.of(context).pushReplacementNamed(
//                 CartScreen.routeName,
//               );
//             } else {
//               /*Navigator.pushNamedAndRemoveUntil(
//                   context, HomeScreen.routeName, (route) => false);*/
//               Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//             }
//           } else {
//             /*Navigator.pushNamedAndRemoveUntil(
//                 context, HomeScreen.routeName, (route) => false);*/
//           }
//           Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
//         } else if (prefs.getString("formapscreen") == "addressscreen") {
//           Navigator.of(context)
//               .pushReplacementNamed(AddressScreen.routeName, arguments: {
//             'addresstype': "new",
//             'addressid': "",
//           });
//         }
//       }
//     } catch (error) {
//       Navigator.of(context).pop();
//       throw error;
//     }
//   }
//
//   void showInSnackBar() {
//     _scaffoldKey.currentState!.showSnackBar(new SnackBar(
//         content: new Text(IConstants.APP_NAME +
//             S .of(context).not_yet_available,//'is not yet available at your current location!!!'
//         ) //" is not yet available at you current location!!!"
//     ));
//   }
//
//   gradientappbarmobile() {
//     return  AppBar(
//       brightness: Brightness.light,
//       backgroundColor: ColorCodes.whiteColor,
//       toolbarHeight: 40.0,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       leading: IconButton(icon: Icon(Icons.arrow_back,size: 20, color: ColorCodes.iconColor),onPressed: ()=>
//           Navigator.of(context).pop(),
//       ),
//       title: Text(S .of(context).set_delivery_locations,//'My Addresses',
//         style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 15),
//       ),
//       titleSpacing: 0,
//     );
//   }
//
//   _bottemnavigation() {
//     addressLine = _fullAddress;
//     var iskeyboardopen = false;
//     setState(() {
//       if(MediaQuery.of(context).viewInsets.bottom != 0){
//         iskeyboardopen = true;
//       }
//       else{
//         iskeyboardopen = false;
//       }
//     });
//     return Container(
//       height: Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)?(!iskeyboardopen)?MediaQuery.of(context).size.height*0.35:MediaQuery.of(context).size.height*0.90:MediaQuery
//           .of(context)
//           .size
//           .height * 0.45,
//
//       width: MediaQuery
//           .of(context)
//           .size
//           .width/3,
//       color: Colors.white,
//
//       child: SingleChildScrollView(
//         child:
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: (!iskeyboardopen)?20.0:15.0,
//             ),
//
//             GestureDetector(
//               onTap: () {
//                 _dialogforChangeLocation();
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   SizedBox(
//                     width: 10.0,
//                   ),
//                   Icon(
//                     Icons.location_on_outlined,
//                     size: 20.0,
//                     color: ColorCodes.blackColor,
//                   ),
//                   SizedBox(
//                     width: 3.0,
//                   ),
//                   Flexible(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           _address,
//
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color:  ColorCodes.blackColor,
//                               fontWeight: FontWeight.bold),
//                         ),
//
//                         Text(
//                           _fullAddress,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 14.0,color:  ColorCodes.blackColor,),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   Container(
//                     margin: const EdgeInsets.only(left: 5.0, right: 5),
//                     padding: const EdgeInsets.all(5.0),
//                     width: 100,
//                     height: 30.0,
//                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
//                             color: ColorCodes.varcolor,
//                             border: Border(
//                               top: BorderSide(width: 1, color: ColorCodes.primaryColor,),
//                               bottom: BorderSide(width: 1, color: ColorCodes.primaryColor,),
//                               left: BorderSide(width: 1, color: ColorCodes.primaryColor,),
//                               right: BorderSide(width: 1, color: ColorCodes.primaryColor,),
//                             )),
//                     child:
//                     Text(S .of(context).change_caps.toUpperCase(),//'CHANGE',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.bold,
//                             color: Theme
//                                 .of(context)
//                                 .primaryColor)),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(
//               height: 10.0,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Form(
//                   key: _form,
//                   child: Container(
//                     margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//
//
//                         TextFormField(
//                         textAlign: TextAlign.left,
//                         style: TextStyle(color: ColorCodes.blackColor, /*fontWeight: FontWeight.w800,*/ fontSize: 17,),
//                         controller: _controllerHouseno,
//                         decoration: InputDecoration(
//                           labelText: S.of(context).address_one,//"Address 1",
//                           labelStyle: TextStyle(color: ColorCodes.lightGreyColor, /*fontWeight: FontWeight.w800,*/ fontSize: 15,),
//                           hintText: S.of(context).building_flat,//"Building / Flat Name",
//                           hintStyle: TextStyle(color: ColorCodes.lightGreyColor, /*fontWeight: FontWeight.w600,*/ fontSize: 15,),
//                           contentPadding: EdgeInsets.only(top: 15, bottom: 0, left: 10, right: 10),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: BorderSide(color: ColorCodes.lightGreyColor),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: BorderSide(color: ColorCodes.lightGreyColor),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: BorderSide(color: ColorCodes.lightGreyColor),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide:
//                             BorderSide(color: ColorCodes.lightGreyColor, width: 1.2),
//                           ),
//
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             setState(() {
//                               pn = "This field is required";
//                             });
//                             return '';
//                           }
//                           setState(() {
//                             pn = "";
//                           });
//                           return null;
//                         },
//                         onSaved: (value) {
//                           //addEmailToSF(value);
//                         },
//
//                         ),
//                         Text(
//                           pn,
//                           textAlign: TextAlign.left,
//                           style: TextStyle(color: Colors.red),
//                         ),
//                         SizedBox(height: (iskeyboardopen) ? 3 : 8,),
//                        // SizedBox(height: 10.0,),
//                         TextFormField(
//                           textAlign: TextAlign.left,
//                           style: TextStyle(color: ColorCodes.blackColor, /*fontWeight: FontWeight.w800,*/ fontSize: 17,),
//                           controller: _controllerArea,
//                           minLines: 2, // any number you need (It works as the rows for the textarea)
//                           keyboardType: TextInputType.multiline,
//                           maxLines: null,
//                           textAlignVertical: TextAlignVertical.top,
//                           decoration: InputDecoration(
//                             labelText: S.of(context).how_to_reach,//"How to reach (optional)",
//                             alignLabelWithHint: true,
//                             labelStyle: TextStyle(color: ColorCodes.lightGreyColor, /*fontWeight: FontWeight.w800,*/ fontSize: 15,),
//                             contentPadding: EdgeInsets.only(top: 15, bottom: 16, left: 10, right: 10),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide: BorderSide(color: ColorCodes.lightGreyColor),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide: BorderSide(color: ColorCodes.lightGreyColor),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide: BorderSide(color: ColorCodes.lightGreyColor),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide:
//                               BorderSide(color: ColorCodes.lightGreyColor, width: 1.2),
//                             ),
//
//                           ),
//                         ),
//
//                         SizedBox(height: 5.0,),
//
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 20.0),
//                   child: Column(
//                     children: [
//                       //SizedBox(height: 20.0,),
//                       SizedBox(height: (iskeyboardopen)?10:15.0,),
//                       Text(S .of(context).save_as,//'Save As',
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: ColorCodes.lightGreyColor,
//                         ),),
//                       SizedBox(height: 10.0,),
//                     ],
//                   ),
//                 ),
//
//                 Container(
//                   margin: EdgeInsets.only(left: 20.0, bottom: 10),
//                   child: Row(
//                     children: <Widget>[
//                       MouseRegion(
//                         cursor: SystemMouseCursors.click,
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _addresstag = S.current.home;//"Home";
//                               _home = Theme.of(context).primaryColor;
//                               _work = ColorCodes.lightGreyColor;
//                               _other = ColorCodes.lightGreyColor;
//                               _homecolor = ColorCodes.varcolor;
//                               _workcolor = ColorCodes.whiteColor;
//                               _othercolor = ColorCodes.whiteColor;
//                               _homeWidth = 1.0;
//                               _workWidth = 1.0;
//                               _otherWidth = 1.0;
//                             });
//                           },
//                           child: Container(
//                             width: 60.0,
//                             decoration: BoxDecoration(
//                                 color: _homecolor,
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 border: Border(
//                                   top: BorderSide(
//                                     width: _homeWidth, color: _home,),
//                                   bottom: BorderSide(
//                                     width: _homeWidth, color: _home,),
//                                   left: BorderSide(
//                                       width: _homeWidth, color: _home),
//                                   right: BorderSide(
//                                       width: _homeWidth, color: _home),
//                                 )),
//                             height: 30.0,
//                             child: Center(
//                               child: Text(
//                                 S .of(context).home,//'Home',// "Home",
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: _home
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 15.0,),
//                       MouseRegion(
//                         cursor: SystemMouseCursors.click,
//                         child: GestureDetector(
//                           //behavior: HitTestBehavior.translucent,
//                           onTap: () {
//                             setState(() {
//                               _addresstag = S.current.work;//"Work";
//                               _home = ColorCodes.lightGreyColor;
//                               _work = Theme.of(context).primaryColor;
//                               _other = ColorCodes.lightGreyColor;
//
//                               _homecolor = ColorCodes.whiteColor;
//                               _workcolor = ColorCodes.varcolor;
//                               _othercolor = ColorCodes.whiteColor;
//                               _homeWidth = 1.0;
//                               _workWidth = 1.0;
//                               _otherWidth = 1.0;
//                             });
//                           },
//                           child: Container(
//                             width: 60.0,
//                             decoration: BoxDecoration(
//                                 color: _workcolor,
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 border: Border(
//                                   top: BorderSide(
//                                     width: _workWidth, color: _work,),
//                                   bottom: BorderSide(
//                                     width: _workWidth, color: _work,),
//                                   left: BorderSide(
//                                     width: _workWidth, color: _work,),
//                                   right: BorderSide(
//                                     width: _workWidth, color: _work,),
//                                 )),
//                             height: 30.0,
//                             child: Center(
//                               child: Text(
//                                 S .of(context).office,//"Office",
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: _work
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 15.0,),
//                       MouseRegion(
//                         cursor: SystemMouseCursors.click,
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _addresstag = S.current.other;//"Other";
//                               _home = ColorCodes.lightGreyColor;
//                               _work = ColorCodes.lightGreyColor;
//                               _other = Theme.of(context).primaryColor;
//
//                               _homecolor = ColorCodes.whiteColor;
//                               _workcolor = ColorCodes.whiteColor;
//                               _othercolor = ColorCodes.varcolor;
//                               _homeWidth = 1.0;
//                               _workWidth = 1.0;
//                               _otherWidth = 1.0;
//                             });
//                           },
//                           child: Container(
//                             width: 60,
//                             height: 30.0,
//                             decoration: BoxDecoration(
//                                 color: _othercolor,
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 border: Border(
//                                   top: BorderSide(
//                                     width: _otherWidth, color: _other,),
//                                   bottom: BorderSide(
//                                     width: _otherWidth, color: _other,),
//                                   left: BorderSide(
//                                     width: _otherWidth, color: _other,),
//                                   right: BorderSide(
//                                     width: _otherWidth, color: _other,),
//                                 )),
//                             child: Center(
//                               child: Text(
//                                 S .of(context).other,//'Other', //"Other",
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   fontWeight: FontWeight.w600,
//                                   color:_other,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 5,),
//                 //    _buildBottomNavigationBar(),
//                 // SizedBox(height: 30,),
//
//               ],
//             ),
//
//             GestureDetector(
//               onTap: () async {
//                 _dialogforSaveadd(context);
//                 checkLocation(addressLine);
//               },
//
//               child: Container(
//                   width: MediaQuery
//                       .of(context)
//                       .size
//                       .width/4,
//                   height: 50.0,
//                   margin: EdgeInsets.only(
//                     left: 50.0, top: 5.0, right: 50.0,),
//                   decoration: BoxDecoration(
//                       color: Theme
//                           .of(context)
//                           .primaryColor,
//                       borderRadius: BorderRadius.circular(5.0),
//                       border: Border(
//                         top: BorderSide(width: 1.0, color: Theme
//                             .of(context)
//                             .primaryColor,),
//                         bottom: BorderSide(width: 1.0, color: Theme
//                             .of(context)
//                             .primaryColor,),
//                         left: BorderSide(width: 1.0, color: Theme
//                             .of(context)
//                             .primaryColor,),
//                         right: BorderSide(width: 1.0, color: Theme
//                             .of(context)
//                             .primaryColor,),
//                       )),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         S .of(context).confirm_location.toUpperCase(),//'Save & Proceed',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: 16.0),
//                       ),
//                     ],
//                   )),
//             ),
//             SizedBox.fromSize()
//
//
//           ],
//         ),
//       ),
//     );
//     // });
//     //});
//   }
// }

import 'dart:convert';
import 'package:grocbay/controller/mutations/home_store_mutation.dart';
import 'package:grocbay/rought_genrator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../generated/l10n.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import '../../main.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/address.dart';
import '../../repository/address_repo.dart';
import '../../screens/map_screen.dart';
import '../../utils/ResponsiveLayout.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:location/location.dart' as loc;

class AddressController with Navigations{
  AddressRepo _addressRepo = AddressRepo();
  add(Address body,sucsess)async{
    Map<String, String> bodymap ={
      "apiKey":body.customer.toString(),
      "addressType":body.addressType!,
      "fullName":body.fullName!,
      "address":body.address!,
      "latitude":body.lattitude!,
      "longitude":body.logingitude!,
      "branch":PrefUtils.prefs!.getString("branch")!,
      "default":"1",
      "ref": (Features.ismultivendor && IConstants.isEnterprise) ?IConstants.refIdForMultiVendor:IConstants.refIdForMultiVendor
    };
    //
    // bodymap.addAll({
    //   "latitude":body.lattitude,
    //   "longitude":body.logingitude,
    //   'apiKey': "1",
    //   'branch':PrefUtils.prefs!.getString("branch")
    // });
    _addressRepo.addupdateAddress(bodymap).then((value) {
      SetAddress(value);
      sucsess(true);
      // return Future.value(true);
    }).onError((error, stackTrace) {
      sucsess(false);
    });
  }
  update(Address body ,sucsess) async{
    _addressRepo.addupdateAddress({
      'apiKey': body.customer!,
      'addressType': body.addressType!,
      'fullName': body.fullName!,
      'address': body.address!,
      'longitude': body.logingitude!,
      'latitude': body.lattitude!,
      'branch': PrefUtils.prefs!.getString("branch")!,
      'addressId': body.id.toString(),
      "ref": (Features.ismultivendor && IConstants.isEnterprise) ?IConstants.refIdForMultiVendor:IConstants.refIdForMultiVendor
    }).then((value){
      SetAddress(value);
      sucsess(true);
    }).onError((error, stackTrace) {
      sucsess(false);
    });
  }
  remove( {required String addressId,required String apiKey,required String branch, BuildContext? context}) async{
    SetAddress(await _addressRepo.removeAddress({
      'addressId': addressId,
      'apiKey': apiKey,
      'branch': branch
    }));
  }
  setdefult({addressId,branch})async{
    _addressRepo.setDefultAddress(addressId:addressId ,branch:branch ).then((value) {
      SetAddress(value!);
    });

  }
  _fetchPrimerylocation(Function(CurrentLocation) value,BuildContext context)async {
    if(Vx.isWeb){
      try {
        _fetchPrimary((_position)async{
          value(await _getaddres(LatLng(_position.latitude,_position.longitude)));
        });
      } on Exception catch (e) {
        value(CurrentLocation(LatLng(double.parse(PrefUtils.prefs!.getString("restaurant_lat")!), double.parse(PrefUtils.prefs!.getString("restaurant_long")!)),
            PrefUtils.prefs!.getString("restaurant_location")!,
            PrefUtils.prefs!.getString("restaurant_location")!,
            true,
            PrefUtils.prefs!.getString("branch")!));
        // TODO
      }
    }else
    {
      bool serviceEnabled;
      loc.Location location = new loc.Location();
      serviceEnabled = await location.serviceEnabled();
      if(Features.ismultivendor) {
        if (!serviceEnabled) {
          /*if(Vx.isAndroid)
       location.requestService();*/
          //return _fetchPrimary();
          if (Features.ismultivendor)
            serviceEnabled = await location.requestService();
          if (serviceEnabled) {
            await _fetchPrimary((_position) async {
              value(await _getaddres(
                  LatLng(_position.latitude, _position.longitude)));
            });
          }
          else {
            if (Features.ismultivendor) WidgetsBinding.instance!
                .addPostFrameCallback((_) {
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                // _dialogforaddress(context);
                MapWeb(context);
              }
              else {
                Navigation(context, name: Routename.MapScreen,
                    navigatore: NavigatoreTyp.Push);
              }
            });
            if (!Features.ismultivendor) value(CurrentLocation(
                LatLng(
                    double.parse(PrefUtils.prefs!.getString("restaurant_lat")!),
                    double.parse(
                        PrefUtils.prefs!.getString("restaurant_long")!)),
                PrefUtils.prefs!.getString("restaurant_location")!,
                PrefUtils.prefs!.getString("restaurant_location")!,
                true,
                PrefUtils.prefs!.getString("branch")!));
          }
          // SetPrimeryLocation();
        } else {
          await _fetchPrimary((_position) async {
            value(await _getaddres(
                LatLng(_position.latitude, _position.longitude)));
          });
        }
      }
      else{
        if (!await location.serviceEnabled()) {
          /*if(Vx.isAndroid)
     location.requestService();*/
          //return _fetchPrimary();
          value(CurrentLocation(
              LatLng(double.parse(PrefUtils.prefs!.getString("restaurant_lat")!),
                  double.parse(PrefUtils.prefs!.getString("restaurant_long")!)),
              PrefUtils.prefs!.getString("restaurant_location")!,
              PrefUtils.prefs!.getString("restaurant_location")!,
              true,
              PrefUtils.prefs!.getString("branch")!));
          // SetPrimeryLocation();
        } else {
          await _fetchPrimary((_position)async {
            value(await _getaddres(LatLng(_position.latitude, _position.longitude)));
          });

        }
      }
    }
    // final  placemark =  await Geolocator().placemarkFromCoordinates(_position.latitude, _position.longitude);
    //
    // if(/*placemark[0].subLocality.toString() == ""||*/placemark[0].locality.toString() == ""){
    //   value(await _addressRepo.getcurentlocation(_position.latitude, _position.longitude));
    //   // return _addressRepo.getcurentlocation(_position.latitude, _position.longitude);
    // } else{
    //   _addresses = await gc.Geocoder.local.findAddressesFromCoordinates(new gc.Coordinates(_position.latitude,  _position.longitude));
    //   var first = _addresses.first;
    //   // PrefUtils.prefs!.setString("deliverylocation",first.addressLine);
    //   value(await _addressRepo.getcurentlocation(_position.latitude, _position.longitude,first.addressLine,first.featureName));
    // }
  }

_fetchPrimary(Function(Position) position)async{
    position(await Geolocator.getCurrentPosition());
 //  if(!Vx.isWeb) {
 //   position(await Geolocator.getCurrentPosition());
 // }else{
 //   final loc = await Geolocator.getCurrentPosition();
 //   position(loc);
 //   // position(Position(
 //    // longitude: pos.coords!.longitude!.toDouble(), latitude: pos.coords!.latitude!.toDouble(), timestamp: null, accuracy: pos.coords!.accuracy!.toDouble(), altitude: pos.coords!.altitude!.toDouble(), heading: pos.coords!.heading!.toDouble(), speed: pos.coords!.speed!.toDouble(), speedAccuracy: pos.coords!.altitudeAccuracy!.toDouble()));
 //  /* getCurrentPosition(allowInterop((pos) => (pos){
 //
 //   }));*/
 // }
  }
}

Future<CurrentLocation> _getaddres(LatLng latLng) async{
  AddressRepo _addressRepo = AddressRepo();
  if(Vx.isWeb){
    const _host = 'https://maps.google.com/maps/api/geocode/json';
    String apiKey = IConstants.googleApiKey+"&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";

    final uri = await Uri.parse('$_host?key=$apiKey&latlng=${latLng.latitude},${latLng.longitude}');
    http.Response response = await http.get(uri);


    final responseJson = json.decode(utf8.decode(response.bodyBytes));

    final resultJson = json.encode(responseJson['results']);
    final resultJsondecode = json.decode(resultJson);

    List data = []; //list for categories

    resultJsondecode.asMap().forEach((index, value) =>
        data.add(resultJsondecode[index] as Map<String, dynamic>));

    final addressJson = json.encode(data[0]['address_components']);
    final addressJsondecode = json.decode(addressJson);

    List dataAddress = []; //list for categories
    var _fullAddress;
    var _address;
    addressJsondecode.asMap().forEach((index, value) =>
        dataAddress.add(addressJsondecode[index] as Map<String, dynamic>));
    for (int i = 1; i < dataAddress.length; i++) {

      if (i == 1) {
        if (i == dataAddress.length - 1) {
          _fullAddress = dataAddress[i]["long_name"];
        } else {
          _fullAddress = dataAddress[i]["long_name"] + ", ";
        }
      } else {
        if (i == dataAddress.length - 1) {
          _fullAddress = _fullAddress + dataAddress[i]["long_name"];
        } else {
          _fullAddress = _fullAddress + dataAddress[i]["long_name"] + ", ";
        }
      }
      _address = dataAddress[dataAddress.length - 4]["long_name"];

    }
 return ( _addressRepo.getcurentlocation(
  latLng.latitude, latLng.longitude,address: _fullAddress??_address,area: _address));
  // return _addressRepo.getcurentlocation(_position.latitude, _position.longitude);
  } else {
    final placemark =
    await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (/*placemark[0].subLocality.toString() == ""||*/ placemark[0]
        .locality
        .toString() ==
        "") {
      return (await _addressRepo.getcurentlocation(
          latLng.latitude, latLng.longitude));
      // return _addressRepo.getcurentlocation(_position.latitude, _position.longitude);
    } else {
      final _addresses = await gc.Geocoder.local.findAddressesFromCoordinates(
          new gc.Coordinates(latLng.latitude, latLng.longitude));
      var first = _addresses.first;

      // PrefUtils.prefs!.setString("deliverylocation",first.addressLine);
      return (await _addressRepo.getcurentlocation(
          latLng.latitude,
          latLng.longitude,
          /*first.addressLine*/
          address: (first.subLocality != null)
              ? (first.subLocality +
              "," +
              first.locality /*+ "," + first.adminArea*/)
              : (first.locality /*+ "," + first.adminArea*/),
          area: first.featureName));
    }
  } /*else {
  final _addresses = await gc.Geocoder.local.findAddressesFromCoordinates(
  new gc.Coordinates(latLng.latitude, latLng.longitude));
  var first = _addresses.first;

  // PrefUtils.prefs!.setString("deliverylocation",first.addressLine);
 return ( _addressRepo.getcurentlocation(latLng.latitude, latLng.longitude,address:  (first.subLocality != null)
     ? (first.subLocality +
     "," +
     first.locality *//*+ "," + first.adminArea*//*)
     : (first.locality *//*+ "," + first.adminArea*//*),
     area: first.featureName));
  }*/
  }

final addresscontroller = AddressController();
class SetAddress extends VxMutation<GroceStore>{
  List<Address>? address;
  SetAddress(this.address);
  @override
  perform() {
    // TODO: implement perform
    store!.userData.billingAddress = address;
  }

}

class PrimeryLocation with Navigations{
  BuildContext? context;
  AddressRepo _addressRepo = AddressRepo();
  fetchPrimarylocation(BuildContext context) async{
    if(!PrefUtils.prefs!.containsKey("deliverylocation")){
      if(!Vx.isWeb){
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
        ].request();
        if (statuses[Permission.location]!.isGranted) {

          addresscontroller._fetchPrimerylocation((location) {
            PrefUtils.prefs!.setString("isdelivering", "${location.status}");
            if (location.status) {
              /// Location Status True: User Current Location is In Delivery Range
              /// And We Can Make Delivery To His Current Location
              ///
              SetPrimeryLocation(location);
            } else {
              ///if ther is no deliverylocation key in SharedPreference than user is opening an app for the first time
              /// and will let User know that we are not delivering to Current location
              ///
              location = CurrentLocation(
                  LatLng(double.parse(PrefUtils.prefs!.getString("restaurant_lat")!),
                      double.parse(PrefUtils.prefs!.getString("restaurant_long")!)),
                  PrefUtils.prefs!.getString("restaurant_location")!,
                  PrefUtils.prefs!.getString("restaurant_location")!,
                  true,
                  PrefUtils.prefs!.getString("branch")!);
              SetPrimeryLocation(location);
            }
          },context);
        } else {
          print("Primary location is Denied");
          if(Features.ismultivendor){
            print("multivendor location denied....");
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                // _dialogforaddress(context);
                MapWeb(context);
              }
              else {
                Navigation(context, name: Routename.MapScreen,
                    navigatore: NavigatoreTyp.Push);
              }
            });
          }
          else {
            SetPrimeryLocation(CurrentLocation(
                LatLng(
                    double.parse(PrefUtils.prefs!.getString("restaurant_lat")!),
                    double.parse(
                        PrefUtils.prefs!.getString("restaurant_long")!)),
                PrefUtils.prefs!.getString("restaurant_location")!,
                PrefUtils.prefs!.getString("restaurant_location")!,
                true,
                PrefUtils.prefs!.getString("branch")!));
          }
        }
      }else{
        addresscontroller._fetchPrimerylocation((location) {
          PrefUtils.prefs!.setString("isdelivering", "${location.status}");
          if (location.status) {
            /// Location Status True: User Current Location is In Delivery Range
            /// And We Can Make Delivery To His Current Location
            ///
            SetPrimeryLocation(location);
          } else {
            ///if ther is no deliverylocation key in SharedPreference than user is opening an app for the first time
            /// and will let User know that we are not delivering to Current location
            ///
            location = CurrentLocation(
                LatLng(double.parse(PrefUtils.prefs!.getString("restaurant_lat")!),
                    double.parse(PrefUtils.prefs!.getString("restaurant_long")!)),
                PrefUtils.prefs!.getString("restaurant_location")!,
                PrefUtils.prefs!.getString("restaurant_location")!,
                true,
                PrefUtils.prefs!.getString("branch")!);
            SetPrimeryLocation(location);
          }
        },context);
      }
    }else{
      print("alredy contain delevery location");
    }

    /*else{
      SetPrimeryLocation(CurrentLocation(
          LatLng(double.parse(PrefUtils.prefs!.getString("restaurant_lat")),
              double.parse(PrefUtils.prefs!.getString("restaurant_long"))),
          PrefUtils.prefs!.getString("restaurant_location"),
          PrefUtils.prefs!.getString("restaurant_location"),
          true,
          PrefUtils.prefs!.getString("branch")));
    }*/
  }
  Future<bool> setDeleveryLocation(LatLng latLng)async {
    CurrentLocation resp;
//     if(Vx.isWeb){
//       const _host = 'https://maps.google.com/maps/api/geocode/json';
//       String apiKey = IConstants.googleApiKey+"&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";
//
//       final uri = await Uri.parse('$_host?key=$apiKey&latlng=${latLng.latitude},${latLng.longitude}');
//       http.Response response = await http.get(uri);
//
//
//       final responseJson = json.decode(utf8.decode(response.bodyBytes));
//
//       final resultJson = json.encode(responseJson['results']);
//       final resultJsondecode = json.decode(resultJson);
//
//       List data = []; //list for categories
//
//       resultJsondecode.asMap().forEach((index, value) =>
//           data.add(resultJsondecode[index] as Map<String, dynamic>));
//
//       final addressJson = json.encode(data[0]['address_components']);
//       final addressJsondecode = json.decode(addressJson);
//
//       List dataAddress = []; //list for categories
// var _fullAddress;
// var _address;
//       addressJsondecode.asMap().forEach((index, value) =>
//           dataAddress.add(addressJsondecode[index] as Map<String, dynamic>));
//         for (int i = 1; i < dataAddress.length; i++) {
//
//             if (i == 1) {
//               if (i == dataAddress.length - 1) {
//                 _fullAddress = dataAddress[i]["long_name"];
//               } else {
//                 _fullAddress = dataAddress[i]["long_name"] + ", ";
//               }
//             } else {
//               if (i == dataAddress.length - 1) {
//                 _fullAddress = _fullAddress + dataAddress[i]["long_name"];
//               } else {
//                 _fullAddress = _fullAddress + dataAddress[i]["long_name"] + ", ";
//               }
//             }
//               _address = dataAddress[dataAddress.length - 4]["long_name"];
//
//         }
//       resp = (await _addressRepo.getcurentlocation(
//           latLng.latitude, latLng.longitude,address: _fullAddress??_address));
//
//       // const _host = 'https://maps.google.com/maps/api/geocode/json';
//       // String apiKey = IConstants.googleApiKey+"&v=3.21.5a&libraries=drawing&signed_in=true&libraries=places,drawing,geometry.key";
//       // final uri = await Uri.parse('$_host?key=$apiKey&latlng=${latLng.latitude},${latLng.longitude}');
//       // http.Response response = await http.get(uri);
//       // List dataAddress = []; //list for categories
//       // List data = []; //list for categories
//       // final responseJson = json.decode(utf8.decode(response.bodyBytes));
//       // final resultJson = json.encode(responseJson['results']);
//       // final resultJsondecode = json.decode(resultJson);
//       // resultJsondecode.asMap().forEach((index, value) =>
//       //     data.add(resultJsondecode[index] as Map<String, dynamic>));
//       // final addressJson = json.encode(data[0]['address_components']);
//       // final addressJsondecode = json.decode(addressJson);
//       // addressJsondecode.asMap().forEach((index, value) =>
//       //     dataAddress.add(addressJsondecode[index] as Map<String, dynamic>));
//       // final _address = dataAddress[dataAddress.length - 4]["long_name"];
//       // resp = (await _addressRepo.getcurentlocation(
//       //     latLng.latitude, latLng.longitude,_address));
//     }else {
//       final placemark =
//           await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//
//       if (/*placemark[0].subLocality.toString() == ""||*/ placemark[0]
//               .locality
//               .toString() ==
//           "") {
//         resp = (await _addressRepo.getcurentlocation(
//             latLng.latitude, latLng.longitude));
//         // return _addressRepo.getcurentlocation(_position.latitude, _position.longitude);
//       } else {
//         final _addresses = await gc.Geocoder.local.findAddressesFromCoordinates(
//             new gc.Coordinates(latLng.latitude, latLng.longitude));
//         var first = _addresses.first;
//
//         // PrefUtils.prefs!.setString("deliverylocation",first.addressLine);
//         resp = (await _addressRepo.getcurentlocation(
//             latLng.latitude,
//             latLng.longitude,
//             /*first.addressLine*/
//             address: (first.subLocality != null)
//                 ? (first.subLocality +
//                 "," +
//                 first.locality /*+ "," + first.adminArea*/)
//                 : (first.locality /*+ "," + first.adminArea*/),
//             area: first.featureName));
//       }
//     }
    // final  resp = await _addressRepo.getcurentlocation(latLng.latitude, latLng.longitude);
    resp = await _getaddres(latLng);
    print("response..location...."+resp.status.toString());
    if(resp.status) {
      PrefUtils.prefs!.setString("deliverylocation",resp.address);
      print("branch......"+resp.branch.toString() +"..."+PrefUtils.prefs!.getString("branch").toString());
      PrefUtils.prefs!.setString("branch", resp.branch);
      IConstants.currentdeliverylocation.value = S.current.location_available;
      IConstants.deliverylocationmain.value = PrefUtils.prefs!.getString("deliverylocation")!;
      await SetPrimeryLocation(resp).perform();
      return Future.value(true);
    }
    else
      return Future.value(false);
  }
}
class SetPrimeryLocation  extends VxMutation<GroceStore>{
  CurrentLocation location;
  AddressRepo _addressRepo = AddressRepo();
  SetPrimeryLocation(this.location);
  @override
  Future<bool> perform() async{
    // TODO: implement perform
    print("lat long initial......"+location.latlng.latitude.toString()+"..."+ location.latlng.longitude.toString());
   final value = await _addressRepo.addPrimeryLocation(LatLng(location.latlng.latitude, location.latlng.longitude),location.address,location.branch);
    // PrefUtils.prefs!.setString("deliverylocation",store.userData.area);
   if(value) {
     store!.userData.longitude = location.latlng.longitude.toString();
     store!.userData.latitude = location.latlng.latitude.toString();
     store!.userData.area = location.address;
     store!.userData.branch =location.status? location.branch:PrefUtils.prefs!.getString("branch");
     store!.userData.delevrystatus = location.status;
     PrefUtils.prefs!.setBool("deliverystatus", store!.userData.delevrystatus!);
     PrefUtils.prefs!.setString("area",  store!.userData.area!);
     PrefUtils.prefs!.setString("branch",  store!.userData.branch!);
     PrefUtils.prefs!.setString("latitude", location.latlng.latitude.toString());
     PrefUtils.prefs!.setString("longitude", location.latlng.longitude.toString());
     PrefUtils.prefs!.setString("deliverylocation", location.address.toString());
     IConstants.deliverylocationmain.value = location.address;
     IConstants.currentdeliverylocation.value = location.status?"Available":"Not Available";
     IConstants.deliverylocationmain.value = location.address;
     IConstants.currentdeliverylocation.notifyListeners();
     print("latrfvffd " +  (VxState.store as GroceStore).homestore.toJson().isEmpty.toString() + " " +  PrefUtils.prefs!.getString("latitude").toString() +"....."+PrefUtils.prefs!.getString("longitude").toString()+ "......"+ PrefUtils.prefs!.getString("area").toString()+ " " + (VxState.store as GroceStore).userData.latitude.toString() + " " + (VxState.store as GroceStore).userData.longitude .toString());
     if((VxState.store as GroceStore).homestore.toJson().isEmpty) {
       HomeStoreScreenController(user: PrefUtils.prefs!.getString("apikey") ?? PrefUtils.prefs!.getString("ftokenid"), lat: (VxState.store as GroceStore).userData.latitude??PrefUtils.prefs!.getString("latitude"),
           long: (VxState.store as GroceStore).userData.longitude??PrefUtils.prefs!.getString("longitude"));
     }
   }
   return Future.value(true);
  }
}

class CurrentLocation{
  LatLng latlng;
  String address;
  bool status;
  String area;
  String branch;
  CurrentLocation(this.latlng,this.address,this.area,this.status,this.branch);
}
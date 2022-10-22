import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocbay/constants/IConstants.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/controller/mutations/address_mutation.dart';
import '../models/newmodle/address.dart';
import '../repository/api.dart';
import '../utils/prefUtils.dart';

class AddressRepo{
  Future<List<Address>?> getAddress()async{
    Api api = Api();
    api.body ={
      "customer":PrefUtils.prefs!.getString("apikey")??"1",
      "branch":PrefUtils.prefs!.getString("branch")!,
      "ref":(Features.ismultivendor && IConstants.isEnterprise) ?IConstants.refIdForMultiVendor:IConstants.refIdForMultiVendor,
    };
    var resp = await api.Posturl(
      "v3/get-address",isv2: false,
    );
    if(resp.toString() != "[]")
   return AddressModle.fromJson(json.decode(resp)).data;
    else
      return [];
  }
  //Todo: Primery location
  Future<bool> addPrimeryLocation(LatLng latLng,area,String branch)async{
    Api api = Api();
    api.body ={
      "id":PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("tokenid")!,
      "latitude": latLng.latitude.toString(),
      "longitude": latLng.longitude.toString(),
      "area": area.toString(),
      "branch":branch,
      "ref": IConstants.isEnterprise && Features.ismultivendor ? IConstants.refIdForMultiVendor : IConstants.refIdForMultiVendor,
      "branchtype": IConstants.isEnterprise && Features.ismultivendor ? IConstants.branchtype.toString() : IConstants.branchtype.toString(),
    };
final resp =await api.Posturl("add-primary-location",isv2: false);
print("location: $resp");
    if(json.decode(resp)["data"]){
      return Future.value(true);
    }else{
      return Future.value(false);
    }
  }
 Future<CurrentLocation> getcurentlocation(double latitude,double longitude,{address,area})async{
   Api api = Api();
    final location =json.decode(await api.Geturl(/*IConstants.isEnterprise &&*/ Features.ismultivendor?"v3/check-location?lat=$latitude&long=$longitude&branch=${PrefUtils.prefs!.getString("branch")}&ref=${IConstants.refIdForMultiVendor.toString()}&branchtype=${IConstants.branchtype.toString()}":
    "check-location?lat=$latitude&long=$longitude&branch=${PrefUtils.prefs!.getString("branch")}&ref=${IConstants.refIdForMultiVendor.toString()}&branchtype=${IConstants.branchtype.toString()}",isv2: false));
    print("status rep: ${location["status"]}");
    return CurrentLocation(LatLng(latitude, longitude),address??location["area"],area??location["area"],location["status"]=="yes",location["branch"]);
  }
  Future<List<Address>?> setDefultAddress({addressId,branch})async {
    Api api = Api();
    if(json.decode(await api.Geturl("set-default-address?id=$addressId&branch=${PrefUtils.prefs!.getString("branch")}"))["status"]==200) {
      print("value s");
      return await getAddress();
    } else null;
  }
  Future<List<Address>?> removeAddress(body)async {
    Api api = Api();
    api.body = body;

    if(json.decode(await api.Posturl("customer/address/remove"))["status"])
      return await getAddress();
    else null;

  }
  Future<List<Address>?> addupdateAddress(Map<String, String>body)async {
    print("body....."+body.toString());
    Api api = Api();
    api.body = body;
    var resp = (Features.ismultivendor && IConstants.isEnterprise) ? await api.Posturl("v3/customer/address/add-new", isv2: false) : await api.Posturl("customer/address/add-new");
    print("Result....."+resp.toString());
    bool result=json.decode(resp)["status"];
    if(result)
      return await getAddress();
    else null;
  }

}
class AddressList{
  List<Address>? data;
  AddressList({
    this.data,
  });
  AddressList.fromJson(List<dynamic> json) {
    json.forEach((element) {
      data!.add(Address.fromJson(element)) ;
    }) ;
  }
}
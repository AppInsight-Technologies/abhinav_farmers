import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/mutations/address_mutation.dart';
import 'package:sign_in_apple/apple_id_user.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/user.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
enum AuthPlatform{
  google,facebook,phone,ios
}
/// this portal is to handle login And sign in Acsess [AuthPlatform]
/// is to sevar he platmorm where you want to login [data] only required if you are login true Phone
/// sent # otp and # phonenumber in map [data]
///
/// you will get error messege if error occerd from login[onerror]
/// in [onSucsess] the data parameter will pass it contain all login daata with the #new or old User Tag
/// you can check if the user is new or the old for sending the user to register page or the home page by checking it
///
class UserAppAuth {
  late AuthPlatform platform;
  Auth _auth = Auth();
  /// [onsucsess] onsucsess(SocialAuthUser values)
  ///, [platform] eg: AuthPlatform.facebook
  login(AuthPlatform platform, {onSucsess,onerror,data}){
    switch(platform){

      case AuthPlatform.google:
        _auth.googleLogin((value){
          if(value.status){
            if(!value.data.newuser);
            onSucsess(value.data,null);
          }else{
            onerror(value.messege);
          }
        });
        // TODO: Handle this case.
        break;
      case AuthPlatform.facebook:
        _auth.facebookLogin((value){
          print("fb error log..."+value.messege.toString());
          if(value.status){
            if(!value.data.newuser)
              onSucsess(value.data,null);
          }else{
            onerror(value.messege);
          }
        });
        // TODO: Handle this case.
        break;
      case AuthPlatform.phone:
        LoginData otpk;
        debugPrint("otp hi...");
        _auth.phoneNumberAuth(data["mobile"],(otp,value){
          debugPrint("otp hihi...");
          otpk = otp;
          debugPrint("otp phoneweb..."+otpk.otp.toString()+"  "+value.status.toString()+"  "+value.data!.newuser.toString());
          if(value.status!){
            if(value.data!.newuser!) {
              debugPrint("type new.....");
              PrefUtils.prefs!.setBool('type', value.data!.newuser!);
            } if(!value.data!.newuser!)
              PrefUtils.prefs!.setString("apikey", value.data!.id!);
            // print("your api key: "+PrefUtils.prefs!.getString("apikey"));
            onSucsess(value.data!,otpk);
          }else{
            debugPrint("error ....");
            onerror(value.messege);
          }
        });
        // TODO: Handle this case.
        break;
      case AuthPlatform.ios:
      // PrefUtils.prefs!.setBool("ioslogedin", false);
        print("ios ${PrefUtils.prefs!.getBool("ioslogedin")}");
        if(!(PrefUtils.prefs!.getBool("ioslogedin")??false))
          _auth.ioslogin(( AuthData result){
            PrefUtils.prefs!.setBool("ioslogedin", true);
            onSucsess(result.data,null);
          },(String error){
            PrefUtils.prefs!.setBool("ioslogedin", false);
            onerror(error);
          });
        // TODO: Handle this case.
        break;
    }
  }
  register({onSucsess,onerror,required RegisterAuthBodyParm data}){
    debugPrint("new user.....cc...");
    _auth.userRegister(data,onSucsess: (UserData response)
    {
      onSucsess(response);
      SetUser(response);}, onError: (messege)=>onerror(messege));
  }

}
final userappauth = UserAppAuth();
class SetUserData extends VxMutation<GroceStore> {
  UserModle data;

  SetUserData(this.data);
  @override
  perform() async{
    store!.notificationCount = data.notificationCount;
    store!.userData = data.data!.first;
    store!.prepaid = data.prepaid!.first;
    store!.userData.delevrystatus = true;
    store!.ShoppingList = data.shoppingList!;
    if(data.data!.first.area.toString() == "null" || data.data!.first.area == "") {
      //For new users area is not there at that time we need to check delivery location is there or not.
      // If exists we need to add deliverylocation otherwise we need to resturant location details.
      if(PrefUtils.prefs!.containsKey("deliverylocation")) {
        SetPrimeryLocation(CurrentLocation(
            LatLng(double.parse(PrefUtils.prefs!.getString("latitude")!),
                double.parse(PrefUtils.prefs!.getString("longitude")!)),
            PrefUtils.prefs!.getString("restaurant_location")!,
            PrefUtils.prefs!.getString("restaurant_location")!,
            true,
            PrefUtils.prefs!.getString("branch")??"999"));
      } else {
        SetPrimeryLocation(CurrentLocation(
            LatLng(double.parse(PrefUtils.prefs!.getString("restaurant_lat")!),
                double.parse(PrefUtils.prefs!.getString("restaurant_long")!)),
            PrefUtils.prefs!.getString("restaurant_location")!,
            PrefUtils.prefs!.getString("restaurant_location")!,
            true,
            PrefUtils.prefs!.getString("branch")??"999"));
      }
    } else {
      PrefUtils.prefs!.setString("deliverylocation", data.data!.first.area!);
      print("branch inside ${data.data!.first.branch!}");
      PrefUtils.prefs!.setString("branch", data.data!.first.branch!);
      PrefUtils.prefs!.setString("latitude", data.data!.first.latitude!);
      PrefUtils.prefs!.setString("longitude", data.data!.first.longitude!);
    }
    // TODO: implement perform
    print('sp.......');
    // if (PrefUtils.prefs!.containsKey("apikey")) {
    //   store.userData =await auth.getuserProfile(PrefUtils.prefs!.getString("apikey"),onsucsess: (value){
    //     store.userData=value;
    //   });
    // }else{
    //   store.userData =await auth.getuserProfile("1",onsucsess: (value){
    //     store.userData=value;
    //   });
    // }
  }
}
class SetUser extends VxMutation<GroceStore>{
  UserData authUser;
  SetUser(this.authUser);
  @override
  perform() async{
    store!.userData = authUser;
  }
}
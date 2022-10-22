
import 'dart:convert';

import 'package:grocbay/repository/api.dart';
import 'package:grocbay/repository/authenticate/AuthRepo.dart';
import 'package:grocbay/utils/prefUtils.dart';

class NotificationRepo{
  clear()async{
    Api api = Api();
    api.body = {
      "id":PrefUtils.prefs!.containsKey("apikey")?PrefUtils.prefs!.getString("apikey")!:PrefUtils.prefs!.getString("ftokenid")!
    };
    if(json.decode(await api.Posturl("customer/notification/ignore"))["status"]==200) {
      auth.getuserProfile(onsucsess: (value){

      }, onerror: (){

      });
    }
  }
  fetch()async{
    auth.getuserProfile(onsucsess: (value){

    }, onerror: (){

    });
  }
}
final notificationrepo = NotificationRepo();
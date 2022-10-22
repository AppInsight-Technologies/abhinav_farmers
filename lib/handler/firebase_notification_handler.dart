import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/prefUtils.dart';

class FirebaseNotifications {
  FirebaseMessaging? _firebaseMessaging;
  int? count = 0;
  GlobalKey<ScaffoldState>? scaffoldKey;


  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessaging_Listeners();
  }

  notificationConfig({
    Function(Map<String, dynamic>)? onresume,
    Function(Map<String, dynamic>)? onLaunch,
    Function(Map<String, dynamic>)? onMessage,
  }){

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message/*_firebaseMessagingBackgroundHandler*/) async{
      onresume!(json.decode(json.encode(message.data)));
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessage!(json.decode(json.encode(message.data)));
      if (message.notification != null) {
      }
    });
    FirebaseMessaging.onMessageOpenedApp.forEach((element) {

      onLaunch!(element.data);
    });
  }
  // ignore: non_constant_identifier_names
  void firebaseCloudMessaging_Listeners() {

    try{
      if(!Vx.isAndroid&&!Vx.isWeb) {
        iOS_Permission();
      }
    } catch(e){
    }

    _firebaseMessaging!.getToken().then((token) async {
      PrefUtils.prefs!.setString("ftokenid", token!);
    });

  }

  void iOS_Permission() async {
    NotificationSettings settings = await _firebaseMessaging!.requestPermission(
        provisional: true,
        sound: true,
        criticalAlert: false,
        carPlay: false,
        badge: true,
        alert: true
    );
  }
}
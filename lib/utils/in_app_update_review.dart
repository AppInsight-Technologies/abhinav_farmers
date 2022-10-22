import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocbay/screens/splash_screen.dart';
import '../constants/IConstants.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_review/in_app_review.dart';

class InAppUpdates{
  Future<void> checkForUpdate( BuildContext context,bool forceupdate,Function latestVersion) async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String code = packageInfo.version;
//
//     InAppUpdate.checkForUpdate().then((info) {
//       print("update version: ${info.availableVersionCode}");
//       // setState(() {
//       //   _updateInfo = info;
//       // });
// if(info.updateAvailability == UpdateAvailability.updateAvailable)
//       return showDialog(context: context, builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Update Available!"),
//           content: Text("your app version $code got a latest version ${info.packageName} "),
//           actions: [
//           TextButton(
//             child: Text("Maybe Later"),
//             onPressed: () async{
//           await  InAppUpdate.performImmediateUpdate().catchError((e){
//               print(e.toString());
//             });
//           },),
//           TextButton(child: Text("Update"),onPressed: (){
//               InAppUpdate.performImmediateUpdate().catchError((e){
//               print(e.toString());
//             });
//           },),
//           // Text("Update"),
//         ],);
//       });
// else
// latestVersion();
// // else return null;
//     }).catchError((e) {
//       SnackBar(content: Text('Some thing went wrong while checking for Update $e'));
//       latestVersion();
//       // showSnack(e.toString());
//     });
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String code = packageInfo.version;

    InAppUpdate.checkForUpdate().then((info) {
      print("update version: ${info.availableVersionCode}");
      // setState(() {
      //   _updateInfo = info;
      // });
if(info.updateAvailability == UpdateAvailability.updateAvailable)
      return showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Available!"),
          content: Text("your app version $code got a latest version "),
          actions: [
          TextButton(
            child: Text("Maybe Later"),
            onPressed: () async{
          await  InAppUpdate.performImmediateUpdate().catchError((e){
              print(e.toString());
            });
          },),
          TextButton(child: Text("Update"),onPressed: (){
              InAppUpdate.performImmediateUpdate().catchError((e){
              print(e.toString());
            });
          },),
          // Text("Update"),
        ],);
      });
else
latestVersion();
// else return null;
    }).catchError((e) {
      SnackBar(content: Text('Some thing went wrong while checking for Update $e'));
      latestVersion();
      // showSnack(e.toString());
    });
  }

}
final inappupdate = InAppUpdates();

class InAppReviews{
  final InAppReview _inAppReview = InAppReview.instance;

  String _appStoreId = IConstants.appleId;
  String _microsoftStoreId = '';
  Availability _availability = Availability.loading;
  initialize(){
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
          final isAvailable = await _inAppReview.isAvailable();

          _availability = isAvailable && !Platform.isAndroid
              ? Availability.available
              : Availability.unavailable;

      } catch (e) {
        _availability = Availability.unavailable;
      }
    });
  }
  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
    appStoreId: _appStoreId,
    microsoftStoreId: _microsoftStoreId,
  );
  requestReview(){
    switch(_availability){
      case Availability.loading:
        CircularProgressIndicator();
        // TODO: Handle this case.
        break;
      case Availability.available:
        _requestReview();
        // TODO: Handle this case.
        break;
      case Availability.unavailable:
        _openStoreListing();
        // TODO: Handle this case.
        break;
    }
  }
}
final inappreview = InAppReviews();
enum Availability { loading, available, unavailable }
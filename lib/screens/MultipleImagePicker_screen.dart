// import 'dart:io';
// import 'dart:async';
// import 'dart:convert';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import '../screens/home_screen.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
// import 'package:image_picker/image_picker.dart';
// import '../generated/l10n.dart';
// import 'package:http/http.dart' as http;
// import 'dart:ui';
// import 'package:dio/dio.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import '../constants/IConstants.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// //import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// //import 'package:shared_preferences/shared_preferences.dart';
// import 'package:file/local.dart';
// import '../assets/images.dart';
// import '../assets/ColorCodes.dart';
// import '../utils/prefUtils.dart';
// import '../utils/ResponsiveLayout.dart';
// import '../constants/api.dart';
// // import 'dart:html' as html;
// class MultipleImagePicker extends StatefulWidget {
//   static const routeName = '/multipleImage-screen';
//
//
//   final LocalFileSystem localFileSystem;
//
//   MultipleImagePicker({localFileSystem})
//       : this.localFileSystem = localFileSystem ?? LocalFileSystem();
//   @override
//   _MultipleImagePickerState createState() => _MultipleImagePickerState();
// }
//
// class _MultipleImagePickerState extends State<MultipleImagePicker> {
//   final _contactFocusNode = FocusNode();
//   final _addressFocusNode = FocusNode();
//   String name = "";
//   String phone ="";
//   String deliverlocation="";
//   String ln = "";
//   String ea = "";
//   String gst = "";
//   String sn = "";
//   String dropdownValue = 'GSTIN';
//   //SharedPreferences prefs;
//   File _image;
//   final picker = ImagePicker();
//   DateTime pickedDate;
//   var image;
//   File file;
//   TextEditingController _controller = new TextEditingController();
//   bool _isDuration = false;
//   File galleryFile;
//   List uploadlist = [];
// //save the result of camera file
//   File cameraFile;
//   var images_captured=List<Widget>();
//   int _groupValue = 1;
//   bool _value = false;
//   List<File> _files;
//   String filePath="";
//   List pics;
//   List<File> images = List<File>();
//   var uploadtime;
//   final _pickedImages = <Image>[];
//   String imageSize;
//   int check = 0;
//   bool status = false;
//   bool iphonex = false;
//   bool _isWeb = false;
//
//   AnimationController _animationController;
//
//   imageSelectorGallery() async {
//     galleryFile = await ImagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 40,
//     );
//
//     images.add(galleryFile);
//
//     uploadlist.add(MultipartFile.fromFileSync(galleryFile.path));
//
//
//     setState(() {});
//   }
//   //display image selected from camera
//   imageSelectorCamera() async {
//     cameraFile = await ImagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 40
//     );
//     images.add(cameraFile);
//     uploadlist.add(MultipartFile.fromFileSync(cameraFile.path));
//     setState(() {
//
//     });
//   }
//
//   Future<void> _pickImage() async {
//     Image fromPicker =
//     await ImagePickerWeb.getImage(outputType: ImageType.widget);
//
//     if (fromPicker != null) {
//       setState(() {
//         _pickedImages.add(fromPicker);
//       });
//     }
//   }
//   displayImagesWeb(){
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate( _pickedImages == null ? 0 : _pickedImages.length, (index) {
//         return Container(
//           margin: EdgeInsets.all(5.0),
//           child: Stack(children: <Widget>[
//             Container(
//                 height: 100,
//                 width: 100,
//                 child: _pickedImages[index]
//             ),
//             Positioned(
//               top: 0,
//               right: 0,
//               child: GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     _pickedImages.removeAt(index);
//                   });
//                 },
//                 child: Icon(
//                   Icons.cancel,
//                 ),
//               ),
//             ),
//           ],),
//         );
//
//       }),
//     );
//   }
//   displayImages(){
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         return Container(
//           margin: EdgeInsets.all(5.0),
//           child: Stack(children: <Widget>[
//             Container(
//               height: 100,
//               width: 100,
//               child: Image.file(images[index],fit: BoxFit.fill,),
//             ),
//             Positioned(
//               top: 0,
//               right: 0,
//               child: GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     images.removeAt(index);
//                   });
//                 },
//                 child: Icon(
//                   Icons.cancel,
//                 ),
//               ),
//             ),
//           ],),
//         );
//
//       }),
//     );
//   }
//   Widget Option() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xffe9e9e9),
//       ),
//       height: 60,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         children: <Widget>[
//           SizedBox(width:10),
//          /* Checkbox(
//             value: _value,
//             checkColor: Theme.of(context).primaryColor,
//             activeColor: Colors.white,
//             hoverColor: Colors.white,
//             focusColor: Colors.white,
//             onChanged: (bool newValue) {
//               setState(() {
//                 _value = newValue;
//               });
//             },
//           ),*/
//           Expanded(
//             child: Text(
//               S .of(context).do_you_want
//               //"Do You Want "
//                   + IConstants.APP_NAME+
//                   S .of(context).call_further_details,
//                  // " To Call You For Further Details?",
//               style: TextStyle(/*fontWeight: FontWeight.bold, fontSize: 16,*/color: Theme.of(context).primaryColor),
//             ),
//           ),
//           SizedBox(width:10),
//           FlutterSwitch(
//             width:60,
//             height: 25,
//             toggleSize: 23,
//
//             activeColor: Theme.of(context).accentColor,
//             activeToggleColor: Theme.of(context).primaryColorDark,
//             value: status,
//             onToggle: (val) {
//             setState(() {
//               status = val;
//             });
//           },
//           ),
//           SizedBox(width:10)
//         ],
//       ),
//     );
//   }
//   _dialogforProcessing1() {
//     return showDialog(context: context,
//         builder: (context) {
//           return StatefulBuilder(
//               builder: (context, setState) {
//                 return AbsorbPointer(
//                   child: Container(
//                     color: Colors.transparent,
//                     height: double.infinity,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//
//
//                     child:
// //                    CircularProgressIndicator(),
//                     LinearPercentIndicator(
// //                      width: MediaQuery.of(context).size.width,
//                       animation: true,
//                       lineHeight: 20.0,
//                       animationDuration: uploadtime,
//                       percent: 0.95,
//                       center: Text( S .of(context).uploading
//                          // "Uploading......."
//                       ),
//                       linearStrokeCap: LinearStrokeCap.roundAll,
//                       progressColor: Colors.green,
//                     ),
//
//                   ),
//                 );
//               }
//           );
//         });
//   }
//   final TextEditingController firstnamecontroller = new TextEditingController();
//   final TextEditingController lastnamecontroller = new TextEditingController();
//
//   bool _isinternet = true;
//
//
//   Future<void> _refreshProducts(BuildContext context) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       setState(() {
//         _isinternet = true;
//       });
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       setState(() {
//         _isinternet = true;
//       });
//     } else {
//       Fluttertoast.showToast(msg:  S .of(context).no_internet
//      // "No internet connection!!!"
//         , fontSize: MediaQuery.of(context).textScaleFactor *13,);
//       setState(() {
//         _isinternet = false;
//       });
//     }
//
//   }
//   @override
//   void initState() {
//     pickedDate = DateTime.now();
//     Future.delayed(Duration.zero, () async {
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//       try {
//         if (Platform.isIOS) {
//           setState(() {
//             iphonex = MediaQuery.of(context).size.height >= 812.0;
//           });
//         }
//       } catch (e) {
//       }
//       setState(() {
//         deliverlocation = PrefUtils.prefs!.getString("deliverylocation");
//       });
//       var connectivityResult = await (Connectivity().checkConnectivity());
//       if (connectivityResult == ConnectivityResult.mobile) {
//         setState(() {
//           _isinternet = true;
//         });
//         // I am connected to a mobile network.
//       } else if (connectivityResult == ConnectivityResult.wifi) {
//         // I am connected to a wifi network.
//         setState(() {
//           _isinternet = true;
//         });
//       } else {
//         Fluttertoast.showToast(msg: S .of(context).no_internet
//       //  "No internet connection!!!"
//           , fontSize: MediaQuery.of(context).textScaleFactor *13,);
//         setState(() {
//           _isinternet = false;
//         });
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     firstnamecontroller.dispose();
//     lastnamecontroller.dispose();
//     _animationController.dispose();
//     _contactFocusNode.dispose();
//     _addressFocusNode.dispose();
//
//     super.dispose();
//   }
//
//
//   _dialogforProcessing() {
//     return showDialog(context: context,
//         builder: (context) {
//           return StatefulBuilder(
//               builder: (context, setState) {
//                 return AbsorbPointer(
//                   child: Container(
//                     color: Colors.transparent,
//                     height: double.infinity,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }
//           );
//         });
//   }
//   Future<void> createTicketWeb() async { // imp feature in adding async is the it automatically wrap into Future.
//     String _imagePath = "";
//     List path = [];
//     for(int i = 0; i < _pickedImages.length; i++) {
//       if(i == 0) {
//         path.add(_pickedImages[i].semanticLabel.toString());
//         _imagePath = _pickedImages[i].semanticLabel.toString();
//       } else {
//         path.add(_pickedImages[i].semanticLabel.toString());
//         _imagePath = _imagePath + "," + (_pickedImages[i].semanticLabel.toString());
//       }
//     }
//     try {
//       final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//       final subject = routeArgs['subject'];
//       final type = routeArgs['type'];
//       var map = FormData.fromMap({
//         "id": PrefUtils.prefs!.getString('apikey'),
//         "parent": PrefUtils.prefs!.getString('apikey'),
//         "subject": subject,
//         "message": name + ", " + deliverlocation + ", Contact Number: " +
//             phone + " Date: " + pickedDate.toString(),
//         "type": type,
//         'image': path,
//         'place': deliverlocation,
//         "callback": (status == true) ? "1" : "0",
//         "branch": PrefUtils.prefs!.getString('branch'),
//       });
//
//       Dio dio;
//       BaseOptions options = BaseOptions(
//         baseUrl: Api.baseURL,
//         connectTimeout: 30000,
//         receiveTimeout: 30000,
//       );
//
//
//       dio = Dio(options);
//       final response = await dio.post(Api.createTicket, data: map);
//       final responseEncode = json.encode(response.data);
//       final responseJson = json.decode(responseEncode);
//       if(responseJson['status'].toString() == "200") {
//         //init();
//         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//         Fluttertoast.showToast(msg: S .of(context).success_submit
//             //"Successfully submitted"
//             , fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//       } else {
//         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//         Fluttertoast.showToast(msg: S .of(context).something_went_wrong,
//             //"Something went wrong",
//             fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//       }
//
//     } catch (error) {
//       Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//       Fluttertoast.showToast(msg:  S .of(context).something_went_wrong,
//           // "Something went wrong",
//           fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//       throw error;
//     }
//   }
//   Future<void> createTicket() async { // imp feature in adding async is the it automatically wrap into Future.
//
//     String _imagePath = "";
//     List path = [];
//     for(int i = 0; i < images.length; i++) {
//       if(i == 0) {
//         path.add(MultipartFile.fromFileSync(images[i].path.toString()));
//         _imagePath = images[i].path.toString();
//       } else {
//         path.add(MultipartFile.fromFileSync(images[i].path.toString()));
//         _imagePath = _imagePath + "," + images[i].path.toString();
//       }
//     }
//     try {
//       final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//       final subject = routeArgs['subject'];
//       final type = routeArgs['type'];
//
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       var map = FormData.fromMap({
//
//         "id": PrefUtils.prefs!.getString('apikey'),
//         "parent": PrefUtils.prefs!.getString('apikey'),
//         "subject": subject,
//         "message": name + ", " + deliverlocation + ", Contact Number: " +
//             phone + " Date: " + pickedDate.toString(),
//         "type": type,
//         'image': path,
//         'place': deliverlocation,
//         "callback": (status == true) ? "1" : "0",
//         "branch": PrefUtils.prefs!.getString('branch'),
//
//       });
//
//       Dio dio;
//       BaseOptions options = BaseOptions(
//         baseUrl: Api.baseURL,
//         connectTimeout: 30000,
//         receiveTimeout: 30000,
//       );
//
//
//       dio = Dio(options);
//       final response = await dio.post(Api.createTicket, data: map);
//       final responseEncode = json.encode(response.data);
//       final responseJson = json.decode(responseEncode);
//       if(responseJson['status'].toString() == "200") {
//         //init();
//         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//         Fluttertoast.showToast(msg: S .of(context).success_submit
//         //"Successfully submitted"
//             , fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//
//       } else {
//         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//         Fluttertoast.showToast(msg: S .of(context).something_went_wrong,
//         //"Something went wrong",
//             fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//       }
//
//     } catch (error) {
//       Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//       Fluttertoast.showToast(msg:  S .of(context).something_went_wrong,
//      // "Something went wrong",
//           fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//       throw error;
//     }
//   }
//
//   init() {
//     pickedDate = DateTime.now();
//
//     Future.delayed(Duration.zero, () async {
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       var connectivityResult = await (Connectivity().checkConnectivity());
//       if (connectivityResult == ConnectivityResult.mobile) {
//         setState(() {
//           _isinternet = true;
//         });
//         // I am connected to a mobile network.
//       } else if (connectivityResult == ConnectivityResult.wifi) {
//         // I am connected to a wifi network.
//         setState(() {
//           _isinternet = true;
//         });
//       } else {
//         Fluttertoast.showToast(msg:S .of(context).no_internet
//         //"No internet connection!!!"
//           , fontSize: MediaQuery.of(context).textScaleFactor *13,);
//         setState(() {
//           _isinternet = false;
//         });
//       }
//     });
//   }
//   void checkdetails() {
//     final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//
//       if(images.length > 0){
//         Fluttertoast.showToast(msg: S .of(context).provide_image
//        // "provide image"
//             , fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
//       }
//       else{
//
//         ( _isWeb && ResponsiveLayout.isSmallScreen(context))?createTicketWeb(): createTicket();
//       }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
//     if(images.length == 1){
//       uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11;
//     }
//     else if (images.length == 2){
//       uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *2;
//     }
//     else if(images.length == 3){
//       uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *3;
//     }
//     else if(images.length == 4){
//       uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *4;
//     }
//     else if(images.length == 5){
//       uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *5;
//     }
//     else if(images.length >= 6){
//       uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *6;
//     }
//     _buildBottomNavigationBar() {
//       return GestureDetector(
//         onTap: (){
//           checkdetails();
//         },
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: 50.0,
//           color: Theme.of(context).primaryColor,
//           child: Center(child: Text(S .of(context).place_order
//            // "PLACE ORDER"
//             ,style: TextStyle(color: Theme.of(context).buttonColor,fontSize: 16),)),
//         ),
//       );
//     }
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: gradientappbarmobile() ,
//       backgroundColor: Color(0xffffffff),
//       body: !_isinternet ?
//       Center(
//         child: Container(
//
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Align(
//                 child: Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.only(left: 80.0, right: 80.0),
//                     width: MediaQuery.of(context).size.width,
//                     height: 200.0,
//                     child: new Image.asset(Images.noInternetImg)
//                 ),
//               ),
//               SizedBox(height: 10.0,),
//               Text(S .of(context).no_internet
//                   //"No internet connection"
//               ),
//               SizedBox(height: 5.0,),
//               Text(S .of(context).not_right_internet,
//                // "Ugh! Something's not right with your internet",
//                 style: TextStyle(fontSize: 12.0, color: Colors.grey),),
//               SizedBox(height: 10.0,),
//               GestureDetector(
//                 onTap: () {
//                   _refreshProducts(context);
//                 },
//                 child: Container(
//                   width: 90.0,
//                   height: 40.0,
//                   decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(3.0),),
//                   child: Center(
//                       child: Text( S .of(context).try_again
//                       //  'Try Again'
//                         , textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ):
//       SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
// //            SizedBox(height: 10,),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xffe9e9e9),
//                 ),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       SizedBox(height: 20,),
//                       GestureDetector(
//                           onTap: (){
//                             if( _isWeb){
//                               if(ResponsiveLayout.isSmallScreen(context)){
//                                 imageSelectorCamera();;
//                               }
//                             }else{
//
//                               _pickImage();
//                             }
//                             // ( _isWeb && ResponsiveLayout.isSmallScreen(context))?_pickImage():imageSelectorCamera();
//                           },
//                           child: Image.asset(Images.cameraImg, width: MediaQuery.of(context).size.width-40,)),
//                       SizedBox(height: 20,),
//                       GestureDetector(
//                           onTap: () {
//                             if (_isWeb) {
//                               if (ResponsiveLayout.isSmallScreen(context)) {
//                                 imageSelectorGallery();
//                               }
//                             } else {
//
//                               _pickImage();
//                             }
//                           },
//                             child: Image.asset(Images.galleryImg, width: MediaQuery.of(context).size.width-40,)),
//                       SizedBox(height: 20,),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height/3,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                           width: MediaQuery.of(context).size.width,
// //                              margin: EdgeInsets.only(bottom: 20.0),
//
//                           child: (_isWeb && ResponsiveLayout.isSmallScreen(context))?displayImagesWeb():displayImages()),
//                     ),
//                   ],
//                 ),
//               ),
//             Spacer(),
//             Option(),
// //            SizedBox(height: 30,),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: iphonex ? 16.0 : 0.0),
//         child: _buildBottomNavigationBar(),
//       ),
//     );
//   }
//
//   gradientappbarmobile() {
//     return  AppBar(
//       brightness: Brightness.dark,
//       toolbarHeight: 60.0,
//       elevation:  (IConstants.isEnterprise)?0:1,
//       automaticallyImplyLeading: false,
//       leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
//           onPressed: () {
//             Navigator.of(context).pop();
//             // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
//             return Future.value(false);
//           }
//       ),
//       titleSpacing: 0,
//       title: Text(S .of(context).upload,
//       //  'Upload',
//         style: TextStyle(color: ColorCodes.menuColor,fontWeight: FontWeight.normal),
//       ),
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   ColorCodes.accentColor,
//                   ColorCodes.primaryColor
//                 ]
//             )
//         ),
//       ),
//     );
//   }
// }


////app.............................dynamic


import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:grocbay/constants/features.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/api.dart';

import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../constants/IConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file/local.dart';
import '../assets/images.dart';
import '../assets/ColorCodes.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';

class MultipleImagePicker extends StatefulWidget {
  static const routeName = '/multipleImage-screen';


  final LocalFileSystem localFileSystem;

  MultipleImagePicker({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> with Navigations {
  final _contactFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  String name = "";
  String phone ="";
  String deliverlocation="";
  String ln = "";
  String ea = "";
  String gst = "";
  String sn = "";
  String dropdownValue = 'GSTIN';
  //SharedPreferences prefs;
  File? _image;
  final picker = ImagePicker();
  DateTime? pickedDate;
  var image;
  File? file;
  TextEditingController _controller = new TextEditingController();
  bool _isDuration = false;
  File? galleryFile;
  List uploadlist = [];
//save the result of camera file
  File? cameraFile;
  var images_captured=<Widget>[];
  int _groupValue = 1;
  bool _value = false;
  List<File>? _files;
  String filePath="";
  List? pics;
  List<File> images = <File>[];
  var uploadtime;
  String? imageSize;
  int check = 0;
  bool status = false;
  bool iphonex = false;

  AnimationController? _animationController;

  imageSelectorGallery() async {



    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );

    images.add(galleryFile!);

    uploadlist.add(MultipartFile.fromFileSync(galleryFile!.path));


    setState(() {});
  }
  //display image selected from camera
  imageSelectorCamera() async {
    if(!Vx.isWeb&&!(await Permission.camera.isGranted)){
      await Permission.camera.request();
    };
    cameraFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 40
    );
    images.add(cameraFile!);
    uploadlist.add(MultipartFile.fromFileSync(cameraFile!.path));
    setState(() {

    });
  }

  displayImages(){
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: Stack(children: <Widget>[
            Container(
              height: 100,
              width: 100,
              child: Image.file(images[index],fit: BoxFit.fill,),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    images.removeAt(index);
                  });
                },
                child: Icon(
                  Icons.cancel,
                ),
              ),
            ),
          ],),
        );

      }),
    );
  }
  Widget Option() {
    return Container(
      decoration: BoxDecoration(
        color: ColorCodes.lightGreyWebColor,
      ),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          SizedBox(width:10),
          /* Checkbox(
            value: _value,
            checkColor: Theme.of(context).primaryColor,
            activeColor: Colors.white,
            hoverColor: Colors.white,
            focusColor: Colors.white,
            onChanged: (bool newValue) {
              setState(() {
                _value = newValue;
              });
            },
          ),*/
          Expanded(
            child: Text(
              S .of(context).do_you_want
                  //"Do You Want "
                  + IConstants.APP_NAME+
                  S .of(context).call_further_details,
              // " To Call You For Further Details?",
              style: TextStyle(/*fontWeight: FontWeight.bold, fontSize: 16,*/color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(width:10),
          FlutterSwitch(
            width:60,
            height: 25,
            toggleSize: 23,

            activeColor: ColorCodes.primaryColor,//Theme.of(context).accentColor,
            activeToggleColor: ColorCodes.whiteColor,//Theme.of(context).primaryColorDark,
            value: status,
            onToggle: (val) {
              setState(() {
                status = val;
              });
            },
          ),
          SizedBox(width:10)
        ],
      ),
    );
  }
  _dialogforProcessing1() {
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


                    child:
//                    CircularProgressIndicator(),
                    LinearPercentIndicator(
//                      width: MediaQuery.of(context).size.width,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: uploadtime,
                      percent: 0.95,
                      center: Text( S .of(context).uploading
                        // "Uploading......."
                      ),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.green,
                    ),

                  ),
                );
              }
          );
        });
  }
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();

  bool _isinternet = true;


  Future<void> _refreshProducts(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        _isinternet = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _isinternet = true;
      });
    } else {
      Fluttertoast.showToast(msg:  S .of(context).no_internet
        // "No internet connection!!!"
        , fontSize: MediaQuery.of(context).textScaleFactor *13,);
      setState(() {
        _isinternet = false;
      });
    }

  }
  @override
  void initState() {
    pickedDate = DateTime.now();
    Future.delayed(Duration.zero, () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        if (Platform.isIOS) {
          setState(() {
            iphonex = MediaQuery.of(context).size.height >= 812.0;
          });
        }
      } catch (e) {
      }
      setState(() {
        deliverlocation = PrefUtils.prefs!.getString("deliverylocation")!;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          _isinternet = true;
        });
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        setState(() {
          _isinternet = true;
        });
      } else {
        Fluttertoast.showToast(msg: S .of(context).no_internet
          //  "No internet connection!!!"
          , fontSize: MediaQuery.of(context).textScaleFactor *13,);
        setState(() {
          _isinternet = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    // _animationController!.dispose();
    _contactFocusNode.dispose();
    _addressFocusNode.dispose();

    super.dispose();
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

  Future<void> createTicket() async { // imp feature in adding async is the it automatically wrap into Future.
    String _imagePath = "";
    List path = [];
    for(int i = 0; i < images.length; i++) {
      if(i == 0) {
        path.add(MultipartFile.fromFileSync(images[i].path.toString()));
        _imagePath = images[i].path.toString();
      } else {
        path.add(MultipartFile.fromFileSync(images[i].path.toString()));
        _imagePath = _imagePath + "," + images[i].path.toString();
      }
    }
    try {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final subject = /*routeArgs['subject']*/ "Click & Send";
      final type = /*routeArgs['type']*/ "click";

      //SharedPreferences prefs = await SharedPreferences.getInstance();

      var map = FormData.fromMap({

        "id": PrefUtils.prefs!.getString('apikey'),
        "parent": PrefUtils.prefs!.getString('apikey'),
        "subject": subject,
        "message": name + ", " + deliverlocation + ", Contact Number: " +
            phone + " Date: " + pickedDate.toString(),
        "type": type,
        'image': path,
        'place': deliverlocation,
        "callback": (status == true) ? "1" : "0",
        "branch": PrefUtils.prefs!.getString('branch'),

      });

      Dio dio;
      BaseOptions options = BaseOptions(
        baseUrl: Api.baseURL,
        connectTimeout: 30000,
        receiveTimeout: 30000,
      );


      dio = Dio(options);
      final response = await dio.post(Api.createTicket, data: map);
      final responseEncode = json.encode(response.data);
      final responseJson = json.decode(responseEncode);
      if(responseJson['status'].toString() == "200") {
        //init();
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: S .of(context).success_submit
            //"Successfully submitted"
            , fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,
            //"Something went wrong",
            fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
      }

    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg:  S .of(context).something_went_wrong,
          // "Something went wrong",
          fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
      throw error;
    }
  }

  init() {
    pickedDate = DateTime.now();

    Future.delayed(Duration.zero, () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          _isinternet = true;
        });
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        setState(() {
          _isinternet = true;
        });
      } else {
        Fluttertoast.showToast(msg:S .of(context).no_internet
          //"No internet connection!!!"
          , fontSize: MediaQuery.of(context).textScaleFactor *13,);
        setState(() {
          _isinternet = false;
        });
      }
    });
  }
  void checkdetails() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    if(images.length == 0){
      Fluttertoast.showToast(msg: S .of(context).provide_image
          // "provide image"
          , fontSize: MediaQuery.of(context).textScaleFactor *13, backgroundColor: Colors.black87, textColor: Colors.white);
    }
    else{
      _dialogforProcessing1();
      createTicket();
    }
  }




  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    if(images.length == 1){
      uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11;
    }
    else if (images.length == 2){
      uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *2;
    }
    else if(images.length == 3){
      uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *3;
    }
    else if(images.length == 4){
      uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *4;
    }
    else if(images.length == 5){
      uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *5;
    }
    else if(images.length >= 6){
      uploadtime = http.MultipartRequest("", Uri.parse("uri")).contentLength * 11 *6;
    }
    _buildBottomNavigationBar() {
      return GestureDetector(
        onTap: (){
          checkdetails();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).primaryColor,
          ),

          child: Center(child: Text(S .of(context).save_changes
            // "PLACE ORDER"
            ,style: TextStyle(color: Theme.of(context).buttonColor,fontSize: 16),)),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: gradientappbarmobile() ,
      backgroundColor: ColorCodes.whiteColor,
      body: !_isinternet ?
      Center(
        child: Container(

          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 80.0, right: 80.0),
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    child: new Image.asset(Images.noInternetImg)
                ),
              ),
              SizedBox(height: 10.0,),
              Text(S .of(context).no_internet
                //"No internet connection"
              ),
              SizedBox(height: 5.0,),
              Text(S .of(context).not_right_internet,
                // "Ugh! Something's not right with your internet",
                style: TextStyle(fontSize: 12.0, color: Colors.grey),),
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: () {
                  _refreshProducts(context);
                },
                child: Container(
                  width: 90.0,
                  height: 40.0,
                  decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(3.0),),
                  child: Center(
                      child: Text( S .of(context).try_again
                        //  'Try Again'
                        , textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                ),
              ),
            ],
          ),
        ),
      ):
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            SizedBox(height: 10,),
//             Container(
//               decoration: BoxDecoration(
//                 color: ColorCodes.whiteColor,
//               ),
//               child: Center(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20,),
//                     GestureDetector(
//                         onTap: (){
//                           imageSelectorCamera();
//                         },
//                         child: Image.asset(Images.cameraImg, width: MediaQuery.of(context).size.width-40,)),
//                     SizedBox(height: 20,),
//                     GestureDetector(
//                         onTap: (){
//                           imageSelectorGallery();
//                         },
//                         child: Image.asset(Images.galleryImg, width: MediaQuery.of(context).size.width-40,)),
//                     SizedBox(height: 20,),
//                   ],
//                 ),
//               ),
//             ),

            Container(
              decoration: BoxDecoration(
                color: ColorCodes.whiteColor,
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    GestureDetector(
                        onTap: (){
                          imageSelectorCamera();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 20),
                          decoration: BoxDecoration(
                            color: ColorCodes.varcolor,
                            borderRadius: BorderRadius.all(
                                const Radius.circular(5.0)
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                Images.bulkImage,
                                height: 30,
                                color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).take_photo, style: TextStyle(color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor, fontWeight: FontWeight.w900, fontSize: 16),),
                                 SizedBox(height: 5),
                                  Text(S.of(context).order_quick, style: TextStyle(color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor, fontWeight: FontWeight.bold, fontSize: 12),),
                                ],
                              )
                            ],
                          ),
                        )),
                    SizedBox(height: 20,),
                    GestureDetector(
                        onTap: (){
                          imageSelectorGallery();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 20),
                          decoration: BoxDecoration(
                            color: ColorCodes.supportbg,
                            borderRadius: BorderRadius.all(
                                const Radius.circular(5.0)
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Image.asset(
                                Images.fileImage,
                                height: 35,
                                color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 25,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).add_file, style: TextStyle(color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor, fontWeight: FontWeight.w900, fontSize: 16),),
                                  SizedBox(height: 5),
                                  Text(S.of(context).upload_file, style: TextStyle(color: IConstants.isEnterprise? ColorCodes.primaryColor:ColorCodes.liteColor, fontWeight: FontWeight.bold, fontSize: 12),),
                                ],
                              )
                            ],
                          ),
                        )),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/3,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
//                              margin: EdgeInsets.only(bottom: 20.0),
                        child: displayImages()),
                  ),
                ],
              ),
            ),
            Spacer(),
            Option(),
           SizedBox(height: 20,),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15.0, top: 0.0, right: 15.0, bottom: iphonex ? 16.0 : 15.0),
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  gradientappbarmobile() {
    return  AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 60.0,
      elevation:  (IConstants.isEnterprise)?0:1,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () async{
           // Navigator.of(context).pop();
            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
            Navigation(context, navigatore: NavigatoreTyp.Pop);
            return Future.value(false);
          }
      ),
      titleSpacing: 0,
      title: Text(S .of(context).upload,
        //  'Upload',
        style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ]
            )
        ),
      ),
    );
  }
}

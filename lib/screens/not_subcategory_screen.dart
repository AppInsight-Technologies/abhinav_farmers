import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocbay/constants/features.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:grocbay/rought_genrator.dart' as nav;
import '../generated/l10n.dart';
import 'package:provider/provider.dart';
import '../rought_genrator.dart' ;
import '../screens/searchitem_screen.dart';
import '../providers/notificationitems.dart';
import '../widgets/categories_item.dart';
import '../constants/IConstants.dart';
import '../providers/branditems.dart';
import '../assets/ColorCodes.dart';
import 'notification_screen.dart';

class NotSubcategoryScreen extends StatefulWidget {
  static const routeName = '/not-subcategory-screen';


  String subcategoryId = "";
  String fromscreen = "";
  String notificationId = "";
  String notificationStatus = "";
  Map<String,String>? notsub;

  NotSubcategoryScreen(Map<String, String> params){
    this.notsub= params;
    this.subcategoryId = params["subcategoryId"]??"" ;
    this.fromscreen = params["fromScreen"]??"";
    this.notificationId = params["notificationId"]??"" ;
    this.notificationStatus = params["notificationStatus"]??"";

  }

  @override
  _NotSubcategoryScreenState createState() => _NotSubcategoryScreenState();
}

class _NotSubcategoryScreenState extends State<NotSubcategoryScreen> with Navigations {
  bool _isLoading = true;
  var subcategoryData;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      print("data click udate....."+widget.notificationStatus.toString());
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final subcategoryId = widget.subcategoryId;//routeArgs['subcategoryId'];

      if(/*routeArgs['fromScreen']*/widget.fromscreen == "ClickLink") {
        Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(/*routeArgs['notificationId']!*/widget.notificationId, "1" );
      } else {
        if(/*routeArgs['notificationStatus']*/widget.notificationStatus == "2" || widget.notificationStatus == "0"){
          Provider.of<NotificationItemsList>(context,listen: false).updateNotificationStatus(/*routeArgs['notificationId']!*/widget.notificationId, "1" ).then((value){
          });
        }
      }

      Provider.of<NotificationItemsList>(context,listen: false).fetchCategoryItems(subcategoryId).then((_) {
        subcategoryData = Provider.of<NotificationItemsList>(context,listen: false);
        if (subcategoryData.catitems.length <= 0) {
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }); // only create the future once.
    });
  }

  @override
  didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });


      Provider.of<BrandItemsList>(context,listen: false).fetchShoppinglist();
      // Provider.of<BrandItemsList>(context,listen: false).GetRestaurant().then((value) async {
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    bool _isNotification = false;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    if(/*routeArgs['fromScreen']*/widget.fromscreen == "ClickLink") {
      _isNotification = false;
    } else {
      _isNotification = true;
    }

    return _isNotification ?
    WillPopScope(
      onWillPop: (){
        if(/*routeArgs['fromScreen'] */widget.fromscreen== "ClickLink"){
        /*  Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);*/
          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
        }
        else {
          Navigation(context, navigatore: nav.NavigatoreTyp.PushReplacment,name: Routename.notify);

        }
        //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorCodes.appbarColor,
                ColorCodes.appbarColor2
              ]
          ),
          elevation: (IConstants.isEnterprise)?0:1,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color:ColorCodes.iconColor),
              onPressed: () {
                if(/*routeArgs['fromScreen'] */widget.fromscreen== "ClickLink"){
                  Navigation(context, navigatore: NavigatoreTyp.Pop,);
                }
                else {
                  Navigation(context, navigatore: NavigatoreTyp.PushReplacment,name: Routename.notify);
                }
                //Navigator.of(context).pop();
               // Navigator.of(context).pushReplacementNamed(NotificationScreen.routeName);
              }
          ),
          title: Text(
            S .of(context).categories, // "Categories",
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),

          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);

              },
              child: Icon(
                Icons.search,
                size: 30.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),

        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :
        GridView.builder(
          shrinkWrap: true,
          controller: new ScrollController(
              keepScrollOffset: false
          ),
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          itemCount: subcategoryData.catitems.length,
          itemBuilder: (BuildContext context, int index) {
            return  Card(
              color: subcategoryData
                    .catitems[index].featuredCategoryBColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),

                   ),
              ),
              elevation: 4,
              margin: EdgeInsets.all(5),
              child: CategoriesItem(
                  "NotSubcategoryScreen", "Offers", "", "", "", index,
                  subcategoryData.catitems[index].imageUrl),
            // backgroundColor: Colors.transparent
            );
          },
/*            itemBuilder: (ctx, i) => ChangeNotifierProvider.value (
                value: subcategoryData.catitems[i],
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.all(5),
                  child: CategoriesItem("SubcategoryScreen", "Offers", i),
                ),
              ),*/
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
        ),
      ),
    )
        :
    WillPopScope(
      onWillPop: () { // this is the block you need
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     '/home-screen', (Route<dynamic> route) => false);
        if(/*routeArgs['fromScreen'] */widget.fromscreen== "ClickLink"){
          /*Navigator.of(context).pushNamedAndRemoveUntil(
              '/home-screen', (Route<dynamic> route) => false);*/
          Navigation(context, /*name:Routename.Home,*/navigatore: NavigatoreTyp.homenav);
        }
        else {
          Navigator.of(context).pushReplacementNamed(
              NotificationScreen.routeName);
        }
        //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
        return Future.value(false);
      },
      child: Scaffold(
          appBar: NewGradientAppBar(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorCodes.appbarColor,
                  ColorCodes.appbarColor2
                ]
            ),
            title: Text(
              S .of(context).categories,//"Categories",
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigation(context, navigatore: NavigatoreTyp.Push,name: Routename.search);

                },
                child: Icon(
                  Icons.search,
                  size: 30.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),

          body: _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              :
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            controller: new ScrollController(
                keepScrollOffset: false
            ),
            itemCount: subcategoryData.catitems.length,
            itemBuilder: (BuildContext context, int index) {
              return  Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.all(5),
                child: CategoriesItem("NotSubcategoryScreen", "Offers", "", "", "", index, subcategoryData.catitems[index].imageUrl),
              );
            },
/*            itemBuilder: (ctx, i) => ChangeNotifierProvider.value (
              value: subcategoryData.catitems[i],
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.all(5),
                child: CategoriesItem("SubcategoryScreen", "Offers", i),
              ),
            ),*/
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
          ),
      ),
    );
  }
}
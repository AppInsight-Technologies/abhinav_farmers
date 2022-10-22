import 'package:flutter/material.dart';
import 'package:grocbay/constants/features.dart';
import '../utils/prefUtils.dart';
import '../constants/IConstants.dart';
import 'package:provider/provider.dart';
import '../providers/advertise1items.dart';
import '../assets/ColorCodes.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../utils/ResponsiveLayout.dart';
import 'dart:io';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class PagesScreen extends StatefulWidget {
  static const routeName = '/pages-screen';

  Map<String,String> id;
  PagesScreen(this.id);
  @override
  _PagesScreentState createState() => _PagesScreentState();
}

class _PagesScreentState extends State<PagesScreen> {
  bool _iscustomsupport = false;
  bool _isWeb =false;
  //SharedPreferences prefs;
  bool _isinternet = true;
  // bool _isloading = true;
  MediaQueryData? queryData;
  double? wid;
  double? maxwid;
  bool _isLoading = true;

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
     Future.delayed(Duration.zero, () async{
       final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

       final id = /*routeArgs['id']*/widget.id['id'];
       await Provider.of<Advertise1ItemsList>(context, listen: false).pageDetails(id.toString()).then((_) => {
       setState(() {
       _isLoading = false;
       }),
       });
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pagesData = Provider.of<Advertise1ItemsList>(context, listen: false);

    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,
        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async{
              Navigator.of(context).pop();
              // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: _isLoading ? SizedBox.shrink() : Text((pagesData.pages.length>0)?pagesData.pages[0].title!:"",
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
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
    _body() {
      /*_isloading ?
      Center(
        child: CircularProgressIndicator(),
      ) :*/
      queryData = MediaQuery.of(context);
      wid= queryData!.size.width;
      maxwid=wid!*0.90;
      return _isLoading ?
      Center(
      child: CircularProgressIndicator(),
      ) :
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            constraints: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?BoxConstraints(maxWidth: maxwid!):null,

            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 5.0,),
//                  Expanded(child: Text(privacy)),
                    Expanded(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1.0),
                          child: Html(
                            data: pagesData.pages[0].content,
                            style: {
                              "span": Style(
                                fontSize: FontSize(12.0),
                                fontWeight: FontWeight.normal,
                              )
                            },
                          ),
                        )
                    ),
                    // SizedBox(width: 5.0,),
                  ],
                ),
                if(_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
              ],
            ),
          ),
        ),
      );

    }

    return Scaffold(
      appBar: ResponsiveLayout.isSmallScreen(context) ?
      gradientappbarmobile() : null,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Column(
        children: <Widget>[
          if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
            Header(false),
          if(pagesData.pages.length>0)
          _body(),
        ],
      ),
    );
  }
}

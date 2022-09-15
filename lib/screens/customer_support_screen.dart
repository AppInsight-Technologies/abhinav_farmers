import 'package:crisp/crisp_view.dart';
import 'package:crisp/models/main.dart';
import 'package:crisp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:grocbay/constants/features.dart';
import 'package:grocbay/models/VxModels/VxStore.dart';
import 'package:grocbay/utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';


class CustomerSupportScreen extends StatefulWidget {
  static const routeName = '/cutomer-support-screen';

  Map<String,String> photourl;
  CustomerSupportScreen(this.photourl);
  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> with Navigations{
  GroceStore store = VxState.store;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {

    });
  }

  @override
  Widget build(BuildContext context) {
    CrispMain crispMain;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final name = routeArgs['name'];
    final email = routeArgs['email'];
    final photourl = routeArgs['photourl'];
    final phone = routeArgs['phone'];
    debugPrint("IConstants.websiteId...."+IConstants.websiteId+"  "+photourl.toString()+"  "+PrefUtils.prefs!.getString("apikey").toString());
    crispMain = CrispMain(
      websiteId: (Features.ismultivendor) ? IConstants.websiteIdroot : IConstants.websiteId,
    );

    crispMain.register(
      user: CrispUser(
        email:  store.userData.email!,
        // avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
        nickname: store.userData.username,
        phone: store.userData.mobileNumber,
      ),
    );

    crispMain.setMessage("Hi");
  // CrispMain _crispmain =  CrispMain(websiteId: IConstants.websiteId,user: CrispUser(
  //   email: store.userData.email!,
  //    // avatar: photourl,
  //     nickname: store.userData.username,
  //     phone: store.userData.mobileNumber, )).setMessage("Hi");


    return /*Scaffold(
      body : Material(
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: CrispView(
                  loadingWidget: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
*//*              SafeArea(
                child: Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios,),
                  ),
                ),
              ),*//*

            ],
          ),
      ),
    );*/
    Scaffold(
      appBar: AppBar(
        backgroundColor: IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.accentColor:ColorCodes.appbarColor,//ColorCodes.primaryColor,
        elevation:  (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: IConstants.isEnterprise && !Features.isWebTrail?ColorCodes.menuColor:ColorCodes.iconColor),
            onPressed: () => Navigator.of(context).pop()),
        title:  Text(S.of(context).chat,//'Chat',
            style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18)),

      ),
      body: CrispView(
        clearCache: true,
        onLinkPressed: (value){

        },
         crispMain: crispMain,
      ),
    );
  }
}

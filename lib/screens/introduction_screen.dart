import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocbay/assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../rought_genrator.dart';
import '../utils/prefUtils.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_screen.dart';



class introductionscreen extends StatefulWidget {
  static const routeName = '/introduction-screen';


  @override
  _introductionscreenState createState() => _introductionscreenState();
}
void introductionupdate() async{
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  PrefUtils.prefs!.setBool('introduction', true);

}
/*void introductionnonupdate()async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  PrefUtils.prefs!.setBool('introduction', false);
}*/

class _introductionscreenState extends State<introductionscreen>with Navigations {
  final introKey = GlobalKey<IntroductionScreenState>();

  void introductionSkip() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    PrefUtils.prefs!.setBool('introduction', true);
   // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    Navigation(context, name:Routename.Home,navigatore: NavigatoreTyp.Push);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 15.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700,color:Colors.green),
      bodyTextStyle: bodyStyle,
      titlePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: Colors.white,
      //imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.zero,
      footerPadding: EdgeInsets.zero,
      bodyFlex: 0,
    );

    /*Stack(children: <Widget>[
      Align(alignment: Alignment.center,
        child: Container(width: 100, height: 100, color: Colors.redAccent,),),
      Align(alignment: Alignment.bottomCenter,
        child: Container(height: 100, color: Colors.purpleAccent,),)
    ],)*/

    return Scaffold(
      body: Center(
        child: IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                title: S .of(context).signup_with_grocbay + IConstants.APP_NAME + S .of(context).today,//'Signup with GrocBay today',
                bodyWidget: Column(
                    children: [
                  //SizedBox(height: 20,),
                      Row(children: <Widget>[
                        Expanded(child: Text(
                            S .of(context).choose_over,//'Choose from over 1000+ items ranging from Farm Fresh Veggies to Imported Fruits and avail attractive discounts on the same.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontSize: 15.0, fontWeight: FontWeight.w300
                            )),),
                      ],),
                      SizedBox(height: 20,),
                      Text(
                        S .of(context).no_more_kit_pit,//'#NoMoreKhitPit',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ColorCodes.greenColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),)
                ]
                ),
                image: Center(
                    child: Image.asset(
                      Images.onboarding1Img,)),//SvgPicture.asset('assets/images/Onboard-1.svg', /*height: MediaQuery.of(context).size.height,*/)),
                decoration: pageDecoration,

              ),
              PageViewModel(
                  title: S .of(context).no_more_kitpit,//'No More Khit-pit',
                  bodyWidget: Column(
                      children:[
                        SizedBox(height: 20,),
                        Row(children:[Expanded(child:Text(
                            S .of(context).shop_form_comforts,
                          //'Shop from the comforts of your home and avoid Congested & Muddy markets, Improper Weighment & Packing, Traffic & Parking Problem aur Daily ka Khit-pit.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontSize: 15.0,fontWeight: FontWeight.w300
                            )),)]),
                        SizedBox(height: 20,),
                        Text(
                          S .of(context).ghar_baite_order,
                          //'#GharBaiteOrderKaro',
                          textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color:ColorCodes.greenColor),)
                      ]
                  ),
                  image: Image.asset(
                    Images.onboarding2Img,),//SvgPicture.asset('assets/images/Onboard-2.svg'),
                  decoration: pageDecoration
              ),
              PageViewModel(
                  title: S .of(context).need_help_we_are_here,//'Need Help? We are here.',
                  bodyWidget: Column(
                      children:[
                        SizedBox(height: 20,),
                        Row(children:[Expanded(child:Text(
                            S .of(context).our_experts,//'Our experts are here to help you with your order. Your feedback and experience is of utmost importance to our team.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorCodes.greenColor,
                                fontSize: 15.0,fontWeight: FontWeight.w300
                            )),)]),
                        SizedBox(height: 20,),
                        Text(S .of(context).here_to_help,//'#HeretoHelp',
                          textAlign: TextAlign.center,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: ColorCodes.greenColor),)
                      ]
                  ),
                  image: Image.asset(
                    Images.onboarding1Img,),//SvgPicture.asset('assets/images/Onboard3.svg'),
                  decoration: pageDecoration
              ),

            ],
            showSkipButton: true,
            showNextButton: true,
            onDone:  ()    {
              introductionSkip();
            },
            onSkip: ()     {
              introductionSkip();
            },
            //skipOrBackFlex: 0,
            nextFlex: 0,
            skip: Text(
              S .of(context).intro_skip,//'Skip',
              style: TextStyle(color: ColorCodes.greenColor,fontWeight: FontWeight.w700,fontSize: 18),),
            next: const Icon(Icons.arrow_forward),
            done: Text(
                S .of(context).done,
                //'Done',
                style: TextStyle(fontWeight: FontWeight.w700,color: ColorCodes.greenColor,fontSize: 18)),
            dotsDecorator: const DotsDecorator(
                size: Size(10.0, 10.0),
                color: Color(0xFFBD),
                activeSize: Size(22.0, 10.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),),
                activeColor: Colors.green)
        ),
      ),
    );
  }
}
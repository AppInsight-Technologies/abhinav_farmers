import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocbay/widgets/alert%20_dailog.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../constants/api.dart';
import '../constants/features.dart';
import '../data/calculations.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/cartModle.dart';
import '../models/newmodle/customer_engagement.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import 'package:http/http.dart' as http;

import '../widgets/simmers/customer_survey_shimmer.dart';
class splittedanswers{
  final String answer ;
  bool isselected;
  splittedanswers({ this.answer= '', this.isselected=false});
}
class CustomerEngagementScreen  extends StatefulWidget{
  @override
  State<CustomerEngagementScreen> createState() => _CustomerEngagementScreenState();
}

class _CustomerEngagementScreenState extends State<CustomerEngagementScreen> with Navigations{
  late Future<CustomerEngagement> _futureCustomerEngagement = Future.value();
  int totalQuestions = 0;
  List splitedQuestions = [];
 // List splitedQuestions1 = [];
  List<splittedanswers> splitedQuestions1 = [];
  int index = 0;
  bool isanswerselected = false;
  bool loading = true;
  bool _checkmembership = false;
  bool surveyProductCart = false;
  List<CartItem> productBox=[];
  bool takensurvey = false;

@override
void initState() {
    // TODO: implement initState
  if (VxState.store.userData.membership! == "1") {
    _checkmembership = true;
  } else {
    _checkmembership = false;
  }
  CustomerApi.getCustomerEngagement(ParamBodyData(branchtype: IConstants.isEnterprise && Features.ismultivendor?IConstants.branchtype.toString():"",branch:PrefUtils.prefs!.getString("branch"))).then((value) {
    setState(() {
      _futureCustomerEngagement = Future.value(value);
    });
    _futureCustomerEngagement.then((value) {
      loading = false;
      totalQuestions = value.data!.length;
      splitedQuestions.clear();
      splitedQuestions1.clear();
      for(int i= 0; i<totalQuestions ;i++){
        debugPrint("value.data![i].answers..."+value.data![i].answers!.length.toString());
        splitedQuestions.add(value.data![i].answers);
        debugPrint("splitedQuestions..."+splitedQuestions.toString());

        for(int j=0; j<value.data![i].answers!.length; j++){
          //splitedQuestions1.add(value.data![i].answers![j]);
          debugPrint("value.data![i].answers![j]..."+value.data![i].answers![j].toString());
          var answerobj = new splittedanswers(answer: value.data![i].answers![j], isselected:false);
       //   answerobj.answer = value.data![i].answers![j];
        //  answerobj.isselected = false;
          splitedQuestions1.add(answerobj);

        }
        debugPrint("splitedQuestions1..."+splitedQuestions1.toString());
      }
    });
  });

  productBox = (VxState.store as GroceStore).CartItemList;
  for (int i = 0; i < productBox.length; i++) {
    if (productBox[i].mode =="3") {
      surveyProductCart = true;
    }
  }
    super.initState();
  }
  _dialogforProcessing() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }


  _dialogforThankyouSurvey(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async{
            return Future.value(true);
          },
          child: AlertDialog(
            title: Image.asset(
              Images.logoImg,
              height: 50,
              width: 138,
            ),
            content: Text(msg),
            actions: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigation(context, name: Routename.SurveyProductScreen,
                    navigatore: NavigatoreTyp.Push,
                  );
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ColorCodes.whiteColor,
                    border: Border.all(
                        color: ColorCodes.greenColor),

                  ),
                  child: Center(
                    child: Text(
                      S.of(context).ok,textAlign: TextAlign.center, //'Ok'
                    ),
                  ),

                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> SubmitAnswers() async {
    try {
      debugPrint("submit answer...."+{
        "user":PrefUtils.prefs!.getString('apikey'),
        "answeredQuestionCount":totalQuestions.toString(),
        "totalQuestionCount":totalQuestions.toString(),
      }.toString());
      final response = await http.post(Api.submitAnswer, body: {
        "user":PrefUtils.prefs!.getString('apikey'),
        "answeredQuestionCount":totalQuestions.toString(),
        "totalQuestionCount":totalQuestions.toString(),
      });
      final responseJson = json.decode(response.body);
      debugPrint("responseJson...rate.."+responseJson.toString());
      if (responseJson['status'].toString() == "200") {
        Navigator.pop(context);
        takensurvey = true;
        _dialogforThankyouSurvey("Thank you for taking Survey, select free product with your next Order");
       /* Alert().showSuccess(context,messege: "Thank you for taking Survey, select free product for your next Order",onpress: (){
          //Navigator.of(context).pop();
          Navigation(context, name: Routename.SurveyProductScreen,
            navigatore: NavigatoreTyp.Push,
          );
        });*/
       // _dialogforThankyouSurvey();
      //  Fluttertoast.showToast(msg: "Thank you for taking Survey, You will get free product in your next Order", fontSize: MediaQuery.of(context).textScaleFactor *13,);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      }
    } catch (error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: S .current.something_went_wrong, fontSize: MediaQuery.of(context).textScaleFactor *13,);
      throw error;
    }
  }
  _buildBottomNavigationBar() {
    return BottomNaviagation(
      itemCount: CartCalculations.itemCount.toString() + " " + S.of(context).items,
      title: S.current.view_cart,
      total: _checkmembership ? (CartCalculations.totalMember).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)
          :
      (CartCalculations.total).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),
      onPressed: (){
        Navigation(context, name: Routename.Cart, navigatore: NavigatoreTyp.Push,qparms: {"afterlogin":null});
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: ResponsiveLayout.isSmallScreen(context)
            ? gradientappbarmobile()
            : null,
        backgroundColor: ColorCodes.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context))
                Header(false),
              _body(),
            ],
          ),
        ),
        bottomNavigationBar:  Vx.isWeb ? SizedBox.shrink() :Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom:  0.0),
              child: _buildBottomNavigationBar()
          ),
        ),
      ),
    );

  }
  gradientappbarmobile() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: (IConstants.isEnterprise)?0:1,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
          onPressed: () {
            Navigator.of(context).pop();

          }),
      titleSpacing: 0,
      title: Text(
        S.of(context).customer_survey,//"Customer Survey",
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
                ])),
      ),
    );
  }

  _body(){
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    int widgetsInRow = (Vx.isWeb &&
        !ResponsiveLayout.isSmallScreen(context)) ? 1 : 2;
    if (deviceWidth > 1200) {
      widgetsInRow = 6;
    } else if (deviceWidth < 768) {
      widgetsInRow = 3;
    }
    double aspectRatio = (Vx.isWeb &&
        !ResponsiveLayout.isSmallScreen(context)) ?
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
        60 :
    (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow /
        60;
    return (loading)? CustomerSurveyShimmer() :
    (VxState.store.userData.customerEngagementFlag! =="2")?
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.55,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Images.logoImg,
                  width: 159,
                  height: 140,
                ),
                Text( S.of(context).survey_taken,//"You have already taken survey with Free product",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorCodes.greyColor,
                  ),
                ),
              ],
            ),
          ),
        ):
    (VxState.store.userData.customerEngagementFlag! =="1" || takensurvey == true)?
    Container(
      height: (Vx.isWeb)?MediaQuery
          .of(context)
          .size
          .height * 0.55 + 277 :MediaQuery
          .of(context)
          .size
          .height * 0.55,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Images.logoImg,
              width: 159,
              height: 140,
            ),
            Text( S.of(context).survey_taken_add,//"You have already taken survey, add free product to cart",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: ColorCodes.greyColor,
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                (surveyProductCart)?
                Alert().showSuccess(context,messege: S.of(context).already_selected_free_prodct/*"You have already selected Free product"*/,onpress: (){
                  Navigation(context, navigatore: NavigatoreTyp.homenav);
                })
                    :
                Navigation(context, name: Routename.SurveyProductScreen,
                    navigatore: NavigatoreTyp.Push,
                   );
              },
              child: Text( S.of(context).add_product,//"Add Product",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: ColorCodes.greenColor,
                ),
              ),
            ),
            if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
          ],
        ),
      ),
    )
   : Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<CustomerEngagement>(
            future: _futureCustomerEngagement,
            builder: (BuildContext context,AsyncSnapshot<CustomerEngagement> snapshot){
              final promoData = snapshot.data;

              return (promoData != null && promoData.data!.length >0)?
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                  child: (promoData !=null)? SizedBox(
                    //  height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: /*promoData.data!.length*/ 1,
                        itemBuilder: (BuildContext context, int index1) {
                          return Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:Container(
                                    width:MediaQuery.of(context).size.width,
                                    height: 20,
                                    child: ListView.builder( scrollDirection:Axis.horizontal,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: promoData.data!.length,
                                        itemBuilder: (BuildContext context,int indx){
                                          return  Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height:5,
                                                width:(MediaQuery.of(context).size.width)/promoData.data!.length,
                                                decoration: BoxDecoration(
                                                  color: ( (index == indx || index == indx+1)  ) ? Colors.green : Colors.grey[200],
                                                  border: Border.all(color: Colors.grey),

                                                ),
                                              ),
                                              Text( promoData.data![indx].type.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                            ],
                                          );
                                        }
                                    ),
                                  )

                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( promoData.data![index].question.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                              ),
                              Container(
                               // height:50,
                                width: MediaQuery.of(context).size.width,
                                child:/*ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: promoData.data![index].answers!.length,
                                    itemBuilder: (BuildContext context, int index2) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 50,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(promoData.data![index].answers![index2],style: TextStyle(color: splitedQuestions1[index2].isselected?Colors.green:Colors.grey),),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: splitedQuestions1[index2].isselected?Colors.green:Colors.grey),
                                                borderRadius: BorderRadius.circular(5.0)
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            splitedQuestions1[index2].isselected =  !splitedQuestions1[index2].isselected;
                                            isanswerselected = true;
                                          });

                                        },
                                      );
                                    }

                                ),*/GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: widgetsInRow,
                                    crossAxisSpacing: 3,
                                    childAspectRatio: aspectRatio,

                                  ),
                                  shrinkWrap: true,
                                  controller: new ScrollController(keepScrollOffset: false),
                                  itemCount:  promoData.data![index].answers!.length,
                                  itemBuilder: (_, index2) {
                                  return  GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                         // height: 50,
                                          child: Center(
                                            child: Text(promoData.data![index]
                                                .answers![index2],
                                              style: TextStyle(
                                                  color: splitedQuestions1[index2]
                                                      .isselected
                                                      ? Colors.green
                                                      : Colors.grey),),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: splitedQuestions1[index2]
                                                      .isselected
                                                      ? Colors.green
                                                      : Colors.grey),
                                              borderRadius: BorderRadius
                                                  .circular(5.0)
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          splitedQuestions1[index2].isselected =
                                          !splitedQuestions1[index2].isselected;
                                          isanswerselected = true;
                                        });
                                      },
                                    );
                                  }
                                )
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: MaterialButton(onPressed:(){
                                  if(isanswerselected == true){
                                    setState(() {
                                      isanswerselected = !isanswerselected;
                                      if(index<promoData.data!.length-1){
                                        index = index+1;
                                        for(var i=0;i<splitedQuestions1.length;i++){
                                          splitedQuestions1[i].isselected = false;
                                        }
                                        debugPrint("index...totalQuestions....");

                                      }
                                      else{
                                      //  if(index == totalQuestions){
                                          _dialogforProcessing();
                                          SubmitAnswers();
                                       // }
                                      }


                                    });
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: S.of(context).select_answer/*"Please select any answer"*/, fontSize: MediaQuery.of(context).textScaleFactor *13,);
                                  }


                                },
                                  child: Text(/*'Next'*/S.of(context).next,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                  color: Colors.green,

                                ),
                                width: MediaQuery.of(context).size.width,
                              )
                            ],
                          );
                        }),
                  ):SizedBox.shrink(),
                ),
              ):
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Align(
                    alignment: Alignment.center,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Images.logoImg,
                          width: 159,
                          height: 140,
                        ),
                        Center(
                            child: Text(
                              S.of(context).no_question,//"No Survey Questions found",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            )),
                        SizedBox(
                          height:20,
                        ),
                      ],
                    ),
                  ),
                );

            },
          ),
        ),
        if(Vx.isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),
      ],
    );
  }
}
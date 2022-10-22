
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import '../constants/features.dart';
enum Cart{
ADD , Remove
}
class FirebaseAnalyticsService{
  bool isweb ;

  FirebaseAnalyticsService({ this.isweb =false});
  // static FirebaseAnalyticsWeb firebaseAnalyticsWeb = FirebaseAnalyticsWeb();
  static FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver getAnalyticsObserver()=> FirebaseAnalyticsObserver(analytics: _analytics);
  Future setScreenName(String screen)async{
    // isweb? await firebaseAnalyticsWeb.setCurrentScreen(screenName: screen):
   if(Features.isAnalytics) await _analytics.setCurrentScreen(screenName: screen,screenClassOverride: screen);
  }
  // final FirebaseAnalyticsObserver Function() observer =
   Future setUserProperties({required String userId,String? userState}) async{
     // ignore: unnecessary_statements
     // if(isweb) {await firebaseAnalyticsWeb.setUserId(userId);
     // await firebaseAnalyticsWeb.setUserProperty(name: "user_state", value: userState);}else{await _analytics.setUserId(userId);
     if(Features.isAnalytics)  await _analytics.setUserProperty(name: "user_", value: userState);
  }
  Future LogLogin() async{
    // isweb?await firebaseAnalyticsWeb.logEvent(name: "login Web"):
    if(Features.isAnalytics)  await _analytics.logLogin(loginMethod: "mobile");
  }Future LogSignUp() async{
    // isweb?await firebaseAnalyticsWeb.logEvent(name: "SignUp Web"):
    if(Features.isAnalytics)   await _analytics.logSignUp(signUpMethod: "mobile");
  }Future LogEvent({required String event, Map<String,String>? parameters}) async{
    // isweb?await firebaseAnalyticsWeb.logEvent(name: event):
    if(Features.isAnalytics)  await _analytics.logEvent(name: event,parameters: parameters);
  }Future LogDefaultEvent({required String event, Map<String,String>? parameters}) async{
    // isweb?await firebaseAnalyticsWeb.logEvent(name: event):
    if(Features.isAnalytics)  await _analytics.logEvent(name: event,parameters: parameters);
    // if(Features.isAnalytics)   await _analytics.logAddToCart(itemId: null, itemName: null, itemCategory: null, quantity: null);
  }Future LogAddtoCart({required String itemId,required String itemName,required String itemCategory,required int quantity ,required double amount,required Cart value}) async{
    // isweb?await firebaseAnalyticsWeb.logEvent(name: event):
    switch(value){

      case Cart.ADD:
        // TODO: Handle this case.
        // if(Features.isAnalytics)    await _analytics.logAddToCart(itemId: itemId, itemName: itemName, itemCategory: itemCategory, quantity: quantity,currency: "INR",value: amount);
        break;
      case Cart.Remove:
        // TODO: Handle this case.
        // if(Features.isAnalytics)   await _analytics.logRemoveFromCart(itemId: itemId, itemName: itemName, itemCategory: itemCategory, quantity: quantity,currency: "INR",value: amount);
        break;
    }
  }Future LogSearchItem({required String search}) async{
    if(Features.isAnalytics)   await _analytics.logViewSearchResults(
      searchTerm: search
    );
  }Future LogItemSelected({required String contentType,required String itemId,}) async{
    if(Features.isAnalytics)  await  _analytics.logSelectContent(
      contentType: contentType,
      itemId: itemId,
    );
  }Future LogConfirmOrder({required double value,required String transactionId}) async{
    if(Features.isAnalytics)    await  _analytics.logEcommercePurchase(currency:"INR" ,transactionId: transactionId,value:value ,);
    // await  _analytics.logPurchase(currency:"INR" ,transactionId: transactionId,value:value ,tax: 0,affiliation: "Ewish Store",coupon: "",shipping: 0,);
  }Future LogCancleOrder({required double value,required String transactionId}) async{
    if(Features.isAnalytics)  await  _analytics.logPurchaseRefund(currency:"INR" ,transactionId: transactionId,value:value );
    // await  _analytics.logRefund(currency:"INR" ,transactionId: transactionId,value:value );
  }/*Future LogCheckOut({required double value,String items,String coupon}) async{
    await  _analytics.logBeginCheckout(currency: "INR",value: value,items: "items",coupon: coupon);
    // await  _analytics.logRefund(currency:"INR" ,transactionId: transactionId,value:value );
  }*/
}

final fas = FirebaseAnalyticsService();
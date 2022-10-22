
import 'package:velocity_x/velocity_x.dart';

import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/fetchdata/home_store_repo.dart';
import '../../utils/prefUtils.dart';

class HomeStoreScreenController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var user;
  var lat;
  var long;

  //var languageid;

  HomeStoreScreenController({this.user,this.lat,this.long});
  @override
  Future<bool> perform() async{
    // TODO: implement perform
    store!.homestore = await homeStorerepo.getData(ParamBodyData(user: user,lat: lat,long: long,refid: IConstants.refIdForMultiVendor,language_id: IConstants.languageId));
    //  store!.userData.delevrystatus = true;
    //store!.storedata = await homeStorerepo.getStore(ParamBodyData(lat: lat,long: long,id: ids,refid: IConstants.refIdForMultiVendor));
    store!.userData.area = PrefUtils.prefs!.containsKey("deliverylocation")?PrefUtils.prefs!.getString("deliverylocation"):IConstants.currentdeliverylocation.value;
    if(Features.ismultivendor) {
      //  if(!PrefUtils.prefs!.containsKey("branch")) {
      if ((VxState.store as GroceStore).CartItemList.isEmpty)
        PrefUtils.prefs!.setString("branch", "1");
      IConstants.googleApiKeyroot = store!.homestore.data!.firebaseMapkey!;
    }
    //}

    IConstants.countryCode = store!.homestore.data!.countryCode!;
    PrefUtils.prefs!.setString("country_code",IConstants.countryCode);
    IConstants.primaryMobileroot = store!.homestore.data!.primaryMobile!;
    IConstants.secondaryMobileroot = store!.homestore.data!.secondaryMobile!;
    IConstants.primaryEmailroot = store!.homestore.data!.email!;
    IConstants.websiteIdroot = store!.homestore.data!.crispChatId!;
    Features.isMembershiproot = store!.homestore.data!.membershipSetting! == "0"?true:false;
    Features.isBulkUploadroot = store!.homestore.data!.isBulkUpload! == "0"?true:false;
    Features.isWalletroot = store!.homestore.data!.walletModule! == "0"?true:false;
    Features.isLoyaltyroot = store!.homestore.data!.loyaltySetting! == "0"?true:false;
    Features.isReferEarnroot = store!.homestore.data!.referralSetting! == "0" ? true : false;
    Features.isSubscriptionroot = (store!.homestore.data!.subscriptionModule! == "0") ? true : false;
    Features.isReturnOrExchange = store!.homestore.data!.returnSetting! == "0" ? true : false;
    Features.isShoppingList = store!.homestore.data!.shoppingListModule! == "0" ? true : false;
    Features.isPromocode = store!.homestore.data!.promocodeModule! == "0" ? true : false;
    Features.isPushNotificationroot = store!.homestore.data!.pushNotificationModule! == "0"  ? true : false;
    Features.isPickupfromStore = store!.homestore.data!.pickerModal! == "0" ? true : false;
    Features.isLiveChatroot = store!.homestore.data!.liveChatModule! == "0" ? true : false;
    Features.isWhatsapproot = store!.homestore.data!.whatsapChatModule! == "0"? true : false;
    Features.isRepeatOrder = store!.homestore.data!.repeatOrderModule! == "0" ? true : false;
    Features.isOnBoarding = store!.homestore.data!.onboardingScreenModule! == "0" ? true : false;
    Features.isRefundModule = store!.homestore.data!.refundModule! == "0" ? true : false;
    Features.isRateOrderModule = store!.homestore.data!.rateOrdersModule! == "0" ? true : false;
    Features.isLanguageModuleroot = store!.homestore.data!.languageModule! == "0" ? true : false;
    Features.isSplit = store!.homestore.data!.splitOrder! == "0" ? true : false;
    Features.callMeInsteadOTP = store!.homestore.data!.callMeInsteadOTP! == "0" ? true : false;
    IConstants.minimumOrderAmount = store!.homestore.data!.minimumOrderAmount!.toString() == "null" ? "0" : store!.homestore.data!.minimumOrderAmount!.toString();
    IConstants.maximumOrderAmount = store!.homestore.data!.maximumOrderAmount!.toString();
    PrefUtils.prefs!.setString("restaurant_location", store!.homestore.data!.address!.toString());
    PrefUtils.prefs!.setString("restaurant_lat", store!.homestore.data!.restaurantLat!.toString());
    PrefUtils.prefs!.setString("restaurant_long", store!.homestore.data!.restaurantLong!.toString());
    IConstants.currencyFormat = store!.homestore.data!.currencyFormat.toString();
    return Future.value(true);
  }}
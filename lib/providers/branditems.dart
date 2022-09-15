import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/api.dart'as ap;
import 'package:velocity_x/velocity_x.dart';
import '../controller/mutations/login.dart';
import '../data/hiveDB.dart';
import '../main.dart';
import 'package:hive/hive.dart';
import '../widgets/header/bloc.dart';
import '../controller/mutations/languagemutations.dart';
import '../constants/features.dart';
import 'package:intl/intl.dart';
import '../services/firebaseAnaliticsService.dart';
import '../models/brandFiledModel.dart';
import 'package:http/http.dart' as http;

import '../models/walletfield.dart';
import '../models/sellingitemsfields.dart';
import '../constants/IConstants.dart';
import '../models/pickuplocFields.dart';
import '../models/shoppinglistfield.dart';
import '../models/loyaltyFields.dart';
import '../models/delChargeFields.dart';
import '../models/brandfields.dart';
import '../assets/images.dart';
import '../utils/prefUtils.dart';
import '../constants/api.dart';
import '../assets/ColorCodes.dart';
import '../data/calculations.dart';
import '../providers/referFields.dart';


class BrandItemsList with ChangeNotifier {
  List<BrandsFields> _items = [];
  List<SellingItemsFields> _brandsitems = [];
  List<SellingItemsFields> _itemspricevar = [];
  List<WalletItemsFields> _walletitems = [];
    List<ShoppinglistItemsFields> _shoplistitems = [];
  List<ShoppinglistItemsFields> _listitemsdetails = [];
  List<ShoppinglistItemsFields> _listitemspricevar = [];
  List<WalletItemsFields> _paymentitems = [];
  List<PickuplocFields> _pickupLocitems = [];
  List<DelChargeFields> _itemsDelCharge = [];
  List<LoyaltyFields> _itemsLoyalty = [];
  List<SellingItemsFields> _OffersItems = [];
  List<BrandsFieldModel> _branditems = [];
  List<SellingItemsFields> _itemimages =[];
  List<SellingItemsFields> _itemshoppingimages=[];
  ReferFields? _referEarn;
  Box<Product>? productBox;
  BrandsFieldModel? resultfinal;


  Future<void> LoginUser() async {
    try {
      final response = await http.post(Api.preRegister, body: {
        // await keyword is used to wait to this operation is complete.
        "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
        "tokenId": PrefUtils.prefs!.getString('tokenid'),
        "signature" : PrefUtils.prefs!.containsKey("signature") ? PrefUtils.prefs!.getString('signature') : "",
        //"branch" : PrefUtils.prefs!.getString("branch")
        "branch": IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor:PrefUtils.prefs!.getString("branch"),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final data = responseJson['data'] as Map<String, dynamic>;

      if (responseJson['status'].toString() == "true") {
        fas.LogLogin();
        if(responseJson['type'].toString() == "new") {
          PrefUtils.prefs!.setString('Otp', data['otp'].toString());
          PrefUtils.prefs!.setString('type', responseJson['type'].toString());
        } else {
          PrefUtils.prefs!.setString('Otp', data['otp'].toString());
          PrefUtils.prefs!.setString('apiKey', data['apiKey'].toString());
          // PrefUtils.prefs!.setString('userID', data['userID'].toString());
          PrefUtils.prefs!.setString('type', responseJson['type'].toString());
          PrefUtils.prefs!.setString('membership', data['membership'].toString());
          PrefUtils.prefs!.setString("mobile", data['mobile'].toString());
          PrefUtils.prefs!.setString("latitude", data['latitude'].toString());
          PrefUtils.prefs!.setString("longitude", data['longitude'].toString());
          PrefUtils.prefs!.setString('apple', data['apple'].toString());

          if (PrefUtils.prefs!.getString('prevscreen') != null) {
            if (PrefUtils.prefs!.getString('prevscreen') == 'signingoogle') {} else
            if (PrefUtils.prefs!.getString('prevscreen') == 'signinfacebook') {} else {
              PrefUtils.prefs!.setString('FirstName', data['name'].toString());
              PrefUtils.prefs!.setString('LastName', "");
              PrefUtils.prefs!.setString('Email', data['email'].toString());
              PrefUtils.prefs!.setString("photoUrl", "");
            }
          }
          userDetails();
        }
      } else if (responseJson['status'].toString() == "false") {}
    } catch (error) {
      throw error;
    }
  }

  GetRestaurantNew(String branch ,Function onload) async {
     ap.Api api = ap.Api();
     try {
       api.body ={
         "branch": Features.isWebTrail ? "random" : PrefUtils.prefs!.getString("branch")!,
         "language_id": IConstants.languageId,
         "refid": Features.isWebTrail ? "random" : IConstants.refIdForMultiVendor,
       };
       final resp = Features.isWebTrail? await api.Posturl("get-resturant-web",isv2: false):await api.Posturl("get-resturant",isv2: false);
       final responseJson = json.decode(resp);
      if (responseJson.toString() == "[]") {

      } else {
        List data = [];
        PrefUtils.prefs!.setBool("restor", true);
        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          Features.logo = data[i]['icon_image']!=null?"${IConstants.API_IMAGE}/restaurant/icons/"+data[i]['icon_image'].toString():"";
          Features.isMembership = (data[i]['membershipSetting'].toString() =="0") ? true : false;
          Features.isLanguageModule = (data[i]['languageModule'].toString() =="0") ? true : false;
          Features.isLoyalty = (data[i]['loyaltySetting'].toString() =="0") ? true : false;
          Features.isReferEarn = (data[i]['referralSetting'].toString() =="0") ? true : false;
          Features.isSubscription = (data[i]['subscriptionStatus'].toString() =="0" && data[i]['subscriptionModule'].toString() =="0") ? true : false;
          Features.isReturnOrExchange = (data[i]['returnSetting'].toString() =="0") ? true : false;
          Features.isShoppingList = (data[i]['shoppingListModule'].toString() =="0") ? true : false;
          Features.isPromocode = (data[i]['promocodeModule'].toString() =="0") ? true : false;
          Features.isPushNotification = (data[i]['pushNotificationModule'].toString() =="0")  ? true : false;
          Features.isPickupfromStore = (data[i]['pickUpfromStoreModule'].toString() =="0") ? true : false;
          Features.isExpressDelivery = (data[i]['expressDeliveryModule'].toString() =="0") ? true : false;
          Features.isWallet = (data[i]['walletModule'].toString() =="0") ? true : false;
          Features.isLiveChat = (data[i]['liveChatModule'].toString() =="0") ? true : false;
          Features.isWhatsapp = (data[i]['whatsapChatModule'].toString() =="0") ? true : false;
          Features.isFilter = (data[i]['productFilteringModule'].toString() =="0") ? true : false;
          Features.isShare = (data[i]['productShareModule'].toString() =="0") ? true : false;
          Features.isRepeatOrder = (data[i]['repeatOrderModule'].toString() =="0") ? true : false;
          Features.isOffers = (data[i]['offerModule'].toString() =="0") ? true : false;
          Features.isOnBoarding = (data[i]['onboardingScreenModule'].toString() =="0") ? true : false;
          Features.isWebsiteSlider = (data[i]['isWebsiteSlider'].toString() =="0") ? true : false;
          Features.isCarousel = (data[i]['isMainSlider'].toString() =="0") ? true : false;
          Features.isCategoryOne = (data[i]['isFeaturedCategoryOne'].toString() =="0") ? true : false;
          Features.isAdsCategoryOne = (data[i]['isAdsBelowFeaturedCategoriesOne'].toString() =="0") ? true : false;
          Features.isBulkUpload = (data[i]['isBulkUpload'].toString() =="0") ? true : false;
          Features.isSellingItems = (data[i]['isFeaturedItems'].toString() =="0") ? true : false;
          Features.isAdsItemsOne = (data[i]['isAdsBelowFeaturedItemsOne'].toString() =="0") ? true : false;
          Features.isCategoryTwo = (data[i]['isFeaturedCategoryTwo'].toString() =="0") ? true : false;
          Features.isAdsCategoryTwo = (data[i]['isAdsBelowFeaturedCategoriesTwo'].toString() =="0") ? true : false;
          Features.isCategoryThree = (data[i]['isFeaturedCategoryThree'].toString() =="0") ? true : false;
          Features.isVerticalSlider = (data[i]['isAdsBelowFeaturedCategoriesThree'].toString() =="0") ? true : false;
          Features.isFeatureAdsThree = (data[i]['isAdsBelowCategory'].toString() =="0") ? true : false;
          Features.isCategory = (data[i]['isCategory'].toString() =="0") ? true : false;
          Features.isBrands = (data[i]['isBrands'].toString() =="0") ? true : false;
          Features.isDiscountItems = (data[i]['isDiscountItems'].toString() =="0") ? true : false;
          Features.isOfferItems = (data[i]['offerModule'].toString() =="0") ? true : false;
          Features.isRefundModule = (data[i]['refundModule'].toString() =="0") ? true : false;
          Features.isOffersForHomepage = (data[i]['homepageOffers'].toString() =="0") ? true : false;
          Features.isRateOrderModule = (data[i]['rateOrdersModule'].toString() =="0") ? true : false;
          Features.isSplit = (data[i]['splitOrder'].toString() =="0") ? true : false;
          Features.ismultivendor = (data[i]['multiVendorModule'].toString() =="0") ? true : false;
          Features.callMeInsteadOTP = (data[i]['callMeInsteadOTP'].toString() =="0") ? true : false;
          Features.mainBanneraboveSlider = (data[i]['mainBanneraboveSlider'].toString() =="0") ? true : false;
          IConstants.isEnterprise =Features.ismultivendor?true: (data[i]['businessPlan'].toString() == "0" || data[i]['businessPlan'].toString() == "3") ? true : false;
          IConstants.countryCode = data[i]['country_code'].toString();
          IConstants.currencyFormat = data[i]['currency_format'].toString();
          IConstants.minimumOrderAmount = data[i]['minimum_order_amount'].toString() == "null" ? "0" : data[i]['minimum_order_amount'].toString();
          IConstants.maximumOrderAmount = data[i]['maximum_order_amount'].toString();
          IConstants.restaurantName = data[i]['restaurant_name'].toString();
          PrefUtils.prefs!.setString("privacy", data[i]['privacy'].toString() == "null" ? "" : data[i]['privacy'].toString());
          IConstants.returnsPolicy = data[i]['returns'].toString() == "null" ? "" : data[i]['returns'].toString();
          IConstants.refundPolicy = data[i]['refund'].toString() == "null" ? "" : data[i]['refund'].toString();
          IConstants.walletPolicy = data[i]['wallet'].toString() == "null" ? "" : data[i]['wallet'].toString();
          PrefUtils.prefs!.setString("description", data[i]['description'].toString());
          PrefUtils.prefs!.setString("restaurant_address", data[i]['restaurant_address'].toString());
          IConstants.primaryMobile = data[i]['primary_mobile'].toString();
          IConstants.secondaryMobile = data[i]['secondary_mobile'].toString();
          IConstants.primaryEmail = data[i]['primary_email'].toString();
          IConstants.secondaryEmail = data[i]['secondary_email'].toString();
          IConstants.restaurantTerms = data[i]['restaurant_terms'].toString();
          PrefUtils.prefs!.setString("restaurant_location", data[i]['restaurant_location'].toString());
          PrefUtils.prefs!.setString("restaurant_lat", data[i]['restaurant_lat'].toString());
          PrefUtils.prefs!.setString("restaurant_long", data[i]['restaurant_long'].toString());
          PrefUtils.prefs!.setString("refer", data[i]['refer'].toString() == "null" ? "" : data[i]['refer'].toString());
          IConstants.categoryOneLabel = data[i]['category_label'].toString() == "null" ? "null" : data[i]['category_label'].toString();
          IConstants.categoryTwoLabel = data[i]['category_two_label'].toString() == "null" ? "null" : data[i]['category_two_label'].toString();
          IConstants.categoryThreeLabel = data[i]['category_three_label'].toString() == "null" ? "null" : data[i]['category_three_label'].toString();
          IConstants.categoryOne = (data[i]['category'].toString() == "null" || data[i]['category'].toString() == "") ? "null" : data[i]['category'].toString();
          IConstants.categoryTwo = (data[i]['category_two'].toString() == "null" || data[i]['category_two'].toString() == "") ? "null" : data[i]['category_two'].toString();
          IConstants.categoryThree = (data[i]['category_three'].toString() == "null" || data[i]['category_three'].toString() == "") ? "null" : data[i]['category_three'].toString();
          IConstants.numberFormat = (data[i]['number_format'].toString() == "null" || data[i]['number_format'].toString() == "") ? "1" : data[i]['number_format'].toString();
          IConstants.decimaldigit = (data[i]['number_format'].toString() == "null" || data[i]['number_format'].toString() == "") ? 0
              : data[i]['number_format'].toString() == "1" ? 0
              : data[i]['number_format'].toString() == "0" ? 2 : 3; //Round = 1, Round for decimal = 0, Round for 3 decimal 2
          IConstants.androidId = data[i]['play_store'].toString();
        //  IConstants.appName = data[i]['appName'].toString();
          IConstants.appleId = data[i]['apple_store'].toString();
          IConstants.websiteId = data[i]['crispChatId'].toString();
          IConstants.googleApiKey = data[i]['firebaseMapkey'].toString();
          IConstants.facebookUrl = data[i]['facebook_url'].toString();
          IConstants.instagramUrl = data[i]['instagram_url'].toString();
          IConstants.youtubeUrl = data[i]['youtube_url'].toString();
          IConstants.twitterUrl = data[i]['twitter_url'].toString();
          IConstants.holyday = data[i]['holiday'].toString();
          IConstants.faquestions = data[i]['faq'].toString() == "null" ? "" : data[i]['faq'].toString();
          Features.isAnalytics = (data[i]['analyticsModule'].toString() =="0") ? true : false;
          if(!Features.ismultivendor)IConstants.APP_NAME = data[i]['appName'].toString();
          IConstants.holydayNote = data[i]['holidayNote'].toString();
          PrefUtils.prefs!.setString("branch", data[i]['id'].toString());
          IConstants.webrefid = data[i]['refid'].toString();
          if(Vx.isWeb) PrefUtils.prefs!.setString("openTime", data[i]["openTime"].toString());
          if(Vx.isWeb) PrefUtils.prefs!.setString("closeTime", data[i]["closeTime"].toString());
          SetLanguageList(data[i] as Map<String, dynamic>);
          if(data[i]['MembershipData'] != '[]'){
            data[i]['MembershipData'].forEach((v) {
              PrefUtils.prefs!.setString("membershipplansname", v['name']);
              PrefUtils.prefs!.setString("membershipplansprice", v['price'].toString());
              PrefUtils.prefs!.setString("membershipplansdiscount", v['discounted_price'].toString());
              PrefUtils.prefs!.setString("membershipplansduration", v['duration'].toString());
            });
          }
          if(data[i]['WebsiteSetting'] != '[]') {
            data[i]['WebsiteSetting'].forEach((v) {
              IConstants.paymentGateway = v['payment_gateway'];
              IConstants.webViewUrl = v['webViewUrl'];
              IConstants.gatewayId = v['gateway_id'];
              IConstants.gateway_secret = v['gateway_secret'];
              IConstants.isPaymentTesting = v['mode'].toString() == "0" ? true : false;
            });
          }

  onload();
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<int> notifyMe(String itemid, String varid, String type) async {
    var currentDate;
    var varId;
    final now = new DateTime.now();
    currentDate = DateFormat('dd/MM/y').format(now);
    if(type == "1"){
      varId = itemid;
    }

    else{
      varId = varid;
    }
    try {
      final response = await http.post(Api.productNotify, body: {
        "user": PrefUtils.prefs!.getString('apikey'),
        "itemId": itemid,
        "varId": varId,
        "date": currentDate,
        "branch": PrefUtils.prefs!.getString('branch'),
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == '200') {
        return int.parse(responseJson['status'].toString());
      } else {
        return int.parse(responseJson['status'].toString());
      }
     } catch (error) {
       throw error;

     }
  }

  Future<void> userDetails()async{
    String membership = "";
    productBox = Hive.box<Product>(productBoxName);
    try{
      final response = await http.post(Api.getProfile, body: {
        // await keyword is used to wait to this operation is complete.
        "apiKey": PrefUtils.prefs!.getString('apiKey'),
        "branch" : PrefUtils.prefs!.getString("branch")
      });
      final responseJson = json.decode(response.body);
      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);
      List data = [];
      for(int i =0; i< productBox!.length ; i++){
        if(productBox!.values.elementAt(i).mode.toString() == "1"){
          membership = "1";
        }
        break;
      }
      dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[index] as Map<String, dynamic>));
      for (int i = 0; i < data.length; i++) {
        (membership == "1") ? PrefUtils.prefs!.setString('membership', "1") :PrefUtils.prefs!.setString('membership', data[i]['membership'].toString());
        PrefUtils.prefs!.setString('myreffer', data[i]['myref'].toString());
      }
      final prepaidJson = json.encode(responseJson['prepaid']); //fetching categories data
      final prepaidJsondecode = json.decode(prepaidJson);
      List prepaidData = [];
      prepaidJsondecode.asMap().forEach((index, value) => prepaidData.add(prepaidJsondecode[index] as Map<String, dynamic>));
      for (int i = 0; i < prepaidData.length; i++) {
        if (double.parse(prepaidData[i]['prepaid'].toString()) < 0) {
          PrefUtils.prefs!.setString("wallet_balance", "0");
        } else {
          PrefUtils.prefs!.setString(
              "wallet_balance", prepaidData[i]['prepaid'].toString());
        }

        if (double.parse(prepaidData[i]['loyalty'].toString()) < 0 ||
            prepaidData[i]['loyalty'].toString() == "null") {
          PrefUtils.prefs!.setString("loyalty_balance", "0");
        } else {
          PrefUtils.prefs!.setString("loyalty_balance", prepaidData[i]['loyalty'].toString());
        }
        if (data[i]['billingAddress'].toString() != "[]"){
          final billingAddressJson = json.encode(data[i]['billingAddress']); //fetching categories data
          final billingAddressJsondecode = json.decode(billingAddressJson);
          List billingAddressData = [];
          billingAddressJsondecode.asMap().forEach((index, value) => billingAddressData.add(billingAddressJsondecode[index] as Map<String, dynamic>));
          for (int i = 0; i < billingAddressData.length; i++) {
            if (billingAddressData[i]['isdefault'].toString() == "1") {
              PrefUtils.prefs!.setString("addressId", billingAddressData[i]['id'].toString());
              break;
            } else {
              PrefUtils.prefs!.setString("addressId", billingAddressData[i]['id'].toString());
            }
          }
        }
      }
      headerBloc.setNotificationCountStream!(int.parse(responseJson['notification_count'].toString()));
    } catch (error){
      throw error;
    }
  }

  Future<List<BrandsFieldModel>> fetchBrands() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      _items.clear();
    _branditems.clear();
      final response = await http.post(Api.getBrands, body: {
        "branch": PrefUtils.prefs!.getString('branch'),
        "language_id": IConstants.languageId,
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson.toString() != "[]") {
        Map<String, dynamic> resdata;
        responseJson.asMap().forEach((index, value) {
          resdata = responseJson[index] as Map<String, dynamic>;
          resultfinal = BrandsFieldModel.fromJson(resdata);
          _branditems.add(resultfinal!);

        });
      }
      return _branditems;
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchBrandItems(String brandsid, int startitem, String checkinitialy) async {
    var url = Api.getMenuitemByBrandByCart;
    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    PrefUtils.prefs!.setBool("endOfProduct", false);
    try {
      if (checkinitialy == "initialy") {
        _brandsitems.clear();
        _itemspricevar.clear();
        _itemimages.clear();
      } else {}
      final response = await http.post(url, body: {
        "id": brandsid,
        "start": startitem.toString(),
        "end": "0",
        "branch": PrefUtils.prefs!.getString('branch'),
        "user": user,
        "language_id": IConstants.languageId,
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]" || responseJson.toString() == "") {
        PrefUtils.prefs!.setBool("endOfProduct", true);
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          final deliveryduration = json.encode(data[i]['delivery_duration']);
          final deliverydurationJsondecode = json.decode(deliveryduration);
          List deliverydurationdata = [];
          String _duration = "";
          String _durationType = "";
          String _note = "";

          if(deliverydurationJsondecode.toString() == "slot" || deliverydurationJsondecode.toString() ==" ") {
            _duration = "";
            _durationType = "";
            _note = "";
          } else {
            deliverydurationJsondecode.asMap().forEach((index, value) =>
                deliverydurationdata.add(
                    deliverydurationJsondecode[index] as Map<String, dynamic>)
            );
            _duration = Features.isSplit ? deliverydurationdata[0]["duration"].toString() : "";
            _durationType = Features.isSplit ? deliverydurationdata[0]["durationType"].toString() : "";
            _note = (deliverydurationdata[0]["note"] ?? "").toString();
          }

          /////Subscription

          final subscriptionslot= json.encode(data[i]['subscription_slot']);
          final subscriptionslotJsondecode = json.decode(subscriptionslot);
          List subscriptionslotdata = [];
          String _cronTime = "";
          String _status = "";

          if(subscriptionslotJsondecode.toString() == "[]") {
            _cronTime = "";
            _status = "";
          } else {
            subscriptionslotJsondecode.asMap().forEach((index, value) =>
                subscriptionslotdata.add(
                    subscriptionslotJsondecode[index] as Map<String, dynamic>)
            );
            _cronTime = subscriptionslotdata[0]["cronTime"].toString();
            _status = subscriptionslotdata[0]["deliveryTime"].toString();

          }

          _brandsitems.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['item_name'].toString(),
            imageUrl: IConstants.API_IMAGE +
                "items/images/" +
                data[i]['item_featured_image'].toString(),
            brand: data[i]['brand'].toString(),
            veg_type: data[i]["veg_type"].toString(),
            type: data[i]["type"].toString(),
            eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",
            delivery: (data[i]['delivery'] ?? "").toString(),
            duration: _duration,
            durationType: _durationType,
            note: _note,
            subscribe:data[i]['eligible_for_subscription'].toString(),
            paymentmode:data[i]['payment_mode'].toString(),
            cronTime: _cronTime,
            name: _status,
          ));


          final pricevarJson = json.encode(
              data[i]['price_variation']); //fetching sub categories data
          final pricevarJsondecode = json.decode(pricevarJson);
          List pricevardata = []; //list for subcategories

          if (pricevarJsondecode == null) {} else {
            pricevarJsondecode.asMap().forEach((index, value) =>
                pricevardata
                    .add(pricevarJsondecode[index] as Map<String, dynamic>));

            for (int j = 0; j < pricevardata.length; j++) {
              bool _discointDisplay = false;
              bool _membershipDisplay = false;

              if (double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
                _discointDisplay = false;
              } else {
                _discointDisplay = true;
              }

              if (pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())
                  || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['price'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _itemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: pricevardata[j]['menu_item_id'].toString(),
                varname: pricevardata[j]['variation_name'].toString(),
                varmrp: (IConstants.numberFormat == "1")
                    ? pricevardata[j]['mrp'].toStringAsFixed(0)
                    : pricevardata[j]['mrp'].toStringAsFixed(IConstants.decimaldigit),
                varprice: (IConstants.numberFormat == "1")
                    ? pricevardata[j]['price'].toStringAsFixed(0)
                    : pricevardata[j]['price'].toStringAsFixed(IConstants.decimaldigit),
                varmemberprice: (IConstants.numberFormat ==
                    "1") ? pricevardata[j]['membership_price'].toStringAsFixed(
                    0) : pricevardata[j]['membership_price'].toStringAsFixed(IConstants.decimaldigit),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['min_item'].toString(),
                varmaxitem: pricevardata[j]['max_item'].toString(),
                varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                    pricevardata[j]['loyalty'].toString() == "null" ? 0 : int
                    .parse(pricevardata[j]['loyalty'].toString()),
                varQty: int.parse(pricevardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
                unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
                  weight: double.parse(pricevardata[j]['weight'].toString())
              ));
              final multiimagesJson = json.encode(
                  pricevardata[j]['images']); //fetching sub categories data
              final multiimagesJsondecode = json.decode(multiimagesJson);
              List multiimagesdata = [];

              if (multiimagesJsondecode.toString() == "[]") {
                _itemimages.add(SellingItemsFields(
                  varid: pricevardata[j]['id'].toString(),
                  menuid: data[i]['id'].toString(),
                  imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
                  varcolor: Color(0xff012961),
                ));
              } else {
                multiimagesJsondecode.asMap().forEach((index, value) =>
                    multiimagesdata.add(multiimagesJsondecode[index] as Map<String, dynamic>)
                );

                for (int k = 0; k < multiimagesdata.length; k++) {
                  var varcolor;
                  if (k == 0) {
                    varcolor = Color(0xff012961);
                  } else {
                    varcolor = Color(0xffBEBEBE);
                  }
                  _itemimages.add(SellingItemsFields(
                    varid: pricevardata[j]['id'].toString(),
                    menuid: data[i]['id'].toString(),
                    imageUrl: IConstants.API_IMAGE + "items/images/" + multiimagesdata[k]['image'].toString(),
                    varcolor: varcolor,
                  ));
                }
              }
            }
          }
        }


        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchPaymentMode() async {
    try {
      _paymentitems.clear();
      String branch = PrefUtils.prefs!.getString('branch')??"999";
      if((VxState.store as GroceStore).CartItemList.length > 0 && Features.ismultivendor){
        branch = (VxState.store as GroceStore).CartItemList[0].branch!.toString();
      }
      final response = await http.post(
          Api.paymentModeBranch,
          body: {
            "id": branch,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if (responseJson.toString() != "[]") {
        List data = [];

        responseJson.asMap().forEach((index, value) => data.add(responseJson[index]));
        String payName = "";
        String payMode = "0";
        String membershipvx = (VxState.store as GroceStore).userData.membership!;
        bool _checkmembership = false;
        final cartItemList =(VxState.store as GroceStore).CartItemList;
          for (int i = 0; i < cartItemList.length; i++) {
            if (cartItemList[i].mode == "1") {
              _checkmembership = true;
            }
        }
        for (int i = 0; i < data.length; i++) {
          if(Features.isMembership && (_checkmembership) ) {
           if (data[i].toString() == "online") {
              payName = "Online Payment";
              payMode = "1";
            }
           else if (data[i].toString() == "wallet") {
             if (Features.isWallet) {
               payName = "Wallet Balance";
               payMode = "2";
             }
             else {
               payName = "";
               payMode = "";
             }
           }
           else {
             payName = "";
             payMode = "";
           }

            if (payMode == "3" || payMode == "5") {} else {
              _paymentitems.add(WalletItemsFields(
                paymentType: "online",
                paymentName: payName,
                paymentMode: payMode,
              ));
            }
          }
          else{
            if (data[i].toString() == "cod") {
              payName = "Pay on Delivery";
              payMode = "6";
            } else if (data[i].toString() == "sod") {
              payName = "Card on Delivery";
              payMode = "0";
            } else if (data[i].toString() == "online") {
              payName = "Online Payment";
              payMode = "1";
            } else if (data[i].toString() == "sodedxo") {
              payName = "Sodexo";
              payMode = "7";
            } else if (data[i].toString() == "wallet") {
              if (Features.isWallet) {
                payName = "Wallet Balance";
                payMode = "2";
              }
              else {
                payName = "";
                payMode = "";
              }
            } else if (data[i].toString() == "loyalty") {
              if (Features.isLoyalty) {
                payName = "Loyalty";
                payMode = "4";
                //_isLoyalty = true;
              }
              else {
                payName = "";
                payMode = "";
              }
            }

            if (payMode == "3" || payMode == "5") {} else {
              _paymentitems.add(WalletItemsFields(
                paymentType: data[i].toString(),
                paymentName: payName,
                paymentMode: payMode,
              ));
            }
          }
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchWalletLogs(String type) async {
    // imp feature in adding async is the it automatically wrap into Future.

    try {
      _walletitems.clear();
      final response = await http.post(Api.walletLogs, body: {
        "userId": PrefUtils.prefs!.getString('apikey'),
        "type": ( type== "wallet") ?  "0" : ( type== "subscribedwallet") ? "5" : "3",
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      List data = [];

      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>));
      for (int i = 0; i < data.length; i++) {
        if (data[i]['data'].toString() != "[]") {
          final pricevarJson = json.encode(data[i]['data']);
          final pricevarJsondecode = json.decode(pricevarJson);

          var amount;
          var title;
          if (double.parse(pricevarJsondecode['credit'].toString()) <= 0) {
            (type == "wallet")
                ? (IConstants.numberFormat == "1") ?
            Features.iscurrencyformatalign?
            amount = "-  " +  double.parse(pricevarJsondecode['debit'].toString()).toStringAsFixed(0) +  " " + IConstants.currencyFormat :
            amount = "-  " + IConstants.currencyFormat + " " + double.parse(pricevarJsondecode['debit'].toString()).toStringAsFixed(0):
            Features.iscurrencyformatalign?amount = "-  " +  double.parse(pricevarJsondecode['debit'].toString()).toStringAsFixed(IConstants.decimaldigit) +  " " +IConstants.currencyFormat
                :amount = "-  " + IConstants.currencyFormat + " " + double.parse(pricevarJsondecode['debit'].toString()).toStringAsFixed(IConstants.decimaldigit)

                : (IConstants.numberFormat == "1") ?
            amount = "-  " + double.parse(pricevarJsondecode['debit'].toString()).toStringAsFixed(0):
            amount = "-  " + double.parse(pricevarJsondecode['debit'].toString()).toStringAsFixed(IConstants.decimaldigit);

            title = "Debit";
          } else {
            (type == "wallet")
                ? (IConstants.numberFormat == "1") ?
            Features.iscurrencyformatalign?  amount = "+  "  + double.parse(pricevarJsondecode['credit'].toString()).toStringAsFixed(0) + " " +IConstants.currencyFormat:
            amount = "+  " + IConstants.currencyFormat + " " + double.parse(pricevarJsondecode['credit'].toString()).toStringAsFixed(0):
            Features.iscurrencyformatalign?  amount = "+  "  + double.parse(pricevarJsondecode['credit'].toString()).toStringAsFixed(0) + " " +IConstants.currencyFormat:
            amount = "+  " + IConstants.currencyFormat + " " + double.parse(pricevarJsondecode['credit'].toString()).toStringAsFixed(IConstants.decimaldigit)
                : (IConstants.numberFormat == "1") ? amount = "+  " + double.parse(pricevarJsondecode['credit'].toString()).toStringAsFixed(0) : amount = "+  " + double.parse(pricevarJsondecode['credit'].toString()).toStringAsFixed(IConstants.decimaldigit);
            title = "Credit";
          }

          _walletitems.add(WalletItemsFields(
            title: title,
            date: pricevarJsondecode['date'].toString(),
            time: pricevarJsondecode['datetime'].toString(),
            amount: amount,
            note: pricevarJsondecode['note'].toString() == "null"
                ? ""
                : pricevarJsondecode['note'].toString(),
            closingbalance: pricevarJsondecode['balance'].toString(),
          ));
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchShoppinglist() async {
    // imp feature in adding async is the it automatically wrap into Future.

    var url = Api.getShoppingList +(PrefUtils.prefs!.getString('apikey')??"1") + "/" + PrefUtils.prefs!.getString('branch')!;
    try {
      _shoplistitems.clear();
      final response = await http.get(url,);

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _shoplistitems.clear();
      if(responseJson.toString() != "[]") {
        List data = [];
        responseJson.asMap().forEach((index, value) => data.add(
            responseJson[index] as Map<String,
                dynamic>));
        for (int i = 0; i < data.length; i++) {
          _shoplistitems.add(ShoppinglistItemsFields(
            listid: data[i]['id'].toString(),
            listname: data[i]['name'].toString(),
            listcheckbox: false,
            totalitemcount: data[i]['count'].toString(),
          ));
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchShoppinglistItem(String listId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getShoppingListItem + listId +"/" + PrefUtils.prefs!.getString('apikey')!;
    try {
      _listitemsdetails.clear();
      _listitemspricevar.clear();
      _itemshoppingimages.clear();
      final response = await http.post(url, body: {
        "apiKey": PrefUtils.prefs!.getString('apikey'),
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if(responseJson.toString() != "[]") {
        List data = [];
        responseJson.asMap().forEach((index, value) => data.add(
            responseJson[index] as Map<String,
                dynamic>));
        for (int i = 0; i < data.length; i++) {



          final priceVarJson = json.encode(data[i]['price_variation']);
          final priceVarJsondecode = json.decode(priceVarJson);
          List priceVardata = []; //list for subcategories

          priceVarJsondecode.asMap().forEach((index, value) =>
              priceVardata.add(priceVarJsondecode[index] as Map<String, dynamic>));

          final deliveryduration= json.encode(data[i]['delivery_duration']);
          final deliverydurationJsondecode = json.decode(deliveryduration);
          List deliverydurationdata = [];
          String _duration = "";
          String _durationType = "";
          String _note = "";

          if(deliverydurationJsondecode.toString() == "slot" || deliverydurationJsondecode.toString() ==" ") {
            _duration = "";
            _durationType = "";
            _note = "";
          } else {
            deliverydurationJsondecode.asMap().forEach((index, value) =>
                deliverydurationdata.add(
                    deliverydurationJsondecode[index] as Map<String, dynamic>)
            );
            _duration = Features.isSplit ? deliverydurationdata[0]["duration"].toString() : "";
            _durationType = Features.isSplit ? deliverydurationdata[0]["durationType"].toString() : "";
            _note = (deliverydurationdata[0]["note"] ?? "").toString();
          }
          /////Subscription

          final subscriptionslot= json.encode(data[i]['subscription_slot']);
          final subscriptionslotJsondecode = json.decode(subscriptionslot);
          List subscriptionslotdata = [];
          String _cronTime = "";
          String _status = "";

          if(subscriptionslotJsondecode.toString() == "[]") {
            _cronTime = "";
            _status = "";
          } else {
            subscriptionslotJsondecode.asMap().forEach((index, value) =>
                subscriptionslotdata.add(
                    subscriptionslotJsondecode[index] as Map<String, dynamic>)
            );
            _cronTime = subscriptionslotdata[0]["cronTime"].toString();
            _status = subscriptionslotdata[0]["deliveryTime"].toString();

          }
          _listitemsdetails.add(ShoppinglistItemsFields(
            listid: listId,
            itemid: data[i]['id'].toString(),
            itemname: data[i]['item_name'].toString(),
            imageurl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
            brand: data[i]['brand'].toString(),
            veg_type: data[i]["veg_type"].toString(),
            type: data[i]["type"].toString(),
            eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",

            delivery:(data[i]['delivery'] ?? "").toString(),
            duration: _duration,
            durationType: _durationType,
            note: _note,
            subscribe:data[i]['eligible_for_subscription'].toString(),
            paymentmode:data[i]['payment_mode'].toString(),
            cronTime: _cronTime,
            name: _status,
          ));

          for (int j = 0; j < priceVardata.length; j++) {

            bool _discointDisplay = false;
            bool _membershipDisplay = false;

            if (double.parse(priceVardata[j]['price'].toString()) <= 0 ||
                priceVardata[j]['price'].toString() == "" ||
                double.parse(priceVardata[j]['price'].toString()) ==
                    double.parse(priceVardata[j]['mrp'].toString())) {
              _discointDisplay = false;
            } else {
              _discointDisplay = true;
            }

            if (priceVardata[j]['membership_price'].toString() == '-' || priceVardata[j]['membership_price'].toString() == "0" || double.parse(priceVardata[j]['membership_price'].toString()) == double.parse(priceVardata[j]['mrp'].toString())
                || double.parse(priceVardata[j]['membership_price'].toString()) == double.parse(priceVardata[j]['price'].toString())) {
              _membershipDisplay = false;
            } else {
              _membershipDisplay = true;
            }
            var varcolor;
            if(j == 0) {
              varcolor = Color(0xff012961);
            } else {
              varcolor = Color(0xffBEBEBE);
            }

            _listitemspricevar.add(
              ShoppinglistItemsFields(
                listid: listId,
                varid: priceVardata[j]['id'].toString(),
                menuid: priceVardata[j]['menu_item_id'].toString(),
                varname: priceVardata[j]['variation_name'].toString(),
                varmrp: (IConstants.numberFormat == "1") ? priceVardata[j]['mrp'].toStringAsFixed(0) : priceVardata[j]['mrp'].toStringAsFixed(IConstants.decimaldigit),
                varprice: (IConstants.numberFormat == "1") ? priceVardata[j]['price'].toStringAsFixed(0) : priceVardata[j]['price'].toStringAsFixed(IConstants.decimaldigit),
                varmemberprice: (IConstants.numberFormat == "1") ? priceVardata[j]['membership_price'].toStringAsFixed(0) : priceVardata[j]['membership_price'].toStringAsFixed(IConstants.decimaldigit),
                varstock: priceVardata[j]['stock'].toString(),
                varminitem: priceVardata[j]['min_item'].toString(),
                varmaxitem: priceVardata[j]['max_item'].toString(),
                varLoyalty: priceVardata[j]['loyalty'].toString() == "" ||
                    priceVardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(priceVardata[j]['loyalty'].toString()),
                varQty: int.parse(priceVardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
                varcolor: varcolor,
                unit: (priceVardata[j]['unit'].toString() == "null")? "" : (priceVardata[j]['unit'] ?? "").toString(),
                  weight: double.parse(priceVardata[j]['weight'].toString())
              ),
            );
            final multiimagesJson = json.encode(
                priceVardata[j]['images']); //fetching sub categories data
            final multiimagesJsondecode = json.decode(multiimagesJson);
            List multiimagesdata = [];

            if (multiimagesJsondecode.toString() == "[]") {
              _itemshoppingimages.add(SellingItemsFields(
                varid: priceVardata[j]['id'].toString(),
                menuid: data[i]['id'].toString(),
                imageUrl: IConstants.API_IMAGE + "items/images/" +
                    data[i]['item_featured_image'].toString(),
                varcolor: Color(0xff012961),
              ));
            } else {
              multiimagesJsondecode.asMap().forEach((index, value) =>
                  multiimagesdata.add(
                      multiimagesJsondecode[index] as Map<String, dynamic>)
              );

              for (int k = 0; k < multiimagesdata.length; k++) {
                var varcolor;
                if (k == 0) {
                  varcolor = Color(0xff012961);
                } else {
                  varcolor = Color(0xffBEBEBE);
                }
                _itemshoppingimages.add(SellingItemsFields(
                  varid: priceVardata[j]['id'].toString(),
                  menuid: data[i]['id'].toString(),
                  imageUrl: IConstants.API_IMAGE + "items/images/" +
                      multiimagesdata[k]['image'].toString(),
                  varcolor: varcolor,
                ));
              }
            }
          }
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> CreateShoppinglist() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      _shoplistitems.clear();
      final response = await http.post(Api.createShoppingList, body: {
        "apiKey": PrefUtils.prefs!.getString('apikey'),
        "list_name": PrefUtils.prefs!.getString('list_name'),
        "branch": PrefUtils.prefs!.getString('branch'),
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == 'true') {
        /*if (responseJson['data'].toString() != "[]") {
          final dataJson = json.encode(
              responseJson['data']); //fetching categories data
          final dataJsondecode = json.decode(dataJson);


          List data = []; //list for categories

          dataJsondecode.asMap().forEach((index, value) =>
              data.add(dataJsondecode[index] as Map<String, dynamic>)
          ); //store each category values in data list
        } else {
        }*/
      } else {}
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> AdditemtoShoppinglist(String itemid, String varid, String listid,String type) async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.addItemToList, body: {
        "apiKey": PrefUtils.prefs!.getString('apikey'),
        "item_id": itemid,
        "list_id": listid,
        "qty": "0",
        "var_id": varid,
        "type" : type
        // await keyword is used to wait to this operation is complete.
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> deliveryCharges(String addressid) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getDeliveryCharges;
   try {
      _itemsDelCharge.clear();
      final response = /*Features.ismultivendor?*/ await http.post(
        url,
          body: {
            "id": addressid.toString(),
            "branch": Features.ismultivendor?IConstants.refIdForMultiVendor.toString():PrefUtils.prefs!.getString("branch"),
            "branchtype": IConstants.branchtype.toString(),
            "ref": IConstants.isEnterprise && Features.ismultivendor?IConstants.refIdForMultiVendor.toString():"",
            // await keyword is used to wait to this operation is complete.
          }
      )
          /*: await http.get(url + addressid)*/;
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() != "[]") {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          _itemsDelCharge.add(DelChargeFields(
            id: data[i]['id'].toString(),
            createdDate: data[i]['created_date'].toString(),
            minimumOrderAmountNoraml:
            (data[i]['minimum_order_amount_normal'].toString() == "null"||data[i]['minimum_order_amount_normal'].toString() == "")
                ? "0"
                : data[i]['minimum_order_amount_normal'].toString(),
            deliveryChargeNormal:
            (data[i]['delivery_charge_normal'].toString() == "null"||data[i]['delivery_charge_normal'].toString() == "")
                ? "0"
                : data[i]['delivery_charge_normal'].toString(),
            minimumOrderAmountPrime:
            (data[i]['minimum_order_amount_prime'].toString() == "null"||data[i]['minimum_order_amount_prime'].toString() == "")
                ? "0"
                : data[i]['minimum_order_amount_prime'].toString(),
            deliveryChargePrime:
            (data[i]['delivery_charge_prime'].toString() == "null"||data[i]['delivery_charge_prime'].toString() == "")
                ? "0"
                : data[i]['delivery_charge_prime'].toString(),
            minimumOrderAmountExpress:
            (data[i]['minimum_order_amount_express'].toString() == "null"||data[i]['minimum_order_amount_express'].toString() == "")
                ? "0"
                : data[i]['minimum_order_amount_express'].toString(),
            deliveryChargeExpress:
            (data[i]['delivery_charge_express'].toString() == "null"||data[i]['delivery_charge_express'].toString() == "")
                ? "0"
                : data[i]['delivery_charge_express'].toString(),
            deliveryDurationExpress:
            (data[i]['duration'].toString() == "null"||data[i]['duration'].toString() == "")
                ? "0"
                : data[i]['duration'].toString(),
          ));
        }
      } else {}

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getLoyalty() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      UserAppAuth n;
      _itemsLoyalty.clear();
      final response = await http.post(Api.getLoyalty, body: {
        // await keyword is used to wait to this operation is complete.
        "branch": PrefUtils.prefs!.getString('branch')??"999",
      });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() != "[]") {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {
          _itemsLoyalty.add(LoyaltyFields(
            id: data[i]['id'].toString(),
            status: data[i]['status'].toString(),
            type: data[i]['type'].toString(),
            note: data[i]['note'].toString(),
            minimumOrderAmount: data[i]['minimum_order_amount'].toString(),
            points: data[i]['points'].toString(),
            maximumRedeem: data[i]['maximum_redeem'].toString(),
            discount: data[i]['discount'].toString(),
          ));
        }
      } else {}

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> checkLoyalty(String total) async {
    // imp feature in adding async is the it automatically wrap into Future.
    String branch;
    if(PrefUtils.prefs!.getString('branch')==null){
      branch="999";
    }else{
      branch = PrefUtils.prefs!.getString('branch')!;
    }
    var url = Api.checkLoyalty + '$total/' +branch /*PrefUtils.prefs!.getString('branch')!*/;
    try {
      final response = await http.get(
        url,
      );

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      PrefUtils.prefs!.setDouble("loyaltyPointsUser",
          (responseJson["points"].toString() == "null")
              ? 0.0
              : double.parse(responseJson["points"].toString()));
    } catch (error) {
      throw error;
    }
  }

  List<BrandsFields> get items {
    return [..._items];
  }

  List<SellingItemsFields> get branditems {
    return [..._brandsitems];
  }

  List<SellingItemsFields> findById(String brandid) {
    return [..._itemspricevar.where((pricevar) => pricevar.menuid == brandid)];
  }

  List<WalletItemsFields> get itemspayment {
    return [..._paymentitems];
  }

  List<WalletItemsFields> get itemswallet {
    return [..._walletitems];
  }

  List<ShoppinglistItemsFields> get itemsshoplist {
    return [..._shoplistitems];
  }

  List<ShoppinglistItemsFields> findByIdlistitem(String listid) {
    return [..._listitemsdetails.where((list) => list.listid == listid)];
  }

  List<ShoppinglistItemsFields> listitem() {
    return [..._listitemsdetails];
  }

  List<ShoppinglistItemsFields> findByIditempricevar(
      String listid, String menuid) {
    return [
      ..._listitemspricevar
          .where((list) => list.listid == listid && list.menuid == menuid)
    ];
  }

  List<DelChargeFields> get itemsDelCharges {
    return [..._itemsDelCharge];
  }

  List<LoyaltyFields> get itemsLoyalty {
    return [..._itemsLoyalty];
  }

  Future<void> removeShoppinglist(String listid) async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      final response = await http.post(Api.removeShoppingList, body: {
        "apiKey": PrefUtils.prefs!.getString('apikey'),
        "shopping_list_id": listid,
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['status'].toString() == 'true') {
      } else {}
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchPickupfromStore() async {
    // imp feature in adding async is the it automatically wrap into Future.
    try {
      _pickupLocitems.clear();
      final response = await http.post(Api.pickupLocation, body: {
        "latitude": PrefUtils.prefs!.getString('latitude'),
        "longitude": PrefUtils.prefs!.getString('longitude'),
        "branch": PrefUtils.prefs!.getString('branch'),
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() != "[]") {
        List data = [];
        responseJson.asMap().forEach((index, value) => data.add(responseJson[index]));
        for (int i = 0; i < data.length; i++) {
          Color selectedColor;
          bool isSelect;
          if(i == 0) {
            selectedColor = ColorCodes.mediumgren;
            isSelect = true;
          } else {
            selectedColor = ColorCodes.whiteColor;
            isSelect = false;
          }
          _pickupLocitems.add(PickuplocFields(
            id: data[i]["id"].toString(),
            name: data[i]["name"].toString(),
            address: data[i]["address"].toString(),
            contact: data[i]["contact"].toString(),
            latitude: double.parse(data[i]["latitude"].toString()),
            longitude: double.parse(data[i]["longitude"].toString()),
            deliveryChargeForRegularUser: (data[i]["delivery_charge_for_regular_user"].toString() == "" ||
                data[i]["delivery_charge_for_regular_user"].toString() == null) ?
            "0" :
            data[i]["delivery_charge_for_regular_user"].toString(),
            deliveryChargeForMembershipUser: (data[i]["delivery_charge_for_membership_user"].toString() == "" ||
                data[i]["delivery_charge_for_membership_user"].toString() == null) ?
            "0" :
            data[i]["delivery_charge_for_membership_user"].toString(),

          ));
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<PickuplocFields> get itemspickuploc {
    return [..._pickupLocitems];
  }

  Future<void> getOffers() async {
    // imp feature in adding async is the it automatically wrap into Future.

    try {
      _OffersItems.clear();
      final response = await http.post(Api.getOffers,
          body: {
            "user": PrefUtils.prefs!.getString('apikey'),
            "branch": PrefUtils.prefs!.getString('branch'),
            "amount": PrefUtils.prefs!.getString("membership") == "1" ? CartCalculations.totalMember.toString() : CartCalculations.total.toString(),
          });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _OffersItems.clear();
      if (responseJson.toString() != "[]") {
        List offers = [];

        responseJson.asMap().forEach((index, value) => offers.add(responseJson[index]));
        for (int i = 0; i < offers.length; i++) {
          if(offers[i]["status"].toString() == "200") {
            final dataJson = json.encode(offers[i]['data']); //fetching sub categories data
            final dataJsondecode = json.decode(dataJson);
            List data = []; //list for subcategories
            if(dataJsondecode.toString() != "[]") {
              dataJsondecode.asMap().forEach((index, value) => data.add(dataJsondecode[index] as Map<String, dynamic>));
              for (int j = 0; j < data.length; j++) {
                final pricevarJson = json.encode(data[j]['price_variation']); //fetching sub categories data
                final pricevarJsondecode = json.decode(pricevarJson);
                List pricevardata = [];
                if(pricevarJsondecode.toString() != "[]") {
                  pricevarJsondecode.asMap().forEach((index, value) => pricevardata.add(pricevarJsondecode[index] as Map<String, dynamic>));


                  Color border;
                  if(_OffersItems.length == 0) {
                    border = ColorCodes.mediumBlueColor;
                  } else {
                    border = ColorCodes.lightBlueColor;
                  }

                  bool _discointDisplay = false;
                  bool _membershipDisplay= false;

                  if (double.parse(pricevardata[0]['price'].toString()) <= 0 || pricevardata[0]['price'].toString() == "" || double.parse(pricevardata[0]['price'].toString()) == double.parse(pricevardata[0]['mrp'].toString())) {
                    _discointDisplay = false;
                  } else {
                    _discointDisplay = true;
                  }
                  if (pricevardata[0]['membership_price'].toString() == '-' || pricevardata[0]['membership_price'].toString() == "0" || double.parse(pricevardata[0]['membership_price'].toString()) == double.parse(pricevardata[0]['mrp'].toString())
                      || double.parse(pricevardata[0]['membership_price'].toString()) == double.parse(pricevardata[0]['price'].toString())) {
                    _membershipDisplay = false;
                  } else {
                    _membershipDisplay = true;
                  }
                  _OffersItems.add(SellingItemsFields(
                    offerId: offers[i]["id"].toString(),
                    offerTitle: offers[i]["title"].toString(),
                    brand: data[i]["brand"].toString(),
                    border: border,
                    title: data[j]['item_name'],
                    veg_type: data[j]['veg_type'],
                    type: data[j]['type'],
                    imageUrl: IConstants.API_IMAGE + "items/images/" + data[j]['item_featured_image'].toString(),
                    varid: pricevardata[0]['id'].toString(),
                    menuid: pricevardata[0]['menu_item_id'].toString(),
                    varname: pricevardata[0]['variation_name'].toString(),
                    varmrp: (IConstants.numberFormat == "1")
                        ? pricevardata[0]['mrp'].toStringAsFixed(0)
                        : pricevardata[0]['mrp'].toStringAsFixed(IConstants.decimaldigit),
                    varprice: (IConstants.numberFormat == "1")
                        ? pricevardata[0]['price'].toStringAsFixed(0)
                        : pricevardata[0]['price'].toStringAsFixed(IConstants.decimaldigit),
                    varmemberprice: (IConstants.numberFormat == "1")
                        ? pricevardata[0]['membership_price'].toStringAsFixed(0)
                        : pricevardata[0]['membership_price'].toStringAsFixed(IConstants.decimaldigit),
                    varstock: pricevardata[0]['stock'].toString(),
                    varminitem: pricevardata[0]['min_item'].toString(),
                    varmaxitem: pricevardata[0]['max_item'].toString(),
                    varLoyalty: pricevardata[0]['loyalty'].toString() == "" ||
                        pricevardata[0]['loyalty'].toString() == "null"
                        ? 0
                        : int.parse(pricevardata[0]['loyalty'].toString()),
                    varQty: int.parse(pricevardata[0]['quantity'].toString()),
                    unit: pricevardata[0]['unit'].toString(),
                    discountDisplay: _discointDisplay,
                    membershipDisplay: _membershipDisplay,
                  ));
                }
              }
            }
          }
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> ReferEarn()async {
    var url = Features.ismultivendor && IConstants.isEnterprise?Api.getReferalMultivendor + IConstants.refIdForMultiVendor + '/' + PrefUtils.prefs!.getString('apikey')!:
        Api.getRefereal + (VxState.store as GroceStore).userData.branch.toString() +'/' + PrefUtils.prefs!.getString('apikey')!;
     try {
      // _referEarn.clear();
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            //  "branch": prefs.getString('branch'),
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() != "[]") {
        List data = [];
        /*responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>)
      );*/
        _referEarn = new ReferFields(
          imageUrl: IConstants.API_IMAGE +
              responseJson['data']['image'].toString(),
          referral_count: responseJson['data']['referral_count'].toString() == "null" ? 0 : int.parse(responseJson['data']['referral_count'].toString()),
          earning_amount: responseJson['data']['earning_amount'].toString() == "null" ? responseJson['data']['earning_amount'].toStringAsFixed(0):(IConstants.numberFormat == "1") ? responseJson['data']['earning_amount'].toStringAsFixed(0) : responseJson['data']['earning_amount'].toStringAsFixed(IConstants.decimaldigit),
          // amount: responseJson['data']['amount'].toString() == "null" ? "0.00" : double.parse(responseJson['data']['amount'].toString()),
          amount: (responseJson['data']['amount']??"0.00").toString() ,
        );
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  List<SellingItemsFields> get offers {
    return [..._OffersItems];
  }
  ReferFields get referEarn {
    return _referEarn!;
  }
  List<SellingItemsFields> findBybrandimage(String pricevarid){
    return [..._itemimages.where((pricevar) => pricevar.varid == pricevarid)];
  }
  List<SellingItemsFields> findByshoppingimage(String pricevarid){
    return [..._itemshoppingimages.where((pricevar) => pricevar.varid == pricevarid)];
  }

}

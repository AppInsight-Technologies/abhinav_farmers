import 'package:flutter/material.dart';

import '../../constants/IConstants.dart';
import '../../controller/mutations/languagemutations.dart';

class Home_Store {
  Data? data;

  Home_Store({this.data});

  Home_Store.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Mainslider>? mainslider;
  List<Categorymainslider>? categorymainslider;
  List<FeaturedMainCategoryTags>? featuredMainCategoryTags;
  List<FeaturedCategories1>? featuredCategories1;
  List<FeaturedCategoryTags>? featuredCategoryTags;
  List<FeaturedTagsBanner>? featuredTagsBanner;
  List<FeaturedStores>? featuredStores;
  String? featuredStoreLabel;
  String? featuredStoreLabelsub;
  String? categoryTagsLabel;
  String? categoryTagsLabelsub;
  String? maincategoryTagsLabel;
  String? maincategoryTagssubLabel;
  List<NearestStores>? nearestStores;
  String? countryCode;
  String? currencyFormat;
  String? firebase;
  String? firebaseMapkey;
  String? crispChatId;
  String? primaryMobile;
  String? secondaryMobile;
  String? email;
  String? aboutUs;
  String? privacyPolicy;
  String? refundPolicy;
  String? returnsPolicy;
  String? walletPolicy;
  String? referPolicy;
  String? otherPolicy;
  String? pickerModal;
  String? deliveryOtp;
  String? affliateModal;
  String? membershipSetting;
  String? loyaltySetting;
  String? referralSetting;
  String? returnSetting;
  String? buyOnegetOne;
  String? isWebsiteSlider;
  String? isMainSlider;
  String? isFeaturedCategoryOne;
  String? isAdsBelowFeaturedCategoriesOne;
  String? isBulkUpload;
  String? isFeaturedItems;
  String? isAdsBelowFeaturedItemsOne;
  String? isFeaturedCategoryTwo;
  String? isAdsBelowFeaturedCategoriesTwo;
  String? isFeaturedCategoryThree;
  String? isAdsBelowFeaturedCategoriesThree;
  String? isAdsBelowCategory;
  String? isCategory;
  String? isBrands;
  String? isDiscountItems;
  String? businessPlan;
  String? subscriptionModule;
  String? shoppingListModule;
  String? promocodeModule;
  String? pushNotificationModule;
  String? onboardingScreenModule;
  String? walletModule;
  String? liveChatModule;
  String? whatsapChatModule;
  String? productFilteringModule;
  String? productShareModule;
  String? analyticsModule;
  String? offerModule;
  String? wholesaleModule;
  String? multiVendorModule;
  String? repeatOrderModule;
  String? homepageOffers;
  String? refundModule;
  String? rateOrdersModule;
  String? languageModule;
  String? callMeInsteadOTP;
  String? splitOrder;
  String? mainBanneraboveSlider;
  String? restaurantLong;
  String? restaurantLat;
  String? address;
  String? minimumOrderAmount;
  String? maximumOrderAmount;
  List<Languages>? languages;

  Data(
      {
        this.categorymainslider,
        this.mainslider,
        this.featuredCategories1,
        this.featuredCategoryTags,
        this.featuredTagsBanner,
        this.featuredStores,
        this.featuredStoreLabel,
        this.featuredStoreLabelsub,
        this.categoryTagsLabel,
        this.categoryTagsLabelsub,
        this.maincategoryTagsLabel,
        this.maincategoryTagssubLabel,
        this.countryCode,
        this.currencyFormat,
        this.firebase,
        this.firebaseMapkey,
        this.crispChatId,
        this.primaryMobile,
        this.secondaryMobile,
        this.email,
        this.aboutUs,
        this.pickerModal,
        this.deliveryOtp,
        this.affliateModal,
        this.membershipSetting,
        this.loyaltySetting,
        this.referralSetting,
        this.returnSetting,
        this.buyOnegetOne,
        this.isWebsiteSlider,
        this.isMainSlider,
        this.isFeaturedCategoryOne,
        this.isAdsBelowFeaturedCategoriesOne,
        this.isBulkUpload,
        this.isFeaturedItems,
        this.isAdsBelowFeaturedItemsOne,
        this.isFeaturedCategoryTwo,
        this.isAdsBelowFeaturedCategoriesTwo,
        this.isFeaturedCategoryThree,
        this.isAdsBelowFeaturedCategoriesThree,
        this.isAdsBelowCategory,
        this.isCategory,
        this.isBrands,
        this.isDiscountItems,
        this.businessPlan,
        this.subscriptionModule,
        this.shoppingListModule,
        this.promocodeModule,
        this.pushNotificationModule,
        this.onboardingScreenModule,
        this.walletModule,
        this.liveChatModule,
        this.whatsapChatModule,
        this.productFilteringModule,
        this.productShareModule,
        this.analyticsModule,
        this.offerModule,
        this.wholesaleModule,
        this.multiVendorModule,
        this.repeatOrderModule,
        this.homepageOffers,
        this.refundModule,
        this.rateOrdersModule,
        this.languageModule,
        this.callMeInsteadOTP,
        this.splitOrder,
        this.mainBanneraboveSlider,
        this.restaurantLong,
        this.restaurantLat,
        this.address,
        this.minimumOrderAmount,
        this.maximumOrderAmount,
        this.languages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categorymainslider'] != null) {
      categorymainslider = <Categorymainslider>[];
      json['categorymainslider'].forEach((v) {
        categorymainslider!.add(new Categorymainslider.fromJson(v));
      });
    }
    if (json['FeaturedMainCategoryTags'] != null) {
      featuredMainCategoryTags = <FeaturedMainCategoryTags>[];
      json['FeaturedMainCategoryTags'].forEach((v) {
        featuredMainCategoryTags!.add(new FeaturedMainCategoryTags.fromJson(v));
      });
    }
    if (json['mainslider'] != null) {
      mainslider = <Mainslider>[];
      json['mainslider'].forEach((v) {
        mainslider!.add(new Mainslider.fromJson(v));
      });
    }
    if (json['FeaturedCategories1'] != null) {
      featuredCategories1 = <FeaturedCategories1>[];
      json['FeaturedCategories1'].forEach((v) {
        featuredCategories1!.add(new FeaturedCategories1.fromJson(v));
      });
    }
    if (json['FeaturedCategoryTags'] != null) {
      featuredCategoryTags = <FeaturedCategoryTags>[];
      json['FeaturedCategoryTags'].forEach((v) {
        featuredCategoryTags!.add(new FeaturedCategoryTags.fromJson(v));
      });
    }
    if (json['FeaturedTagsBanner'] != null) {
      featuredTagsBanner = <FeaturedTagsBanner>[];
      json['FeaturedTagsBanner'].forEach((v) {
        featuredTagsBanner!.add(new FeaturedTagsBanner.fromJson(v));
      });
    }
    if (json['FeaturedStores'] != null) {
      featuredStores = <FeaturedStores>[];
      json['FeaturedStores'].forEach((v) {
        featuredStores!.add(new FeaturedStores.fromJson(v));
      });
    }
    featuredStoreLabel = json['featuredStoreLabel'];
    featuredStoreLabelsub = json['featuredStoreLabelsub'];
    categoryTagsLabel = json['categoryTagsLabel'];
    categoryTagsLabelsub = json['categoryTagsLabelsub'];
    if (json['nearestStores'] != null) {
      nearestStores = <NearestStores>[];
      json['nearestStores'].forEach((v) {
        nearestStores!.add(new NearestStores.fromJson(v));
      });
    }
    maincategoryTagsLabel = json['maincategoryTagsLabel'];
    maincategoryTagssubLabel = json['maincategoryTagssubLabel'];
    countryCode = json['countryCode'];
    currencyFormat = json['currencyFormat'];
    firebase = json['firebase'];
    firebaseMapkey = json['firebaseMapkey'];
    crispChatId = json['crispChatId'];
    primaryMobile = json['primaryMobile'];
    secondaryMobile = json['secondaryMobile'];
    email = json['email'];
    aboutUs = json['about_us'];
    IConstants.aboutroot = json['about_us']??"";
    privacyPolicy = json['privacy_policy'];
    IConstants.privacyroot = json['privacy_policy']??"";
    refundPolicy = json['refund_policy'];
    IConstants.refundroot = json['refund_policy']??"";
    returnsPolicy = json['returns_policy'];
    IConstants.returnsroot = json['returns_policy']??"";
    walletPolicy = json['wallet_policy'];
    IConstants.walletroot = json['wallet_policy']??"";
    referPolicy = json['refer_policy'];
    IConstants.referroot = json['refer_policy']??"";
    otherPolicy = json['other_policy'];
    IConstants.additionalroot = json['other_policy']??"";
    pickerModal = json['pickerModal'];
    deliveryOtp = json['deliveryOtp'];
    affliateModal = json['affliateModal'];
    membershipSetting = json['membershipSetting'];
    loyaltySetting = json['loyaltySetting'];
    referralSetting = json['referralSetting'];
    returnSetting = json['returnSetting'];
    buyOnegetOne = json['buyOnegetOne'];
    isWebsiteSlider = json['isWebsiteSlider'];
    isMainSlider = json['isMainSlider'];
    isFeaturedCategoryOne = json['isFeaturedCategoryOne'];
    isAdsBelowFeaturedCategoriesOne = json['isAdsBelowFeaturedCategoriesOne'];
    isBulkUpload = json['isBulkUpload'];
    isFeaturedItems = json['isFeaturedItems'];
    isAdsBelowFeaturedItemsOne = json['isAdsBelowFeaturedItemsOne'];
    isFeaturedCategoryTwo = json['isFeaturedCategoryTwo'];
    isAdsBelowFeaturedCategoriesTwo = json['isAdsBelowFeaturedCategoriesTwo'];
    isFeaturedCategoryThree = json['isFeaturedCategoryThree'];
    isAdsBelowFeaturedCategoriesThree =
    json['isAdsBelowFeaturedCategoriesThree'];
    isAdsBelowCategory = json['isAdsBelowCategory'];
    isCategory = json['isCategory'];
    isBrands = json['isBrands'];
    isDiscountItems = json['isDiscountItems'];
    businessPlan = json['businessPlan'];
    subscriptionModule = json['subscriptionModule'];
    shoppingListModule = json['shoppingListModule'];
    promocodeModule = json['promocodeModule'];
    pushNotificationModule = json['pushNotificationModule'];
    onboardingScreenModule = json['onboardingScreenModule'];
    walletModule = json['walletModule'];
    liveChatModule = json['liveChatModule'];
    whatsapChatModule = json['whatsapChatModule'];
    productFilteringModule = json['productFilteringModule'];
    productShareModule = json['productShareModule'];
    analyticsModule = json['analyticsModule'];
    offerModule = json['offerModule'];
    wholesaleModule = json['wholesaleModule'];
    multiVendorModule = json['multiVendorModule'];
    repeatOrderModule = json['repeatOrderModule'];
    homepageOffers = json['homepageOffers'];
    refundModule = json['refundModule'];
    rateOrdersModule = json['rateOrdersModule'];
    languageModule = json['languageModule']??"";
    callMeInsteadOTP = json['callMeInsteadOTP'];
    splitOrder = json['splitOrder'];
    mainBanneraboveSlider = json['mainBanneraboveSlider'];
    restaurantLong = json['restaurantLong'];
    restaurantLat = json['restaurantLat'];
    address = json['address'];
    minimumOrderAmount = json['minimum_order_amount'];
    maximumOrderAmount = json['maximum_order_amount'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(new Languages.fromJson(v));

      });

    }
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categorymainslider != null) {
      data['categorymainslider'] =
          this.categorymainslider!.map((v) => v.toJson()).toList();
    }
    if (this.featuredMainCategoryTags != null) {
      data['FeaturedMainCategoryTags'] =
          this.featuredMainCategoryTags!.map((v) => v.toJson()).toList();
    }
    if (this.mainslider != null) {
      data['mainslider'] = this.mainslider!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories1 != null) {
      data['FeaturedCategories1'] =
          this.featuredCategories1!.map((v) => v.toJson()).toList();
    }
    if (this.featuredTagsBanner != null) {
      data['FeaturedTagsBanner'] =
          this.featuredTagsBanner!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategoryTags != null) {
      data['FeaturedCategoryTags'] =
          this.featuredCategoryTags!.map((v) => v.toJson()).toList();
    }
    if (this.featuredStores != null) {
      data['FeaturedStores'] =
          this.featuredStores!.map((v) => v.toJson()).toList();
    }
    data['featuredStoreLabel'] = this.featuredStoreLabel;
    data['featuredStoreLabelsub'] = this.featuredStoreLabelsub;
    data['categoryTagsLabel'] = this.categoryTagsLabel;
    data['categoryTagsLabelsub'] = this.categoryTagsLabelsub;
    if (this.nearestStores != null) {
      data['nearestStores'] =
          this.nearestStores!.map((v) => v.toJson()).toList();
    }
    data['maincategoryTagsLabel'] = this.maincategoryTagsLabel;
    data['maincategoryTagssubLabel'] = this.maincategoryTagssubLabel;
    data['countryCode'] = this.countryCode;
    data['currencyFormat'] = this.currencyFormat;
    data['firebase'] = this.firebase;
    data['firebaseMapkey'] = this.firebaseMapkey;
    data['crispChatId'] = this.crispChatId;
    data['primaryMobile'] = this.primaryMobile;
    data['secondaryMobile'] = this.secondaryMobile;
    data['email'] = this.email;
    data['about_us'] = this.aboutUs;
    data['privacy_policy'] = this.privacyPolicy;
    data['refund_policy'] = this.refundPolicy;
    data['returns_policy'] = this.returnsPolicy;
    data['wallet_policy'] = this.walletPolicy;
    data['refer_policy'] = this.referPolicy;
    data['other_policy'] = this.otherPolicy;
    data['pickerModal'] = this.pickerModal;
    data['deliveryOtp'] = this.deliveryOtp;
    data['affliateModal'] = this.affliateModal;
    data['membershipSetting'] = this.membershipSetting;
    data['loyaltySetting'] = this.loyaltySetting;
    data['referralSetting'] = this.referralSetting;
    data['returnSetting'] = this.returnSetting;
    data['buyOnegetOne'] = this.buyOnegetOne;
    data['isWebsiteSlider'] = this.isWebsiteSlider;
    data['isMainSlider'] = this.isMainSlider;
    data['isFeaturedCategoryOne'] = this.isFeaturedCategoryOne;
    data['isAdsBelowFeaturedCategoriesOne'] =
        this.isAdsBelowFeaturedCategoriesOne;
    data['isBulkUpload'] = this.isBulkUpload;
    data['isFeaturedItems'] = this.isFeaturedItems;
    data['isAdsBelowFeaturedItemsOne'] = this.isAdsBelowFeaturedItemsOne;
    data['isFeaturedCategoryTwo'] = this.isFeaturedCategoryTwo;
    data['isAdsBelowFeaturedCategoriesTwo'] =
        this.isAdsBelowFeaturedCategoriesTwo;
    data['isFeaturedCategoryThree'] = this.isFeaturedCategoryThree;
    data['isAdsBelowFeaturedCategoriesThree'] =
        this.isAdsBelowFeaturedCategoriesThree;
    data['isAdsBelowCategory'] = this.isAdsBelowCategory;
    data['isCategory'] = this.isCategory;
    data['isBrands'] = this.isBrands;
    data['isDiscountItems'] = this.isDiscountItems;
    data['businessPlan'] = this.businessPlan;
    data['subscriptionModule'] = this.subscriptionModule;
    data['shoppingListModule'] = this.shoppingListModule;
    data['promocodeModule'] = this.promocodeModule;
    data['pushNotificationModule'] = this.pushNotificationModule;
    data['onboardingScreenModule'] = this.onboardingScreenModule;
    data['walletModule'] = this.walletModule;
    data['liveChatModule'] = this.liveChatModule;
    data['whatsapChatModule'] = this.whatsapChatModule;
    data['productFilteringModule'] = this.productFilteringModule;
    data['productShareModule'] = this.productShareModule;
    data['analyticsModule'] = this.analyticsModule;
    data['offerModule'] = this.offerModule;
    data['wholesaleModule'] = this.wholesaleModule;
    data['multiVendorModule'] = this.multiVendorModule;
    data['repeatOrderModule'] = this.repeatOrderModule;
    data['homepageOffers'] = this.homepageOffers;
    data['refundModule'] = this.refundModule;
    data['rateOrdersModule'] = this.rateOrdersModule;
    data['languageModule'] = this.languageModule;
    data['callMeInsteadOTP'] = this.callMeInsteadOTP;
    data['splitOrder'] = this.splitOrder;
    data['mainBanneraboveSlider'] = this.mainBanneraboveSlider;
    data['restaurantLong'] = this.restaurantLong;
    data['restaurantLat'] = this.restaurantLat;
    data['address'] = this.address;
    data['minimum_order_amount'] = this.minimumOrderAmount;
    data['maximum_order_amount'] = this.maximumOrderAmount;
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
      debugPrint("data['languages']...."+this.languages.toString());

    }
    // SetLanguageList(this.languages as Map<String, dynamic>);
    return data;
  }
}


class Categorymainslider {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  String? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;
  String? stores;
  String? package;

  Categorymainslider(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage,
        this.stores,
        this.package});

  Categorymainslider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    isActive = json['is_active'];
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    bannerImage = IConstants.API_IMAGE+"banners/banner/"+ json['banner_image'];
    stores = json['stores'];
    package = json['package'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['branch'] = this.branch;
    data['banner_for'] = this.bannerFor;
    data['is_active'] = this.isActive;
    data['advertisement_type'] = this.advertisementType;
    data['display_for'] = this.displayFor;
    data['banner_image'] = this.bannerImage;
    data['stores'] = this.stores;
    data['package'] = this.package;
    return data;
  }
}


class FeaturedMainCategoryTags {

  String? id;
  String? name;
  String? iconImage;
  String? branch;
  String? status;
  String? ref;

  FeaturedMainCategoryTags(
      {this.id, this.name, this.iconImage, this.branch, this.status, this.ref});

  FeaturedMainCategoryTags.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    name = json['name'];
    iconImage = IConstants.API_IMAGE+"categoryTags/"+json['iconImage'];
    branch = json['branch'];
    status = json['status'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iconImage'] = this.iconImage;
    data['branch'] = this.branch;
    data['status'] = this.status;
    data['ref'] = this.ref;
    return data;
  }
}


class Mainslider {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  String? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;
  String? stores;

  Mainslider(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage,
        this.stores});


  Mainslider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    isActive = json['is_active'];
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    bannerImage = IConstants.API_IMAGE+"banners/banner/"+json['banner_image'];
    stores = json['stores'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['branch'] = this.branch;
    data['banner_for'] = this.bannerFor;
    data['is_active'] = this.isActive;
    data['advertisement_type'] = this.advertisementType;
    data['display_for'] = this.displayFor;
    data['banner_image'] = this.bannerImage;
    data['stores'] = this.stores;
    return data;
  }
}

class FeaturedTagsBanner {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  String? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;
  String? stores;

  FeaturedTagsBanner(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage,
        this.stores});

  FeaturedTagsBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    isActive = json['is_active'];
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    bannerImage = IConstants.API_IMAGE +"banners/banner/" + json['banner_image'];
    stores = json['stores'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['branch'] = this.branch;
    data['banner_for'] = this.bannerFor;
    data['is_active'] = this.isActive;
    data['advertisement_type'] = this.advertisementType;
    data['display_for'] = this.displayFor;
    data['banner_image'] = this.bannerImage;
    data['stores'] = this.stores;
    return data;
  }
}

class FeaturedCategories1 {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  String? data;
  String? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;
  FeaturedCategories1(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.data,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage});
  FeaturedCategories1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    data = json['data'];
    isActive = json['is_active'];
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    bannerImage = IConstants.API_IMAGE+"banners/banner/"+json['banner_image'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['branch'] = this.branch;
    data['banner_for'] = this.bannerFor;
    data['data'] = this.data;
    data['is_active'] = this.isActive;
    data['advertisement_type'] = this.advertisementType;
    data['display_for'] = this.displayFor;
    data['banner_image'] = this.bannerImage;
    return data;
  }
}

class FeaturedCategoryTags {
  String? id;
  String? name;
  String? iconImage;
  String? branch;
  String? status;

  FeaturedCategoryTags(
      {this.id, this.name, this.iconImage, this.branch, this.status});

  FeaturedCategoryTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconImage = IConstants.API_IMAGE+"categoryTags/"+json['iconImage'];
    branch = json['branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iconImage'] = this.iconImage;
    data['branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}




class FeaturedStores {
  String? id;
  String? restaurantName;
  String? restaurantLocation;
  String? restaurantLong;
  String? restaurantLat;
  double? distance;
  String? iconImage;
  String? bannerImage;
  String? offerText;
  int? ratings;
  List<String>? categoryData;
  int? menuItemCount;

  FeaturedStores(
      {this.id,
        this.restaurantName,
        this.restaurantLocation,
        this.restaurantLong,
        this.restaurantLat,
        this.distance,
        this.iconImage,
        this.bannerImage,
        this.offerText,
        this.ratings,
        this.categoryData,
        this.menuItemCount});

  FeaturedStores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantName = json['restaurantName'];
    restaurantLocation = json['restaurantLocation'];
    restaurantLong = json['restaurantLong'];
    restaurantLat = json['restaurantLat'];
    distance = double.parse(json['distance'].toString());
    iconImage = json['iconImage'];
    bannerImage = IConstants.API_IMAGE+"restaurant/banners/"+json['bannerImage'];
    offerText = json['offerText'];
    ratings = json['ratings'];
    categoryData = json['category_data'].cast<String>();
    menuItemCount = json['menu_item_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantName'] = this.restaurantName;
    data['restaurantLocation'] = this.restaurantLocation;
    data['restaurantLong'] = this.restaurantLong;
    data['restaurantLat'] = this.restaurantLat;
    data['distance'] = this.distance;
    data['iconImage'] = this.iconImage;
    data['bannerImage'] = this.bannerImage;
    data['offerText'] = this.offerText;
    data['ratings'] = this.ratings;
    data['category_data'] = this.categoryData;
    data['menu_item_count'] = this.menuItemCount;
    return data;
  }
}


class NearestStores {
  String? id;
  String? restaurantName;
  String? restaurantLocation;
  double? distance;
  String? iconImage;
  String? offerText;
  int? ratings;
  String? restaurantLong;
  String? restaurantLat;
  int? menuItemCount;

  NearestStores(
      {this.id,
        this.restaurantName,
        this.restaurantLocation,
        this.distance,
        this.iconImage,
        this.offerText,
        this.ratings,
        this.restaurantLong,
        this.restaurantLat,
        this.menuItemCount});

  NearestStores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantName = json['restaurantName'];
    restaurantLocation = json['restaurantLocation'];
    distance = double.parse(json['distance'].toString());
    iconImage = IConstants.API_IMAGE+"restaurant/icons/"+json['iconImage'];
    offerText = json['offerText'];
    ratings = json['ratings'];
    restaurantLong = json['restaurantLong'];
    restaurantLat = json['restaurantLat'];
    menuItemCount = json['menu_item_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantName'] = this.restaurantName;
    data['restaurantLocation'] = this.restaurantLocation;
    data['distance'] = this.distance;
    data['iconImage'] = this.iconImage;
    data['offerText'] = this.offerText;
    data['ratings'] = this.ratings;
    data['restaurantLong'] = this.restaurantLong;
    data['restaurantLat'] = this.restaurantLat;
    data['menu_item_count'] = this.menuItemCount;
    return data;
  }
}

class Languages {
  String? id;
  String? name;
  String? createdAt;
  String? branch;
  String? status;
  String? languageCode;
  String? invoice;

  Languages(
      {this.id,
        this.name,
        this.createdAt,
        this.branch,
        this.status,
        this.languageCode,
        this.invoice});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    branch = json['branch'];
    status = json['status'];
    languageCode = json['languageCode'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['branch'] = this.branch;
    data['status'] = this.status;
    data['languageCode'] = this.languageCode;
    data['invoice'] = this.invoice;
    return data;
  }
}
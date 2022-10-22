import 'package:grocbay/constants/IConstants.dart';

class StoreOfferbanner {
  int? status;
  StoreOfferData? data;

  StoreOfferbanner({this.status, this.data});

  StoreOfferbanner.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new StoreOfferData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StoreOfferData {
  List<RootBanner>? rootBanner;
  List<OfferBanner>? offerBanner;

  StoreOfferData({this.rootBanner, this.offerBanner});

  StoreOfferData.fromJson(Map<String, dynamic> json) {
    if (json['rootBanner'] != null) {
      rootBanner = <RootBanner>[];
      json['rootBanner'].forEach((v) {
        rootBanner!.add(new RootBanner.fromJson(v));
      });
    }
    if (json['offerBanner'] != null) {
      offerBanner = <OfferBanner>[];
      json['offerBanner'].forEach((v) {
        offerBanner!.add(new OfferBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rootBanner != null) {
      data['rootBanner'] = this.rootBanner!.map((v) => v.toJson()).toList();
    }
    if (this.offerBanner != null) {
      data['offerBanner'] = this.offerBanner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RootBanner {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  String? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;
  String? stores;

  RootBanner(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage,
        this.stores});

  RootBanner.fromJson(Map<String, dynamic> json) {
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

class OfferBanner {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  String? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;
  String? stores;

  OfferBanner(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage,
        this.stores});

  OfferBanner.fromJson(Map<String, dynamic> json) {
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
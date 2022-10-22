import '../constants/IConstants.dart';

class BrandsFields {
  int? _id;
  String? _title;
  String? _branch;
  String? _bannerFor;
  String? _bannerData;
  String? _clickLink;
  bool? _isActive;
  String? _bannerImage;
  String? _displayFor;

  BrandsFields(
      {int? id,
        String? title,
        String? branch,
        String? bannerFor,
        String? bannerData,
        String? clickLink,
        bool? isActive,
        String? bannerImage,
        String? displayFor}) {
    this._id = id;
    this._title = title;
    this._branch = branch;
    this._bannerFor = bannerFor;
    this._bannerData = bannerData;
    this._clickLink = clickLink;
    this._isActive = isActive;
    this._bannerImage = bannerImage;
    this._displayFor = displayFor;
  }

  int get id => _id!;
  set id(int id) => _id = id;
  String get title => _title!;
  set title(String title) => _title = title;
  String get branch => _branch!;
  set branch(String branch) => _branch = branch;
  String get bannerFor => _bannerFor!;
  set bannerFor(String bannerFor) => _bannerFor = bannerFor;
  String get bannerData => _bannerData!;
  set data(String bannerData) => _bannerData = bannerData;
  String get clickLink => _clickLink!;
  set clickLink(String clickLink) => _clickLink = clickLink;
  bool get isActive => _isActive!;
  set isActive(bool isActive) => _isActive = isActive;
  String get bannerImage => _bannerImage!;
  set bannerImage(String bannerImage) => _bannerImage = bannerImage;
  String get displayFor => _displayFor!;
  set displayFor(String displayFor) => _displayFor = displayFor;

  BrandsFields.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _branch = json['branch'];
    _bannerFor = json['banner_for'];
    _bannerData = json['data'];
    _clickLink = json['click_link'];
    _isActive = json['is_active'];
    if(json['banner_image']==null)bannerImage = "";else _bannerImage = IConstants.API_IMAGE+"banners/banner/"+json['banner_image'];
    _displayFor = json['display_for'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['branch'] = this._branch;
    data['banner_for'] = this._bannerFor;
    data['data'] = this._bannerData;
    data['click_link'] = this._clickLink;
    data['is_active'] = this._isActive;
    data['banner_image'] = this._bannerImage;
    data['display_for'] = this._displayFor;
    return data;
  }
}


class Advertisement {
  int? _id;
  String? _title;
  String? _branch;
  String? _bannerFor;
  String? _data;
  String? _clickLink;
  bool? _isActive;
  String? _bannerImage;
  String? _displayFor;

  Advertisement(
      {int? id,
        String? title,
        String? branch,
        String? bannerFor,
        String? data,
        String? clickLink,
        bool? isActive,
        String? bannerImage,
        String? displayFor}) {
    this._id = id;
    this._title = title;
    this._branch = branch;
    this._bannerFor = bannerFor;
    this._data = data;
    this._clickLink = clickLink;
    this._isActive = isActive;
    this._bannerImage = bannerImage;
    this._displayFor = displayFor;
  }

  int get id => _id!;
  set id(int id) => _id = id;
  String get title => _title!;
  set title(String title) => _title = title;
  String get branch => _branch!;
  set branch(String branch) => _branch = branch;
  String get bannerFor => _bannerFor!;
  set bannerFor(String bannerFor) => _bannerFor = bannerFor;
  String get data => _data!;
  set data(String data) => _data = data;
  String get clickLink => _clickLink!;
  set clickLink(String clickLink) => _clickLink = clickLink;
  bool get isActive => _isActive!;
  set isActive(bool isActive) => _isActive = isActive;
  String get bannerImage => _bannerImage!;
  set bannerImage(String bannerImage) => _bannerImage = bannerImage;
  String get displayFor => _displayFor!;
  set displayFor(String displayFor) => _displayFor = displayFor;

  Advertisement.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _branch = json['branch'];
    _bannerFor = json['banner_for'];
    _data = json['data'];
    _clickLink = json['click_link'];
    _isActive = json['is_active'];
    _bannerImage = json['banner_image'];
    _displayFor = json['display_for'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['branch'] = this._branch;
    data['banner_for'] = this._bannerFor;
    data['data'] = this._data;
    data['click_link'] = this._clickLink;
    data['is_active'] = this._isActive;
    data['banner_image'] = this._bannerImage;
    data['display_for'] = this._displayFor;
    return data;
  }
}
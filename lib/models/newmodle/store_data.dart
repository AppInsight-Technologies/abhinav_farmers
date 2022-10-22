
import 'package:grocbay/constants/IConstants.dart';

class StoreData {
  int? status;
  List<Store_Data>? data;

  StoreData({this.status, this.data});

  StoreData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Store_Data>[];
      json['data'].forEach((v) {
        data!.add(new Store_Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Store_Data {
  String? id;
  String? restaurantName;
  String? restaurantLocation;
  String? restaurantLong;
  String? restaurantLat;
  double? distance;
  String? iconImage;
  String? offerText;
  int? ratings;
  int? menuItemCount;

  Store_Data(
      {this.id,
        this.restaurantName,
        this.restaurantLocation,
        this.restaurantLong,
        this.restaurantLat,
        this.distance,
        this.iconImage,
        this.offerText,
        this.ratings,
        this.menuItemCount
      });

  Store_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantName = json['restaurantName'];
    restaurantLocation = json['restaurantLocation'];
    restaurantLong = json['restaurantLong'];
    restaurantLat = json['restaurantLat'];
    distance = double.parse(json['distance'].toString());
    iconImage = IConstants.API_IMAGE + "restaurant/icons/"+json['iconImage'];
    offerText = json['offerText'];
    ratings = json['ratings'];
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
    data['offerText'] = this.offerText;
    data['ratings'] = this.ratings;
    data['menu_item_count'] = this.menuItemCount;
    return data;
  }
}
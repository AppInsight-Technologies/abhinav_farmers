
class CategoryStore {
  int? status;
  List<Data>? data;

  CategoryStore({this.status, this.data});

  CategoryStore.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? id;
  String? restaurantName;
  String? restaurantLocation;
  String? restaurantLong;
  String? restaurantLat;
  double? distance;
  String? iconImage;
  String? offerText;
  int? ratings;

  Data(
      {this.id,
        this.restaurantName,
        this.restaurantLocation,
        this.restaurantLong,
        this.restaurantLat,
        this.distance,
        this.iconImage,
        this.offerText,
        this.ratings});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantName = json['restaurantName'];
    restaurantLocation = json['restaurantLocation'];
    restaurantLong = json['restaurantLong'];
    restaurantLat = json['restaurantLat'];
    distance = double.parse(json['distance'].toString());
    iconImage = json['iconImage'];
    offerText = json['offerText'];
    ratings = json['ratings'];
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
    return data;
  }
}
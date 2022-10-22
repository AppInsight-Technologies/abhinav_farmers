
import '../../models/newmodle/product_data.dart';

class swap {
  List<ItemData>? data;
  List<ItemData>? surveyProducts;

  swap({this.data, this.surveyProducts});

  swap.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(new ItemData.fromJson(v));
      });
    }
    if (json['survey_products'] != null) {
      surveyProducts = <ItemData>[];
      json['survey_products'].forEach((v) {
        surveyProducts!.add(new ItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.surveyProducts != null) {
      data['survey_products'] =
          this.surveyProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


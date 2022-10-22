import '../../constants/IConstants.dart';
import 'package:velocity_x/velocity_x.dart';

import 'category_modle.dart';
import 'product_data.dart';
import 'user.dart';

class HomePageData {
  Data? data;

  HomePageData({this.data});

  HomePageData.fromJson(Map<String, dynamic> json) {
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
  int? menuItemCount;
  int? ratings;
  double? distance;
  String? restaurantName;
  String? restaurantLocation;
  List<UserData>? customerDetails =[];
  OfferByCart? offerByCart;
  OfferByCart? featuredByCart;
  OfferByCart? discountByCart;
  List<AllBrands>? allBrands =[];
  List<CategoryData>? allCategoryDetails=[];
  String? categoryLabel;
  List<CategoryData>? category1Details=[];
  String? categoryTwoLabel;
  List<CategoryData>? category2Details=[];
  String? categoryThreeLabel;
  List<CategoryData>? category3Details=[];
  List<BannerDetails>? mainslider=[];
  List<BannerDetails>? featuredCategories1=[];
  List<BannerDetails>? featureditems1=[];
  List<BannerDetails>? featuredCategories2=[];
  List<BannerDetails>? featuredCategories3=[];
  List<BannerDetails>? verticalSlider=[];
  List<BannerDetails>? footerImage=[];
  List<BannerDetails>? wesiteslider=[];
  List<BannerDetails>? mainslideradd=[];
  List<BannerDetails>? testimonials = [];

  Data(
      {this.menuItemCount,
        this.ratings,
        this.distance,
        this.restaurantName,
        this.restaurantLocation,
        this.customerDetails,
        this.offerByCart,
        this.featuredByCart,
        this.discountByCart,
        this.allBrands,
        this.allCategoryDetails,
        this.categoryLabel,
        this.category1Details,
        this.categoryTwoLabel,
        this.category2Details,
        this.categoryThreeLabel,
        this.category3Details,
        this.mainslider,
        this.featuredCategories1,
        this.featureditems1,
        this.featuredCategories2,
        this.featuredCategories3,
        this.verticalSlider,
        this.mainslideradd,
        this.wesiteslider,
        this.footerImage,
        this.testimonials});

  Data.fromJson(Map<String, dynamic> json) {
    menuItemCount = json['menu_item_count'];
    ratings = json['ratings'];
    distance = double.parse(json['distance'].toString());
    restaurantName = json['restaurantName'];
    restaurantLocation = json['restaurantLocation'];
    if (json['customerDetails'] != null&&json['customerDetails'].toString() !="[]") {
      customerDetails = <UserData>[];
      json['customerDetails'].forEach((v) {
        customerDetails!.add(new UserData.fromJson(json['customerDetails'][0]));
      });
    }
    offerByCart = json['OfferByCart'] != null&&json['OfferByCart'].toString() !="[]"
        ? new OfferByCart.fromJson(json['OfferByCart'])
        : null;
    featuredByCart = json['FeaturedByCart'] != null&&json['FeaturedByCart'].toString() !="[]"
        ? new OfferByCart.fromJson(json['FeaturedByCart'])
        : null;
    discountByCart = json['DiscountByCart'] != null&&json['DiscountByCart'].toString() !="[]"
        ? new OfferByCart.fromJson(json['DiscountByCart'])
        : null;
    if (json['AllBrands'] != null&&json['AllBrands'].toString() !="[]") {
      allBrands = <AllBrands>[];
      json['AllBrands'].forEach((v) {
        allBrands!.add(new AllBrands.fromJson(v));
      });
    }
    if (json['AllCategoryDetails'] != null&&json['AllCategoryDetails'].toString() !="[]") {
      allCategoryDetails = <CategoryData>[];
      json['AllCategoryDetails'].forEach((v) {
        allCategoryDetails!.add(new CategoryData.fromJson(v));
      });
    }
    categoryLabel = json['category_label'];
    if (json['Category1Details'] != null&&json['Category1Details'].toString() !="[]") {
      category1Details = <CategoryData>[];
      json['Category1Details'].forEach((v) {
        category1Details!.add(new CategoryData.fromJson(v));
      });
    }
    categoryTwoLabel = json['category_two_label'];
    if (json['Category2Details'] != null&&json['Category2Details'].toString() !="[]") {
      category2Details = <CategoryData>[];
      json['Category2Details'].forEach((v) {
        category2Details!.add(new CategoryData.fromJson(v));
      });
    }
    categoryThreeLabel = json['category_three_label'];
    if (json['Category3Details'] != null&&json['Category3Details'].toString() !="[]") {
      category3Details = <CategoryData>[];
      json['Category3Details'].forEach((v) {
        category3Details!.add(new CategoryData.fromJson(v));
      });
    }
    if(json['MainSliderAdd']!=null&&json['MainSliderAdd'].toString() !="[]"){
      mainslideradd =<BannerDetails>[];
      json['MainSliderAdd'].forEach((v){
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            mainslideradd!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            mainslideradd!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['mainslider'] != null&&json['mainslider'].toString() !="[]") {
      mainslider = <BannerDetails>[];
      json['mainslider'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            mainslider!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            mainslider!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['FeaturedCategories1'] != null&&json['FeaturedCategories1'].toString() !="[]") {
      featuredCategories1 = <BannerDetails>[];
      json['FeaturedCategories1'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            featuredCategories1!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            featuredCategories1!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['Featureditems1'] != null&&json['Featureditems1'].toString() !="[]") {
      featureditems1 = <BannerDetails>[];
      json['Featureditems1'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            featureditems1!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            featureditems1!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['FeaturedCategories2'] != null&&json['FeaturedCategories2'].toString() !="[]") {
      featuredCategories2 = <BannerDetails>[];
      json['FeaturedCategories2'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            featuredCategories2!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            featuredCategories2!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['FeaturedCategories3'] != null&&json['FeaturedCategories3'].toString() !="[]") {
      featuredCategories3 = <BannerDetails>[];
      json['FeaturedCategories3'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            featuredCategories3!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            featuredCategories3!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['VerticalSlider'] != null&&json['VerticalSlider'].toString() !="[]") {
      verticalSlider = <BannerDetails>[];
      json['VerticalSlider'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            verticalSlider!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            verticalSlider!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['FooterImage'] != null&&json['FooterImage'].toString() !="[]") {
      footerImage = <BannerDetails>[];
      json['FooterImage'].forEach((v) {
        if(Vx.isWeb) {
          if (BannerDetails.fromJson(v).displayFor.toString().contains("0")) {
            footerImage!.add(new BannerDetails.fromJson(v));
          }
        }else{
          if (BannerDetails.fromJson(v).displayFor.toString().contains("1")) {
            footerImage!.add(new BannerDetails.fromJson(v));
          }
        }
      });
    }
    if (json['WebsiteSlider'] != null&&json['WebsiteSlider'].toString() !="[]") {
      wesiteslider = <BannerDetails>[];
      json['WebsiteSlider'].forEach((v) {
        wesiteslider!.add(new BannerDetails.fromJson(v));
      });
    }
    if (json['Testimonials'] != null &&json['Testimonials'].toString() !="[]") {
      testimonials = <BannerDetails>[];
      json['Testimonials'].forEach((v) {
        testimonials!.add(new BannerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_item_count'] = this.menuItemCount;
    data['ratings'] = this.ratings;
    data['distance'] = this.distance;
    data['restaurantName'] = this.restaurantName;
    data['restaurantLocation'] = this.restaurantLocation;
    if (this.customerDetails != null) {
      data['customerDetails'] =
          this.customerDetails!.map((v) => v.toJson()).toList();
    }
    if (this.featuredByCart != null) {
      data['FeaturedByCart'] = this.featuredByCart!.toJson();
    }
    if (this.discountByCart != null) {
      data['DiscountByCart'] = this.discountByCart!.toJson();
    }
    if (this.offerByCart != null) {
      data['OfferByCart'] = this.offerByCart!.toJson();
    }
    if (this.allBrands != null) {
      data['AllBrands'] = this.allBrands!.map((v) => v.toJson()).toList();
    }
    if (this.allCategoryDetails != null) {
      data['AllCategoryDetails'] =
          this.allCategoryDetails!.map((v) => v.toJson()).toList();
    }
    data['category_label'] = this.categoryLabel;
    if (this.category1Details != null) {
      data['Category1Details'] =
          this.category1Details!.map((v) => v.toJson()).toList();
    }
    data['category_two_label'] = this.categoryTwoLabel;
    if (this.category2Details != null) {
      data['Category2Details'] =
          this.category2Details!.map((v) => v.toJson()).toList();
    }
    data['category_three_label'] = this.categoryThreeLabel;
    if (this.category3Details != null) {
      data['Category3Details'] =
          this.category3Details!.map((v) => v.toJson()).toList();
    }
    if (this.mainslider != null) {
      data['mainslider'] = this.mainslider!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories1 != null) {
      data['FeaturedCategories1'] =
          this.featuredCategories1!.map((v) => v.toJson()).toList();
    }
    if (this.featureditems1 != null) {
      data['Featureditems1'] =
          this.featureditems1!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories2 != null) {
      data['FeaturedCategories2'] =
          this.featuredCategories2!.map((v) => v.toJson()).toList();
    }
    if (this.featuredCategories3 != null) {
      data['FeaturedCategories3'] =
          this.featuredCategories3!.map((v) => v.toJson()).toList();
    }
    if (this.verticalSlider != null) {
      data['VerticalSlider'] =
          this.verticalSlider!.map((v) => v.toJson()).toList();
    }
    if (this.footerImage != null) {
      data['FooterImage'] = this.footerImage!.map((v) => v.toJson()).toList();
    }
    if (this.mainslideradd != null) {
      data['MainSliderAdd'] = this.mainslideradd!.map((v) => v.toJson()).toList();
    }
    if (this.wesiteslider != null) {
      data['WebsiteSlider'] = this.wesiteslider!.map((v) => v.toJson()).toList();
    }
    if (this.testimonials != null) {
      data['Testimonials'] = this.testimonials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferByCart {
  List<ItemData>? data;
  String? label;

  OfferByCart({this.data, this.label});

  OfferByCart.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(new ItemData.fromJson(v));
      });
    }
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    return data;
  }
}


class AllBrands {
  String? id;
  String? categoryName;
  String? iconImage;

  AllBrands({this.id, this.categoryName, this.iconImage});

  AllBrands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    iconImage = IConstants.API_IMAGE+"sub-category/icons/" +json['icon_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon_image'] = this.iconImage;
    return data;
  }
}

class BannerDetails {
  int? id;
  String? title;
  String? branch;
  String? bannerFor;
  bool? isActive;
  String? bannerImage;
  String? advertisementType;
  String? displayFor;
  String? click_link;
  String? data;

  BannerDetails(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.bannerImage,
        this.advertisementType,
        this.click_link,
        this.data,
        this.displayFor});

  BannerDetails.fromJson(Map<String, dynamic> json) {
    id =int.parse( json['id'].toString());
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    isActive = (json['is_active']=="1");
    data =json['data']??"";
    bannerImage = IConstants.API_IMAGE+"banners/banner/"+json['banner_image'];
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    click_link = json['clickLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['branch'] = this.branch;
    data['banner_for'] = this.bannerFor;
    data['data']=this.data;
    data['is_active'] = this.isActive;
    data['banner_image'] = this.bannerImage;
    data['advertisement_type'] = this.advertisementType;
    data['display_for'] = this.displayFor;
    data['clickLink'] = this.click_link;
    return data;
  }
}

class Testimonials {
  String? id;
  String? title;
  String? branch;
  String? bannerFor;
  bool? isActive;
  String? advertisementType;
  String? displayFor;
  String? bannerImage;

  Testimonials(
      {this.id,
        this.title,
        this.branch,
        this.bannerFor,
        this.isActive,
        this.advertisementType,
        this.displayFor,
        this.bannerImage});

  Testimonials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    branch = json['branch'];
    bannerFor = json['banner_for'];
    isActive = (json['is_active']=="1");
    advertisementType = json['advertisement_type'];
    displayFor = json['display_for'];
    bannerImage = IConstants.API_IMAGE+"banners/banner/"+json['banner_image'];;
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
    return data;
  }
}
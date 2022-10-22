import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/branditems.dart';
import 'package:provider/provider.dart';
import '../constants/features.dart';
import '../constants/api.dart';
import 'package:http/http.dart' as http;

import '../constants/IConstants.dart';
import '../main.dart';
import '../models/sellingitemsfields.dart';
import '../models/categoriesfields.dart';
import '../models/notificationfield.dart';
import '../utils/prefUtils.dart';
import '../assets/ColorCodes.dart';
import '../models/brandfields.dart';

class NotificationItemsList with ChangeNotifier {
  List<SellingItemsFields> _items = [];
  List<SellingItemsFields> _itemspricevar = [];
  List<CategoriesFields> _bannerSubcat = [];
  List<CategoriesFields> _catItems = [];
  List<NotificationFields> _notItems = [];
  List<NotificationFields> _notUpdate = [];
  List<BrandsFields> _brandItems = [];
  List<SellingItemsFields> _itemnotproductimage =[];
  late Color featuredCategoryBColor;

  Future<void> fetchProductItems(String productId) async {
    // imp feature in adding async is the it automatically wrap into Future.

    String user = (!PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!.getString("tokenid") !: PrefUtils.prefs!.getString('apikey')!;
    var url = Api.getItemsByCart + productId + "/" + user;

    _items = [];
    _itemspricevar = [];
    _itemnotproductimage=[];
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs!.getString('branch'),
            "language_id": IConstants.languageId,
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("product Item respnse....."+responseJson.toString());
      if (responseJson.toString() == "[]") {
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        for (int i = 0; i < data.length; i++) {

          final deliveryduration= json.encode(
              data[i]['delivery_duration']);

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

          _items.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['item_name'].toString(),
            imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['item_featured_image'].toString(),
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

          final pricevarJson = json.encode(
              data[i]['price_variation']); //fetching sub categories data
          final pricevarJsondecode = json.decode(pricevarJson);
          print("pricaveriation...."+pricevarJsondecode.toString());
          List pricevardata = []; //list for subcategories

          if (pricevarJsondecode == null) {
          } else {
            pricevarJsondecode.asMap().forEach((index, value) => pricevardata
                .add(pricevarJsondecode[index] as Map<String, dynamic>));

            for (int j = 0; j < pricevardata.length; j++) {
              final multiimagesJson = json.encode(
                  pricevardata[j]['images']); //fetching sub categories data
              final multiimagesJsondecode = json.decode(multiimagesJson);
              List multiimagesdata = [];
              String imageurl = "";

              if (multiimagesJsondecode.toString() == "[]") {
                imageurl = IConstants.API_IMAGE +
                    "items/images/" +
                    data[i]['item_featured_image'].toString();
              } else {
                multiimagesJsondecode.asMap().forEach((index, value) =>
                    multiimagesdata.add(
                        multiimagesJsondecode[index] as Map<String, dynamic>));
                imageurl = IConstants.API_IMAGE +
                    "items/images/" +
                    multiimagesdata[0]['image'].toString();
              }
              bool _discointDisplay = false;
              bool _membershipDisplay = false;

              if (double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
                _discointDisplay = false;
              } else {
                _discointDisplay = true;
              }
              if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())
                  || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['price'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _itemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: pricevardata[j]['menu_item_id'].toString(),
                varname: pricevardata[j]['variation_name'].toString(),
                varmrp: pricevardata[j]['mrp'].toString(),
                varprice: pricevardata[j]['price'].toString(),
                varmemberprice: pricevardata[j]['membership_price'].toString(),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['min_item'].toString(),
                varmaxitem: pricevardata[j]['max_item'].toString(),
                varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                    pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
                varQty: int.parse(pricevardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
                imageUrl: imageurl,
                unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
                  weight: double.parse(pricevardata[j]['weight'].toString())
              ));
              if (multiimagesJsondecode.toString() == "[]") {
                _itemnotproductimage.add(SellingItemsFields(
                  varid: pricevardata[j]['id'].toString(),
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
                  _itemnotproductimage.add(SellingItemsFields(
                    varid: pricevardata[j]['id'].toString(),
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
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<SellingItemsFields> get items {
    return [..._items];
  }

  List<SellingItemsFields> findById(String menuid) {
    return [..._itemspricevar.where((pricevar) => pricevar.menuid == menuid)];
  }
  List<SellingItemsFields> findBynotproductimage(String pricevarid){
    return [..._itemnotproductimage.where((pricevar) => pricevar.varid == pricevarid)];
  }
  Future<void> fetchCategoryItems(String categoryId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getFeaturedCategories/* + categoryId + "/" + PrefUtils.prefs!.getString('branch')*/;
    _catItems = [];
    try {
      final response = await http.post(url,
          body: {
            "id": categoryId,
            "branch": PrefUtils.prefs!.getString('branch'),
            "language_id": IConstants.languageId,
          });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson.toString() == "[]") {
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));
        var list = [
          Color(0xffC6EEF1),
          Color(0xffC6F1C6),
          Color(0xffC6D6F1),
          Color(0xffE9F1C6),
          Color(0xffE9F1C6),
          Color(0xffE1C6F1),
          Color(0xffC6C7F1),
        ];

// generates a new Random object
        final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element
        var element = list[_random.nextInt(list.length)];

        for (int i = 0; i < data.length; i++) {
          _catItems.add(CategoriesFields(
            catid: data[i]['parentId'].toString(),
            subcatid: data[i]['id'].toString(),
            title: data[i]['category_name'].toString(),
            imageUrl: IConstants.API_IMAGE +
                "sub-category/icons/" +
                data[i]['icon_image'].toString(),
             featuredCategoryBColor: /*list[_random.nextInt(list.length)]*/Colors.white,
          ));
                           }
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<CategoriesFields> get catitems {
    return [..._catItems];
  }

  Future<void> fetchBrandsItems(String brandsId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getBrandsData + brandsId;
    _catItems = [];
    try {
      _brandItems.clear();
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "branch": PrefUtils.prefs!.getString('branch'),
        "language_id": IConstants.languageId,
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
//      var idlist = responseJson.map<int>((m) => m['id'] as int).toList();
//      var imagelist = responseJson.map<String>((m) => m['banner_image'] as String).toList();

      var data = [];

      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>));
      Color boxbackcolor;
      Color boxsidecolor;
      Color textcolor;
      for (int i = 0; i < data.length; i++) {
        if (i != 0)         {
          boxbackcolor = ColorCodes.mediumBlackColor;
          boxsidecolor = ColorCodes.blackColor;
          textcolor = ColorCodes.blackColor;
        } else {
          boxbackcolor = ColorCodes.mediumBlueColor;
          boxsidecolor = ColorCodes.mediumBlueColor;
          textcolor = ColorCodes.whiteColor;
        }
        _brandItems.add(BrandsFields(
          id: data[i]['id'].toString(),
          title: data[i]['category_name'].toString(),
          imageUrl: IConstants.API_IMAGE +
              "sub-category/icons/" +
              data[i]['icon_image'].toString(),
          // featuredCategoryBColor: list[_random.nextInt(list.length)]
          boxbackcolor: boxbackcolor,
          boxsidecolor: boxsidecolor,
          textcolor: textcolor,
        ));

      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<BrandsFields> get brands {
    return [..._brandItems];
  }

  Future<void> fetchNotificationLogs(String userId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = (Features.ismultivendor && IConstants.isEnterprise) ?
    Api.getNotificationmultivendor + '$userId/' + IConstants.refIdForMultiVendor:Api.getNotification + '$userId/' + PrefUtils.prefs!.getString("branch")!;
    debugPrint("fetchNotificationLogs . . .  .. ." + url);
    _notItems = [];
    try {
      final response = await http.get(
        url,
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      debugPrint('notification..'+responseJson.toString());
      if (responseJson.toString() == "[]") {
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        int unreadCount = 0;
        for (int i = 0; i < data.length; i++) {
          if (data[i]['status'].toString() == "0") unreadCount++;
          _notItems.add(NotificationFields(
            id: data[i]['id'].toString(),
            status: data[i]['status'].toString(),
            date: data[i]['date'].toString(),
            notificationFor: data[i]['notificationFor'].toString(),
            dateTime: data[i]['dateTime'].toString(),
            data: data[i]['data'].toString(),
            message: data[i]['message'].toString(),
            unreadcount: unreadCount,
          ));
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<NotificationFields> get notItems {
    return [..._notItems];
  }

  Future<void> updateNotificationStatus(
      String notificationId, String status) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.updateNotification + notificationId + "/" + status;
    try {
      final response = await http.post(
          url,
          body: {
            // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs!.getString('branch'),
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("update notification...response...."+responseJson.toString());
      if (responseJson['status'].toString() == "200") {
        await Provider.of<BrandItemsList>(navigatorKey.currentContext!,listen: false).userDetails();
      }
    } catch (error) {
      throw error;
    }
  }
}

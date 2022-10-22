
import 'dart:convert';

import '../constants/features.dart';
import '../constants/IConstants.dart';
import '../constants/api.dart';
import '../models/search_item_model.dart';
import '../models/sellingitemsfields.dart';
import '../utils/prefUtils.dart';
import 'package:http/http.dart' as http;

class SearchItemProvider{
  var _searchitems;

  var _searchitemspricevar;
  List<PriceVariation1> _searchitemspricevar1 =[];

  Future<List<SearchtemModel>> fetchsearchItemProviderOld(String item_name) async{
    List<SearchtemModel> sellingitemlist = [];
    var url = Api.getSerachitemByCart;
    String user = (PrefUtils.prefs!.containsKey("apikey")!) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
   /* try {*/
      sellingitemlist.clear();
      // _sellingitems.clear();
      final response = await http
          .post(
          url,
          body: {
            "apiKey": PrefUtils.prefs!.containsKey('apiKey') ? PrefUtils.prefs!.getString('apiKey') : "",
            "item_name": item_name,
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      // List<SearchtemModel> result;
      final responseJson = json.decode(utf8.decode(response.bodyBytes));

      if(responseJson.toString() != "[]") {
        if(responseJson.toString() != "[]") {
          // Map<String, dynamic> resdata;
          responseJson['data'].forEach((resdata) {
            sellingitemlist.add(SearchtemModel.fromJson(resdata));
          });
          responseJson['data'].forEach((resdata) {
            _searchitemspricevar1.clear();
            resdata['priceVariation'].forEach((resdata) {
              _searchitemspricevar1.add(PriceVariation1.fromJson(resdata));
            });
          });
          // sbloc.serchItemspricevarsink.add(_searchitemspricevar1);
        }
    /*
        final dataJson = json.encode(responseJson['data']);
        final dataJsondecode = json.decode(dataJson);
        List data1 = [];


        dataJsondecode.asMap().forEach((index, value) =>
            data1.add(
                dataJsondecode[index] as Map<String, dynamic>)
        );


        for (int i = 0; i < data1.length; i++){
    *//*      _searchitems.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['itemName'].toString(),
            imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['itemFeaturedImage'].toString(),
            brand: data[i]['brand'].toString(),
          ));*//*


          final pricevarJson = json.encode(data1[i]['priceVariation']); //fetching sub categories data
          final pricevarJsondecode = json.decode(pricevarJson);
          List pricevardata = []; //list for subcategories

          if (pricevarJsondecode == null){

          } else {
            pricevarJsondecode.asMap().forEach((index, value) =>
                pricevardata.add(
                    pricevarJsondecode[index] as Map<String, dynamic>)
            );

            for (int j = 0; j < pricevardata.length; j++) {
              bool _discointDisplay = false;
              bool _membershipDisplay = false;

              if(double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())){
                _discointDisplay = false;
              } else {
                _discointDisplay = true;
              }

              if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _searchitemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: data1[i]['id'].toString(),
                varname: pricevardata[j]['variationName'].toString(),
                varmrp: (IConstants.numberFormat == "1") ? pricevardata[j]['mrp'].toStringAsFixed(0) : pricevardata[j]['mrp'].toStringAsFixed(2),
                varprice: (IConstants.numberFormat == "1") ? pricevardata[j]['price'].toStringAsFixed(0) : pricevardata[j]['price'].toStringAsFixed(2),
                varmemberprice: (IConstants.numberFormat == "1") ? pricevardata[j]['membership_price'].toStringAsFixed(0) : pricevardata[j]['membership_price'].toStringAsFixed(2),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['minItem'].toString(),
                varmaxitem: pricevardata[j]['maxItem'].toString(),
                varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                    pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
                varQty: int.parse(pricevardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
              ));
              sbloc.serchItemspricevarsink.add(_searchitemspricevar);
            }
          }}*/
      }else{
      }
      return sellingitemlist;
   /* } catch (error) {
      throw error;
    }*/
    return sellingitemlist;
  }
  Future<List<SearchtemModel>> fetchsearchItemProvider(String item_name) async{
    List<SearchtemModel> sellingitemlist = [];
    var url = Api.getSerachitemByCart;
    String user = (PrefUtils.prefs!.containsKey("apikey")!) ? PrefUtils.prefs!.getString("tokenid") !: PrefUtils.prefs!.getString('apikey')!;
    /* try {*/
    sellingitemlist.clear();
    // _sellingitems.clear();
    final response = await http
        .post(
        url,
        body: {
          "apiKey": PrefUtils.prefs!.containsKey('apiKey') ? PrefUtils.prefs!.getString('apiKey') : "",
          "item_name": item_name,
          "branch": PrefUtils.prefs!.getString('branch'),
          "user": user,
          "language_id": IConstants.languageId,
          // await keyword is used to wait to this operation is complete.
        }
    );
    // List<SearchtemModel> result;
    final responseJson = json.decode(utf8.decode(response.bodyBytes));

    if(responseJson.toString() != "[]") {
      if(responseJson.toString() != "[]") {
        // Map<String, dynamic> resdata;
        responseJson['data'].forEach((resdata) {
          sellingitemlist.add(SearchtemModel.fromJson(resdata));
        });
        responseJson['data'].forEach((resdata) {
          _searchitemspricevar1.clear();
          resdata['priceVariation'].forEach((resdata) {
            _searchitemspricevar1.add(PriceVariation1.fromJson(resdata));
          });
        });
        // sbloc.serchItemspricevarsink.add(_searchitemspricevar1);
      }
      /*
        final dataJson = json.encode(responseJson['data']);
        final dataJsondecode = json.decode(dataJson);
        List data1 = [];


        dataJsondecode.asMap().forEach((index, value) =>
            data1.add(
                dataJsondecode[index] as Map<String, dynamic>)
        );


        for (int i = 0; i < data1.length; i++){
    *//*      _searchitems.add(SellingItemsFields(
            id: data[i]['id'].toString(),
            title: data[i]['itemName'].toString(),
            imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['itemFeaturedImage'].toString(),
            brand: data[i]['brand'].toString(),
          ));*//*


          final pricevarJson = json.encode(data1[i]['priceVariation']); //fetching sub categories data
          final pricevarJsondecode = json.decode(pricevarJson);
          List pricevardata = []; //list for subcategories

          if (pricevarJsondecode == null){

          } else {
            pricevarJsondecode.asMap().forEach((index, value) =>
                pricevardata.add(
                    pricevarJsondecode[index] as Map<String, dynamic>)
            );

            for (int j = 0; j < pricevardata.length; j++) {
              bool _discointDisplay = false;
              bool _membershipDisplay = false;

              if(double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())){
                _discointDisplay = false;
              } else {
                _discointDisplay = true;
              }

              if(pricevardata[j]['membership_price'].toString() == '-' || pricevardata[j]['membership_price'].toString() == "0" || double.parse(pricevardata[j]['membership_price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())) {
                _membershipDisplay = false;
              } else {
                _membershipDisplay = true;
              }

              _searchitemspricevar.add(SellingItemsFields(
                varid: pricevardata[j]['id'].toString(),
                menuid: data1[i]['id'].toString(),
                varname: pricevardata[j]['variationName'].toString(),
                varmrp: (IConstants.numberFormat == "1") ? pricevardata[j]['mrp'].toStringAsFixed(0) : pricevardata[j]['mrp'].toStringAsFixed(2),
                varprice: (IConstants.numberFormat == "1") ? pricevardata[j]['price'].toStringAsFixed(0) : pricevardata[j]['price'].toStringAsFixed(2),
                varmemberprice: (IConstants.numberFormat == "1") ? pricevardata[j]['membership_price'].toStringAsFixed(0) : pricevardata[j]['membership_price'].toStringAsFixed(2),
                varstock: pricevardata[j]['stock'].toString(),
                varminitem: pricevardata[j]['minItem'].toString(),
                varmaxitem: pricevardata[j]['maxItem'].toString(),
                varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                    pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
                varQty: int.parse(pricevardata[j]['quantity'].toString()),
                discountDisplay: _discointDisplay,
                membershipDisplay: _membershipDisplay,
              ));
              sbloc.serchItemspricevarsink.add(_searchitemspricevar);
            }
          }}*/
    }else{
    }
    return sellingitemlist;
    /* } catch (error) {
      throw error;
    }*/
    return sellingitemlist;
  }

  Future<void> fetchsearchItems(String item_name) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = Api.getSerachitemByCart;
    String user = (PrefUtils.prefs!.containsKey("apikey")!) ? PrefUtils.prefs!.getString("tokenid")! : PrefUtils.prefs!.getString('apikey')!;
    try {

      final response = await http
          .post(
          url,
          body: {
            "apiKey": PrefUtils.prefs!.containsKey('apiKey') ? PrefUtils.prefs!.getString('apiKey') : "",
            "item_name": item_name,
            "branch": PrefUtils.prefs!.getString('branch'),
            "user": user,
            "language_id": IConstants.languageId,
            // await keyword is used to wait to this operation is complete.
          }
      );
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final dataJson = json.encode(responseJson['data']);
      final dataJsondecode = json.decode(dataJson);
      List data = [];


      dataJsondecode.asMap().forEach((index, value) =>
          data.add(
              dataJsondecode[index] as Map<String, dynamic>)
      );


      for (int i = 0; i < data.length; i++){
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
        _searchitems.add(SellingItemsFields(
          id: data[i]['id'].toString(),
          title: data[i]['itemName'].toString(),
          imageUrl: IConstants.API_IMAGE + "items/images/" + data[i]['itemFeaturedImage'].toString(),
          brand: data[i]['brand'].toString(),
          veg_type: data[i]["veg_type"].toString(),
          type: data[i]["type"].toString(),
          eligible_for_express: Features.isExpressDelivery ? Features.isSplit ? data[i]['eligible_for_express'].toString(): "0" : "1",
          duration: _duration,
          delivery:(data[i]['delivery'] ?? "").toString(),
          durationType: _durationType,
          note: _note,
          subscribe:data[i]['eligible_for_subscription'].toString(),
          paymentmode:data[i]['payment_mode'].toString(),
          cronTime: _cronTime,
          name: _status,
        ));


        final pricevarJson = json.encode(data[i]['priceVariation']); //fetching sub categories data
        final pricevarJsondecode = json.decode(pricevarJson);
        List pricevardata = []; //list for subcategories

        if (pricevarJsondecode == null){

        } else {
          pricevarJsondecode.asMap().forEach((index, value) =>
              pricevardata.add(
                  pricevarJsondecode[index] as Map<String, dynamic>)
          );

          for (int j = 0; j < pricevardata.length; j++) {
            bool _discointDisplay = false;
            bool _membershipDisplay = false;

            if(double.parse(pricevardata[j]['price'].toString()) <= 0 || pricevardata[j]['price'].toString() == "" || double.parse(pricevardata[j]['price'].toString()) == double.parse(pricevardata[j]['mrp'].toString())){
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

            _searchitemspricevar.add(SellingItemsFields(
              varid: pricevardata[j]['id'].toString(),
              menuid: data[i]['id'].toString(),
              varname: pricevardata[j]['variationName'].toString(),
              varmrp: (IConstants.numberFormat == "1") ? pricevardata[j]['mrp'].toStringAsFixed(0) : pricevardata[j]['mrp'].toStringAsFixed(2),
              varprice: (IConstants.numberFormat == "1") ? pricevardata[j]['price'].toStringAsFixed(0) : pricevardata[j]['price'].toStringAsFixed(2),
              varmemberprice: (IConstants.numberFormat == "1") ? pricevardata[j]['membership_price'].toStringAsFixed(0) : pricevardata[j]['membership_price'].toStringAsFixed(2),
              varstock: pricevardata[j]['stock'].toString(),
              varminitem: pricevardata[j]['minItem'].toString(),
              varmaxitem: pricevardata[j]['maxItem'].toString(),
              varLoyalty: pricevardata[j]['loyalty'].toString() == "" ||
                  pricevardata[j]['loyalty'].toString() == "null" ? 0 : int.parse(pricevardata[j]['loyalty'].toString()),
              varQty: int.parse(pricevardata[j]['quantity'].toString()),
              discountDisplay: _discointDisplay,
              membershipDisplay: _membershipDisplay,
              unit: (pricevardata[j]['unit'].toString() == "null")? "" : (pricevardata[j]['unit'] ?? "").toString(),
                weight: double.parse(pricevardata[j]['weight'].toString())
            ));
          }
        }
      }


    } catch (error) {
      throw error;
    }
  }

  List<SellingItemsFields> serchItems(){
    return _searchitems;
  }
  List<SellingItemsFields>  serchItemsPricevar(){
    return _searchitemspricevar;
  }
}
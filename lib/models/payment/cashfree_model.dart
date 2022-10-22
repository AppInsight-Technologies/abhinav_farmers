import 'package:flutter/cupertino.dart';

class CashFreeTocken {
  String? _status;
  String? _message;
  String? _cftoken;
  String? _subCode;
  CashFreeTocken({String? status, String? subCode, String? message, String? cftoken}) {
    this._status = status;
    this._message = message;
    this._cftoken = cftoken;
    this._subCode = subCode;
  }

  String get status => _status!;
  set status(String status) => _status = status;
  String get message => _message!;
  set message(String message) => _message = message;
  String get cftoken => _cftoken!;
  set cftoken(String cftoken) => _cftoken = cftoken;
  String get subCode => _subCode!;
  set subCode(String subCode) => _subCode = subCode;

  CashFreeTocken.fromJson(Map<String, dynamic> json) {
    debugPrint("CashFreeTocken....");
    _status = json['status'];
    _message = json['message'];
    _cftoken = json['cftoken'];
    _subCode = json['subCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    data['subCode'] = this._subCode;
    data['cftoken'] = this._cftoken;
    return data;
  }
}
class CashFreeWebTocken {
  int? cfOrderId;
  String? createdAt;
  CustomerDetails? customerDetails;
  String? entity;
  double? orderAmount;
  String? orderCurrency;
  String? orderExpiryTime;
  String? orderId;
  OrderMeta? orderMeta;
  String? orderNote;
  String? orderStatus;
  String? orderToken;
  String? paymentLink;
  Payments? payments;
  Payments? refunds;
  Payments? settlements;

  CashFreeWebTocken(
      {this.cfOrderId,
        this.createdAt,
        this.customerDetails,
        this.entity,
        this.orderAmount,
        this.orderCurrency,
        this.orderExpiryTime,
        this.orderId,
        this.orderMeta,
        this.orderNote,
        this.orderStatus,
        this.orderToken,
        this.paymentLink,
        this.payments,
        this.refunds,
        this.settlements});

  CashFreeWebTocken.fromJson(Map<String, dynamic> json) {
    cfOrderId = json['cf_order_id'];
    createdAt = json['created_at'];
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    entity = json['entity'];
    orderAmount = json['order_amount'];
    orderCurrency = json['order_currency'];
    orderExpiryTime = json['order_expiry_time'];
    orderId = json['order_id'];
    orderMeta = json['order_meta'] != null
        ? new OrderMeta.fromJson(json['order_meta'])
        : null;
    orderNote = json['order_note'];
    orderStatus = json['order_status'];
    orderToken = json['order_token'];
    paymentLink = json['payment_link'];
    payments = json['payments'] != null
        ? new Payments.fromJson(json['payments'])
        : null;
    refunds =
    json['refunds'] != null ? new Payments.fromJson(json['refunds']) : null;
    settlements = json['settlements'] != null
        ? new Payments.fromJson(json['settlements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cf_order_id'] = this.cfOrderId;
    data['created_at'] = this.createdAt;
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    data['entity'] = this.entity;
    data['order_amount'] = this.orderAmount;
    data['order_currency'] = this.orderCurrency;
    data['order_expiry_time'] = this.orderExpiryTime;
    data['order_id'] = this.orderId;
    if (this.orderMeta != null) {
      data['order_meta'] = this.orderMeta!.toJson();
    }
    data['order_note'] = this.orderNote;
    data['order_status'] = this.orderStatus;
    data['order_token'] = this.orderToken;
    data['payment_link'] = this.paymentLink;
    if (this.payments != null) {
      data['payments'] = this.payments!.toJson();
    }
    if (this.refunds != null) {
      data['refunds'] = this.refunds!.toJson();
    }
    if (this.settlements != null) {
      data['settlements'] = this.settlements!.toJson();
    }
    return data;
  }
}

class CustomerDetails {
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;

  CustomerDetails(
      {this.customerId,
        this.customerName,
        this.customerEmail,
        this.customerPhone});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    return data;
  }
}

class OrderMeta {
  String? returnUrl;
  String? notifyUrl;
  String? paymentMethods;

  OrderMeta({this.returnUrl, this.notifyUrl, this.paymentMethods});

  OrderMeta.fromJson(Map<String, dynamic> json) {
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    paymentMethods = json['payment_methods'];
    print("sdfghjk"+paymentMethods.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_url'] = this.returnUrl;
    data['notify_url'] = this.notifyUrl;
    data['payment_methods'] = this.paymentMethods;
    return data;
  }
}

class Payments {
  String? url;

  Payments({this.url});

  Payments.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
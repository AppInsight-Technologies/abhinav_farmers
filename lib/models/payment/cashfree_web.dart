class CashFreeWebModle {
  Order? order;
  Transaction? transaction;

  CashFreeWebModle({this.order, this.transaction});

  CashFreeWebModle.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Order {
  String? status;
  String? orderId;

  Order({this.status, this.orderId});

  Order.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    return data;
  }
}

class Transaction {
  int? merchantId;
  int? cfOrderId;
  String? orderId;
  String? orderHash;
  int? transactionId;
  int? paymentCode;
  String? paymentMode;
  double? transactionAmount;
  String? bankName;
  String? txStatus;
  String? txTime;
  String? txEndTime;
  bool? isFlagged;
  String? pg;
  bool? captured;
  int? credId;
  double? capturedAmount;
  String? currency;
  String? cardType;
  String? txMsg;
  String? txRef;
  String? txPGRef;
  String? authIdCode;
  String? maskedCardNumber;
  String? issuerRefNo;
  double? orderAmount;
  ExtData? extData;

  Transaction(
      {this.merchantId,
        this.cfOrderId,
        this.orderId,
        this.orderHash,
        this.transactionId,
        this.paymentCode,
        this.paymentMode,
        this.transactionAmount,
        this.bankName,
        this.txStatus,
        this.txTime,
        this.txEndTime,
        this.isFlagged,
        this.pg,
        this.captured,
        this.credId,
        this.capturedAmount,
        this.currency,
        this.cardType,
        this.txMsg,
        this.txRef,
        this.txPGRef,
        this.authIdCode,
        this.maskedCardNumber,
        this.issuerRefNo,
        this.orderAmount,
        this.extData});

  Transaction.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    cfOrderId = json['cfOrderId'];
    orderId = json['orderId'];
    orderHash = json['orderHash'];
    transactionId = json['transactionId'];
    paymentCode = json['paymentCode'];
    paymentMode = json['paymentMode'];
    transactionAmount = json['transactionAmount'];
    bankName = json['bankName'];
    txStatus = json['txStatus'];
    txTime = json['txTime'];
    txEndTime = json['txEndTime'];
    isFlagged = json['isFlagged'];
    pg = json['pg'];
    captured = json['captured'];
    credId = json['credId'];
    capturedAmount = json['capturedAmount'];
    currency = json['currency'];
    cardType = json['cardType'];
    txMsg = json['txMsg'];
    txRef = json['txRef'];
    txPGRef = json['txPGRef'];
    authIdCode = json['authIdCode'];
    maskedCardNumber = json['maskedCardNumber'];
    issuerRefNo = json['issuerRefNo'];
    orderAmount = json['orderAmount'];
    extData =
    json['extData'] != null ? new ExtData.fromJson(json['extData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['cfOrderId'] = this.cfOrderId;
    data['orderId'] = this.orderId;
    data['orderHash'] = this.orderHash;
    data['transactionId'] = this.transactionId;
    data['paymentCode'] = this.paymentCode;
    data['paymentMode'] = this.paymentMode;
    data['transactionAmount'] = this.transactionAmount;
    data['bankName'] = this.bankName;
    data['txStatus'] = this.txStatus;
    data['txTime'] = this.txTime;
    data['txEndTime'] = this.txEndTime;
    data['isFlagged'] = this.isFlagged;
    data['pg'] = this.pg;
    data['captured'] = this.captured;
    data['credId'] = this.credId;
    data['capturedAmount'] = this.capturedAmount;
    data['currency'] = this.currency;
    data['cardType'] = this.cardType;
    data['txMsg'] = this.txMsg;
    data['txRef'] = this.txRef;
    data['txPGRef'] = this.txPGRef;
    data['authIdCode'] = this.authIdCode;
    data['maskedCardNumber'] = this.maskedCardNumber;
    data['issuerRefNo'] = this.issuerRefNo;
    data['orderAmount'] = this.orderAmount;
    if (this.extData != null) {
      data['extData'] = this.extData!.toJson();
    }
    return data;
  }
}

class ExtData {
  Null? vendors;
  Null? merchantOrderData;

  ExtData({this.vendors, this.merchantOrderData});

  ExtData.fromJson(Map<String, dynamic> json) {
    vendors = json['vendors'];
    merchantOrderData = json['merchantOrderData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendors'] = this.vendors;
    data['merchantOrderData'] = this.merchantOrderData;
    return data;
  }
}

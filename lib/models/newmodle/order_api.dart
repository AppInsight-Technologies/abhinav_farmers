class Order {
  List<OrderItems>? items;

  Order({this.items});

  Order.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderItems>[];
      json['items'].forEach((v) {
        items!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? tips;
  String? id;
  String? orderD;
  String? itemId;
  String? itemName;
  String? priceVariavtion;
  String? price;
  String? quantity;
  String? actualAmount;
  String? extraAmount;
  String? discount;
  String? subTotal;
  String? isTray;
  String? loyalty;
  String? image;
  String? menuid;
  String? barcode;
  String? fixdate;
  String? itemPrice;
  int? itemQuantity;
  int? itemLeftCount;
  String? itemImage;
  String? orderStatus;
  String? fixtime;
  String? orderType;
  String? orderAmount;
  String? wallet;
  String? discountTotal;
  String? totalDiscount;
  String? deliveryCharge;
  String? otp;

  OrderItems(
      {this.tips,
        this.id,
        this.orderD,
        this.itemId,
        this.itemName,
        this.priceVariavtion,
        this.price,
        this.quantity,
        this.actualAmount,
        this.extraAmount,
        this.discount,
        this.subTotal,
        this.isTray,
        this.loyalty,
        this.image,
        this.menuid,
        this.barcode,
        this.fixdate,
        this.itemPrice,
        this.itemQuantity,
        this.itemLeftCount,
        this.itemImage,
        this.orderStatus,
        this.fixtime,
        this.orderType,
        this.orderAmount,
        this.wallet,
        this.discountTotal,
        this.totalDiscount,
        this.deliveryCharge,
        this.otp});

  OrderItems.fromJson(Map<String, dynamic> json) {
    tips = json['tips'];
    id = json['id'];
    orderD = json['order_d'];
    itemId = json['itemId'];
    itemName = json['itemName'];
    priceVariavtion = json['priceVariavtion'];
    price = json['price'];
    quantity = json['quantity'];
    actualAmount = json['actualAmount'];
    extraAmount = json['extraAmount'];
    discount = json['discount'];
    subTotal = json['subTotal'];
    isTray = json['isTray'];
    loyalty = json['loyalty'];
    image = json['image'];
    menuid = json['menuid'];
    barcode = json['barcode'];
    fixdate = json['fixdate'];
    itemPrice = json['itemPrice'];
    itemQuantity = json['itemQuantity'];
    itemLeftCount = json['itemLeftCount'];
    itemImage = json['itemImage'];
    orderStatus = json['orderStatus'];
    fixtime = json['fixtime'];
    orderType = json['orderType'];
    orderAmount = json['orderAmount'];
    wallet = json['wallet'];
    discountTotal = json['discountTotal'];
    totalDiscount = json['totalDiscount'];
    deliveryCharge = json['deliveryCharge'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tips'] = this.tips;
    data['id'] = this.id;
    data['order_d'] = this.orderD;
    data['itemId'] = this.itemId;
    data['itemName'] = this.itemName;
    data['priceVariavtion'] = this.priceVariavtion;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['actualAmount'] = this.actualAmount;
    data['extraAmount'] = this.extraAmount;
    data['discount'] = this.discount;
    data['subTotal'] = this.subTotal;
    data['isTray'] = this.isTray;
    data['loyalty'] = this.loyalty;
    data['image'] = this.image;
    data['menuid'] = this.menuid;
    data['barcode'] = this.barcode;
    data['fixdate'] = this.fixdate;
    data['itemPrice'] = this.itemPrice;
    data['itemQuantity'] = this.itemQuantity;
    data['itemLeftCount'] = this.itemLeftCount;
    data['itemImage'] = this.itemImage;
    data['orderStatus'] = this.orderStatus;
    data['fixtime'] = this.fixtime;
    data['orderType'] = this.orderType;
    data['orderAmount'] = this.orderAmount;
    data['wallet'] = this.wallet;
    data['discountTotal'] = this.discountTotal;
    data['totalDiscount'] = this.totalDiscount;
    data['deliveryCharge'] = this.deliveryCharge;
    data['otp'] = this.otp;
    return data;
  }
}

class PaytmTocken {
  Head? _head;
  Body? _body;

  PaytmTocken({Head? head, Body? body}) {
    this._head = head;
    this._body = body;
  }

  Head get head => _head!;
  set head(Head head) => _head = head;
  Body get body => _body!;
  set body(Body body) => _body = body;

  PaytmTocken.fromJson(Map<String, dynamic> json) {
    _head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    _body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._head != null) {
      data['head'] = this._head!.toJson();
    }
    if (this._body != null) {
      data['body'] = this._body!.toJson();
    }
    return data;
  }
}

class Head {
  String? _responseTimestamp;
  String? _version;
  String? _signature;

  Head({String? responseTimestamp, String? version, String? signature}) {
    this._responseTimestamp = responseTimestamp;
    this._version = version;
    this._signature = signature;
  }

  String get responseTimestamp => _responseTimestamp!;
  set responseTimestamp(String responseTimestamp) =>
      _responseTimestamp = responseTimestamp;
  String get version => _version!;
  set version(String version) => _version = version;
  String get signature => _signature!;
  set signature(String signature) => _signature = signature;

  Head.fromJson(Map<String, dynamic> json) {
    _responseTimestamp = json['responseTimestamp'];
    _version = json['version'];
    _signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseTimestamp'] = this._responseTimestamp;
    data['version'] = this._version;
    data['signature'] = this._signature;
    return data;
  }
}

class Body {
  ResultInfo? _resultInfo;
  String? _txnToken;
  bool? _isPromoCodeValid;
  bool? _authenticated;

  Body(
      {ResultInfo? resultInfo,
        String? txnToken,
        bool? isPromoCodeValid,
        bool? authenticated}) {
    this._resultInfo = resultInfo!;
    this._txnToken = txnToken!;
    this._isPromoCodeValid = isPromoCodeValid!;
    this._authenticated = authenticated!;
  }

  ResultInfo get resultInfo => _resultInfo!;
  set resultInfo(ResultInfo resultInfo) => _resultInfo = resultInfo;
  String get txnToken => _txnToken!;
  set txnToken(String txnToken) => _txnToken = txnToken;
  bool get isPromoCodeValid => _isPromoCodeValid!;
  set isPromoCodeValid(bool isPromoCodeValid) =>
      _isPromoCodeValid = isPromoCodeValid;
  bool get authenticated => _authenticated!;
  set authenticated(bool authenticated) => _authenticated = authenticated;

  Body.fromJson(Map<String, dynamic> json) {
    _resultInfo = (json['resultInfo'] != null
        ? new ResultInfo.fromJson(json['resultInfo'])
        : null)!;
    _txnToken = json['txnToken'];
    _isPromoCodeValid = json['isPromoCodeValid'];
    _authenticated = json['authenticated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._resultInfo != null) {
      data['resultInfo'] = this._resultInfo!.toJson();
    }
    data['txnToken'] = this._txnToken;
    data['isPromoCodeValid'] = this._isPromoCodeValid;
    data['authenticated'] = this._authenticated;
    return data;
  }
}

class ResultInfo {
  String? _resultStatus;
  String? _resultCode;
  String? _resultMsg;

  ResultInfo({String? resultStatus, String? resultCode, String? resultMsg}) {
    this._resultStatus = resultStatus;
    this._resultCode = resultCode;
    this._resultMsg = resultMsg;
  }

  String get resultStatus => _resultStatus!;
  set resultStatus(String resultStatus) => _resultStatus = resultStatus;
  String get resultCode => _resultCode!;
  set resultCode(String resultCode) => _resultCode = resultCode;
  String get resultMsg => _resultMsg!;
  set resultMsg(String resultMsg) => _resultMsg = resultMsg;

  ResultInfo.fromJson(Map<String, dynamic> json) {
    _resultStatus = json['resultStatus'];
    _resultCode = json['resultCode'];
    _resultMsg = json['resultMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultStatus'] = this._resultStatus;
    data['resultCode'] = this._resultCode;
    data['resultMsg'] = this._resultMsg;
    return data;
  }
}
/*
class PaytmTocken {
  Head _head;
  Body _body;

  PaytmTocken({Head head, Body body}) {
    this._head = head;
    this._body = body;
  }

  Head get head => _head;
  set head(Head head) => _head = head;
  Body get body => _body;
  set body(Body body) => _body = body;

  PaytmTocken.fromJson(Map<String, dynamic> json) {
    _head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    _body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._head != null) {
      data['head'] = this._head.toJson();
    }
    if (this._body != null) {
      data['body'] = this._body.toJson();
    }
    return data;
  }
}

class Head {
  String _responseTimestamp;
  String _version;
  String _signature;

  Head({String responseTimestamp, String version, String signature}) {
    this._responseTimestamp = responseTimestamp;
    this._version = version;
    this._signature = signature;
  }

  String get responseTimestamp => _responseTimestamp;
  set responseTimestamp(String responseTimestamp) =>
      _responseTimestamp = responseTimestamp;
  String get version => _version;
  set version(String version) => _version = version;
  String get signature => _signature;
  set signature(String signature) => _signature = signature;

  Head.fromJson(Map<String, dynamic> json) {
    _responseTimestamp = json['responseTimestamp'];
    _version = json['version'];
    _signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseTimestamp'] = this._responseTimestamp;
    data['version'] = this._version;
    data['signature'] = this._signature;
    return data;
  }
}

class Body {
  ResultInfo _resultInfo;
  String _txnToken;
  bool _isPromoCodeValid;
  bool _authenticated;

  Body(
      {ResultInfo resultInfo,
        String txnToken,
        bool isPromoCodeValid,
        bool authenticated}) {
    this._resultInfo = resultInfo;
    this._txnToken = txnToken;
    this._isPromoCodeValid = isPromoCodeValid;
    this._authenticated = authenticated;
  }

  ResultInfo get resultInfo => _resultInfo;
  set resultInfo(ResultInfo resultInfo) => _resultInfo = resultInfo;
  String get txnToken => _txnToken;
  set txnToken(String txnToken) => _txnToken = txnToken;
  bool get isPromoCodeValid => _isPromoCodeValid;
  set isPromoCodeValid(bool isPromoCodeValid) =>
      _isPromoCodeValid = isPromoCodeValid;
  bool get authenticated => _authenticated;
  set authenticated(bool authenticated) => _authenticated = authenticated;

  Body.fromJson(Map<String, dynamic> json) {
    _resultInfo = json['resultInfo'] != null
        ? new ResultInfo.fromJson(json['resultInfo'])
        : null;
    _txnToken = json['txnToken'];
    _isPromoCodeValid = json['isPromoCodeValid'];
    _authenticated = json['authenticated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._resultInfo != null) {
      data['resultInfo'] = this._resultInfo.toJson();
    }
    data['txnToken'] = this._txnToken;
    data['isPromoCodeValid'] = this._isPromoCodeValid;
    data['authenticated'] = this._authenticated;
    return data;
  }
}

class ResultInfo {
  String _resultStatus;
  String _resultCode;
  String _resultMsg;

  ResultInfo({String resultStatus, String resultCode, String resultMsg}) {
    this._resultStatus = resultStatus;
    this._resultCode = resultCode;
    this._resultMsg = resultMsg;
  }

  String get resultStatus => _resultStatus;
  set resultStatus(String resultStatus) => _resultStatus = resultStatus;
  String get resultCode => _resultCode;
  set resultCode(String resultCode) => _resultCode = resultCode;
  String get resultMsg => _resultMsg;
  set resultMsg(String resultMsg) => _resultMsg = resultMsg;

  ResultInfo.fromJson(Map<String, dynamic> json) {
    _resultStatus = json['resultStatus'];
    _resultCode = json['resultCode'];
    _resultMsg = json['resultMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultStatus'] = this._resultStatus;
    data['resultCode'] = this._resultCode;
    data['resultMsg'] = this._resultMsg;
    return data;
  }
}
*/


class Paytm {
  String? bANKNAME;
  String? bANKTXNID;
  String? cHECKSUMHASH;
  String? cURRENCY;
  String? gATEWAYNAME;
  String? mID;
  String? oRDERID;
  String? pAYMENTMODE;
  String? rESPCODE;
  String? rESPMSG;
  String? sTATUS;
  String? tXNAMOUNT;
  String? tXNDATE;
  String? tXNID;

  Paytm(
      {this.bANKNAME,
        this.bANKTXNID,
        this.cHECKSUMHASH,
        this.cURRENCY,
        this.gATEWAYNAME,
        this.mID,
        this.oRDERID,
        this.pAYMENTMODE,
        this.rESPCODE,
        this.rESPMSG,
        this.sTATUS,
        this.tXNAMOUNT,
        this.tXNDATE,
        this.tXNID});

  Paytm.fromJson(Map<String, dynamic> json) {
    bANKNAME = json['BANKNAME'];
    bANKTXNID = json['BANKTXNID'];
    cHECKSUMHASH = json['CHECKSUMHASH'];
    cURRENCY = json['CURRENCY'];
    gATEWAYNAME = json['GATEWAYNAME'];
    mID = json['MID'];
    oRDERID = json['ORDERID'];
    pAYMENTMODE = json['PAYMENTMODE'];
    rESPCODE = json['RESPCODE'];
    rESPMSG = json['RESPMSG'];
    sTATUS = json['STATUS'];
    tXNAMOUNT = json['TXNAMOUNT'];
    tXNDATE = json['TXNDATE'];
    tXNID = json['TXNID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BANKNAME'] = this.bANKNAME;
    data['BANKTXNID'] = this.bANKTXNID;
    data['CHECKSUMHASH'] = this.cHECKSUMHASH;
    data['CURRENCY'] = this.cURRENCY;
    data['GATEWAYNAME'] = this.gATEWAYNAME;
    data['MID'] = this.mID;
    data['ORDERID'] = this.oRDERID;
    data['PAYMENTMODE'] = this.pAYMENTMODE;
    data['RESPCODE'] = this.rESPCODE;
    data['RESPMSG'] = this.rESPMSG;
    data['STATUS'] = this.sTATUS;
    data['TXNAMOUNT'] = this.tXNAMOUNT;
    data['TXNDATE'] = this.tXNDATE;
    data['TXNID'] = this.tXNID;
    return data;
  }
}
import '../generated/l10n.dart';
class Weeks{
  String? _weekcode;
  String? _weekname;
  bool? _isselected;
  Weeks([this._weekcode,this._weekname, this._isselected]);

  bool get isselected => _isselected!;

  set isselected(bool value) {
    _isselected = value;
  }

  String get weekcode => _weekcode!;

  set weekcode(String value) {
    _weekcode = value;
  }

  String get weekname => _weekcode!;

  set weekname(String value) {
    _weekcode = value;
  }
 List<Weeks> getweeks(){

    return  [
      Weeks(S .current.Mon,S .current.Monday, true),
      Weeks(S .current.Tue,S .current.Tuesday,true),
      Weeks(S .current.Wed,S .current.Wednesday, true),
      Weeks(S .current.Thu,S .current.Thursday, true),
      Weeks(S .current.Fri,S .current.Friday, true),
      Weeks(S .current.Sat,S .current.Saturday,true),
      Weeks(S .current.Sun,S .current.Sunday, true),
    ];
  }
}

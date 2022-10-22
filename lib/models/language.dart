import '../utils/prefUtils.dart';

class Language {
  String? id;
  String? localName;
  String? branch;
  String? status;
  String? code;
  bool? selected;

  Language({this.id, this.localName, this.branch, this.status, this.code,this.selected = false});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    localName = json['name'];
    branch = json['branch'];
    status = json['status'];
    code = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.localName;
    data['branch'] = this.branch;
    data['status'] = this.status;
    data['languageCode'] = this.code;
    return data;
  }
}

class LanguagesList {
  Language language =  new Language(code: "en", localName: "English", status: "0", id: "", branch: PrefUtils.prefs!.getString("branch"));
  List<Language>? _languages=[];

  LanguagesList({List<Language>? languages}) {
    this._languages = languages;
  }

  List<Language> get languages => _languages!;
  set languages(List<Language> languages) => _languages = languages;

  LanguagesList.fromJson(Map<String, dynamic> json) {
    if (json['languages'] != null) {
      _languages = <Language>[];
      json['languages'].forEach((v) {
        _languages!.add(new Language.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._languages != null) {
      data['languages'] = this._languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

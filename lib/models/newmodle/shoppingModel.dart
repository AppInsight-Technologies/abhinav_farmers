class ShoppingListData{
  String? id;
  String? customerId;
  String? branch;
  String? name;
  int? count;
  bool? listcheckbox;

  ShoppingListData({this.id, this.customerId, this.branch, this.name, this.count,this.listcheckbox});

  ShoppingListData.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  customerId = json['customer_id'];
  branch = json['branch'];
  name = json['name'];
  count = json['count'];
  listcheckbox = false;
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['customer_id'] = this.customerId;
  data['branch'] = this.branch;
  data['name'] = this.name;
  data['count'] = this.count;
  return data;
  }
}
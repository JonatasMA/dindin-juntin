class Bills {
  String? value;
  String? title;
  int? billType;

  Bills(this.value, this.title, this.billType);

  Bills.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    title = json['title'];
    billType = json['billType'];
  }

  Bills.fromFirebase(bill) {
    value = bill.child('value').value;
    title = bill.child('title').value;
    billType = bill.child('billType').value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = value;
    data['title'] = title;
    data['billType'] = billType;
    return data;
  }
}

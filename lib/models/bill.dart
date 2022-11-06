class Bills {
  String? value;
  String? title;
  int? billType;
  DateTime? date;

  Bills(this.value, this.title, this.billType, this.date);

  Bills.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    title = json['title'];
    billType = json['billType'];
    date = json['date'];
  }

  Bills.fromFirebase(bill) {
    value = bill.child('value').value;
    title = bill.child('title').value;
    billType = bill.child('billType').value;
    String dateAux = bill.child('date').value;
    date = DateTime.tryParse(dateAux);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['title'] = title;
    data['billType'] = billType;
    data['date'] = date.toString();
    return data;
  }
}

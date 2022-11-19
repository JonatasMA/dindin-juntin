class Bills {
  num? value;
  String? title;
  String? biller;
  String? billerPhoto;
  int? billType;
  DateTime? date;
  bool? paid;

  Bills(this.value, this.title, this.billType, this.date, this.biller, this.billerPhoto);

  Bills.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    title = json['title'];
    billType = json['billType'];
    biller = json['biller'];
    billerPhoto = json['billerPhoto'];
    date = DateTime.tryParse(json['date']);
  }

  Bills.fromFirebase(bill) {
    value = bill.child('value').value;
    title = bill.child('title').value;
    billType = bill.child('billType').value;
    biller = bill.child('biller').value;
    billerPhoto = bill.child('billerPhoto').value;
    String dateAux = bill.child('date').value;
    date = DateTime.tryParse(dateAux);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['title'] = title;
    data['billType'] = billType;
    data['biller'] = biller;
    data['billerPhoto'] = billerPhoto;
    data['date'] = date.toString();
    return data;
  }

  String getFormattedDate() {
    return '${date?.day}/${date?.month}/${date?.year}';
  }
}

class SavedUser {
  String? email;
  // String? name;
  String? local;

  SavedUser({this.email, this.local});

  SavedUser.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    // name = json['name'];
    local = json['local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    // data['name'] = name;
    data['local'] = local;
    return data;
  }
}

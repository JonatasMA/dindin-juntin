class SavedUser {
  String? email;
  String? uid;
  String? local;

  SavedUser({this.email, this.local});

  SavedUser.fromFirebase(user) {
    email = user.child('email').value;
    uid = user.child('uid').value;
    local = user.child('local').value;
  }

  SavedUser.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uid = json['uid'];
    local = json['local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['uid'] = uid;
    data['local'] = local;
    return data;
  }
}

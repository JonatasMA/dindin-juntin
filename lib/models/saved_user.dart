class SavedUser {
  String? email;
  String? name;
  String? uid;
  String? local;
  String? photoURL;

  SavedUser({this.name, this.email, this.uid, this.local, this.photoURL});

  SavedUser.fromFirebase(user) {
    name = user.child('name').value;
    email = user.child('email').value;
    uid = user.child('uid').value;
    local = user.child('local').value;
    photoURL = user.child('photoURL').value;
  }

  SavedUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    uid = json['uid'];
    local = json['local'];
    photoURL = json['photoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['email'] = email;
    data['uid'] = uid;
    data['local'] = local;
    data['photoURL'] = photoURL;
    return data;
  }
}

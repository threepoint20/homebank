import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String parent;
  String avatarSvg;
  String name;
  String email;
  String profileImageUrl;
  String loggedInVia;
  String birthday;
  int point;

  UserModel({
    this.uid = "",
    this.parent = "",
    this.avatarSvg = "",
    this.email = "",
    this.name = "",
    this.profileImageUrl = "",
    this.loggedInVia = "",
    this.birthday = "",
    this.point = 0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return UserModel.fromMap(data);
  }

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'] ?? "",
      parent: data['parent'] ?? "",
      avatarSvg: data['avatarSvg'] ?? "",
      email: data['email'] ?? "",
      name: data['name'] ?? "",
      profileImageUrl: data['profileImageUrl'] ?? "",
      loggedInVia: data['loggedInVia'] ?? "",
      birthday: data['birthday'] ?? "",
      point: data['point'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "parent": parent,
      "avatarSvg": avatarSvg,
      "email": email,
      "name": name,
      "profileImageUrl": profileImageUrl,
      "loggedInVia": loggedInVia,
      "birthday": birthday,
      'point': point,
    };
  }

  bool isParent() {
    return parent.isEmpty;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String? parent; // 父帳號可為空，因此改為可空類型
  String avatarSvg;
  String name;
  String email;
  String? profileImageUrl; // 個人檔案圖片網址可為空
  String? loggedInVia; // 登入方式可為空
  String? birthday; // 生日可為空
  int point;

  UserModel({
    this.uid = "",
    this.parent, // 移除初始值，因為它已經是可空類型
    this.avatarSvg = "",
    this.email = "",
    this.name = "",
    this.profileImageUrl, // 移除初始值
    this.loggedInVia, // 移除初始值
    this.birthday, // 移除初始值
    this.point = 0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    // 修正: 將 doc.data() 轉型為 Map<String, dynamic> 並處理潛在的空值
    final data = doc.data() as Map<String, dynamic>?;
    return UserModel.fromMap(data!);
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? "",
      parent: data['parent'], // 直接取值，可空
      avatarSvg: data['avatarSvg'] ?? "",
      email: data['email'] ?? "",
      name: data['name'] ?? "",
      profileImageUrl: data['profileImageUrl'], // 直接取值，可空
      loggedInVia: data['loggedInVia'], // 直接取值，可空
      birthday: data['birthday'], // 直接取值，可空
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
    return parent == null || parent!.isEmpty;
  }
}

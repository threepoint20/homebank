// 修正後的 lib/providers/auth.dart
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homebank/models/job.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/models/user.dart';
//import 'package:homebank/common_functions.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UserModel _user = UserModel();

  final List<UserModel> _children = [];
  final Map<String, List<JobModel>> _jobs = {};
  final Map<String, List<PointModel>> _points = {};

  UserModel get user {
    return _user;
  }

  // 修正: 新增 user setter
  set user(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  List<UserModel> get children {
    return _children;
  }

  Map<String, dynamic> get jobs {
    return _jobs;
  }

  Map<String, dynamic> get points {
    return _points;
  }

  Future<void> autologin(String email, String password) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> loginUser(String email, String password) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> refreshUserProfile(String email) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<UserModel?> getUserProfile(String email) async {
    // 修正: 註解掉 Firebase 相關邏輯
    return null;
  }

  Future<void> modifyAccount({
    required String email,
    required String userName,
    required String birthday,
    required String svgCode,
  }) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> listenToChildren(String parentId) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> listenChildrenPoints(String parentId) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> listenChildrenJobs(String parentId) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> listenToPoints(String email) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> listenToJobs(String email) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> logout() async {
    // 修正: 註解掉 Firebase 相關邏輯
    _user = UserModel();
    notifyListeners();
  }

  Future<void> signUpWithEmail({
    required String userName,
    required String email,
    required String password,
  }) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<void> createAccount({
    required String userName,
    required String email,
    required String password,
    String? parent,
    String? birthday,
    String svgCode = "",
  }) async {
    // 修正: 註解掉 Firebase 相關邏輯
  }

  Future<bool> resetEmail(String email) async {
    // 修正: 註解掉 Firebase 相關邏輯
    return true;
  }
}

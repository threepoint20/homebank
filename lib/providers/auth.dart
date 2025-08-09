import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:homebank/models/job.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/models/user.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:homebank/common_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UserModel _user = UserModel();

  final List<UserModel> _children = [];
  final Map<String, List<JobModel>> _jobs = {};
  final Map<String, List<PointModel>> _points = {};

  UserModel get user {
    return _user;
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
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        _user = await getUserProfile(email) as UserModel;
      }
      notifyListeners();
    } catch (error) {
      print("[DEBUG] error: $error");
      rethrow;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      print("[DEBUG] loginUser: $email $password");
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("[DEBUG] authResult: $authResult");
      if (authResult.user != null) {
        await pref.setString("email", email);
        await pref.setString("password", password);
        _user = await getUserProfile(email) as UserModel;
        print("[DEBUG] _user = $_user");
      }
      notifyListeners();
    } catch (error) {
      print("[DEBUG] error: $error");
      rethrow;
    }
  }

  Future<void> refreshUserProfile(String email) async {
    print("getUserProfile!");
    try {
      DocumentSnapshot doc = await db.collection(USER_DB).doc(email).get();
      if (doc.exists) {
        UserModel currentUser = UserModel.fromFirestore(doc);
        _user = currentUser;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUserProfile(String email) async {
    print("getUserProfile!");
    try {
      DocumentSnapshot doc = await db.collection(USER_DB).doc(email).get();
      if (doc.exists) {
        UserModel currentUser = UserModel.fromFirestore(doc);
        return currentUser;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> modifyAccount({
    required String email,
    required String userName,
    required String birthday,
    required String svgCode,
  }) async {
    print("getUserProfile!");
    try {
      await db.collection(USER_DB).doc(email).update({
        "name": userName,
        "birthday": birthday,
        "avatarSvg": svgCode,
      });
      _user.name = userName;
      _user.avatarSvg = svgCode;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveToFirebase({required UserModel userModel}) async {
    try {
      DocumentReference ref = db.collection(USER_DB).doc(userModel.email);
      var data = userModel.toJson();
      print("save $data");
      await ref.set(data, SetOptions(merge: true));
      if (userModel.parent?.isNotEmpty ?? false) {
        await db.collection(POINT_DB).doc(userModel.email).set({
          "parent": userModel.parent,
        }, SetOptions(merge: true));
        await db.collection(JOB_DB).doc(userModel.email).set({
          "parent": userModel.parent,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('failed to save user details:: $e');
    }
  }

  Future<void> listenToChildren(String parentId) async {
    print("listenToChildren for $parentId");
    db
        .collection(USER_DB)
        .where("parent", isEqualTo: parentId)
        .snapshots()
        .listen((snapshot) {
          _children.clear();
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            _children.add(UserModel.fromFirestore(doc));
          }
          notifyListeners();
        });
  }

  Future<void> listenChildrenPoints(String parentId) async {
    print("listenChildrenPoints for $parentId");
    db
        .collection(POINT_DB)
        .where("parent", isEqualTo: parentId)
        .snapshots()
        .listen((snapshot) {
          _points.clear();
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            if (doc.exists) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) {
                for (String key in data.keys) {
                  if (key != "parent") {
                    for (var item in data[key]) {
                      PointModel _detail = PointModel.fromMap(item);
                      if (_points.containsKey(doc.id)) {
                        _points[doc.id]!.add(_detail);
                      } else {
                        _points.putIfAbsent(doc.id, () => [_detail]);
                      }
                    }
                  }
                }
              }
            }
          }
          notifyListeners();
        });
  }

  Future<void> listenChildrenJobs(String parentId) async {
    print("listenChildrenJobs for $parentId");
    db
        .collection(JOB_DB)
        .where("parent", isEqualTo: parentId)
        .snapshots()
        .listen((snapshot) {
          _jobs.clear();
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            if (doc.exists) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) {
                for (String key in data.keys) {
                  if (key != "parent") {
                    print("jobs: $data");
                    for (var item in data[key]) {
                      JobModel _detail = JobModel.fromMap(item);
                      if (_jobs.containsKey(doc.id)) {
                        _jobs[doc.id]!.add(_detail);
                      } else {
                        _jobs.putIfAbsent(doc.id, () => [_detail]);
                      }
                    }
                  }
                }
              }
            }
          }
          notifyListeners();
        });
  }

  Future<void> listenToPoints(String email) async {
    print("listenToPoints for $email");
    db.collection(POINT_DB).doc(email).snapshots().listen((doc) {
      _points.clear();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          for (String key in data.keys) {
            if (key != "parent") {
              for (var item in data[key]) {
                PointModel _detail = PointModel.fromMap(item);
                if (_points.containsKey(doc.id)) {
                  _points[doc.id]!.add(_detail);
                } else {
                  _points.putIfAbsent(doc.id, () => [_detail]);
                }
              }
            }
          }
        }
      }
      notifyListeners();
    });
  }

  Future<void> listenToJobs(String email) async {
    print("listenToJobs for $email");
    db.collection(JOB_DB).doc(email).snapshots().listen((doc) {
      _jobs.clear();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          for (String key in data.keys) {
            if (key != "parent") {
              print("jobs: $data");
              for (var item in data[key]) {
                JobModel _detail = JobModel.fromMap(item);
                if (_jobs.containsKey(doc.id)) {
                  _jobs[doc.id]!.add(_detail);
                } else {
                  _jobs.putIfAbsent(doc.id, () => [_detail]);
                }
              }
            }
          }
        }
      }
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = UserModel();
    notifyListeners();
  }

  Future<void> signUpWithEmail({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      print("signUpWithEmail");
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(authResult);
      if (authResult.user != null) {
        String svgCode = randomAvatarString(
          DateTime.now().millisecondsSinceEpoch.toRadixString(16),
        );
        _user = UserModel.fromMap({
          "uid": authResult.user!.uid,
          "email": email,
          "name": userName,
          "loggedInVia": "Email",
          "avatarSvg": svgCode,
        });
        await _saveToFirebase(userModel: _user);
        notifyListeners();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> createAccount({
    required String userName,
    required String email,
    required String password,
    String? parent,
    String? birthday,
    String svgCode = "",
  }) async {
    try {
      print("signUpWithEmail");
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(authResult);
      if (authResult.user != null) {
        if (svgCode.isEmpty) {
          svgCode = randomAvatarString(
            DateTime.now().millisecondsSinceEpoch.toRadixString(16),
          );
        }
        UserModel new_user = UserModel.fromMap({
          "uid": authResult.user!.uid,
          "email": email,
          "name": userName,
          "birthday": birthday,
          "loggedInVia": "Email",
          "parent": parent,
          "avatarSvg": svgCode,
        });
        await _saveToFirebase(userModel: new_user);
        notifyListeners();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> resetEmail(String email) async {
    try {
      print("[DEBUG] resetEmail: $email");
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("[DEBUG] resetEmail sent fail!");
      print(e);
      return false;
    }
    print("[DEBUG] resetEmail sent success!");
    return true;
  }
}

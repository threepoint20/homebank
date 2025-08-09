import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/common_functions.dart';

class PointProvider with ChangeNotifier {
  Future<void> changePoint(
      {String email, String type, String note, int point}) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(USER_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        int total = snapshot.data()['point'] + point;
        transaction.update(ref, {
          "point": total,
        });
        await addRecord(
            email: email, type: type, note: note, point: point, total: total);
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addRecord(
      {String email, String type, String note, int point, int total}) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(POINT_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        DateTime today = DateTime.now();
        String year_month =
            "${today.year}-${today.month.toString().padLeft(2, "0")}";
        String datetime = today.toString().split(".").first;
        List<dynamic> data = snapshot.data()[year_month] ?? [];
        PointModel model = PointModel(
            type: type, note: note, date: datetime, point: point, total: total);
        data.add(model.toJson());
        transaction.update(ref, {year_month: data});
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, List<PointModel>>> getPointRecord({String email}) async {
    try {
      print("getPointRecord");
      DocumentReference ref = db.collection(POINT_DB).doc(email);
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        Map<String, List<PointModel>> list = {};
        Map<String, dynamic> data = doc.data();
        for (var key in data.keys.toList().reversed) {
          if (key != 'parent') {
            List<dynamic> details = data[key];
            List<PointModel> tmp = [];
            for (var detail in details) {
              tmp.add(PointModel.fromMap(detail));
            }
            list.putIfAbsent(key, () => tmp);
          }
        }
        return list;
      } else {
        return {};
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

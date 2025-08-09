import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/job.dart';

class JobProvider with ChangeNotifier {
  Future<void> createJob(
      {String email,
      String type,
      String note,
      DateTime date,
      int point}) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(JOB_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        String year_month = getYearMonth(date);
        String datetime = getDateTimeString(date);
        List<dynamic> data = [];
        if (snapshot.exists) {
          data = snapshot.data()[year_month] ?? [];
        }
        JobModel detail =
            JobModel(type: type, note: note, date: datetime, point: point);
        data.add(detail.toJson());
        transaction.update(ref, {year_month: data});
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> finishJob(
      {String email, String type, String note, String date, int point}) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(JOB_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        DateTime date_time = DateTime.parse(date);
        String year_month = getYearMonth(date_time);
        String datetime = getDateTimeString(date_time);
        List<dynamic> data = [];
        if (snapshot.exists) {
          data = snapshot.data()[year_month] ?? [];
        }
        JobModel detail =
            JobModel(type: type, note: note, date: datetime, point: point);
        for (int index = 0; index < data.length; index++) {
          if (data[index]['type'] == detail.type &&
              data[index]['note'] == detail.note &&
              data[index]['point'] == detail.point &&
              data[index]['date'] == detail.date &&
              data[index]['finish'] == false) {
            data[index]['finish'] = true;
            transaction.update(ref, {year_month: data});
            break;
          }
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteJob(
      {String email, String type, String note, String date, int point}) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(JOB_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        DateTime date_time = DateTime.parse(date);
        String year_month = getYearMonth(date_time);
        String datetime = getDateTimeString(date_time);
        List<dynamic> data = [];
        if (snapshot.exists) {
          data = snapshot.data()[year_month] ?? [];
        }
        JobModel detail =
            JobModel(type: type, note: note, date: datetime, point: point);
        int delete_index = -1;
        for (int index = 0; index < data.length; index++) {
          if (data[index]['type'] == detail.type &&
              data[index]['note'] == detail.note &&
              data[index]['point'] == detail.point &&
              data[index]['date'] == detail.date &&
              data[index]['finish'] == false) {
            delete_index = index;
            break;
          }
        }
        if (delete_index != -1) {
          data.removeAt(delete_index);
          transaction.update(ref, {year_month: data});
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, List<JobModel>>> getJobRecord({String email}) async {
    try {
      DocumentReference ref = db.collection(JOB_DB).doc(email);
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        Map<String, List<JobModel>> list = {};
        Map<String, dynamic> data = doc.data();
        for (var key in data.keys.toList().reversed) {
          if (key != 'parent') {
            List<dynamic> details = data[key];
            List<JobModel> tmp = [];
            for (var detail in details) {
              tmp.add(JobModel.fromMap(detail));
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

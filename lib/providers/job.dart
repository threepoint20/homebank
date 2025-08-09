import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/job.dart';

class JobProvider with ChangeNotifier {
  Future<void> createJob({
    required String email,
    required String type,
    required String note,
    required DateTime date,
    required int point,
  }) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(JOB_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        String year_month = getYearMonth(date);
        String datetime = getDateTimeString(date);
        List<dynamic> data = [];
        if (snapshot.exists) {
          final docData = snapshot.data() as Map<String, dynamic>?;
          if (docData != null && docData.containsKey(year_month)) {
            data = docData[year_month] ?? [];
          }
        }
        JobModel detail = JobModel(
          type: type,
          note: note,
          date: datetime,
          point: point,
          finish: false,
        );
        data.add(detail.toJson());
        transaction.update(ref, {year_month: data});
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> finishJob({
    required String email,
    required String type,
    required String note,
    required String date,
    required int point,
  }) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(JOB_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        DateTime date_time = DateTime.parse(date);
        String year_month = getYearMonth(date_time);
        String datetime = getDateTimeString(date_time);
        List<dynamic> data = [];
        if (snapshot.exists) {
          final docData = snapshot.data() as Map<String, dynamic>?;
          if (docData != null && docData.containsKey(year_month)) {
            data = docData[year_month] ?? [];
          }
        }
        JobModel detail = JobModel(
          type: type,
          note: note,
          date: datetime,
          point: point,
          finish: false,
        );
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

  Future<void> deleteJob({
    required String email,
    required String type,
    required String note,
    required String date,
    required int point,
  }) async {
    try {
      await db.runTransaction((transaction) async {
        DocumentReference ref = db.collection(JOB_DB).doc(email);
        DocumentSnapshot snapshot = await transaction.get(ref);
        DateTime date_time = DateTime.parse(date);
        String year_month = getYearMonth(date_time);
        String datetime = getDateTimeString(date_time);
        List<dynamic> data = [];
        if (snapshot.exists) {
          final docData = snapshot.data() as Map<String, dynamic>?;
          if (docData != null && docData.containsKey(year_month)) {
            data = docData[year_month] ?? [];
          }
        }
        JobModel detail = JobModel(
          type: type,
          note: note,
          date: datetime,
          point: point,
          finish: false,
        );
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

  Future<Map<String, List<JobModel>>> getJobRecord({
    required String email,
  }) async {
    try {
      DocumentReference ref = db.collection(JOB_DB).doc(email);
      DocumentSnapshot doc = await ref.get();
      if (doc.exists) {
        Map<String, List<JobModel>> list = {};
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          for (var key in data.keys.toList().reversed) {
            if (key != 'parent') {
              List<dynamic> details = data[key] as List<dynamic>;
              List<JobModel> tmp = [];
              for (var detail in details) {
                tmp.add(JobModel.fromMap(detail));
              }
              list.putIfAbsent(key, () => tmp);
            }
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

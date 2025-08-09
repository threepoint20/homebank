import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  String type;
  String note;
  String date;
  int point;
  bool finish;

  JobModel({
    this.type = "",
    this.note = "",
    this.date = "",
    this.point = 0,
    this.finish = false,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return JobModel.fromMap(data);
  }

  factory JobModel.fromMap(Map data) {
    return JobModel(
      type: data['type'] ?? "",
      note: data['note'] ?? "",
      date: data['date'] ?? "",
      point: data['point'] ?? 0,
      finish: data['finish'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "note": note,
      "date": date,
      "point": point,
      "finish": finish,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class PointModel {
  String type;
  String note;
  String date;
  int point;
  int total;

  PointModel({
    this.type = "",
    this.note = "",
    this.date = "",
    this.point = 0,
    this.total = 0,
  });

  factory PointModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return PointModel.fromMap(data);
  }

  factory PointModel.fromMap(Map data) {
    return PointModel(
      type: data['type'] ?? "",
      note: data['note'] ?? "",
      date: data['date'] ?? "",
      point: data['point'] ?? 0,
      total: data['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "note": note,
      "date": date,
      "point": point,
      "total": total,
    };
  }
}

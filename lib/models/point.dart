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
    // 修正: 將 doc.data() 轉型為 Map<String, dynamic> 並處理潛在的空值
    final data = doc.data() as Map<String, dynamic>?;
    // 如果 data 是 null，則傳遞一個空的 Map 給 fromMap
    return PointModel.fromMap(data ?? {});
  }

  // 修正: 將 Map 參數明確指定為 Map<String, dynamic>
  factory PointModel.fromMap(Map<String, dynamic> data) {
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

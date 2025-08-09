import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String type;
  final String note;
  final String date;
  final int point;
  bool finish;

  JobModel({
    required this.type,
    required this.note,
    required this.date,
    required this.point,
    required this.finish,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return JobModel.fromMap(data ?? {});
  }

  factory JobModel.fromMap(Map<String, dynamic> data) {
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

  JobModel copyWith({
    String? type,
    String? note,
    String? date,
    int? point,
    bool? finish,
  }) {
    return JobModel(
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
      point: point ?? this.point,
      finish: finish ?? this.finish,
    );
  }
}

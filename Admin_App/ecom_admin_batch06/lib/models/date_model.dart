import 'package:cloud_firestore/cloud_firestore.dart';

class DateModel {
  Timestamp timestamp;
  int day, month, year;

  DateModel({
    required this.timestamp,
    required this.day,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      'timestamp' : timestamp,
      'day' : day,
      'month' : month,
      'year' : year,
    };
  }

  factory DateModel.fromMap(Map<String, dynamic> map) => DateModel(
    timestamp: map['timestamp'],
    day: map['day'],
    month: map['month'],
    year: map['year'],
  );
}
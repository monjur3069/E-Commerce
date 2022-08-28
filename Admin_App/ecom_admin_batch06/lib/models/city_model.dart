import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
  String name;
  List<String> area;

  CityModel({
    required this.name,
    required this.area,
  });

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      'name' : name,
      'area' : area
    };
  }

  factory CityModel.fromMap(Map<String, dynamic> map){
    return CityModel(
      name: map['name'],
      area: (map['area'] as List).map((e) => e.toString()).toList(),
    );
  }
}

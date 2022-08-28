import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String streetAddress;
  String area;
  String city;
  int zipCode;


  AddressModel({
    required this.streetAddress,
    required this.area,
    required this.city,
    required this.zipCode});

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      'streetAddress' : streetAddress,
      'area' : area,
      'city' : city,
      'zipCode' : zipCode,

    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map){
    return AddressModel(
      streetAddress: map['streetAddress'],
      area: map['area'],
      city: map['city'],
      zipCode: map['zipCode'],
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../db/dbhelper.dart';
import '../models/city_model.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  List<CityModel> cityList = [];

  getAllCities() {
    /*DbHelper.getAllCities().listen((snapshot) {
      cityList = List.generate(snapshot.docs.length, (index) =>
          CityModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });*/
  }

  List<String> getAreasByCity(String? city) {
    if(city != null) {
      return cityList.firstWhere((element) =>
      element.name == city).area;
    }
    return <String>[];
  }



  /*Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(String uid) =>
      DbHelper.getUserByUid(uid);*/



  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final photoRef = FirebaseStorage.instance.ref().child('ProfilePictures/$imageName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
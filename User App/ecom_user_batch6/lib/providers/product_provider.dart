import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_batch6/auth/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../db/dbhelper.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/rating_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> featuredProductList = [];
  List<CategoryModel> categoryList = [];
  List<String> categoryNameList = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) =>
          CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryNameList = List.generate(categoryList.length, (index) => categoryList[index].name!);
      categoryNameList.insert(0, 'All');
      notifyListeners();
    });
  }

  Future<bool> canUserRate(String pid) =>
    DbHelper.canUserRate(AuthService.user!.uid, pid);

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllFeaturedProducts() {
    DbHelper.getAllFeaturedProducts().listen((snapshot) {
      featuredProductList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String category) {
    DbHelper.getAllProductsByCategory(category).listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
    DbHelper.getProductById(id);

  Future<void> updateCategoryProductCount(List<CartModel> cartList) =>
      DbHelper.updateCategoryProductCount(categoryList, cartList);

  Future<void> addRating(String pid, double value) async {
    final ratingModel = RatingModel(
      userId: AuthService.user!.uid,
      productId: pid,
      rating: value,
    );
    await DbHelper.addRating(ratingModel);
    final qSnapshot = await DbHelper.getAllRatingsByProduct(pid);
    var sumOfRating = 0.0;
    final List<RatingModel> ratingList =
        List.generate(qSnapshot.docs.length, (index) =>
            RatingModel.fromMap(qSnapshot.docs[index].data()));
    for(var ratingM in ratingList) {
      sumOfRating += ratingM.rating;
    }
    final avgRating = sumOfRating / ratingList.length;
    return DbHelper.updateProduct(pid, {productRating : avgRating, productRatingCount : ratingList.length});
  }

}
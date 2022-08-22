import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin_batch06/models/category_model.dart';
import 'package:ecom_admin_batch06/models/product_model.dart';
import 'package:ecom_admin_batch06/models/purchase_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionPurchase = 'Purchases';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final doc = _db.collection(collectionCategory).doc();
    categoryModel.id = doc.id;
    return doc.set(categoryModel.toMap());
  }

  static Future<void> addProduct(
      ProductModel productModel,
      PurchaseModel purchaseModel,
      String catId, num count) {
    final wb = _db.batch();
    final proDoc = _db.collection(collectionProduct).doc();
    final purDoc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(catId);
    productModel.id = proDoc.id;
    purchaseModel.id = purDoc.id;
    purchaseModel.productId = proDoc.id;
    wb.set(proDoc, productModel.toMap());
    wb.set(purDoc, purchaseModel.toMap());
    wb.update(catDoc, {'productCount' : count});
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_batch6/models/product_model.dart';
import 'package:ecom_user_batch6/models/rating_model.dart';
import 'package:ecom_user_batch6/utils/constants.dart';

import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class DbHelper {
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionRating = 'Ratings';
  static const String collectionComment = 'Comments';
  static const String collectionUser = 'Users';
  static const String collectionCart = 'Cart';
  static const String collectionOrder = 'Order';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionCities = 'Cities';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(UserModel userModel) =>
    _db.collection(collectionUser).doc(userModel.uid)
      .set(userModel.toMap());

  static Future<void> addToCart(CartModel cartModel, String uid) =>
      _db.collection(collectionUser).doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productId)
          .set(cartModel.toMap());

  static Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderModel.toMap());
    for(var cartM in cartList) {
      final detailsDoc = orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(detailsDoc, cartM.toMap());
      final productDoc = _db.collection(collectionProduct).doc(cartM.productId);
      wb.update(productDoc, {productStock : (cartM.stock - cartM.quantity)});
    }
    return wb.commit();
  }


  static Future<void> removeFromCart(String pid, String uid) =>
      _db.collection(collectionUser).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .delete();

  static Future<void> clearAllCartItems(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUser).doc(uid);
    for(var cartM in cartList) {
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  static Future<void> updateCategoryProductCount(List<CategoryModel> catList,List<CartModel> cartList) {
    final wb = _db.batch();
    for(var cartM in cartList) {
      final catModel = catList.firstWhere((element) => element.name == cartM.category);
      final catDoc = _db.collection(collectionCategory).doc(catModel.id);
      wb.update(catDoc, {categoryProductCount : (catModel.productCount - cartM.quantity)});
    }
    return wb.commit();
  }

  static Future<void> updateCartQuantity(String uid, String pid, num quantity) =>
      _db.collection(collectionUser).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .update({cartProductQuantity : quantity});

  static Future<void> updateProduct(String pid, Map<String, dynamic> map) {
    return _db.collection(collectionProduct)
        .doc(pid)
        .update(map);

  }

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser)
        .doc(uid).get();
    return snapshot.exists;
  }


  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant)
          .snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants2() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct)
          .where(productAvailable, isEqualTo: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrdersByUser(String uid) =>
      _db.collection(collectionOrder)
          .where(orderUserIDKey, isEqualTo: uid)
          //.orderBy(orderGrandTotalKey, descending: true)
          .orderBy('$orderDateKey.timestamp', descending: true)
          //.where(orderStatusKey, isEqualTo: OrderStatus.pending)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartByUser(String uid) =>
      _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(String category) =>
      _db.collection(collectionProduct).where(productCategory, isEqualTo: category).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFeaturedProducts() =>
      _db.collection(collectionProduct).where(productFeatured, isEqualTo: true).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllRatingsByProduct(String pid) =>
      _db.collection(collectionProduct)
          .doc(pid)
          .collection(collectionRating)
          .get();

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser)
        .doc(uid)
        .update({'address' : map});
  }


  static Future<bool> canUserRate(String uid, String pid) async {
    final snapshot = await _db.collection(collectionOrder)
        .where(orderUserIDKey, isEqualTo: uid)
        .where(orderStatusKey, isEqualTo: OrderStatus.delivered)
        .get();
    if(snapshot.docs.isEmpty) return false;
    bool tag = false;
    for(var doc in snapshot.docs) {
      final detailsSnapshot = await doc.reference.collection(collectionOrderDetails)
          .where(cartProductId, isEqualTo: pid)
          .get();
      if(detailsSnapshot.docs.isNotEmpty) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  static Future<void> addRating(RatingModel ratingModel) {
    return _db.collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userId)
        .set(ratingModel.toMap());
  }

}
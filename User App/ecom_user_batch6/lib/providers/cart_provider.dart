import 'package:ecom_user_batch6/auth/auth_service.dart';
import 'package:ecom_user_batch6/db/dbhelper.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  getCartByUser() {
    DbHelper.getCartByUser(AuthService.user!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length, (index) =>
          CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addToCart(CartModel cartModel) =>
    DbHelper.addToCart(cartModel, AuthService.user!.uid);

  Future<void> removeFromCart(String pid) =>
      DbHelper.removeFromCart(pid, AuthService.user!.uid);

  Future<void> clearAllCartItems() =>
    DbHelper.clearAllCartItems(AuthService.user!.uid, cartList);

  Future<void> _updateCartQuantity(String pid, num quantity) =>
    DbHelper.updateCartQuantity(AuthService.user!.uid, pid, quantity);
  
  int get totalItemsInCart => cartList.length;

  num unitPriceWithQuantity(CartModel cartModel) =>
    cartModel.salePrice * cartModel.quantity;

   increaseQuantity(CartModel cartModel) async {
    if(cartModel.quantity < cartModel.stock) {
      await _updateCartQuantity(cartModel.productId!, cartModel.quantity + 1);
    }
  }

   decreaseQuantity(CartModel cartModel) async {
    if(cartModel.quantity > 1) {
      await _updateCartQuantity(cartModel.productId!, cartModel.quantity - 1);
    }

  }

  num getCartSubTotal() {
     num total = 0;
     for(var cartM in cartList) {
       total += cartM.salePrice * cartM.quantity;
     }
     return total;
  }

  bool isInCart(String pid) {
    bool tag = false;
    for(var cartM in cartList) {
      if(cartM.productId == pid) {
        tag = true;
        break;
      }
    }
    return tag;
  }
}
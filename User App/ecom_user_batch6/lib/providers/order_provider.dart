
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../db/dbhelper.dart';
import '../models/cart_model.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> orderList = [];

  getOrdersByUser() {
    DbHelper.getAllOrdersByUser(AuthService.user!.uid).listen((snapshot) {
      orderList = List.generate(snapshot.docs.length, (index) =>
          OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    }).onError((error) {
      print(error.toString());
    });
  }

  Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) {
    return DbHelper.addOrder(orderModel, cartList);
  }

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((event) {
      if(event.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> getOrderConstants2() async {
    final snapshot = await DbHelper.getOrderConstants2();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }

  num getDiscountAmount(num subtotal) {
    return (subtotal * orderConstantsModel.discount) / 100;
  }

  num getVatAmount(num subtotal) {
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal);
    return (priceAfterDiscount * orderConstantsModel.vat) / 100;
  }

  num getGrandTotal(num subtotal) {
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal);
    final vatAmount = getVatAmount(subtotal);
    return priceAfterDiscount + vatAmount + orderConstantsModel.deliveryCharge;
  }

}
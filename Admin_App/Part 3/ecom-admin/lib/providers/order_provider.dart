import 'package:ecom_admin_batch06/db/dbhelper.dart';
import 'package:ecom_admin_batch06/models/order_constants_model.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

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

  Future<void> addOrderConstants(OrderConstantsModel model) =>
      DbHelper.addOrderConstants(model);

}
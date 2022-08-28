import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin_batch06/db/dbhelper.dart';
import 'package:ecom_admin_batch06/models/order_constants_model.dart';
import 'package:ecom_admin_batch06/utils/constants.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> orderList = [];

  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((event) {
      if(event.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrdersByOrderId(String oid) {
    return DbHelper.getAllOrdersByOrderId(oid);
  }

  Future<void> getOrderConstants2() async {
    final snapshot = await DbHelper.getOrderConstants2();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }

  Future<void> addOrderConstants(OrderConstantsModel model) =>
      DbHelper.addOrderConstants(model);

  void getAllOrders() {
    DbHelper.getAllOrders().listen((snapshot) {
      orderList = List.generate(snapshot.docs.length, (index) =>
          OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<OrderModel> getFilteredListBySingleDay(DateTime dt) {
    return orderList.where((orderM) =>
    orderM.orderDate.timestamp.toDate().day == dt.day &&
        orderM.orderDate.timestamp.toDate().month == dt.month &&
        orderM.orderDate.timestamp.toDate().year == dt.year).toList();
  }

  List<OrderModel> getFilteredListByWeek(DateTime dt) {
    return orderList.where((orderM) =>
    orderM.orderDate.timestamp.toDate().isAfter(dt)).toList();
  }

  List<OrderModel> getFilteredListByDateRange(DateTime dt) {
    return orderList.where((orderM) =>
    orderM.orderDate.timestamp.toDate().month == dt.month &&
        orderM.orderDate.timestamp.toDate().year == dt.year).toList();
  }

  num getTotalSaleBySingleDate(DateTime dt) {
    num total = 0;
    final list = getFilteredListBySingleDay(dt);
    for(var order in list) {
      total += order.grandTotal;
    }
    return total.round();
  }

  num getTotalSaleByWeek(DateTime dt) {
    num total = 0;
    final list = getFilteredListByWeek(dt);
    for(var order in list) {
      total += order.grandTotal;
    }
    return total.round();
  }

  num getTotalSaleByDateRange(DateTime dt) {
    num total = 0;
    final list = getFilteredListByDateRange(dt);
    for(var order in list) {
      total += order.grandTotal;
    }
    return total.round();
  }

  num getTotalAllTimeSale() {
    num total = 0;
    for(var order in orderList) {
      total += order.grandTotal;
    }
    return total.round();
  }

  List<OrderModel> getFilteredList(OrderFilter filter) {
    var list = <OrderModel>[];
    switch(filter) {
      case OrderFilter.TODAY:
        list = getFilteredListBySingleDay(DateTime.now());
        break;
      case OrderFilter.YESTERDAY:
        list = getFilteredListBySingleDay(DateTime.now().subtract(const Duration(days: 1)));
        break;
      case OrderFilter.SEVEN_DAYS:
        list = getFilteredListByWeek(DateTime.now().subtract(const Duration(days: 7)));
        break;
      case OrderFilter.THIS_MONTH:
        list = getFilteredListByDateRange(DateTime.now());
        break;
      case OrderFilter.ALL_TIME:
        list = orderList;
        break;
    }
    return list;
  }
}
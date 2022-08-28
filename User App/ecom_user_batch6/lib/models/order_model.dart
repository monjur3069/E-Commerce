
 import 'package:ecom_user_batch6/models/address_model.dart';

import 'date_model.dart';

const String orderIDKey = 'orderId';
 const String orderUserIDKey = 'userId';
 const String orderDateKey = 'orderDate';
 const String orderStatusKey = 'orderStatus';
 const String orderPaymentMethodKey = 'paymentMethod';
 const String orderDeliveryChargeKey = 'deliveryCharge';
 const String orderDiscountKey = 'discount';
 const String orderVatKey = 'vat';
 const String orderGrandTotalKey = 'grandTotal';
 const String orderDeliveryAddressKey = 'deliveryAddress';

class OrderModel{
  String? orderId, userId;
  String orderStatus, paymentMethod;
  AddressModel deliveryAddress;
  num deliveryCharge, discount, vat, grandTotal;
  DateModel orderDate;

  OrderModel(
      {this.orderId,
      this.userId,
      required this.orderStatus,
        required this.paymentMethod,
        required this.deliveryAddress,
        required this.deliveryCharge,
        required this.discount,
        required this.vat,
        required this.grandTotal,
        required this.orderDate});

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      orderIDKey : orderId,
      orderUserIDKey : userId,
      orderDateKey: orderDate.toMap(),
      orderStatusKey: orderStatus,
      orderPaymentMethodKey : paymentMethod,
      orderGrandTotalKey : grandTotal,
      orderDeliveryChargeKey : deliveryCharge,
      orderDiscountKey : discount,
      orderVatKey : vat,
      orderDeliveryAddressKey : deliveryAddress.toMap(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map){
    return OrderModel(
      orderId: map[orderIDKey],
      userId: map[orderUserIDKey],
      orderDate: DateModel.fromMap(map[orderDateKey]),
      orderStatus: map[orderStatusKey],
      paymentMethod: map[orderPaymentMethodKey],
      deliveryAddress: AddressModel.fromMap(map[orderDeliveryAddressKey]),
      deliveryCharge: map[orderDeliveryChargeKey],
      discount: map[orderDiscountKey],
      vat: map[orderVatKey],
      grandTotal: map[orderGrandTotalKey],
    );
  }
}
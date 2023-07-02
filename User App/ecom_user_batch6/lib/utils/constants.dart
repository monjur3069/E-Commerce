import 'package:flutter/material.dart';

const String currencySymbol = '৳';


const Color lightPrimary = Color.fromRGBO(255, 208, 0, 1);
const Color darkPrimary = Color.fromRGBO(255, 184, 0, 1);
const Color black = Colors.black;
const Color darkShadow = Color.fromRGBO(222, 160, 0, 1);
const Color lightShadow = Color.fromRGBO(255, 208, 0, 1);

const double appPadding = 30;


abstract class PaymentMethod {
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

abstract class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
}
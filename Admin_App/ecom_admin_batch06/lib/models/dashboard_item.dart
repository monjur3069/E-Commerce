import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardItem {
  IconData icon;
  String title;

  DashboardItem({
    required this.icon,
    required this.title,
  });

  static const String product = 'Product';
  static const String category = 'Category';
  static const String order = 'Orders';
  static const String user = 'Users';
  static const String settings = 'Settings';
  static const String report = 'Report';
}

final List<DashboardItem> dashboardItems = [
  DashboardItem(icon: Icons.card_giftcard, title: DashboardItem.product,),
  DashboardItem(icon: Icons.category, title: DashboardItem.category,),
  DashboardItem(icon: Icons.monetization_on, title: DashboardItem.order,),
  DashboardItem(icon: Icons.person, title: DashboardItem.user,),
  DashboardItem(icon: Icons.settings, title: DashboardItem.settings,),
  DashboardItem(icon: Icons.area_chart, title: DashboardItem.report,),
];



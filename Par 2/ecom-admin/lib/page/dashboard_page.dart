
import 'package:ecom_admin_batch06/page/category_page.dart';
import 'package:ecom_admin_batch06/page/order_page.dart';
import 'package:ecom_admin_batch06/page/product_page.dart';
import 'package:ecom_admin_batch06/page/settings_page.dart';
import 'package:ecom_admin_batch06/page/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_item.dart';
import '../providers/product_provider.dart';
import '../widgets/dashboard_item_view.dart';
import 'report_page.dart';

class DashboardPage extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: dashboardItems.length,
        itemBuilder: (context, index) => DashboardItemView(
          item: dashboardItems[index],
          onPressed: (value) {
            final route = navigate(value);
            Navigator.pushNamed(context, route);
          },
        ),
      ),
    );
  }

  String navigate(String value) {
    String route = '';
    switch(value) {
      case DashboardItem.product:
        route = ProductPage.routeName;
        break;
      case DashboardItem.category:
        route = CategoryPage.routeName;
        break;
      case DashboardItem.order:
        route = OrderPage.routeName;
        break;
      case DashboardItem.user:
        route = UserPage.routeName;
        break;
      case DashboardItem.settings:
        route = SettingsPage.routeName;
        break;
      case DashboardItem.report:
        route = ReportPage.routeName;
        break;
    }
    return route;
  }
}

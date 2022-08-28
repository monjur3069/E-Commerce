import 'package:ecom_admin_batch06/providers/order_provider.dart';
import 'package:ecom_admin_batch06/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_list_page.dart';

class OrderPage extends StatelessWidget {
  static const String routeName = '/order';
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text('Today', style: Theme.of(context).textTheme.headline6,),
                  const SizedBox(height: 5,),
                  const Divider(height: 2, color: Colors.black,),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Orders',),
                          const SizedBox(height: 5,),
                          Text('${provider.getFilteredListBySingleDay(DateTime.now()).length}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Total Sale'),
                          const SizedBox(height: 5,),
                          Text('$currencySymbol${provider.getTotalSaleBySingleDate(DateTime.now())}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(
                            context,
                            OrderListPage.routeName,
                          arguments: OrderFilter.TODAY,
                        ),
                    child: const Text('VIEW ALL'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text('Yesterday', style: Theme.of(context).textTheme.headline6,),
                  const SizedBox(height: 5,),
                  const Divider(height: 2, color: Colors.black,),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Orders',),
                          const SizedBox(height: 5,),
                          Text('${provider.getFilteredListBySingleDay(DateTime.now().subtract(const Duration(days: 1))).length}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Total Sale'),
                          const SizedBox(height: 5,),
                          Text('$currencySymbol${provider.getTotalSaleBySingleDate(DateTime.now().subtract(const Duration(days: 1)))}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(
                          context,
                          OrderListPage.routeName,
                          arguments: OrderFilter.YESTERDAY,
                        ),
                    child: const Text('VIEW ALL'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text('Last 7 days', style: Theme.of(context).textTheme.headline6,),
                  const SizedBox(height: 5,),
                  const Divider(height: 2, color: Colors.black,),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Orders',),
                          const SizedBox(height: 5,),
                          Text('${provider.getFilteredListByWeek(DateTime.now().subtract(const Duration(days: 7))).length}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Total Sale'),
                          const SizedBox(height: 5,),
                          Text('$currencySymbol${provider.getTotalSaleByWeek(DateTime.now().subtract(const Duration(days: 7)))}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(
                          context,
                          OrderListPage.routeName,
                          arguments: OrderFilter.SEVEN_DAYS,
                        ),
                    child: const Text('VIEW ALL'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text('This Month', style: Theme.of(context).textTheme.headline6,),
                  const SizedBox(height: 5,),
                  const Divider(height: 2, color: Colors.black,),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Orders',),
                          const SizedBox(height: 5,),
                          Text('${provider.getFilteredListByDateRange(DateTime.now()).length}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Total Sale'),
                          const SizedBox(height: 5,),
                          Text('$currencySymbol${provider.getTotalSaleByDateRange(DateTime.now())}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(
                          context,
                          OrderListPage.routeName,
                          arguments: OrderFilter.THIS_MONTH,
                        ),
                    child: const Text('VIEW ALL'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text('All Time', style: Theme.of(context).textTheme.headline6,),
                  const SizedBox(height: 5,),
                  const Divider(height: 2, color: Colors.black,),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Orders',),
                          const SizedBox(height: 5,),
                          Text('${provider.orderList.length}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Total Sale'),
                          const SizedBox(height: 5,),
                          Text('$currencySymbol${provider.getTotalAllTimeSale()}',  style: Theme.of(context).textTheme.headline5,)
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(
                          context,
                          OrderListPage.routeName,
                          arguments: OrderFilter.ALL_TIME,
                        ),
                    child: const Text('VIEW ALL'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

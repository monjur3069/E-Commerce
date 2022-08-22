import 'package:ecom_admin_batch06/page/new_product_page.dart';
import 'package:ecom_admin_batch06/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import 'product_details_page.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = '/product';
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) =>
        provider.categoryList.isEmpty ?
        const Center(child: Text('No item found',
          style: TextStyle(fontSize: 18),),) :
        ListView.builder(
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {
            final product = provider.productList[index];
            return ListTile(
              onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: product.id),
              title: Text(product.name!),
              trailing: Text('$currencySymbol${product.salesPrice}'),
            );
          },
        ),
      ),
    );
  }
}

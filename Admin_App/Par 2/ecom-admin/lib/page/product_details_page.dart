import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin_batch06/models/purchase_model.dart';
import 'package:ecom_admin_batch06/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/date_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';
  ValueNotifier dateChangeNotifier = ValueNotifier(DateTime);

  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dateChangeNotifier.value = DateTime.now();
    final pid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) =>
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return ListView(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'images/loading.gif',
                    image: product.imageUrl!,
                    fadeInDuration: const Duration(seconds: 2),
                    fadeInCurve: Curves.bounceInOut,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showRePurchaseForm(context, provider, product);
                        },
                        child: const Text('Re-Purchase'),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.getAllPurchaseByProductId(pid);
                          _showPurchaseHistory(context, provider);
                        },
                        child: const Text('Purchase History'),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(product.name!),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: Text('$currencySymbol${product.salesPrice}'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: const Text('Product Description'),
                    subtitle: Text(product.description ?? 'Not Available'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Available'),
                    value: product.available,
                    onChanged: (value) {
                      provider.updateProduct(pid, productAvailable, value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Featured'),
                    value: product.featured,
                    onChanged: (value) {
                      provider.updateProduct(pid, productFeatured, value);
                    },
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to get data'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _showPurchaseHistory(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
              itemCount: provider.purchaseListOfSpecificProduct.length,
              itemBuilder: (context, index) {
                final purchase = provider.purchaseListOfSpecificProduct[index];
                return ListTile(
                  title: Text(getFormattedDateTime(
                      purchase.dateModel.timestamp.toDate(), 'dd/MM/yyyy')),
                  subtitle: Text('Quantity: ${purchase.quantity}'),
                  trailing: Text('$currencySymbol${purchase.price}'),
                );
              },
            ));
  }

  void _showRePurchaseForm(BuildContext context, ProductProvider provider,
      ProductModel productModel) {
    final qController = TextEditingController();
    final priceController = TextEditingController();
    showModalBottomSheet(
      enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  title: Text('Re-Purchase ${productModel.name}'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: qController,
                  decoration: const InputDecoration(
                      filled: true, labelText: 'Enter Quantity'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  decoration: const InputDecoration(
                      filled: true, labelText: 'Enter Price'),
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () async {
                            final _purchaseDate = await _selectDate(context);
                            dateChangeNotifier.value = _purchaseDate;
                          },
                          child: Text('Select Purchase Date')),
                      ValueListenableBuilder(
                        valueListenable: dateChangeNotifier,
                        builder: (context, value, child) =>  Text(
                          getFormattedDateTime(value, 'dd/MM/yyyy'),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final purchase = PurchaseModel(
                      dateModel: DateModel(
                        timestamp: Timestamp.fromDate(dateChangeNotifier.value),
                        day: dateChangeNotifier.value.day,
                        month: dateChangeNotifier.value.month,
                        year: dateChangeNotifier.value.year,
                      ),
                      price: num.parse(priceController.text),
                      quantity: num.parse(qController.text),
                      productId: productModel.id,
                    );
                    provider.addNewPurchase(purchase).then((value) {
                      qController.clear();
                      priceController.clear();
                      Navigator.pop(context);
                    }).catchError((err) {
                      Navigator.pop(context);
                      showMsg(context, 'Failed to perform....');
                    });
                  },
                  child: const Text('Re-Purchase'),
                )
              ],
            ));
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
  }
}

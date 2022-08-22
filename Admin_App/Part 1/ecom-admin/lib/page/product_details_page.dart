import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
    );
  }
}

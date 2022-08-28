import 'package:ecom_user_batch6/models/product_model.dart';
import 'package:ecom_user_batch6/page/product_details_page.dart';
import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;

  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
          context,
          ProductDetailsPage.routeName,
        arguments: widget.productModel.id
      ),
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(seconds: 2),
                    fadeInCurve: Curves.bounceInOut,
                    placeholder: 'images/placeholder.jpg',
                    image: widget.productModel.imageUrl!,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productModel.name!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  '$currencySymbol${widget.productModel.salesPrice!}',
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    final isInCart = provider.isInCart(widget.productModel.id!);
                    return ElevatedButton.icon(
                      icon: Icon(isInCart
                          ? Icons.remove_shopping_cart
                          : Icons.add_shopping_cart),
                      onPressed: () {
                        if (isInCart) {
                          provider.removeFromCart(widget.productModel.id!);
                        } else {
                          final cartModel = CartModel(
                            productId: widget.productModel.id!,
                            productName: widget.productModel.name,
                            category: widget.productModel.category,
                            imageUrl: widget.productModel.imageUrl,
                            salePrice: widget.productModel.salesPrice,
                            stock: widget.productModel.stock,
                          );
                          provider.addToCart(cartModel);
                        }
                      },
                      label: Text(isInCart ? 'Remove' : 'ADD'),
                    );
                  },
                )
              ],
            ),
            if(widget.productModel.stock <= 0) Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                color: Colors.black54,
                child: const Text(
                  'Out of stock',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

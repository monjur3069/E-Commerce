import 'package:ecom_user_batch6/providers/cart_provider.dart';
import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'checkout_page.dart';
import 'user_address_page.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartM = provider.cartList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        cartM.imageUrl!
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Unit Price: $currencySymbol${cartM.salePrice}'),
                        Row(
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, size: 30,),
                              onPressed: () {
                                provider.decreaseQuantity(cartM);
                              },
                            ),
                            Text('${cartM.quantity}', style: const TextStyle(fontSize: 17),),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, size: 30,),
                              onPressed: () {
                                provider.increaseQuantity(cartM);
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                provider.removeFromCart(cartM.productId!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    title: Text(cartM.productName!),
                    trailing: Text('$currencySymbol${provider.unitPriceWithQuantity(cartM)}'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal: $currencySymbol${provider.getCartSubTotal()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      TextButton(
                        onPressed: provider.totalItemsInCart == 0 ? null
                            : () => Navigator.pushNamed(context, CheckoutPage.routeName),
                        child: const Text('CHECKOUT'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

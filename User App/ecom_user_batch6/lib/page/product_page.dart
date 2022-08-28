import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_user_batch6/db/dbhelper.dart';
import 'package:ecom_user_batch6/providers/cart_provider.dart';
import 'package:ecom_user_batch6/providers/order_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../widgets/main_drawer.dart';
import '../widgets/product_item.dart';
import 'cart_page.dart';
import 'product_details_page.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/product';

  ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int? chipValue = 0;
  bool isFirst = true;

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    if(isFirst) {
      Provider.of<ProductProvider>(context, listen: false).getAllProducts();
      Provider.of<ProductProvider>(context, listen: false).getAllCategories();
      Provider.of<ProductProvider>(context, listen: false)
          .getAllFeaturedProducts();
      Provider.of<CartProvider>(context, listen: false).getCartByUser();
    }
    isFirst = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart, size: 30,),
                  Positioned(
                    top: -4,
                    left: -4,
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                      ),
                      child: FittedBox(child: Consumer<CartProvider>(
                          builder: (context, value, child) => Text('${value.totalItemsInCart}',))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => Column(
          children: [
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.categoryNameList.length,
                itemBuilder: (context, index) {
                  final catName = provider.categoryNameList[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      labelStyle: TextStyle(
                          color:
                              chipValue == index ? Colors.white : Colors.black),
                      selectedColor: Theme.of(context).primaryColor,
                      label: Text(catName),
                      selected: chipValue == index,
                      onSelected: (value) {
                        setState(() {
                          chipValue = value ? index : null;
                        });
                        if (chipValue != null && chipValue != 0) {
                          provider.getAllProductsByCategory(catName);
                        } else if (chipValue == 0) {
                          provider.getAllProducts();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const Text(
              'Featured Products',
              style: TextStyle(fontSize: 18),
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.7,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    //onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: provider.featuredProductList
                      .map((e) => Container(
                            padding: const EdgeInsets.all(4),
                            child: Stack(
                              children: [
                                FadeInImage.assetNetwork(
                                  fadeInDuration: const Duration(seconds: 2),
                                  fadeInCurve: Curves.bounceInOut,
                                  placeholder: 'images/placeholder.jpg',
                                  image: e.imageUrl!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    color: Colors.black54,
                                    child: Text(e.name!, style: TextStyle(color: Colors.white, fontSize: 18),),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            provider.productList.isEmpty
                ? const Center(
                    child: Text(
                      'No item found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 0.7),
                      itemCount: provider.productList.length,
                      itemBuilder: (context, index) {
                        final product = provider.productList[index];
                        return ProductItem(productModel: product);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin_batch06/models/product_model.dart';
import 'package:ecom_admin_batch06/models/purchase_model.dart';
import 'package:ecom_admin_batch06/providers/product_provider.dart';
import 'package:ecom_admin_batch06/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/date_model.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/new_product';

  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final salePriceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final quantityController = TextEditingController();
  DateTime? _purchaseDate;
  String? _imageUrl;
  String? _category;
  bool isUploading = false, isSaving = false;
  ImageSource _imageSource = ImageSource.camera;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    salePriceController.dispose();
    purchasePriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            onPressed: isUploading ? null : _saveProduct,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Product Description',
                prefixIcon: Icon(Icons.call),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: purchasePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Purchase Price',
                prefixIcon: Icon(Icons.monetization_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: salePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sale Price',
                prefixIcon: Icon(Icons.monetization_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                prefixIcon: Icon(Icons.monetization_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<ProductProvider>(
              builder: (context, provider, _) =>
                  DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                hint: const Text('Select Category'),
                value: _category,
                items: provider.categoryList
                    .map((model) => DropdownMenuItem<String>(
                          value: model.name,
                          child: Text(model.name!),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: _selectDate,
                      child: Text('Select Purchase Date')),
                  Text(_purchaseDate == null
                      ? 'No Date Chosen'
                      : getFormattedDateTime(_purchaseDate!, 'dd/MM/yyyy')),
                ],
              ),
            ), //date of birth
            Center(
              child: Card(
                  elevation: 5,
                  child: _imageUrl == null
                      ? isUploading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Image.asset(
                              'images/placeholder.jpg',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                      : FadeInImage.assetNetwork(
                          placeholder: 'images/loading.gif',
                          image: _imageUrl!,
                          fadeInDuration: const Duration(seconds: 2),
                          fadeInCurve: Curves.bounceInOut,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _imageSource = ImageSource.camera;
                      _getImage();
                    },
                    child: Text('Camera')),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _imageSource = ImageSource.gallery;
                      _getImage();
                    },
                    child: Text('Gallary')),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _saveProduct() async {
    if (_imageUrl == null) {
      showMsg(context, 'Image required for product');
      return;
    }
    if (_purchaseDate == null) {
      showMsg(context, 'Purchase Date is required');
      return;
    }
    if (formKey.currentState!.validate()) {
      EasyLoading.show(
          status: 'Please wait..',
          dismissOnTap: false);
      final productModel = ProductModel(
        name: nameController.text,
        description: descriptionController.text,
        category: _category,
        salesPrice: num.parse(salePriceController.text),
        imageUrl: _imageUrl,
        stock: num.parse(quantityController.text),
      );
      final purchaseModel = PurchaseModel(
        dateModel: DateModel(
          timestamp: Timestamp.fromDate(_purchaseDate!),
          day: _purchaseDate!.day,
          month: _purchaseDate!.month,
          year: _purchaseDate!.year,
        ),
        price: num.parse(purchasePriceController.text),
        quantity: num.parse(quantityController.text),
      );
      final catModel =
          context.read<ProductProvider>().getCategoryByName(_category!);
      context
          .read<ProductProvider>()
          .addProduct(productModel, purchaseModel, catModel)
          .then((value) {
            EasyLoading.dismiss(animation: true);
        setState(() {
          nameController.clear();
          descriptionController.clear();
          purchasePriceController.clear();
          salePriceController.clear();
          quantityController.clear();
          _purchaseDate = null;
          _imageUrl = null;
          _category = null;
        });
      });
    }
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      setState(() {
        _purchaseDate = selectedDate;
      });
    }
  }

  void _getImage() async {
    final selecteImage = await ImagePicker().pickImage(source: _imageSource);
    if (selecteImage != null) {
      setState(() {
        isUploading = true;
      });
      try {
        final url =
            await context.read<ProductProvider>().updateImage(selecteImage);
        setState(() {
          _imageUrl = url;
          isUploading = false;
        });
      } catch (e) {}
    }
  }
}

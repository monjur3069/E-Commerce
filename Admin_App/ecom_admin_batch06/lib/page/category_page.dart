import 'package:ecom_admin_batch06/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) =>
          provider.categoryList.isEmpty ?
          const Center(child: Text('No item found',
            style: TextStyle(fontSize: 18),),) :
            ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return ListTile(
              title: Text('${category.name}(${category.productCount})'),
            );
          },
        ),
      ),
      bottomSheet: DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 0.5,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Card(
            elevation: 10,
            color: Colors.blue[100],
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              controller: scrollController,
              children: [
                const Center(
                  child: Icon(Icons.drag_handle,),
                ),
                const ListTile(
                  title: Text('ADD CATEGORY'),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter new Category',
                    filled: true,
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    await Provider
                        .of<ProductProvider>(context, listen: false)
                        .addCategory(nameController.text);
                    nameController.clear();
                  },
                  child: const Text('ADD'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

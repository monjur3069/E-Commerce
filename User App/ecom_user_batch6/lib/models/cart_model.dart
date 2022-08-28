
 const String cartProductId = 'productId';
 const String cartProductName = 'productName';
 const String cartProductImage = 'productImage';
 const String cartProductPrice = 'productPrice';
 const String cartProductQuantity = 'productQuantity';
 const String cartProductStock = 'productStock';
 const String cartProductCategory = 'productCategory';

class CartModel{
  String? productId, productName, imageUrl, category;
  num salePrice, quantity, stock;


  CartModel(
      {this.productId,
      this.productName,
      this.imageUrl,
        this.category,
      required this.salePrice,
        required this.stock,
      this.quantity = 1});

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      cartProductId : productId,
      cartProductName : productName,
      cartProductImage : imageUrl,
      cartProductPrice : salePrice,
      cartProductQuantity : quantity,
      cartProductStock : stock,
      cartProductCategory : category,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map){
    return CartModel(
      productId: map[cartProductId],
      productName: map[cartProductName],
      imageUrl: map[cartProductImage],
      salePrice: map[cartProductPrice],
      quantity: map[cartProductQuantity],
      stock: map[cartProductStock],
      category: map[cartProductCategory],
    );
  }
}
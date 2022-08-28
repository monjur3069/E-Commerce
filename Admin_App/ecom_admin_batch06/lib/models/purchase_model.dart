import 'date_model.dart';

const String purchaseId = 'id';
const String purchaseProductId = 'productId';
const String purchaseDate = 'date';
const String purchasePrice = 'price';
const String purchaseQuantity = 'quantity';

class PurchaseModel {
  String? id, productId;
  num price, quantity;
  DateModel dateModel;

  PurchaseModel({
    this.id,
    this.productId,
    required this.dateModel,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      purchaseId : id,
      purchaseProductId : productId,
      purchaseDate : dateModel.toMap(),
      purchasePrice : price,
      purchaseQuantity : quantity,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      id: map[purchaseId],
      productId: map[purchaseProductId],
      price: map[purchasePrice],
      dateModel: DateModel.fromMap(map[purchaseDate]),
      quantity: map[purchaseQuantity],
    );
  }
}

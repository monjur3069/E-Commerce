
 const String deliveryChargeKey = 'deliveryCharge';
 const String discountKey = 'discount';
 const String vatKey = 'vat';

class OrderConstantsModel{
  num deliveryCharge, discount, vat;


  OrderConstantsModel({
    this.deliveryCharge = 0,
    this.discount = 0,
    this.vat = 0});

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      deliveryChargeKey : deliveryCharge,
      discountKey : discount,
      vatKey : vat,
    };
  }

  factory OrderConstantsModel.fromMap(Map<String, dynamic> map){
    return OrderConstantsModel(
      deliveryCharge: map[deliveryChargeKey],
      discount: map[discountKey],
      vat: map[vatKey],
    );
  }
}
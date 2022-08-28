
 const String ratingUserIdKey = 'userId';
 const String ratingProductIdKey = 'productId';
 const String ratingValueKey = 'rating';

class RatingModel{
  String? userId, productId;
  double rating;

  RatingModel({
    this.userId,
    this.productId,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      ratingUserIdKey : userId,
      ratingProductIdKey : productId,
      ratingValueKey : rating,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map){
    return RatingModel(
      userId: map[ratingUserIdKey],
      productId: map[ratingProductIdKey],
      rating: map[ratingValueKey],
    );
  }
}
const String productId = 'id';
const String productName = 'name';
const String productCategory = 'category';
const String productDescription = 'description';
const String productImageUrl = 'imageUrl';
const String productSalesPrice = 'salesPrice';
const String productFeatured = 'featured';
const String productAvailable = 'available';
const String productStock = 'stock';
const String productRating = 'rating';
const String productRatingCount = 'ratingCount';

class ProductModel {
  String? id, name, category, description, imageUrl;
  num salesPrice, stock, ratingCount;
  double rating;
  bool featured, available;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.description,
    this.imageUrl,
    this.stock = 0,
    required this.salesPrice,
    this.featured = true,
    this.available = true,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[productId],
      name: map[productName],
      category: map[productCategory],
      description: map[productDescription],
      imageUrl: map[productImageUrl],
      salesPrice: map[productSalesPrice],
      featured: map[productFeatured],
      available: map[productAvailable],
      stock: map[productStock],
      rating: map[productRating] ?? 0.0,
      ratingCount: map[productRatingCount] ?? 0,
    );
  }

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      productId: id,
      productName: name,
      productCategory: category,
      productDescription: description,
      productImageUrl: imageUrl,
      productSalesPrice: salesPrice,
      productFeatured: featured,
      productAvailable: available,
      productStock: stock,
      productRating: rating,
      productRatingCount: ratingCount,
    };
  }
}

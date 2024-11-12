class ProductCategory {
  final String id;
  final String productName;
  final String price;
  final String image;

  ProductCategory({
    required this.id,
    required this.productName,
    required this.price,
    required this.image,
  });

  // Updated `fromMap` method with default values for null handling
  factory ProductCategory.fromMap(Map<String, dynamic> data) {
    return ProductCategory(
      id: data['id'] ?? 'Unknown ID',
      productName: data['name'] ?? 'Unknown Product',
      price: data['price'] ?? '0',  // Default to "0" if price is missing
      image: data['image'] ?? '',   // Default to an empty string for image
    );
  }
}

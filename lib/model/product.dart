import 'package:uuid/uuid.dart';

class Product {
  String id; // Unique identifier for the product
  String? productName;
  String? brand;
  String? stock;
  double? salePrice;
  String? discount;
  String? image;
  String? description; // New field for product description

  // Make these nullable to handle cases where they might not be provided
  double? rating; // Change to double? if rating is supposed to be a number
  int? soldCount; // Change to int? for sold count

  Product({
    String? id,
    this.productName,
    this.brand,
    this.stock,
    this.salePrice,
    this.discount,
    this.image,
    this.description, // Include description in constructor
    this.rating,
    this.soldCount,
  }) : id = id ?? Uuid().v4();

  get userName => null;

  get userEmail => null;

  get userPhone => null; // Generate a unique ID if not provided

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'brand': brand,
      'stock': stock,
      'salePrice': salePrice,
      'discount': discount,
      'image': image,
      'description': description, // Include description in map
      'rating': rating,
      'soldCount': soldCount,
    };
  }

  static Product fromMap(Map<dynamic, dynamic> data, String key) {
    return Product(
      id: key, // Use the key as the product ID
      productName: data['productName'] ?? null,
      brand: data['brand'] ?? null,
      stock: data['stock'] ?? null,
      salePrice: data['salePrice'] ?? null,
      discount: data['discount'] ?? null,
      image: data['image'] ?? null,
      description: data['description'] ?? null, // Get description from map
      rating: data['rating']?.toDouble(), // Safely convert to double if present
      soldCount: data['soldCount']?.toInt(), // Safely convert to int if present
    );
  }
}

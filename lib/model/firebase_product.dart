class FirebaseProduct {
  final String id;
  final String productName;
  final String category;
  final String brand;
  final String productCode;
  final int stock;
  final double salePrice;
  final double discount;
  final String image; // This will hold base64 encoded string

  FirebaseProduct({
    required this.id,
    required this.productName,
    required this.category,
    required this.brand,
    required this.productCode,
    required this.stock,
    required this.salePrice,
    required this.discount,
    required this.image, // Base64 string
  });

  factory FirebaseProduct.fromMap(Map<dynamic, dynamic> data) {
    return FirebaseProduct(
      id: data['id'] ?? '',
      productName: data['productName'] ?? '',
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      productCode: data['productCode'] ?? '',
      stock: int.tryParse(data['stock']?.toString() ?? '0') ?? 0,
      salePrice: double.tryParse(data['salePrice']?.toString() ?? '0.0') ?? 0.0,
      discount: double.tryParse(data['discount']?.toString() ?? '0.0') ?? 0.0,
      image: data['image'] ?? '', // Ensure this is a base64 string
    );
  }
}

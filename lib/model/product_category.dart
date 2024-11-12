class ProductCategory  {
  String? id; // Optionally store the ID if needed
  String categoryId;
  String categoryName;
  String productName;
  String price;
  String description;
  String discount;
  String stock;
  String? image; // Base64 image string

  ProductCategory ({
    this.id,
    required this.categoryId,
    required this.categoryName,
    required this.productName,
    required this.price,
    required this.description,
    required this.discount,
    required this.stock,
    this.image,
  });

  // Convert a Product into a Map. The keys must correspond to the keys used in the database
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'productName': productName,
      'price': price,
      'description': description,
      'discount': discount,
      'stock': stock,
      'image': image,
    };
  }

  // Create a Product from a Map
  factory ProductCategory .fromMap(Map<String, dynamic> map) {
    return ProductCategory (
      id: map['id'], // If you're storing the ID
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      productName: map['productName'],
      price: map['price'],
      description: map['description'],
      discount: map['discount'],
      stock: map['stock'],
      image: map['image'],
    );
  }

 
}

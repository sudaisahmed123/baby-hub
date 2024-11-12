class CartItem {
  final String userId; // Store user ID
  final String productId; // Store product ID
  final String productName;
  final int quantity;
  final double price;
  final String userName; // Add user name field
  final String userEmail; // Add user email field
  final String userPhone; // Add user phone number field
  final String? image; // Add image field

  CartItem({
    required this.userId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.image, // Add image parameter to constructor
  });

  // Convert CartItem to a Map for storing in the database
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'userName': userName, // Add to map
      'userEmail': userEmail, // Add to map
      'userPhone': userPhone, // Add to map
      'image': image, // Add to map (Base64 encoded image)
    };
  }

  // Create a CartItem instance from a Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPhone: map['userPhone'] ?? '',
      image: map['image'] ?? '', // Retrieve image (Base64 encoded)
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/cart_item.dart';

class OrderService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> createOrder({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String address,
    required List<CartItem> items,
  }) async {
    double totalPrice = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

    // Prepare order data with a default status of "pending"
    Map<String, dynamic> orderData = {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'totalPrice': totalPrice,
      'orderDate': DateTime.now().toString(),
      'status': 'pending', // Add default status here
    };

    try {
      // Get a reference to the orders node and create a new order
      DatabaseReference ordersRef = _database.ref().child('orders');
      DatabaseReference newOrderRef = ordersRef.push(); // Generate a new unique key for each order

      // Set the order data at the new order reference
      await newOrderRef.set(orderData);

      // Add each cart item under the current order reference
      for (CartItem item in items) {
        Map<String, dynamic> orderItemData = {
          'productId': item.productId,
          'productName': item.productName,
          'quantity': item.quantity,
          'price': item.price,
          'userName': item.userName,
          'userEmail': item.userEmail,
          'userPhone': item.userPhone,
        };

        // Add the order items to the current order node
        await newOrderRef.child('items').push().set(orderItemData);
      }

      print("Order created successfully with pending status.");
    } catch (e) {
      print("Failed to create order: $e");
    }
  }
}

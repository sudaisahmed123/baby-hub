import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/cart_item.dart';

class CartService {
  // Method to fetch cart items for a specific user
  Future<List<CartItem>> fetchCartItems(String userId) async {
    List<CartItem> cartItems = [];
    try {
      DatabaseReference cartRef = FirebaseDatabase.instance.ref('cartItems');
      DatabaseEvent event = await cartRef.orderByChild('userId').equalTo(userId).once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> items = event.snapshot.value as Map<dynamic, dynamic>;
        items.forEach((key, value) {
          cartItems.add(CartItem.fromMap(Map<String, dynamic>.from(value)));
        });
      }
    } catch (e) {
      print("Error fetching cart items: $e");
    }
    return cartItems;
  }

Future<void> deleteCartItems(String userId) async {
  try {
    DatabaseReference cartRef = FirebaseDatabase.instance.ref('cartItems');
    Query query = cartRef.orderByChild('userId').equalTo(userId);

    // Fetch data once to get the cart items
    DatabaseEvent event = await query.once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> items = event.snapshot.value as Map<dynamic, dynamic>;

      // Delete each cart item one by one
      for (var key in items.keys) {
        await cartRef.child(key).remove();  // Ensure this operation is completed before continuing
      }
      print("Cart items deleted successfully.");
    } else {
      print("No cart items found for user: $userId");
    }
  } catch (e) {
    print("Error deleting cart items: $e");
  }
}



}

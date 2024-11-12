import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/cart_item.dart';

class CartPage extends StatefulWidget {
  final String userId; // Pass the user ID to this widget

  const CartPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseReference _cartRef = FirebaseDatabase.instance.ref('carts');
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Do not fetch cart items here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading && widget.userId.isNotEmpty) {
      _fetchCartItems();
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      print("Fetching cart items for user ID: ${widget.userId}");

      DatabaseEvent event = await _cartRef.child(widget.userId).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        final cartData = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _cartItems = cartData.entries.map((cartEntry) {
            final data = cartEntry.value as Map<dynamic, dynamic>?;

            return CartItem.fromMap({
              'userId': widget.userId, // User ID remains the same
              'productId': cartEntry.key, // Assuming productId is the key
              'productName': data?['productName'] ?? 'Unknown Product',
              'quantity': data?['quantity'] ?? 0,
              'price': (data?['price'] ?? 0).toDouble(),
              'userName': data?['userName'] ?? '',
              'userEmail': data?['userEmail'] ?? '',
              'userPhone': data?['userPhone'] ?? '',
            });
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _cartItems = [];
          _isLoading = false;
        });
        print("No items found in the cart for this user.");
      }
    } catch (e) {
      print("Error fetching cart items: $e");
      setState(() {
        _isLoading = false;
      });
      // Move context usage here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart items: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'No items in the cart',
                    style: TextStyle(fontSize: 24),
                  ),
                )
              : ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = _cartItems[index];
                    return ListTile(
                      title: Text(cartItem.productName),
                      subtitle: Text('Quantity: ${cartItem.quantity} - Price: \$${cartItem.price}'),
                      trailing: Text(
                        'Total: \$${(cartItem.quantity * cartItem.price).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
    );
  }
}

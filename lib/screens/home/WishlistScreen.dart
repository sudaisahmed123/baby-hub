import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/screens/detail/detail_screen.dart';
import 'package:fresh_store_ui/model/product.dart';

class WishlistScreen extends StatefulWidget {
  static String route() => '/wishlist';

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Product> _wishlistItems = [];

  @override
  void initState() {
    super.initState();
    _fetchWishlistItems();
  }

  Future<void> _fetchWishlistItems() async {
    final user = _auth.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('favorites/${user.uid}');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        List<Product> items = [];
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          // Creating a Product object
          Product product = Product(
            id: value['productId'],
            productName: value['productName'],
            salePrice: value['price'],
            image: value['image'],
          );
          items.add(product);
        });

        setState(() {
          _wishlistItems = items;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.orange,
      ),
      body: _wishlistItems.isEmpty
          ? const Center(child: Text('No items in wishlist'))
          : ListView.builder(
              itemCount: _wishlistItems.length,
              itemBuilder: (context, index) {
                final product = _wishlistItems[index];
                return InkWell(
                  onTap: () => _navigateToShopDetailScreen(product),
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: product.image != null
                          ? Image.memory(
                              base64Decode(product.image!),
                              fit: BoxFit.cover,
                              width: 60,
                            )
                          : const Icon(Icons.image),
                      title: Text(product.productName ?? 'No name'),
                      subtitle: Text('Price: Rs ${product.salePrice ?? 'N/A'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFromWishlist(product.id),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _removeFromWishlist(String productId) async {
    final user = _auth.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('favorites/${user.uid}');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) async {
          if (value['productId'] == productId) {
            await ref.child(key).remove();
            _fetchWishlistItems(); // Refresh the wishlist
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item removed from wishlist')),
            );
          }
        });
      }
    }
  }

  // Navigate to ShopDetailScreen using the Product object
  void _navigateToShopDetailScreen(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopDetailScreen(product: product),
      ),
    );
  }
}

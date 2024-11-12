import 'dart:convert';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/cart_item.dart';
import 'package:fresh_store_ui/size_config.dart';
import 'package:fresh_store_ui/model/product.dart';
import 'package:firebase_database/firebase_database.dart';

class ShopDetailScreen extends StatefulWidget {
  final Product product;

  const ShopDetailScreen({super.key, required this.product});

  static String route() => '/shop_detail';

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  int _quantity = 1;
  bool _isCollected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: getProportionateScreenHeight(400),
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                        color: Colors.grey[300],
                      ),
                      child: widget.product.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                              child: Image.memory(
                                base64Decode(widget.product.image!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 16),
                        _buildColorOptions(),
                        const SizedBox(height: 16),
                        _buildDescription(),
                        const SizedBox(height: 24),
                        _buildQuantity(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildFloatBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.product.productName ?? 'No name available',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            overflow: TextOverflow.ellipsis,
          ),
        ),
           IconButton(
          onPressed: () {
            setState(() {
              _isCollected = !_isCollected;
            });
            if (_isCollected) {
              _addToFavorites(); // Add to favorites
            } else {
              // Optional: Add functionality to remove from favorites if needed
            }
          },
          icon: Icon(
            _isCollected ? Icons.favorite : Icons.favorite_border,
            color: _isCollected ? Colors.red : Colors.grey,
          ),
          iconSize: 28,
        ),
      ],
    );
  }

  Widget _buildColorOptions() {
    // This represents color selection options, if needed
    return Row(
      children: [
        _colorOption(Colors.green[200]!),
        const SizedBox(width: 8),
        _colorOption(Colors.brown[200]!),
        const SizedBox(width: 8),
        _colorOption(Colors.grey[400]!),
        const SizedBox(width: 8),
        _colorOption(Colors.orange[200]!),
      ],
    );
  }

  Widget _colorOption(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ExpandableText(
          '${widget.product.description}',
          expandText: 'view more',
          collapseText: 'view less',
          maxLines: 4,
          linkStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(width: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    child: Icon(Icons.remove, color: Colors.black54),
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() => _quantity -= 1);
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(width: 20),
                  InkWell(
                    child: Icon(Icons.add, color: Colors.black54),
                    onTap: () => setState(() => _quantity += 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          'Total: \$${(widget.product.salePrice ?? 0) * _quantity}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildFloatBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _quantity > 0 ? _addToCart : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, color: Colors.white),
              const SizedBox(width: 16),
              const Text(
                'Add to Cart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
Future<void> _addToCart() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
    DataSnapshot snapshot = await userRef.get();
    String userName = snapshot.child('username').value as String? ?? '';
    String userEmail = snapshot.child('email').value as String? ?? '';
    String userPhone = snapshot.child('phoneNumber').value as String? ?? '';

    // Get the product's image as a base64 encoded string
    String? productImage = widget.product.image; // This may be null

    // Create CartItem and handle image as nullable
    CartItem newItem = CartItem(
      userId: user.uid,
      productId: widget.product.id,
      productName: widget.product.productName ?? 'No name available',
      quantity: _quantity,
      price: widget.product.salePrice! * _quantity,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      image: productImage, // Pass the image field (can be null)
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref('cartItems');
    await ref.push().set(newItem.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newItem.productName} added to cart')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please log in to add items to the cart')),
    );
  }
}



  Future<void> _addToFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic> favoriteItem = {
        'userId': user.uid,
        'productId': widget.product.id,
        'productName': widget.product.productName ?? 'No name available',
        'quantity': _quantity,
        'price': widget.product.salePrice! * _quantity,
        'image': widget.product.image,
      };

      DatabaseReference ref = FirebaseDatabase.instance.ref('favorites/${user.uid}');
      await ref.push().set(favoriteItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );
    }
  }
}

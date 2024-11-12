import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/categoryProducts.dart';

class ViewProducts extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ViewProducts({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProducts> {
  final DatabaseReference _categoriesRef = FirebaseDatabase.instance.ref('categories');
  List<ProductCategory> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      print("Fetching products for category ID: ${widget.categoryId}");

      DatabaseEvent event = await _categoriesRef.child(widget.categoryId).child('products').once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        final productsData = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _products = productsData.entries.map((productEntry) {
            final data = productEntry.value as Map<dynamic, dynamic>?;

            return ProductCategory.fromMap({
              'id': productEntry.key,
              'name': data?['name'] ?? 'Unknown Product',
              'price': data?['price']?.toString() ?? '0',
              'image': data?['image'] ?? '',
            });
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _products = [];
          _isLoading = false;
        });
        print("No products found for this category.");
      }
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  Image? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    final decodedBytes = base64Decode(base64String);
    return Image.memory(decodedBytes, width: double.infinity, height: 150, fit: BoxFit.cover);
  }

  void addToCart(String productId) {
    // Implement the functionality to add the product to the cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product $productId added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in ${widget.categoryName}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text("No products available in this category."))
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      elevation: 8.0, // Box shadow added
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Border radius removed
                      ),
                      color: Colors.white, // Card color set to white
                      child: Column(
                        children: [
                          // Centered product image with increased width and height
                          Expanded(
                            child: Center(
                              child: product.image.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12.0)),
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        child: _decodeBase64Image(product.image),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(12.0)),
                                      ),
                                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                                    ),
                            ),
                          ),
                          // Product details
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.productName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  "Price: \$${product.price}",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Row for Add to Cart icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_shopping_cart, color: Colors.black), // Icon color changed to black
                                onPressed: () => addToCart(product.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

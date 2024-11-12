import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/categoryProducts.dart';

class ViewProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ViewProductsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
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
      }
    } catch (e) {
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

  void deleteProduct(String productId) async {
    try {
      await _categoriesRef.child(widget.categoryId).child('products').child(productId).remove();
      setState(() {
        _products.removeWhere((product) => product.id == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $error')),
      );
    }
  }

  void updateProduct(String productId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Update functionality for product $productId')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in ${widget.categoryName}'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
                      color: Colors.white,
                      elevation: 8.0,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                              child: product.image.isNotEmpty
                                  ? _decodeBase64Image(product.image)
                                  : Container(
                                      width: double.infinity,
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                                    ),
                            ),
                          ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.orange),
                                onPressed: () => deleteProduct(product.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => updateProduct(product.id),
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

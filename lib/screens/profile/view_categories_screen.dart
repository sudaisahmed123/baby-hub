import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/category1.dart';
import 'package:fresh_store_ui/screens/profile/ViewProductsScreen.dart';
import 'package:fresh_store_ui/screens/profile/add_category_screen.dart';
import 'product_form_screen.dart';
import 'dart:convert';

class ViewCategoriesScreen extends StatefulWidget {
  const ViewCategoriesScreen({Key? key}) : super(key: key);

  @override
  _ViewCategoriesScreenState createState() => _ViewCategoriesScreenState();
}

class _ViewCategoriesScreenState extends State<ViewCategoriesScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('categories');
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      DatabaseEvent event = await _dbRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        final categoriesData = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _categories = categoriesData.entries.map((entry) {
            final id = entry.key;
            final data = entry.value;

            return Category(
              id: id as String,
              name: data['name'] as String,
              icon: data['icon'] as String,
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _categories = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  Image _decodeBase64Image(String base64String) {
    final decodedBytes = base64Decode(base64String);
    return Image.memory(decodedBytes, width: 40, height: 40);
  }

  Future<void> _deleteCategory(String categoryId) async {
    try {
      await _dbRef.child(categoryId).remove();
      await _fetchCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted')),
      );
    } catch (e) {
      print("Error deleting category: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete category: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Categories'),
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
          : _categories.isEmpty
              ? const Center(child: Text('No categories found.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      color: Colors.white,
                      elevation: 6.0,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _decodeBase64Image(category.icon),
                          const SizedBox(height: 8.0),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.orange),
                                tooltip: 'Add Product',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductFormScreen(
                                        categoryId: category.id,
                                        categoryName: category.name,
                                        isUpdating: false,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                tooltip: 'Update Category',
                                onPressed: () {
                                  // Implement update category functionality
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.orange),
                                tooltip: 'Delete Category',
                                onPressed: () {
                                  _deleteCategory(category.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility, color: Colors.orange),
                                tooltip: 'View Products',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewProductsScreen(
                                        categoryId: category.id,
                                        categoryName: category.name,
                                      ),
                                    ),
                                  );
                                },
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

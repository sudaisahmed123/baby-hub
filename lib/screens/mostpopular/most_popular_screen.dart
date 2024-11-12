import 'package:flutter/material.dart';
import 'package:fresh_store_ui/components/app_bar.dart';
import 'package:fresh_store_ui/components/product_card.dart';
import 'package:fresh_store_ui/model/product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/popular.dart';
import 'package:fresh_store_ui/screens/detail/detail_screen.dart';
import 'package:fresh_store_ui/screens/home/most_popular.dart';

class MostPopularScreen extends StatefulWidget {
  const MostPopularScreen({super.key});

  static String route() => '/most_popular';

  @override
  State<MostPopularScreen> createState() => _MostPopularScreenState();
}

class _MostPopularScreenState extends State<MostPopularScreen> {
  final DatabaseReference _productRef = FirebaseDatabase.instance.ref('products');
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    try {
      final snapshot = await _productRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<Product> fetchedProducts = data.entries.map((e) {
          final productData = Map<String, dynamic>.from(e.value);
          return Product(
            productName: productData['productName'] ?? 'Unknown Product',
            brand: productData['brand'] ?? '',
            stock: productData['stock'] ?? '',
            salePrice: productData['salePrice'] ?? '',
            discount: productData['discount'] ?? '',
            image: productData['image'] ?? '',
            description: productData['description'] ?? '',
          );
        }).toList();

        setState(() {
          products = fetchedProducts;
          isLoading = false;
        });
      } else {
        print("No products found in the database.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      appBar: FRAppBar.defaultAppBar(
        context,
        title: 'Most Popular',
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/search@2x.png', scale: 2.0),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text("No products available"))
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: padding,
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => MostPupularCategory(),
                          childCount: 1,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: padding,
                      sliver: _buildPopulars(),
                    ),
                    const SliverAppBar(flexibleSpace: SizedBox(height: 24))
                  ],
                ),
    );
  }

  Widget _buildPopulars() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 185,
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
        mainAxisExtent: 285,
      ),
      delegate: SliverChildBuilderDelegate(
        _buildPopularItem,
        childCount: products.length,
      ),
    );
  }

  Widget _buildPopularItem(BuildContext context, int index) {
    final data = products[index];
    return ProductCard(
      data: data, // Pass product data here
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailScreen(product: data),
          ),
        );
      },
    );
  }
}

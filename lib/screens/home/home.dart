import 'package:flutter/material.dart';
import 'package:fresh_store_ui/components/product_card.dart';

import 'package:fresh_store_ui/screens/detail/detail_screen.dart';
import 'package:fresh_store_ui/screens/home/hearder.dart';
import 'package:fresh_store_ui/screens/home/most_popular.dart';
import 'package:fresh_store_ui/model/product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/screens/home/search_field.dart';
import 'package:fresh_store_ui/screens/home/special_offer.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  static String route() => '/home';

  const HomeScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> datas = [];
  List<Product> filteredProductsList = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final databaseReference = FirebaseDatabase.instance.ref("products");
    databaseReference.once().then((DatabaseEvent event) {
      final List<Product> loadedProducts = [];

      if (event.snapshot.value is Map<dynamic, dynamic>) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          try {
            loadedProducts.add(Product.fromMap(value, key));
          } catch (e) {
            print("Error parsing product data: $e");
          }
        });
      } else {
        print("Fetched data is not a valid Map");
      }

      setState(() {
        datas = loadedProducts;
        filteredProductsList = loadedProducts; // Initialize filtered list
      });
    }).catchError((error) {
      print("Error fetching products: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            flexibleSpace: HomeAppBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildBody(context),
                childCount: 1,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: _buildPopulars(),
          ),
          const SliverAppBar(flexibleSpace: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // Pass the products list and callback to the SearchField
        SearchField(
          products: datas, // Pass the fetched products list
          onFiltered: (filteredProducts) {
            setState(() {
              filteredProductsList = filteredProducts;
            });
          },
        ),
        const SizedBox(height: 24),
        SpecialOffers(onTapSeeAll: () => _onTapSpecialOffersSeeAll(context)),
        const SizedBox(height: 24),
        MostPopularTitle(onTapseeAll: () => _onTapMostPopularSeeAll(context)),
        const SizedBox(height: 24),
        const MostPupularCategory(),
      ],
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
        (context, index) {
          if (filteredProductsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = filteredProductsList[index % filteredProductsList.length];
          return ProductCard(
            data: data,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopDetailScreen(product: data),
                ),
              );
            },
          );
        },
        childCount: filteredProductsList.length,
      ),
    );
  }

  void _onTapMostPopularSeeAll(BuildContext context) {
    // Implement navigation to the most popular screen
  }

  void _onTapSpecialOffersSeeAll(BuildContext context) {
    // Implement navigation to the special offers screen
  }
}


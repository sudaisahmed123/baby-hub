import 'package:flutter/material.dart';
import 'package:fresh_store_ui/components/product_card.dart';
import 'package:fresh_store_ui/screens/detail/detail_screen.dart';
import 'package:fresh_store_ui/screens/home/most_popular.dart';
import 'package:fresh_store_ui/screens/home/search_field.dart';
import 'package:fresh_store_ui/screens/home/special_offer.dart';
import 'package:fresh_store_ui/model/product.dart';

class ProductScreen extends StatefulWidget {
  final List<Product> products; // Your list of products

  const ProductScreen({Key? key, required this.products}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> filteredProductsList = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered products list with the full products list
    filteredProductsList = widget.products;
  }

  // Function to handle filtered product list
  void _updateFilteredProducts(List<Product> filteredProducts) {
    setState(() {
      filteredProductsList = filteredProducts; // Update the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Search")),
      body: Column(
        children: [
          // Pass the products list and the callback to SearchField
          SearchField(
            products: widget.products, // Pass the list of products
            onFiltered: _updateFilteredProducts, // Update filtered products
          ),
          const SizedBox(height: 24),
          SpecialOffers(onTapSeeAll: () => _onTapSpecialOffersSeeAll(context)),
          const SizedBox(height: 24),
          MostPopularTitle(onTapseeAll: () => _onTapMostPopularSeeAll(context)),
          const SizedBox(height: 24),
          const MostPupularCategory(),
          const SizedBox(height: 24),
          // Display the filtered products using GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredProductsList.length, // Filtered products count
              itemBuilder: (context, index) {
                final product = filteredProductsList[index];
                return ProductCard(
                  data: product,
                  onTap: () {
                    // Handle product tap to navigate to product details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to handle "See All" for special offers
  void _onTapSpecialOffersSeeAll(BuildContext context) {
    // Your logic for "See All" for special offers
  }

  // Function to handle "See All" for most popular category
  void _onTapMostPopularSeeAll(BuildContext context) {
    // Your logic for "See All" for most popular category
  }
}

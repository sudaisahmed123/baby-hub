import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/product.dart';

class SearchField extends StatefulWidget {
  final List<Product> products;
  final Function(List<Product>) onFiltered;

  const SearchField({Key? key, required this.products, required this.onFiltered}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  // Function to filter products based on search query
  void _filterProducts(String query) {
    List<Product> filtered = widget.products.where((product) {
      return product.productName?.toLowerCase().contains(query.toLowerCase()) ?? false;
    }).toList();
    widget.onFiltered(filtered);
  }

  // Function to clear search text
  void _clearSearch() {
    _controller.clear();
    _filterProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.black], // Gradient from orange to black
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: _filterProducts,
          decoration: InputDecoration(
            hintText: 'Search for products...',
            hintStyle: const TextStyle(color: Colors.white), // Change hint text color to white
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.white), // Change icon color to white
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white), // Change clear icon color to white
                    onPressed: _clearSearch,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

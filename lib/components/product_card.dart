import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/product.dart';
import 'package:fresh_store_ui/screens/detail/detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final VoidCallback onTap;

  const ProductCard({Key? key, required this.data, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.45, // Responsive width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            data.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      child: Image.memory(
                        base64Decode(data.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 12),

            // Product Name
            Text(
              data.productName ?? 'No Product Name',
              style: const TextStyle(
                color: Color(0xFF212121),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 8),

            // Sold Point
            _buildSoldPoint(4.5, 6937),
            const SizedBox(height: 8),

            // Price and Button Row
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rs ${data.salePrice ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetailScreen(product: data),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Star Rating and Sold Count Widget
  Widget _buildSoldPoint(double star, int sold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/icons/start@2x.png', width: 20, height: 20),
        const SizedBox(width: 5),
        Text(
          '$star',
          style: const TextStyle(
            color: Color(0xFF616161),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            '$sold sold',
            style: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/firebase_product.dart'; // Adjust import based on your project structure
import 'dart:convert';
import 'dart:typed_data';

class CustomProductCard extends StatelessWidget {
  final FirebaseProduct data;
  final Function(FirebaseProduct) onTap;

  const CustomProductCard({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;

    // Check if the image string is base64 and decode it
    if (data.image.isNotEmpty && (data.image.startsWith('data:image/') || data.image.startsWith('data:image;base64,'))) {
      try {
        String base64String = data.image.split(',').last; // Remove prefix if necessary
        imageBytes = base64.decode(base64String);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return GestureDetector(
      onTap: () => onTap(data),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/placeholder.png', // Fallback if no image
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.productName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$${data.salePrice.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

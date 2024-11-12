import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ProductFormScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final bool isUpdating;

  const ProductFormScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.isUpdating,
  }) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _base64Image;

  Future<void> _addProduct() async {
    String productName = _productNameController.text.trim();
    String productPrice = _productPriceController.text.trim();

    if (productName.isNotEmpty && productPrice.isNotEmpty && _base64Image != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('categories/${widget.categoryId}/products');
      DatabaseReference newProductRef = ref.push();
      await newProductRef.set({
        'id': newProductRef.key,
        'name': productName,
        'price': productPrice,
        'image': _base64Image,
      });

      _productNameController.clear();
      _productPriceController.clear();
      setState(() {
        _base64Image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _addProduct,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSelectionWidget(
              base64Image: _base64Image,
              onImageSelected: _selectImage,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                prefixIcon: IconTheme(
                  data: IconThemeData(color: Colors.orange), // Orange icon color
                  child: Icon(Icons.shopping_bag),
                ),
                border: UnderlineInputBorder(), // Underline border
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _productPriceController,
              decoration: const InputDecoration(
                labelText: 'Product Price',
                prefixIcon: IconTheme(
                  data: IconThemeData(color: Colors.orange), // Orange icon color
                  child: Icon(Icons.attach_money),
                ),
                border: UnderlineInputBorder(), // Underline border
              ),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            Center(
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.black],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ImageSelectionWidget extends StatelessWidget {
  final String? base64Image;
  final Future<void> Function() onImageSelected;

  const ImageSelectionWidget({
    Key? key,
    required this.base64Image,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (base64Image != null)
          Image.memory(
            base64Decode(base64Image!),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.black],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: onImageSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Select Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

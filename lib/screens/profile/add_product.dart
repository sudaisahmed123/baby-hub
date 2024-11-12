import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fresh_store_ui/controllers/product_controller.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? selectedImage;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = pickedImage;
    });
  }

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a Photo'),
            onTap: () async {
              final pickedImage = await _picker.pickImage(source: ImageSource.camera);
              setState(() {
                selectedImage = pickedImage;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () async {
              await _pickImage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      double? salePrice = double.tryParse(salePriceController.text);
      if (salePrice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid sale price")),
        );
        return;
      }

      Product product = Product(
        productName: productNameController.text,
        brand: brandController.text,
        stock: stockController.text,
        salePrice: salePrice,
        discount: discountController.text,
        description: descriptionController.text,
        image: selectedImage != null ? await _encodeImageToBase64(selectedImage!) : null,
      );

      try {
        await _productController.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product added successfully!")),
        );
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding product: $e")),
        );
      }
    }
  }

  Future<String> _encodeImageToBase64(XFile image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  void _clearFields() {
    productNameController.clear();
    brandController.clear();
    stockController.clear();
    salePriceController.clear();
    discountController.clear();
    descriptionController.clear();
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
        elevation: 1,
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField("Product Name*", productNameController, Icons.production_quantity_limits),
                _buildTextField("Brand", brandController, Icons.branding_watermark),
                _buildTextField("Stock*", stockController, Icons.inventory),
                _buildTextField("Sale Price*", salePriceController, Icons.price_check),
                _buildTextField("Discount", discountController, Icons.discount),
                _buildTextField("Description*", descriptionController, Icons.description),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _showImageSourceOptions,
                  child: selectedImage == null ? _buildImagePlaceholder() : _buildImageDisplay(),
                ),
                const SizedBox(height: 20),
                _buildGradientButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.orange),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildImageDisplay() {
    return FutureBuilder<Uint8List>(
      future: selectedImage!.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading image');
        } else if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          );
        } else {
          return _buildImagePlaceholder();
        }
      },
    );
  }

  Widget _buildGradientButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _uploadProduct,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Save & Publish",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

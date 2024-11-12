import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DatabaseReference _productRef = FirebaseDatabase.instance.ref('products');
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

void _fetchProducts() async {
  final snapshot = await _productRef.get();
  if (snapshot.exists) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    setState(() {
      products = data.entries.map((e) {
        final productData = Map<String, dynamic>.from(e.value);
        return Product(
          id: e.key, // Firebase ki key ko id ke taur par set kar rahe hain
          productName: productData['productName'] ?? 'Unknown Product',
          brand: productData['brand'] ?? '',
          stock: productData['stock'] ?? '',
          salePrice: productData['salePrice'] ?? '',
          discount: productData['discount'] ?? '',
          image: productData['image'] ?? '',
          description: productData['description'] ?? '',
        );
      }).toList();
    });
  }
}


  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product.productName ?? 'Product Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Category: ${product.description ?? 'Unknown Category'}'),
                Text('Brand: ${product.brand ?? 'Unknown Brand'}'),
                Text('Stock: ${product.stock ?? 'Unknown'}'),
                Text('Sale Price: \$${product.salePrice ?? 'Unknown'}'),
                Text('Discount: ${product.discount ?? 'No Discount'}%'),
                product.image != null
                    ? Image.memory(base64Decode(product.image!))
                    : SizedBox.shrink(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

void _deleteProduct(String productId) {
  if (productId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product ID is missing!')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _productRef.child(productId).remove();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product deleted successfully!'))
                );
                _fetchProducts(); // Refresh the product list
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete product: $error'))
                );
              }
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


void _updateProduct(Product product) {
  TextEditingController nameController = TextEditingController(text: product.productName);
  TextEditingController brandController = TextEditingController(text: product.brand);
  TextEditingController stockController = TextEditingController(text: product.stock);
  TextEditingController priceController = TextEditingController(text: product.salePrice.toString());
  TextEditingController discountController = TextEditingController(text: product.discount);
  TextEditingController descriptionController = TextEditingController(text: product.description);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update Product'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameController, 'Product Name', Icons.shopping_bag),
              _buildTextField(brandController, 'Brand', Icons.branding_watermark),
              _buildTextField(stockController, 'Stock', Icons.inventory),
              _buildTextField(priceController, 'Sale Price', Icons.attach_money, isNumber: true),
              _buildTextField(discountController, 'Discount', Icons.percent),
              _buildTextField(descriptionController, 'Description', Icons.description),
            ],
          ),
        ),
        actions: [
      TextButton(
  onPressed: () => Navigator.pop(context),
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero, // Remove default padding
  ),
  child: Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orange, Colors.black],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.center,
      child: Text(
        'Cancel',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  ),
),

         TextButton(
  onPressed: () async {
    try {
      await _productRef.child(product.id).update({
        'productName': nameController.text,
        'brand': brandController.text,
        'stock': stockController.text,
        'salePrice': double.tryParse(priceController.text) ?? 0.0,
        'discount': discountController.text,
        'description': descriptionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );

      _fetchProducts();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: $error')),
      );
    }

    Navigator.pop(context);
  },
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero, // Remove default padding
  ),
  child: Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orange, Colors.black],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.center,
      child: Text(
        'Update',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  ),
),

        ],
      );
    },
  );
}

Widget _buildTextField(
  TextEditingController controller,
  String labelText,
  IconData icon, {
  bool isNumber = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0), // Increase vertical space between fields
    child: TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.orange),
        // Both focused and enabled borders now have an underline
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange), // Default border color
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange), // Focused border color
        ),
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.white, // Card color set to white
                  shadowColor: Colors.black.withOpacity(0.2), // Box shadow color
                  child: ListTile(
                    leading: product.image != null
                        ? Image.memory(base64Decode(product.image!))
                        : Icon(Icons.image),
                    title: Text(product.productName ?? 'Unknown Product'),
                    subtitle: Text(product.description ?? 'Unknown Category'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.info, color: Colors.orange), // Icon color set to orange
                          onPressed: () => _showProductDetails(product),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange), // Icon color set to orange
                          onPressed: () => _updateProduct(product),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.orange), // Icon color set to orange
                          onPressed: () => _deleteProduct(product.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

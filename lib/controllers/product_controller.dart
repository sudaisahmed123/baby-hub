import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/product.dart';

class ProductController {
  final DatabaseReference _productRef = FirebaseDatabase.instance.ref().child('products');

  Future<void> addProduct(Product product) async {
    await _productRef.push().set(product.toMap());
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_store_ui/model/product.dart';

class ProductDetailArguments {
  final Product product;
  final User? user;

  ProductDetailArguments({
    required this.product,
    required this.user,
  });
}

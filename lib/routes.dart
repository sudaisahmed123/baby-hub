import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/product.dart';
import 'package:fresh_store_ui/screens/action/login_screen.dart';
import 'package:fresh_store_ui/screens/action/signup_screen.dart';
import 'package:fresh_store_ui/screens/detail/detail_screen.dart';
import 'package:fresh_store_ui/screens/home/WishlistScreen.dart';
import 'package:fresh_store_ui/screens/home/home.dart';
import 'package:fresh_store_ui/screens/mostpopular/most_popular_screen.dart';
import 'package:fresh_store_ui/screens/profile/OrderScreen.dart';
import 'package:fresh_store_ui/screens/profile/add_category_screen.dart';
import 'package:fresh_store_ui/screens/profile/approved.dart';
import 'package:fresh_store_ui/screens/profile/delivered.dart';
import 'package:fresh_store_ui/screens/profile/order_detail_screen.dart';
import 'package:fresh_store_ui/screens/profile/profile_screen.dart';
import 'package:fresh_store_ui/screens/profile/reject.dart';
import 'package:fresh_store_ui/screens/profile/view_categories_screen.dart';
import 'package:fresh_store_ui/screens/profile/view_product.dart';
import 'package:fresh_store_ui/screens/special_offers/special_offers_screen.dart';
import 'package:fresh_store_ui/screens/test/test_screen.dart';
import 'package:fresh_store_ui/screens/profile/add_product.dart';

final Map<String, WidgetBuilder> appRoutes = { // Renamed to appRoutes
  HomeScreen.route(): (context) => const HomeScreen(title: '123'),
  MostPopularScreen.route(): (context) => const MostPopularScreen(),
  SpecialOfferScreen.route(): (context) => const SpecialOfferScreen(),
  ProfileScreen.route(): (context) => const ProfileScreen(),
   ShopDetailScreen.route(): (context) => ShopDetailScreen(product: ModalRoute.of(context)!.settings.arguments as Product),
  TestScreen.route(): (context) => const TestScreen(),
  '/addProduct': (context) => AddProductScreen(),
  '/login': (context) => LoginScreen(),
  '/signup': (context) => SignUpScreen(),
   '/viewproduct': (context) => ProductListScreen(),
   '/addcategorie': (context) => AddCategoryScreen(),
   '/viewcategorie': (context) => ViewCategoriesScreen(),
    '/orderdetails': (context) => OrderDetailScreen(),
    '/approvedetails': (context) => ApprovedScreen(),
     '/deliverdetails': (context) => DeliveredScreen(),
      '/rejectdetails': (context) => RejectedScreen(),
   WishlistScreen.route(): (context) => WishlistScreen(),


};

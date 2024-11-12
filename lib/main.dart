import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresh_store_ui/routes.dart';
import 'package:fresh_store_ui/screens/tabbar/tabbar.dart';
import 'package:fresh_store_ui/theme.dart';
import 'package:fresh_store_ui/screens/action/login_screen.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Database
import 'authentication_wrapper.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAG7DRcw5XiSm8PQfLtdGZcrz51HSdTN0I",
          authDomain: "babyshop-6a6f2.firebaseapp.com",
          projectId: "babyshop-6a6f2",
          storageBucket: "babyshop-6a6f2.appspot.com",
          messagingSenderId: "933543459060",
          appId: "1:933543459060:web:25bea9f44bdd04cbb006a1",
          databaseURL: "https://babyshop-6a6f2-default-rtdb.firebaseio.com",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Hub',
      theme: appTheme(),
      home: AuthenticationWrapper(),
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
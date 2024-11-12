import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore dependency
import 'screens/action/login_screen.dart'; // Correct path to your LoginScreen
import 'package:fresh_store_ui/screens/tabbar/tabbar.dart';
import 'package:fresh_store_ui/screens/admin_dashboard.dart'; // Import your Admin Dashboard screen

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data; // Get the user object
          if (user == null) {
            // If the user is not signed in, show the login screen
            return LoginScreen();
          } else {
            // If the user is signed in, check their role
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(), // Fetch user role from Firestore
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading spinner while waiting for the role to load
                  return Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasError) {
                  // Handle errors
                  return Center(child: Text('Error fetching role'));
                } else if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
                  String userRole = roleSnapshot.data!.get('role'); // Assuming the field name is 'role'
                  
                  if (userRole == 'admin') {
                    return FRTabbarScreen(); // Redirect to admin dashboard
                  } else {
                    return const FRTabbarScreen(); // Redirect to user main app screen
                  }
                } else {
                  return Center(child: Text('User role not found'));
                }
              },
            );
          }
        } else {
          // Show a loading spinner while waiting for auth state to load
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

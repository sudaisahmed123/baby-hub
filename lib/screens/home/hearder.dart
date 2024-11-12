import 'package:flutter/material.dart';
import 'package:fresh_store_ui/constants.dart';
import 'package:fresh_store_ui/screens/home/WishlistScreen.dart';
import 'package:fresh_store_ui/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _currentUser = _auth.currentUser; // Get the current user

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange,
            Colors.black87, // Lighter shade of black
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              onTap: () => Navigator.pushNamed(context, ProfileScreen.route()),
              child: const CircleAvatar(
                backgroundImage: AssetImage('$kIconPath/profile@2x.png'),
                radius: 24,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Baby Hub Shop 👋',
                      style: TextStyle(
                        color: Colors.white, // Text color changed to white
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Display the user's email or username
                    Text(
                      _currentUser?.email ?? 'Guest',
                      style: const TextStyle(
                        color: Colors.white, // Text color changed to white
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              iconSize: 28,
              icon: Image.asset(
                '$kIconPath2/notification.png',
                color: Colors.white, // Icon color changed to white
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
       IconButton(
  iconSize: 28,
  icon: Image.asset(
    '$kIconPath2/light/heart@2x.png',
    color: Colors.white,
  ),
  onPressed: () {
    Navigator.pushNamed(context, WishlistScreen.route());
  },
),


          ],
        ),
      ),
    );
  }
}

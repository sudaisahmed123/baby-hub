import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileHeader({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.orange),
                  iconSize: 28,
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                ),
                Image.asset('assets/icons/profile/logo@2x.png', scale: 2),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black color for better contrast
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 28,
                  icon: Image.asset(
                    'assets/icons/tabbar/light/more_circle@2x.png',
                    scale: 2,
                    color: Colors.orange, // Set icon color to orange
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Stack(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/icons/tabbar/light/profile@2x.png'),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    child: Image.asset(
                      'assets/icons/profile/edit_square@2x.png',
                      scale: 2,
                      color: Colors.orange, // Set icon color to orange
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black, // Black color for name text
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey, // Grey color for email
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              color: const Color(0xFFCCCCCC),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

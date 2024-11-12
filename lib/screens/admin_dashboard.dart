import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add logout functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DashboardCard(title: 'Total Users', count: '150'),
                DashboardCard(title: 'Total Orders', count: '75'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DashboardCard(title: 'Total Revenue', count: '\$1,200'),
                DashboardCard(title: 'Pending Requests', count: '5'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('User Management'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to user management screen
                    },
                  ),
                  ListTile(
                    title: const Text('Order Management'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to order management screen
                    },
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to settings screen
                    },
                  ),
                  // Add more options as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String count;

  const DashboardCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

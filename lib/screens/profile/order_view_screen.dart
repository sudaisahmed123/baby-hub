import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderViewScreen extends StatelessWidget {
  final String userId;
  final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');

  OrderViewScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 100, 0), // Orange
                Color.fromARGB(255, 0, 0, 0), // Black
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Page background color
        child: StreamBuilder(
          stream: ordersRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              final Map<dynamic, dynamic> ordersData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              final List<Map<String, dynamic>> userOrders = [];

              // Filter orders to include only orders for the logged-in user
              ordersData.forEach((key, value) {
                final order = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
                if (order['userId'] == userId) {
                  userOrders.add({
                    'orderId': key,
                    ...order,
                  });
                }
              });

              if (userOrders.isEmpty) {
                return const Center(child: Text('No orders available.', style: TextStyle(color: Colors.black)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: userOrders.length,
                itemBuilder: (context, index) {
                  final order = userOrders[index];
                  final List<dynamic> items = (order['items'] is Map)
                      ? (order['items'] as Map).values.toList()
                      : [];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    color: Colors.white, // Card color
                    shadowColor: Colors.black.withOpacity(0.7), // Box shadow
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${order['orderId']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Name: ${order['name']}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                          Text('Total Price: ${order['totalPrice']}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          const Text(
                            'Items:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          // Display each item in the order
                          for (var item in items)
                            if (item is Map)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '${item['productName']} - Qty: ${item['quantity']}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                          const SizedBox(height: 8),
                          // Display the order status in red
                          Text(
                            'Status: ${order['status']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No orders available.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderDetailScreen extends StatelessWidget {
  final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');

  OrderDetailScreen({Key? key}) : super(key: key);

  // Function to update order status in Firebase
  void updateOrderStatus(String orderId, String newStatus) {
    ordersRef.child(orderId).update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: ordersRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            final Map<dynamic, dynamic> ordersData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final List<Map<String, dynamic>> pendingOrders = [];

            // Filter orders with status "Pending"
            ordersData.forEach((key, value) {
              final order = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
              if (order['status'] == 'pending') {
                pendingOrders.add({
                  'orderId': key,
                  ...order,
                });
              }
            });

            if (pendingOrders.isEmpty) {
              return const Center(child: Text('No pending orders available.'));
            }

            return ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final order = pendingOrders[index];
                final List<dynamic> items = (order['items'] is Map)
                    ? (order['items'] as Map).values.toList()
                    : [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Order ID: ${order['orderId']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${order['name']}'),
                        Text('Total Price: ${order['totalPrice']}'),
                        Text(
                          'Status: ${order['status'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.red),
                        ), // Display order status in red color
                        const SizedBox(height: 8),
                        const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                        // Display each item in the order
                        for (var item in items)
                          if (item is Map)
                            Text(
                              '${item['productName']} - Qty: ${item['quantity']}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.orange),
                          onPressed: () {
                            updateOrderStatus(order['orderId'], 'Approved');
                          },
                          tooltip: 'Mark as Approved',
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            updateOrderStatus(order['orderId'], 'Rejected');
                          },
                          tooltip: 'Mark as Rejected',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No pending orders available.'));
          }
        },
      ),
    );
  }
}

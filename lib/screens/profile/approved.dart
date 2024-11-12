import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ApprovedScreen extends StatelessWidget {
  final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');

  ApprovedScreen({Key? key}) : super(key: key);

  // Function to update order status in Firebase
  void updateOrderStatus(String orderId, String newStatus) {
    ordersRef.child(orderId).update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approved Orders'),
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
            final List<Map<String, dynamic>> approvedOrders = [];

            // Filter orders with status "Approved"
            ordersData.forEach((key, value) {
              final order = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
              if (order['status'] == 'Approved') {
                approvedOrders.add({
                  'orderId': key,
                  ...order,
                });
              }
            });

            if (approvedOrders.isEmpty) {
              return const Center(child: Text('No approved orders available.'));
            }

            return ListView.builder(
              itemCount: approvedOrders.length,
              itemBuilder: (context, index) {
                final order = approvedOrders[index];
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
                          'Status: ${order['status']}',
                          style: const TextStyle(color: Colors.green),
                        ),
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
                          icon: const Icon(Icons.local_shipping, color: Colors.orange),
                          onPressed: () {
                            updateOrderStatus(order['orderId'], 'Delivered');
                          },
                          tooltip: 'Mark as Delivered',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No approved orders available.'));
          }
        },
      ),
    );
  }
}

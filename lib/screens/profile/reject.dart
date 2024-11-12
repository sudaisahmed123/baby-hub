import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RejectedScreen extends StatelessWidget {
  final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');

  RejectedScreen({Key? key}) : super(key: key);

  // Function to update order status in Firebase
  void updateOrderStatus(String orderId, String newStatus) {
    ordersRef.child(orderId).update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected Orders'),
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
            final List<Map<String, dynamic>> rejectedOrders = [];

            // Filter orders with status "Rejected"
            ordersData.forEach((key, value) {
              final order = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
              if (order['status'] == 'Rejected') {
                rejectedOrders.add({
                  'orderId': key,
                  ...order,
                });
              }
            });

            if (rejectedOrders.isEmpty) {
              return const Center(child: Text('No rejected orders available.'));
            }

            return ListView.builder(
              itemCount: rejectedOrders.length,
              itemBuilder: (context, index) {
                final order = rejectedOrders[index];
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
                          style: const TextStyle(color: Colors.red),
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
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order is rejected.')),
                        );
                      },
                      tooltip: 'Rejected',
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No rejected orders available.'));
          }
        },
      ),
    );
  }
}

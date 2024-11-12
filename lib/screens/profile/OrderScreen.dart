import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/cart_item.dart';

class OrderScreen extends StatefulWidget {
  final String userId;

  const OrderScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();

  static route({required userId}) {}
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      DatabaseReference ordersRef = _database.ref().child('orders');
      final snapshot = await ordersRef.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> orders = [];
        Map<String, dynamic> data = Map.from(snapshot.value as Map);
        
        // Iterate through the orders data and add to list
        data.forEach((key, value) {
          orders.add(Map.from(value));
        });

        setState(() {
          _orders = orders;
        });
      } else {
        setState(() {
          _orders = [];
        });
      }
    } catch (e) {
      print('Failed to fetch orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _orders.isEmpty
          ? const Center(child: Text('No orders found'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Date: ${order['orderDate']}'),
                        Text('Total Price: \$${order['totalPrice']}'),
                        const SizedBox(height: 10),
                        Text('Address: ${order['address']}'),
                        const SizedBox(height: 10),
                        Text('Name: ${order['name']}'),
                        Text('Email: ${order['email']}'),
                        Text('Phone: ${order['phone']}'),
                        const SizedBox(height: 10),
                        // Display the items for this order
                        const Text('Items:'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (order['items'] as List).length,
                          itemBuilder: (context, itemIndex) {
                            final item = (order['items'] as List)[itemIndex];
                            return ListTile(
                              title: Text(item['productName']),
                              subtitle: Text(
                                  'Quantity: ${item['quantity']} - Price: \$${item['price']}'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

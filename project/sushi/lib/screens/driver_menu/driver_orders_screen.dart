import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../widgets/app_colors.dart';

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('My Deliveries', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('driverId', isEqualTo: uid)
            .where('status', isEqualTo: OrderStatus.delivered.name)
            .snapshots(), // Removed orderBy temporarily to fix immediate crash/disappear
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Error: ${snapshot.error}\n\nPlease check if Firestore index is missing in Console.', 
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF4A73D)));
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No completed deliveries yet.'));
          }

          // Sort manually in memory to avoid needing a complex index for now
          final orders = snapshot.data!.docs.map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                  title: Text('Order #${o.id.substring(0, 5)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(DateFormat('MMM dd, yyyy • hh:mm a').format(o.createdAt), style: const TextStyle(fontSize: 12)),
                  trailing: Text('${o.totalAmount.toStringAsFixed(2)} EGP', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

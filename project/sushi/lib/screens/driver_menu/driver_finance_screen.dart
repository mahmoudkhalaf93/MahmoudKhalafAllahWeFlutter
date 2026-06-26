import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../widgets/app_colors.dart';

class DriverFinanceScreen extends StatelessWidget {
  const DriverFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('My Finance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('driverId', isEqualTo: uid)
            .where('status', isEqualTo: OrderStatus.delivered.name)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFF4A73D)));
          
          final orders = snapshot.data!.docs.map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();

          double totalCollected = 0;
          for (var o in orders) {
            totalCollected += o.totalAmount;
          }

          if (orders.isEmpty) {
            return const Center(child: Text('No financial records found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Unified Finance Card
              _buildFinanceCard('Total Paid to Company', totalCollected, Colors.green, Icons.account_balance_wallet_outlined),
              
              const SizedBox(height: 40),
              const Text('Finance Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              
              ...orders.map((o) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Order #${o.id.substring(0, 5)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('MMM dd, yyyy • hh:mm a').format(o.createdAt)),
                trailing: Text('${o.totalAmount.toStringAsFixed(2)} EGP', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFinanceCard(String title, double amount, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Text(
            '${amount.toStringAsFixed(2)} EGP', 
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

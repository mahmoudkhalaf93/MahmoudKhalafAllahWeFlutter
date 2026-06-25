import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../widgets/app_colors.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../blocs/orders/orders_state.dart';
import '../../models/order_model.dart';
import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) return const Center(child: CircularProgressIndicator());
          if (state is OrdersError) return Center(child: Text(state.message));
          if (state is OrdersLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.activeOrders.isNotEmpty) ...[
                  const Text('ACTIVE ORDERS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  ...state.activeOrders.map((o) => _buildOrderCard(o, true)),
                  const SizedBox(height: 20),
                ],
                if (state.historyOrders.isNotEmpty) ...[
                  const Text('PAST ORDERS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  ...state.historyOrders.map((o) => _buildOrderCard(o, false)),
                ],
                if (state.activeOrders.isEmpty && state.historyOrders.isEmpty)
                  const Center(child: Text('No orders found yet.')),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isActive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.lightOrange.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(isActive ? Icons.moped : Icons.history, color: AppColors.lightOrange),
        ),
        title: Text('Order #${order.id.substring(0, 5)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${order.items.length} items • ${order.totalAmount.toStringAsFixed(2)} EGP'),
            Text(DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt), style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                order.status.name.toUpperCase().replaceAll('_', ' '),
                style: TextStyle(color: _getStatusColor(order.status), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
            if (isActive) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: () {
          if (isActive) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: order.id)));
          }
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelledByCustomer:
      case OrderStatus.cancelledByRestaurant:
      case OrderStatus.failedDelivery: return Colors.red;
      case OrderStatus.pending: return Colors.orange;
      default: return Colors.blue;
    }
  }
}

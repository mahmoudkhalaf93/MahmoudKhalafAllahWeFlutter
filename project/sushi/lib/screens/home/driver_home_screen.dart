import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/app_colors.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../models/restaurant_model.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../screens/auth/welcome_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  StreamSubscription<Position>? _locationSubscription;
  String? _activeOrderId;
  Position? _currentPosition;
  RestaurantModel? _restaurant;
  bool _isViewingActiveOrder = false;

  @override
  void initState() {
    super.initState();
    _loadRestaurantInfo();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _loadRestaurantInfo() async {
    final doc = await FirebaseFirestore.instance.collection('restaurants').doc('sushir12').get();
    if (doc.exists) {
      setState(() => _restaurant = RestaurantModel.fromJson(doc.data()!));
    }
  }

  void _startLocationUpdates() {
    late LocationSettings locationSettings;
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        intervalDuration: const Duration(seconds: 5),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Tracking location for delivery",
          notificationTitle: "Sushi Delivery",
          enableWakeLock: true,
        ),
      );
    } else {
      locationSettings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 0);
    }

    _locationSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      if (mounted) setState(() => _currentPosition = position);
      
      final authState = context.read<AuthCubit>().state;
      final uid = authState is Authenticated ? authState.user.uid : FirebaseAuth.instance.currentUser?.uid;
      
      if (uid != null) {
        final geoPoint = GeoPoint(position.latitude, position.longitude);
        
        // 1. Update Global Driver Location
        FirebaseFirestore.instance.collection('DeliveryDrivers').doc(uid).set({
          'location': geoPoint,
          'lastUpdate': FieldValue.serverTimestamp(),
          'isOnline': true,
        }, SetOptions(merge: true));

        // 2. Automatically update Active Order if accepted
        if (_activeOrderId != null) {
          FirebaseFirestore.instance.collection('orders').doc(_activeOrderId).update({
            'driverLocation': geoPoint,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
          
          final authState = context.read<AuthCubit>().state;
          final String? uid = authState is Authenticated ? authState.user.uid : FirebaseAuth.instance.currentUser?.uid;

          if (uid == null) return const Scaffold(body: Center(child: Text('Not authenticated')));

          final allOrders = snapshot.data!.docs.map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();

          final availableOrders = allOrders.where((o) => o.status == OrderStatus.readyForPickup && o.driverId == null).toList();
          final myActiveOrders = allOrders.where((o) => o.driverId == uid && o.status.index < OrderStatus.delivered.index).toList();

          OrderModel? activeOrder;
          if (myActiveOrders.isNotEmpty) {
            activeOrder = myActiveOrders.first;
            _activeOrderId = activeOrder.id;
          } else {
            _activeOrderId = null;
            _isViewingActiveOrder = false;
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            appBar: AppBar(
              title: Text(_isViewingActiveOrder ? 'Active Task' : 'Driver Dashboard', 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: const Color(0xFFF4A73D),
              elevation: 0,
              leading: _isViewingActiveOrder 
                ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => setState(() => _isViewingActiveOrder = false))
                : null,
            ),
            drawer: _isViewingActiveOrder ? null : _buildDriverDrawer(),
            body: (_isViewingActiveOrder && activeOrder != null)
                ? _buildActiveOrderWorkflow(activeOrder)
                : _buildAvailableOrdersList(availableOrders, myActiveOrders),
          );
        },
      ),
    );
  }

  Widget _buildAvailableOrdersList(List<OrderModel> available, List<OrderModel> mine) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (mine.isNotEmpty) ...[
          const Text('CURRENT TASK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 10),
          ...mine.map((o) => _buildActiveOrderCard(o)),
          const SizedBox(height: 30),
        ],
        const Text('READY FOR PICKUP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        if (available.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No orders available.')))
        else
          ...available.map((o) => _buildSimpleOrderCard(o)),
      ],
    );
  }

  Widget _buildActiveOrderCard(OrderModel order) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text('Order #${order.id.substring(0, 5)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Status: ${order.status.name.toUpperCase()}'),
        trailing: const Icon(Icons.map, color: Color(0xFFF4A73D)),
        onTap: () => setState(() => _isViewingActiveOrder = true),
      ),
    );
  }

  Widget _buildSimpleOrderCard(OrderModel order) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text('Order #${order.id.substring(0, 5)}'),
        subtitle: Text('${order.totalAmount} EGP'),
        trailing: ElevatedButton(
          onPressed: () => _updateOrderStatus(order.id, OrderStatus.driverAssigned),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF4A73D)),
          child: const Text('ACCEPT', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildActiveOrderWorkflow(OrderModel order) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(order.deliveryLocation?.latitude ?? 30.0, order.deliveryLocation?.longitude ?? 31.0),
              zoom: 12,
            ),
            markers: {
              if (_currentPosition != null)
                Marker(markerId: const MarkerId('driver'), position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)),
              if (_restaurant?.branches != null)
                Marker(markerId: const MarkerId('restaurant'), position: LatLng(_restaurant!.branches![0].location!.latitude, _restaurant!.branches![0].location!.longitude), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
              if (order.deliveryLocation != null)
                Marker(markerId: const MarkerId('customer'), position: LatLng(order.deliveryLocation!.latitude, order.deliveryLocation!.longitude), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            children: [
              // Standardized Tracking UI for Driver
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.lightOrange.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(_getStatusIcon(order.status), color: AppColors.lightOrange, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.status.name.toUpperCase().replaceAll('_', ' '), 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Order #${order.id.substring(0, 5)}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: (order.status.index + 1) / (OrderStatus.delivered.index + 1),
                backgroundColor: Colors.grey.shade200,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
                valueColor: const AlwaysStoppedAnimation(AppColors.lightOrange),
              ),
              const Divider(height: 40),
              _buildCustomerInfo(order.userId),
              const SizedBox(height: 20),
              _buildWorkflowButton(order),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    if (status.index <= OrderStatus.readyForPickup.index) return Icons.restaurant;
    if (status.index <= OrderStatus.arrivedAtCustomer.index) return Icons.delivery_dining;
    return Icons.check_circle;
  }

  Widget _buildCustomerInfo(String userId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final customer = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
        return Row(
          children: [
            CircleAvatar(backgroundImage: customer.image != null ? NetworkImage(customer.image!) : null),
            const SizedBox(width: 15),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(customer.name ?? 'Customer', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(customer.phone ?? 'No phone', style: const TextStyle(color: Colors.grey)),
              ])),
            IconButton(icon: const Icon(Icons.phone, color: Colors.green), onPressed: () => _launchCaller(customer.phone)),
          ],
        );
      },
    );
  }

  Widget _buildWorkflowButton(OrderModel order) {
    String label = "";
    OrderStatus nextStatus = order.status;

    switch (order.status) {
      case OrderStatus.readyForPickup: label = "ACCEPT ORDER"; nextStatus = OrderStatus.driverAssigned; break;
      case OrderStatus.driverAssigned: label = "ARRIVED AT RESTAURANT"; nextStatus = OrderStatus.arrivedAtRestaurant; break;
      case OrderStatus.arrivedAtRestaurant: label = "PICKED UP / OUT FOR DELIVERY"; nextStatus = OrderStatus.outForDelivery; break;
      case OrderStatus.outForDelivery: label = "ARRIVED AT CUSTOMER"; nextStatus = OrderStatus.arrivedAtCustomer; break;
      case OrderStatus.arrivedAtCustomer: label = "COMPLETE DELIVERY"; nextStatus = OrderStatus.delivered; break;
      default: return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => _updateOrderStatus(order.id, nextStatus),
        style: ElevatedButton.styleFrom(
          backgroundColor: nextStatus == OrderStatus.delivered ? Colors.green : AppColors.lightOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Future<void> _updateOrderStatus(String orderId, OrderStatus status) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    
    final Map<String, dynamic> data = {
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (status == OrderStatus.driverAssigned) data['driverId'] = uid;
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update(data);
  }

  void _launchCaller(String? phone) async {
    if (phone == null) return;
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Widget _buildDriverDrawer() {
    final state = context.read<AuthCubit>().state;
    final email = state is Authenticated ? state.user.email : FirebaseAuth.instance.currentUser?.email;
    return Drawer(
      child: Column(children: [
        UserAccountsDrawerHeader(decoration: const BoxDecoration(color: Color(0xFFF4A73D)), currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.delivery_dining, color: Color(0xFFF4A73D))), accountName: const Text('Driver Mode'), accountEmail: Text(email ?? '')),
        ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () => Navigator.pop(context)),
        const Spacer(),
        ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Logout', style: TextStyle(color: Colors.red)), onTap: () { context.read<AuthCubit>().logout(); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()), (r) => false); }),
      ]),
    );
  }
}

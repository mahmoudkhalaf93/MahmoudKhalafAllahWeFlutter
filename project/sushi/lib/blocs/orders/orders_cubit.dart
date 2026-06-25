import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/order_model.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OrdersCubit() : super(OrdersInitial());

  String? get _uid => _auth.currentUser?.uid;

  void loadOrders() {
    if (_uid == null) return;
    emit(OrdersLoading());

    _firestore
        .collection('orders')
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final allOrders = snapshot.docs.map((doc) => OrderModel.fromJson(doc.data(), doc.id)).toList();

      final active = allOrders.where((o) => 
        o.status != OrderStatus.delivered && 
        o.status != OrderStatus.cancelledByCustomer &&
        o.status != OrderStatus.cancelledByRestaurant &&
        o.status != OrderStatus.failedDelivery
      ).toList();

      final history = allOrders.where((o) => 
        o.status == OrderStatus.delivered || 
        o.status == OrderStatus.cancelledByCustomer ||
        o.status == OrderStatus.cancelledByRestaurant ||
        o.status == OrderStatus.failedDelivery
      ).toList();

      emit(OrdersLoaded(activeOrders: active, historyOrders: history));
    }, onError: (e) {
      emit(OrdersError(e.toString()));
    });
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': OrderStatus.cancelledByCustomer.name,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}

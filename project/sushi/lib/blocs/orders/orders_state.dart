import 'package:equatable/equatable.dart';
import '../../models/order_model.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> activeOrders;
  final List<OrderModel> historyOrders;

  OrdersLoaded({required this.activeOrders, required this.historyOrders});

  @override
  List<Object?> get props => [activeOrders, historyOrders];
}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

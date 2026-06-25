import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/app_colors.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../blocs/cart/cart_state.dart';
import '../../widgets/cart_item_tile.dart';
import '../orders/my_orders_screen.dart';
import '../auth/login_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackgroundProfile,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty 🍱', style: TextStyle(fontSize: 18, color: AppColors.gray)));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items.values.toList()[index];
                    return CartItemTile(
                      item: item,
                      onQuantityChanged: (delta) => context.read<CartCubit>().updateQuantity(item.firebaseId!, delta),
                      onRemove: () => context.read<CartCubit>().removeItem(item.firebaseId!),
                    );
                  },
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.read<CartCubit>().calculateDelivery(),
                        icon: const Icon(Icons.location_on_outlined, size: 18),
                        label: const Text('CALCULATE DELIVERY'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.lightOrange,
                          side: const BorderSide(color: AppColors.lightOrange),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildPriceRow('Subtotal', '${state.subtotal.toStringAsFixed(2)} EGP'),
                    _buildPriceRow('Delivery Fee', '${state.deliveryFee.toStringAsFixed(2)} EGP'),
                    const Divider(height: 20),
                    _buildPriceRow('Total Amount', '${state.totalAmount.toStringAsFixed(2)} EGP', isTotal: true),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            _showLoginPrompt(context);
                          } else {
                            final orderId = await context.read<CartCubit>().placeOrder();
                            if (orderId != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order placed successfully! 🚀')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('PURCHASE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to sign in or create an account to complete your order.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.lightOrange),
            child: const Text('LOGIN / REGISTER'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(
            fontSize: isTotal ? 22 : 14, 
            fontWeight: FontWeight.bold, 
            color: isTotal ? AppColors.lightOrange : AppColors.black,
          )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/app_colors.dart';
import '../../models/item_model.dart';
import '../../models/category_model.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../blocs/cart/cart_state.dart';
import '../menu/item_details_screen.dart';
import '../cart/cart_screen.dart';
import '../favorites/favorites_screen.dart';

class CategoryItemsScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryItemsScreen({super.key, required this.category});

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      final snapshot = await _firestore
          .collection('cat')
          .doc(widget.category.firebaseId)
          .collection('items')
          .get();
      
      if (mounted) {
        setState(() {
          _items = snapshot.docs.map((doc) => ItemModel.fromJson(doc.data(), doc.id)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading items: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Order Banner
              Stack(
                children: [
                  Image.asset(
                    'assets/images/layer_2_copy_3.png',
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                  widget.category.name ?? '',
                  style: const TextStyle(
                    color: AppColors.lightOrange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 2. Items List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.lightOrange))
                    : BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 0, bottom: 100),
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final isInCart = cartState.items.containsKey(_items[index].firebaseId);
                              return _buildXmlStyleTile(_items[index], isInCart);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),

          // 3. Floating Action Buttons with Stroke
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              children: [
                // _buildFloatingButton(Icons.favorite, AppColors.lightOrange, Colors.white, () {
                //    Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                // }),
                // const SizedBox(height: 15),
                _buildFloatingButton(Icons.shopping_cart, AppColors.lightOrange, Colors.white, () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                }, isLarge: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXmlStyleTile(ItemModel item, bool isInCart) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemDetailsScreen(item: item)),
        );
      },
      child: Container(
        height: 125,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Card
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.79,
                margin: const EdgeInsets.only(left: 55, right: 15), // Pushed to the right
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                padding: const EdgeInsets.only(left: 60, right: 45), // Left padding for text to clear the image
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name ?? '',
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.description ?? '',
                      style: const TextStyle(fontSize: 11, color: AppColors.gray),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Price (itme_price)
            Positioned(
              top: 25,
              right: 60,
              child: Text(
                '${item.price?.toStringAsFixed(2)}',
                style: const TextStyle(color: AppColors.grayTextInProfile, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),

            // Image Card - Half-in, Half-out
            Positioned(
              left: 10, // Absolute left position
              child: Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: item.image ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (c,e,s) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),

            // Action Button (Cart/Check) - Overlapping the edge
            Positioned(
              right: 12, // Half-in, Half-out feel
              child: GestureDetector(
                onTap: () {
                  if (isInCart) {
                    context.read<CartCubit>().removeItem(item.firebaseId!);
                  } else {
                    context.read<CartCubit>().addItem(item);
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade100, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Icon(
                    isInCart ? Icons.check : Icons.shopping_cart_outlined,
                    size: 20,
                    color: AppColors.lightOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap, {bool isLarge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isLarge ? 70 : 55,
        height: isLarge ? 70 : 55,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3), // White Stroke
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Icon(icon, color: iconColor, size: isLarge ? 30 : 22),
      ),
    );
  }
}

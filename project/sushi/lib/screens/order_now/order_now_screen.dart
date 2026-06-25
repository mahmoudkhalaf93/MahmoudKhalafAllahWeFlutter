import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../blocs/menu/menu_cubit.dart';
import '../../blocs/menu/menu_state.dart';
import '../../models/category_model.dart';
import 'category_items_screen.dart';
import '../favorites/favorites_screen.dart';
import '../cart/cart_screen.dart';

class OrderNowScreen extends StatefulWidget {
  const OrderNowScreen({super.key});

  @override
  State<OrderNowScreen> createState() => _OrderNowScreenState();
}

class _OrderNowScreenState extends State<OrderNowScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().loadCategories();
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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                  'Order Now',
                  style: TextStyle(
                    color: AppColors.lightOrange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 2. Categories List (Matching CategoryItems style)
              Expanded(
                child: BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    if (state is MenuLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.lightOrange));
                    } else if (state is MenuLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 0, bottom: 100),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryTile(state.categories[index]);
                        },
                      );
                    }
                    return const Center(child: Text('No categories found'));
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
                _buildFloatingButton(Icons.favorite, AppColors.lightOrange, Colors.white, () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                }),
                const SizedBox(height: 15),
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

  Widget _buildCategoryTile(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => CategoryItemsScreen(category: category))
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
                margin: const EdgeInsets.only(left: 55, right: 15),
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                padding: const EdgeInsets.only(left: 60, right: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name ?? '',
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      category.description ?? 'Explore our delicious items',
                      style: const TextStyle(fontSize: 11, color: AppColors.gray),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Image Card - Half-in, Half-out
            Positioned(
              left: 10,
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
                    imageUrl: category.image ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (c,e,s) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),

            // Action Button (Arrow) - Overlapping the edge
            Positioned(
              right: 12,
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
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.lightOrange,
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

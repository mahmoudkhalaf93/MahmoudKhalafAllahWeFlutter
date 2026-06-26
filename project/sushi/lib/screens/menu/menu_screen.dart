import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../blocs/menu/menu_cubit.dart';
import '../../blocs/menu/menu_state.dart';
import '../../models/item_model.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../blocs/cart/cart_state.dart';
import '../favorites/favorites_screen.dart';
import '../cart/cart_screen.dart';
import 'item_details_screen.dart';

class MenuScreen extends StatefulWidget {
  final bool isShell;
  const MenuScreen({super.key, this.isShell = false});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading && state is! MenuLoaded) {
            return const Center(child: CircularProgressIndicator(color: AppColors.lightOrange));
          } else if (state is MenuLoaded) {
            final categories = state.categories;
            final items = state.items;
            final selectedIndex = state.selectedCategoryIndex;

            return Stack(
              children: [
                Column(
                  children: [
                    // --- Header Section ---
                    Transform.translate(
                      offset: const Offset(0, -35),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 500) {
                            if (selectedIndex > 0) {
                              context.read<MenuCubit>().selectCategory(selectedIndex - 1);
                            }
                          } else if (details.primaryVelocity! < -500) {
                            if (selectedIndex < categories.length - 1) {
                              context.read<MenuCubit>().selectCategory(selectedIndex + 1);
                            }
                          }
                        },
                        child: Stack(
                          children: [
                            // 1. White Base Bar (The thick curve at bottom)
                            Container(
                              height: 260,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                            ),
                            
                            // 2. Main Image
                            Container(
                              height: 250,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                                  child: CachedNetworkImage(
                                    key: ValueKey<int>(selectedIndex),
                                    imageUrl: categories[selectedIndex].image ?? '',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: double.infinity,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                                    errorWidget: (c,e,s) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),

                            // 3. Color Overlays (Orange + Gradient)
                            Positioned.fill(
                              bottom: 10, // Match image height roughly (260 - 250 = 10 difference)
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4A73D).withOpacity(0.15),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                ),
                              ),
                            ),

                            // 4. PURE WHITE BORDER (Placed on top of overlays to stay white)
                            Positioned.fill(
                              bottom: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                ),
                              ),
                            ),

                            // 5. Text & Dots
                            Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              child: Text(
                                categories[selectedIndex].name ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  categories.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: index == selectedIndex ? 10 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index == selectedIndex ? Colors.white : Colors.white38,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Items List ---
                    Expanded(
                      child: BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 0, bottom: 100),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final isInCart = cartState.items.containsKey(items[index].firebaseId);
                              return _buildXmlStyleTile(items[index], isInCart);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Floating Action Buttons
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
            );
          }
          return const Center(child: Text('No categories available.'));
        },
      ),
    );
  }

  Widget _buildXmlStyleTile(ItemModel item, bool isInCart) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailsScreen(item: item)));
      },
      child: Container(
        height: 125,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.79,
                margin: const EdgeInsets.only(left: 55, right: 15),
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                padding: const EdgeInsets.only(left: 60, right: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name ?? '', style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(item.description ?? '', style: const TextStyle(fontSize: 11, color: AppColors.gray), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: 60,
              child: Text('${item.price?.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.grayTextInProfile, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            Positioned(
              left: 10,
              child: Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))]),
                child: ClipRRect(borderRadius: BorderRadius.circular(18), child: CachedNetworkImage(imageUrl: item.image ?? '', fit: BoxFit.cover, errorWidget: (c,e,s) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover))),
              ),
            ),
            Positioned(
              right: 12,
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
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade100, width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Icon(isInCart ? Icons.check : Icons.shopping_cart_outlined, size: 20, color: AppColors.lightOrange),
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
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Icon(icon, color: iconColor, size: isLarge ? 30 : 22),
      ),
    );
  }
}

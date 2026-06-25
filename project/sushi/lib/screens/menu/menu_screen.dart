import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../blocs/menu/menu_cubit.dart';
import '../../blocs/menu/menu_state.dart';
import '../../widgets/menu_item_tile.dart';
import 'item_details_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

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
      backgroundColor: AppColors.grayBackgroundProfileStrong,
      appBar: AppBar(
        title: Image.asset('assets/images/layer_2.png', height: 40),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading && state is! MenuLoaded) {
            return const Center(child: CircularProgressIndicator(color: AppColors.lightOrange));
          } else if (state is MenuLoaded) {
            final categories = state.categories;
            final items = state.items;
            final selectedIndex = state.selectedCategoryIndex;

            return Column(
              children: [
                // Categories Header with Curved Bottom and Swipe
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      // Curved Category Image
                      Positioned.fill(
                        child: ClipPath(
                          clipper: CustomMenuHeaderClipper(),
                          child: GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! < 0) {
                                if (selectedIndex < categories.length - 1) {
                                  context.read<MenuCubit>().selectCategory(selectedIndex + 1);
                                }
                              } else if (details.primaryVelocity! > 0) {
                                if (selectedIndex > 0) {
                                  context.read<MenuCubit>().selectCategory(selectedIndex - 1);
                                }
                              }
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: CachedNetworkImage(
                                key: ValueKey<int>(selectedIndex),
                                imageUrl: categories[selectedIndex].image ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Gradient Overlay
                      Positioned.fill(
                        child: IgnorePointer(
                          child: ClipPath(
                            clipper: CustomMenuHeaderClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Category Name and Indicator
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              categories[selectedIndex].name ?? '',
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                categories.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: index == selectedIndex ? 10 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == selectedIndex ? Colors.white : Colors.white30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Items List
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ListView.builder(
                      key: ValueKey<int>(selectedIndex),
                      padding: const EdgeInsets.only(top: 0, bottom: 20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return MenuItemTile(
                          item: items[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ItemDetailsScreen(item: items[index])),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CustomMenuHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height + 50, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

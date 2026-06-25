import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../models/item_model.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/favorites/favorites_state.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Left Orange Background Strip
          Container(
            width: MediaQuery.of(context).size.width * 0.40,
            height: double.infinity,
            color: const Color(0xFFF4A73D),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Item Name (Floating Box)
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      widget.item.name ?? '',
                      style: const TextStyle(
                        color: Color(0xFFF4A73D),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Item Price (Orange Box)
                Padding(
                  padding: const EdgeInsets.only(left: 150, top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4A73D),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      '${widget.item.price?.toStringAsFixed(2) ?? '0.00'} EGP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Item Image Card
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Hero(
                          tag: 'image_${widget.item.firebaseId}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: widget.item.image ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey.shade200),
                              errorWidget: (context, url, error) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      
                      // Favorite Heart - Positioned inside the card
                      Positioned(
                        top: 10,
                        right: 10,
                        child: BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {
                            final isFav = context.read<FavoritesCubit>().isFavorite(widget.item.firebaseId ?? '');
                            return GestureDetector(
                              onTap: () {
                                context.read<FavoritesCubit>().toggleFavorite(widget.item);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4A73D).withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Description Text
                Padding(
                  padding: const EdgeInsets.only(left: 170, right: 24),
                  child: Text(
                    widget.item.description ?? '',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFF4A73D),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Add to Cart Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartCubit>().addItem(widget.item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.item.name} added to cart!'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFFF4A73D),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFF4A73D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'ADD TO CART',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

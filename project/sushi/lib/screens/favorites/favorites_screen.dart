import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/app_colors.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../blocs/favorites/favorites_state.dart';
import '../../widgets/menu_item_tile.dart';
import '../menu/item_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final bool isShell;
  const FavoritesScreen({super.key, this.isShell = false});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackgroundProfileStrong,
      appBar: widget.isShell ? null : AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.lightOrange));
          } else if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('No favorites yet ❤️', style: TextStyle(fontSize: 18, color: AppColors.gray)));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                return MenuItemTile(
                  item: state.favorites[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsScreen(item: state.favorites[index]),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

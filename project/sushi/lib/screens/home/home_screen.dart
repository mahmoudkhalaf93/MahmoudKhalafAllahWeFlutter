import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_strings.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../models/offer_model.dart';
import '../../widgets/offer_card.dart';
import '../../blocs/menu/menu_cubit.dart';
import '../menu/menu_screen.dart';
import '../cart/cart_screen.dart';
import '../order_now/order_now_screen.dart';
import '../orders/my_orders_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../restaurant/restaurant_screen.dart';
import '../info/about_us_screen.dart';
import '../info/contact_us_screen.dart';
import 'offer_items_screen.dart';
import '../../models/item_model.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  UserModel? _userData;
  List<OfferModel> _offers = [];
  bool _isLoadingOffers = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadOffers();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _userData = UserModel.fromJson(doc.data()!);
        });
      }
    }
  }

  void _loadOffers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('offers').get();
      if (mounted) {
        setState(() {
          _offers = snapshot.docs.map((doc) => OfferModel.fromJson(doc.data(), doc.id)).toList();
          _isLoadingOffers = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingOffers = false);
      debugPrint("Error loading offers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Image.asset('assets/images/layer_2.png', height: 50),
        centerTitle: true,
        backgroundColor: Color(0xFFF4A73D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Banner Image with Orange Background to remove white gap
            Container(
              width: double.infinity,
              height: 280,
              color: AppColors.white,
              child: Image.asset(
                'assets/images/layer_10.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: AppColors.lightOrange),
              ),
            ),
            
            // Offers Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              // Removed negative transform to avoid cutting the image
              child: _isLoadingOffers
                  ? const Center(child: CircularProgressIndicator(color: AppColors.lightOrange))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _offers.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final offer = _offers[index];
                        return OfferCard(
                          offer: offer,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OfferItemsScreen(offer: offer)),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.home_outlined, AppStrings.menuHome, () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.shopping_bag_outlined, 'Order Now', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderNowScreen()));
                }),
                _buildDrawerItem(Icons.list_alt_outlined, 'My Orders', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersScreen()));
                }),
                _buildDrawerItem(Icons.restaurant_menu, 'Menu', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
                }),
                _buildDrawerItem(Icons.store_outlined, AppStrings.menuRestaurant, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RestaurantScreen()));
                }),
                _buildDrawerItem(Icons.favorite_border, AppStrings.menuFavorites, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                }),
                _buildDrawerItem(Icons.shopping_cart_outlined, AppStrings.menuCart, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                }),
                _buildDrawerItem(Icons.person_outline, 'My Account', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                }),
                const Divider(),
                _buildDrawerItem(Icons.info_outline, 'About Us', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
                }),
                _buildDrawerItem(Icons.contact_support_outlined, 'Contact Us', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsScreen()));
                }),
                _buildDrawerItem(Icons.logout, AppStrings.logout, _handleLogout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 20, bottom: 20, right: 20),
      decoration: const BoxDecoration(
        color: AppColors.lightOrange,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _userData?.image != null
                ? CachedNetworkImage(
                    imageUrl: _userData!.image!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset('assets/images/userpng.png', width: 60),
                    errorWidget: (context, url, error) => Image.asset('assets/images/userpng.png', width: 60),
                  )
                : Image.asset('assets/images/userpng.png', width: 60),
          ),
          const SizedBox(height: 10),
          Text(
            _userData?.name ?? 'Guest User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _userData?.email ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.lightOrange),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}

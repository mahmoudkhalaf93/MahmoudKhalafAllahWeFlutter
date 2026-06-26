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
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  UserModel? _userData;
  
  // Navigation State
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  // Get current title based on section
  String _getTitle() {
    switch (_currentIndex) {
      case 0: return 'Sushi';
      case 1: return 'Order Now';
      case 2: return 'My Orders';
      case 3: return 'Menu';
      case 4: return 'Our Restaurant';
      case 5: return 'Favorites';
      case 6: return 'My Cart';
      case 7: return 'My Account';
      case 8: return 'About Us';
      case 9: return 'Contact Us';
      default: return 'Sushi';
    }
  }

  // Get current content based on section
  Widget _getContent() {
    switch (_currentIndex) {
      case 0: return const HomeContent();
      case 1: return const OrderNowScreen(isShell: true);
      case 2: return const MyOrdersScreen(isShell: true);
      case 3: return const MenuScreen(isShell: true);
      case 4: return const RestaurantScreen(isShell: true);
      case 5: return const FavoritesScreen(isShell: true);
      case 6: return const CartScreen(isShell: true);
      case 7: return const ProfileScreen(isShell: true);
      case 8: return const AboutUsScreen(isShell: true);
      case 9: return const ContactUsScreen(isShell: true);
      default: return const HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: _currentIndex == 0 
          ? Image.asset('assets/images/layer_2.png', height: 50)
          : Text(_getTitle(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: _getContent(),
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
                _buildDrawerItem(Icons.home_outlined, AppStrings.menuHome, 0),
                _buildDrawerItem(Icons.shopping_bag_outlined, 'Order Now', 1),
                _buildDrawerItem(Icons.list_alt_outlined, 'My Orders', 2),
                _buildDrawerItem(Icons.restaurant_menu, 'Menu', 3),
                _buildDrawerItem(Icons.store_outlined, AppStrings.menuRestaurant, 4),
                _buildDrawerItem(Icons.favorite_border, AppStrings.menuFavorites, 5),
                _buildDrawerItem(Icons.shopping_cart_outlined, AppStrings.menuCart, 6),
                _buildDrawerItem(Icons.person_outline, 'My Account', 7),
                const Divider(),
                _buildDrawerItem(Icons.info_outline, 'About Us', 8),
                _buildDrawerItem(Icons.contact_support_outlined, 'Contact Us', 9),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.lightOrange),
                  title: const Text(AppStrings.logout),
                  onTap: _handleLogout,
                ),
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

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: AppColors.lightOrange),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex == index ? AppColors.lightOrange : Colors.black,
          fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        Navigator.pop(context); // Close Drawer
      },
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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<OfferModel> _offers = [];
  bool _isLoadingOffers = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../models/item_model.dart';
import '../../models/offer_model.dart';
import '../../widgets/menu_item_tile.dart';
import '../menu/item_details_screen.dart';

class OfferItemsScreen extends StatefulWidget {
  final OfferModel offer;

  const OfferItemsScreen({super.key, required this.offer});

  @override
  State<OfferItemsScreen> createState() => _OfferItemsScreenState();
}

class _OfferItemsScreenState extends State<OfferItemsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferItems();
  }

  void _loadOfferItems() async {
    try {
      final snapshot = await _firestore
          .collection('offers')
          .doc(widget.offer.firebaseId)
          .collection('items')
          .get();
      
      if (mounted) {
        setState(() {
          _items = snapshot.docs.map((doc) => ItemModel.fromJson(doc.data(), doc.id)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading offer items: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackgroundProfileStrong,
      body: Stack(
        children: [
          // Header Background (matching the offer image)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: widget.offer.image ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (c,e,s) => Container(color: AppColors.lightOrange),
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.4)),
                Center(
                  child: Text(
                    '${widget.offer.nameline1 ?? ''} ${widget.offer.nameline2 ?? ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Items List
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.grayBackgroundProfileStrong,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.lightOrange))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return MenuItemTile(
                          item: _items[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ItemDetailsScreen(item: _items[index])),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

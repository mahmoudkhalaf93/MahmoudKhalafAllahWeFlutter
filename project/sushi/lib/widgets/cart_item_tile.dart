import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item_model.dart';
import 'app_colors.dart';

class CartItemTile extends StatelessWidget {
  final ItemModel item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('dismiss_${item.firebaseId}'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onRemove(),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: Container(
        height: 125, // roughly _102sdp
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Card (Main Body)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                margin: const EdgeInsets.only(left: 40, right: 30),
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                padding: const EdgeInsets.only(left: 60, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // itme_mycart_name
                    Text(
                      item.name ?? '',
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // itme_mycart_description
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

            // Price (itme_mycart_price)
            Positioned(
              top: 25,
              right: 85,
              child: Text(
                '${item.price?.toStringAsFixed(1) ?? '0.0'}',
                style: const TextStyle(color: AppColors.grayTextInProfile, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            // Image Card (cardView4)
            Positioned(
              left: 15,
              child: Container(
                width: 86,
                height: 86,
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

            // Quantity Controller (cardView5) - Vertical Pill Shape
            Positioned(
              right: 15,
              child: Container(
                width: 42,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(180),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Plus Button - Expanded hit area
                    Expanded(
                      child: InkWell(
                        onTap: () => onQuantityChanged(1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(180)),
                        child: Center(
                          child: Image.asset('assets/images/copy.png', width: 14, height: 14, color: AppColors.lightOrange),
                        ),
                      ),
                    ),
                    
                    // Quantity Text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${item.quantity ?? 0}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                    ),
                    
                    // Minus Button - Expanded hit area
                    Expanded(
                      child: InkWell(
                        onTap: () => onQuantityChanged(-1),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(180)),
                        child: Center(
                          child: Image.asset('assets/images/invalid_name.png', width: 14, height: 14, color: AppColors.lightOrange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

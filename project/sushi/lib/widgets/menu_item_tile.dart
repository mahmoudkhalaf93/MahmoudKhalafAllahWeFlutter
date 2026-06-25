import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item_model.dart';
import 'app_colors.dart';

class MenuItemTile extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const MenuItemTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        height: 110,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // White Rounded Container (The Body)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(left: 65, right: 60, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name ?? '',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description ?? '',
                      style: const TextStyle(fontSize: 12, color: AppColors.gray),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            // Price Tag (Top Right)
            Positioned(
              top: 25,
              right: 65,
              child: Text(
                '${item.price?.toStringAsFixed(1) ?? '0.0'}EGP',
                style: const TextStyle(color: AppColors.grayTextInProfile, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            // Item Image (Floating Circle on Left)
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(2, 5)),
                ],
              ),
              child: Hero(
                tag: 'image_${item.firebaseId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: item.image ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColors.lightOrange, strokeWidth: 2)),
                    errorWidget: (context, url, error) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            
            // Circular Arrow Button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
                  ],
                ),
                child: const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.lightOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

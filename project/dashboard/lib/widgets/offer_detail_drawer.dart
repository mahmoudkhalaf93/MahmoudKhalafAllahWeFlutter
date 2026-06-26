import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/offer_model.dart';
import '../models/meal_model.dart';
import '../theme/app_theme.dart';
import '../l10n/app_strings.dart';
import 'app_image.dart';
import 'image_upload_field.dart';

class OfferDetailDrawer extends StatefulWidget {
  final OfferModel offer;
  final VoidCallback onClose;

  const OfferDetailDrawer({
    super.key,
    required this.offer,
    required this.onClose,
  });

  @override
  State<OfferDetailDrawer> createState() => _OfferDetailDrawerState();
}

class _OfferDetailDrawerState extends State<OfferDetailDrawer> {
  final FirebaseService _fs = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgCard,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<List<MealModel>>(
              stream: _fs.streamOfferItems(widget.offer.id),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snap.data ?? [];
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildSectionInfo(),
                    const SizedBox(height: 24),
                    _buildItemsList(items),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.offer.title.isNotEmpty
                      ? widget.offer.title
                      : 'قسم العرض',
                  style: AppTheme.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.offer.nameline1.isNotEmpty)
                  Text(
                    '${widget.offer.nameline1} ${widget.offer.nameline2}',
                    style: AppTheme.smallText,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppTheme.textMuted),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات القسم',
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (widget.offer.image.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: 120,
                child: AppImage(
                  imageUrl: widget.offer.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _infoRow(
            'السطر الأول:',
            '${widget.offer.nameline1} / ${widget.offer.nameline1Ar}',
          ),
          const SizedBox(height: 8),
          _infoRow(
            'السطر الثاني:',
            '${widget.offer.nameline2} / ${widget.offer.nameline2Ar}',
          ),
          const SizedBox(height: 8),
          _infoRow('الوقت:', '${widget.offer.time} / ${widget.offer.timeAr}'),
          const SizedBox(height: 8),
          _infoRow('الخصم:', '${widget.offer.discount}%'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label, style: AppTheme.smallText)),
        Expanded(
          child: Text(
            value,
            style: AppTheme.bodyText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(List<MealModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('عناصر العرض', style: AppTheme.sectionTitle),
            ElevatedButton.icon(
              onPressed: () => _showItemDialog(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('إضافة عنصر', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                foregroundColor: AppTheme.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'لا توجد عناصر مضافة',
              style: AppTheme.bodyText.copyWith(color: AppTheme.textMuted),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.bgCard,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: item.image.isEmpty
                          ? Icon(Icons.fastfood, color: AppTheme.textMuted)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AppImage(
                                imageUrl: item.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name.isNotEmpty ? item.name : item.nameAr,
                            style: AppTheme.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            '${item.price} EGP',
                            style: AppTheme.smallText.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          color: AppTheme.textSecondary,
                          onPressed: () => _showItemDialog(item),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          color: AppTheme.error,
                          onPressed: () => _confirmDeleteItem(item),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  void _showItemDialog([MealModel? item]) {
    final nameC = TextEditingController(text: item?.name ?? '');
    final nameArC = TextEditingController(text: item?.nameAr ?? '');
    final descC = TextEditingController(text: item?.description ?? '');
    final descArC = TextEditingController(text: item?.descriptionAr ?? '');
    final priceC = TextEditingController(text: item?.price.toString() ?? '');
    final imgC = TextEditingController(text: item?.image ?? '');
    bool isAvailable = item?.isAvailable ?? true;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            item == null ? 'إضافة عنصر للعرض' : 'تعديل العنصر',
            style: AppTheme.sectionTitle,
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      labelText: 'اسم العنصر (EN)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: nameArC,
                    decoration: const InputDecoration(
                      labelText: 'اسم العنصر (AR)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: descC,
                    decoration: const InputDecoration(labelText: 'الوصف (EN)'),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: descArC,
                    decoration: const InputDecoration(labelText: 'الوصف (AR)'),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: priceC,
                    decoration: const InputDecoration(
                      labelText: 'السعر بعد الخصم (EGP)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  ImageUploadField(
                    label: 'صورة العنصر',
                    currentImageUrl: imgC.text,
                    folderName: 'offers_items',
                    onImageUploaded: (url) {
                      imgC.text = url;
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  SwitchListTile(
                    title: Text('متاح', style: AppTheme.bodyText),
                    value: isAvailable,
                    onChanged: (v) => setState(() => isAvailable = v),
                    activeThumbColor: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(ctx),
              child: Text(
                S.cancel,
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (nameC.text.trim().isEmpty &&
                          nameArC.text.trim().isEmpty) {
                        return;
                      }
                      setState(() => isLoading = true);

                      final priceValue =
                          double.tryParse(priceC.text.trim()) ?? 0;
                      final newItem = MealModel(
                        id: item?.id ?? '',
                        categoryId: widget.offer.id,
                        name: nameC.text.trim(),
                        nameAr: nameArC.text.trim(),
                        description: descC.text.trim(),
                        descriptionAr: descArC.text.trim(),
                        price: priceValue,
                        image: imgC.text.trim(),
                        isAvailable: isAvailable,
                      );

                      bool ok;
                      if (item == null) {
                        ok = await _fs.addOfferItem(widget.offer.id, newItem);
                      } else {
                        ok = await _fs.updateOfferItem(
                          widget.offer.id,
                          newItem,
                        );
                      }

                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              item == null ? S.successAdd : S.successEdit,
                            ),
                          ),
                        );
                      } else if (!ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.errorOccurred)),
                        );
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(S.save),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteItem(MealModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.confirmDelete,
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(
          'هل أنت متأكد من حذف العنصر ${item.name.isNotEmpty ? item.name : item.nameAr}؟',
          style: AppTheme.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              S.cancel,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              final ok = await _fs.deleteOfferItem(widget.offer.id, item.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(ok ? S.successDelete : S.errorOccurred)),
              );
            },
            child: Text(S.delete),
          ),
        ],
      ),
    );
  }
}

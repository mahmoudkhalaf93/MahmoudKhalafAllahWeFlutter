import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/offer_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../l10n/app_strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/image_upload_field.dart';
import '../widgets/offer_detail_drawer.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';
  OfferModel? _selectedOffer;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_refresh);
  }

  @override
  void dispose() {
    _settings.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentIndex: 6,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: _selectedOffer != null ? 55 : 100,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppTheme.spaceL),
                  Expanded(child: _buildOffersList()),
                ],
              ),
            ),
          ),

          if (_selectedOffer != null) ...[
            Container(width: 1, color: AppTheme.borderColor),
            SizedBox(
              width: 420,
              child: OfferDetailDrawer(
                key: ValueKey(_selectedOffer!.id),
                offer: _selectedOffer!,
                onClose: () => setState(() => _selectedOffer = null),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Wrap(
      spacing: AppTheme.spaceM,
      runSpacing: AppTheme.spaceM,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إدارة العروض', style: AppTheme.pageTitle),
            const SizedBox(height: 4),
            Text(
              'عرض وإدارة العروض والخصومات',
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
        SizedBox(
          width: 250,
          height: 40,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: AppTheme.bodyText,
            decoration: InputDecoration(
              hintText: 'بحث في العروض...',
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showOfferDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: Text('إضافة عرض'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
        ),
      ],
    );
  }

  Widget _buildOffersList() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: StreamBuilder<List<OfferModel>>(
        stream: _fs.streamOffers(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    'لا توجد أقسام عروض حتى الآن',
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          var offers = snap.data!;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            offers = offers
                .where(
                  (o) =>
                      o.title.toLowerCase().contains(q) ||
                      o.nameline1.toLowerCase().contains(q),
                )
                .toList();
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusMain),
                  ),
                  border: Border(
                    bottom: BorderSide(color: AppTheme.borderColor, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'العرض',
                        style: AppTheme.smallText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'الخصم',
                        style: AppTheme.smallText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'الحالة',
                        style: AppTheme.smallText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'الإجراءات',
                        style: AppTheme.smallText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final o = offers[index];
                    final isSelected = _selectedOffer?.id == o.id;
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _selectedOffer = isSelected ? null : o,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withValues(alpha: 0.05)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: AppTheme.borderColor,
                                width: 0.5,
                              ),
                              right: isSelected
                                  ? BorderSide(
                                      color: AppTheme.primary,
                                      width: 3,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppTheme.bgSurface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: o.image.isEmpty
                                          ? Icon(
                                              Icons.local_offer,
                                              color: AppTheme.textMuted,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                o.image,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons
                                                          .image_not_supported_outlined,
                                                      color: AppTheme.textMuted,
                                                    ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: AppTheme.spaceM),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            o.title.isNotEmpty
                                                ? o.title
                                                : o.nameline1,
                                            style: AppTheme.bodyText.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            o.description.length > 30
                                                ? '${o.description.substring(0, 30)}...'
                                                : o.description,
                                            style: AppTheme.smallText.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${o.discount}%',
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppTheme.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: o.isActive
                                          ? AppTheme.success.withValues(
                                              alpha: 0.1,
                                            )
                                          : AppTheme.error.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      o.isActive ? 'نشط' : 'غير نشط',
                                      style: AppTheme.smallText.copyWith(
                                        color: o.isActive
                                            ? AppTheme.success
                                            : AppTheme.error,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      color: AppTheme.textSecondary,
                                      onPressed: () => _showOfferDialog(o),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                      ),
                                      color: AppTheme.error,
                                      onPressed: () => _confirmDelete(o),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showOfferDialog([OfferModel? offer]) {
    final titleC = TextEditingController(text: offer?.title ?? '');
    final descC = TextEditingController(text: offer?.description ?? '');
    final discountC = TextEditingController(
      text: offer?.discount.toString() ?? '',
    );
    final imgC = TextEditingController(text: offer?.image ?? '');

    final nameline1C = TextEditingController(text: offer?.nameline1 ?? '');
    final nameline1ArC = TextEditingController(text: offer?.nameline1Ar ?? '');
    final nameline2C = TextEditingController(text: offer?.nameline2 ?? '');
    final nameline2ArC = TextEditingController(text: offer?.nameline2Ar ?? '');
    final timeC = TextEditingController(text: offer?.time ?? '');
    final timeArC = TextEditingController(text: offer?.timeAr ?? '');

    bool isActive = offer?.isActive ?? true;
    bool isTimeCalendar = offer?.isTimeCalendar ?? false;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            offer == null ? 'إضافة قسم عرض' : 'تعديل قسم العرض',
            style: AppTheme.sectionTitle,
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: titleC,
                          decoration: const InputDecoration(
                            labelText: 'معرف أو عنوان داخلي (Title)',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: TextField(
                          controller: discountC,
                          decoration: const InputDecoration(
                            labelText: 'نسبة الخصم (%)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: descC,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameline1C,
                          decoration: const InputDecoration(
                            labelText: 'السطر الأول (EN)',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: TextField(
                          controller: nameline1ArC,
                          decoration: const InputDecoration(
                            labelText: 'السطر الأول (AR)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameline2C,
                          decoration: const InputDecoration(
                            labelText: 'السطر الثاني (EN)',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: TextField(
                          controller: nameline2ArC,
                          decoration: const InputDecoration(
                            labelText: 'السطر الثاني (AR)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: timeC,
                          decoration: const InputDecoration(
                            labelText: 'الوقت (EN)',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: TextField(
                          controller: timeArC,
                          decoration: const InputDecoration(
                            labelText: 'الوقت (AR)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  ImageUploadField(
                    label: 'صورة خلفية العرض',
                    currentImageUrl: imgC.text,
                    folderName: 'offers',
                    onImageUploaded: (url) {
                      imgC.text = url;
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: Text('القسم نشط', style: AppTheme.bodyText),
                          value: isActive,
                          onChanged: (v) => setState(() => isActive = v),
                          activeThumbColor: AppTheme.primary,
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: Text('مؤقت التقويم', style: AppTheme.bodyText),
                          value: isTimeCalendar,
                          onChanged: (v) => setState(() => isTimeCalendar = v),
                          activeThumbColor: AppTheme.primary,
                        ),
                      ),
                    ],
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
                      setState(() => isLoading = true);

                      final discountValue =
                          double.tryParse(discountC.text.trim()) ?? 0;

                      final newOffer = OfferModel(
                        id:
                            offer?.id ??
                            (titleC.text.trim().isNotEmpty
                                ? titleC.text.trim()
                                : DateTime.now().millisecondsSinceEpoch
                                      .toString()),
                        title: titleC.text.trim(),
                        description: descC.text.trim(),
                        discount: discountValue,
                        image: imgC.text.trim(),
                        isActive: isActive,
                        isTimeCalendar: isTimeCalendar,
                        nameline1: nameline1C.text.trim(),
                        nameline1Ar: nameline1ArC.text.trim(),
                        nameline2: nameline2C.text.trim(),
                        nameline2Ar: nameline2ArC.text.trim(),
                        time: timeC.text.trim(),
                        timeAr: timeArC.text.trim(),
                      );

                      bool ok;
                      if (offer == null) {
                        ok = await _fs.addOffer(newOffer);
                      } else {
                        ok = await _fs.updateOffer(offer.id, newOffer.toJson());
                      }

                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              offer == null ? S.successAdd : S.successEdit,
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

  void _confirmDelete(OfferModel o) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.confirmDelete,
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(
          'هل أنت متأكد من حذف العرض ${o.title}؟',
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
              final ok = await _fs.deleteOffer(o.id);
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

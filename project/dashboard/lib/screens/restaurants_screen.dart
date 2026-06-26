import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/restaurant_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../l10n/app_strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/image_upload_field.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';

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
      currentIndex: 5,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppTheme.spaceL),
            Expanded(child: _buildMainContent()),
          ],
        ),
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
            Text('إدارة المطاعم', style: AppTheme.pageTitle),
            const SizedBox(height: 4),
            Text(
              'عرض وإدارة المطاعم المشاركة',
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
              hintText: 'بحث بالاسم...',
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showRestaurantDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: Text('إضافة مطعم'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return StreamBuilder<List<RestaurantModel>>(
      stream: _fs.streamRestaurants(),
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
                  Icons.storefront_outlined,
                  size: 48,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(height: AppTheme.spaceM),
                Text(
                  'لا توجد مطاعم حتى الآن',
                  style: AppTheme.bodyText.copyWith(color: AppTheme.textMuted),
                ),
              ],
            ),
          );
        }

        var restaurants = snap.data!;
        if (_search.isNotEmpty) {
          final q = _search.toLowerCase();
          restaurants = restaurants
              .where((r) => r.name.toLowerCase().contains(q))
              .toList();
        }

        return _buildExpandableList(restaurants);
      },
    );
  }

  Widget _buildExpandableList(List<RestaurantModel> restaurants) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'المطعم',
                    style: AppTheme.smallText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'عدد الفروع',
                    style: AppTheme.smallText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
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
            child: ListView.separated(
              itemCount: restaurants.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, thickness: 1, color: AppTheme.borderColor),
              itemBuilder: (context, i) {
                final r = restaurants[i];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
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
                                  child: r.image.isEmpty
                                      ? Icon(
                                          Icons.storefront,
                                          color: AppTheme.textMuted,
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            r.image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) => Icon(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        r.name,
                                        style: AppTheme.bodyText.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        r.description.length > 30
                                            ? '${r.description.substring(0, 30)}...'
                                            : r.description,
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
                              '${r.branches.length} فروع',
                              style: AppTheme.bodyText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                  color: AppTheme.textSecondary,
                                  tooltip: S.edit,
                                  onPressed: () => _showRestaurantDialog(r),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                  ),
                                  color: AppTheme.error,
                                  tooltip: S.delete,
                                  onPressed: () => _confirmDelete(r),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildBranchesContent(r),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesContent(RestaurantModel r) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('إدارة الفروع', style: AppTheme.sectionTitle),
              ElevatedButton.icon(
                onPressed: () => _showBranchDialog(r),
                icon: const Icon(Icons.add, size: 16),
                label: Text('إضافة فرع', style: const TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                  foregroundColor: AppTheme.primary,
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          if (r.branches.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spaceL),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.borderColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Center(
                child: Text(
                  'لا توجد فروع مسجلة حتى الآن',
                  style: AppTheme.bodyText.copyWith(color: AppTheme.textMuted),
                ),
              ),
            )
          else
            Wrap(
              spacing: AppTheme.spaceM,
              runSpacing: AppTheme.spaceM,
              children: r.branches.map((b) => _buildBranchItem(r, b)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBranchItem(RestaurantModel r, RestaurantBranch b) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.storefront, color: AppTheme.primary, size: 16),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.name.isNotEmpty ? b.name : b.nameAr,
                  style: AppTheme.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'الحالة: ${b.status}',
                  style: AppTheme.smallText.copyWith(
                    color: b.status.toLowerCase() == 'open'
                        ? AppTheme.success
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 16),
            color: AppTheme.textSecondary,
            onPressed: () => _showBranchDialog(r, b),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 16),
            color: AppTheme.error,
            onPressed: () => _confirmDeleteBranch(r, b),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
    );
  }

  void _showBranchDialog(RestaurantModel r, [RestaurantBranch? branch]) {
    final nameC = TextEditingController(text: branch?.name ?? '');
    final nameArC = TextEditingController(text: branch?.nameAr ?? '');
    String status = branch?.status ?? 'open';
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            branch == null ? 'إضافة فرع جديد' : 'تعديل الفرع',
            style: AppTheme.sectionTitle,
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفرع (إنجليزي)',
                  ),
                ),
                const SizedBox(height: AppTheme.spaceS),
                TextField(
                  controller: nameArC,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفرع (عربي)',
                  ),
                ),
                const SizedBox(height: AppTheme.spaceS),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'الحالة',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: status,
                      isExpanded: true,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 'open', child: Text('مفتوح')),
                        DropdownMenuItem(value: 'close', child: Text('مغلق')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => status = v);
                      },
                    ),
                  ),
                ),
              ],
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

                      final newBranch = RestaurantBranch(
                        name: nameC.text.trim(),
                        nameAr: nameArC.text.trim(),
                        status: status,
                        location: branch?.location,
                      );

                      final updatedBranches = List<RestaurantBranch>.from(
                        r.branches,
                      );
                      if (branch == null) {
                        updatedBranches.add(newBranch);
                      } else {
                        final idx = updatedBranches.indexOf(branch);
                        if (idx != -1) updatedBranches[idx] = newBranch;
                      }

                      final ok = await _fs.updateRestaurant(r.id, {
                        'branches': updatedBranches
                            .map((b) => b.toJson())
                            .toList(),
                      });

                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (ok && mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(S.successEdit)));
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

  void _confirmDeleteBranch(RestaurantModel r, RestaurantBranch branch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(
          'هل أنت متأكد من حذف فرع "${branch.name.isNotEmpty ? branch.name : branch.nameAr}"؟',
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
              final updatedBranches = List<RestaurantBranch>.from(r.branches)
                ..remove(branch);
              final ok = await _fs.updateRestaurant(r.id, {
                'branches': updatedBranches.map((b) => b.toJson()).toList(),
              });

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

  void _showRestaurantDialog([RestaurantModel? restaurant]) {
    final nameC = TextEditingController(text: restaurant?.name ?? '');
    final descC = TextEditingController(text: restaurant?.description ?? '');
    final phoneC = TextEditingController(text: restaurant?.phone ?? '');
    final addressC = TextEditingController(text: restaurant?.address ?? '');
    final imgC = TextEditingController(text: restaurant?.image ?? '');
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            restaurant == null ? 'إضافة مطعم' : 'تعديل المطعم',
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
                    decoration: const InputDecoration(labelText: 'اسم المطعم'),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: descC,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: phoneC,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف (الرئيسي)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: addressC,
                    decoration: const InputDecoration(
                      labelText: 'العنوان (الرئيسي)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  ImageUploadField(
                    label: 'صورة المطعم',
                    currentImageUrl: imgC.text,
                    folderName: 'restaurants',
                    onImageUploaded: (url) {
                      imgC.text = url;
                    },
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
                      if (nameC.text.trim().isEmpty) return;
                      setState(() => isLoading = true);

                      bool ok;
                      if (restaurant == null) {
                        final newRes = RestaurantModel(
                          id: '',
                          name: nameC.text.trim(),
                          description: descC.text.trim(),
                          phone: phoneC.text.trim(),
                          address: addressC.text.trim(),
                          image: imgC.text.trim(),
                          branches: [],
                        );
                        ok = await _fs.addRestaurant(newRes);
                      } else {
                        final data = {
                          'name': nameC.text.trim(),
                          'description': descC.text.trim(),
                          'phone': phoneC.text.trim(),
                          'address': addressC.text.trim(),
                          'image': imgC.text.trim(),
                        };
                        ok = await _fs.updateRestaurant(restaurant.id, data);
                      }

                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              restaurant == null ? S.successAdd : S.successEdit,
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

  void _confirmDelete(RestaurantModel r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.confirmDelete,
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(
          'هل أنت متأكد من حذف المطعم ${r.name} وجميع فروعه؟',
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
              final ok = await _fs.deleteRestaurant(r.id);
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

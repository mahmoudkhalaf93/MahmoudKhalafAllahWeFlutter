import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/category_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../l10n/app_strings.dart';
import '../providers/settings_provider.dart';
import 'category_detail_screen.dart';
import '../widgets/image_upload_field.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';

  Map<String, CategoryStats> _analytics = {};
  bool _analyticsLoaded = false;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_refresh);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _settings.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _loadAnalytics() {
    _fs.getCategoryAnalytics().then((data) {
      if (mounted) {
        setState(() {
          _analytics = data;
          _analyticsLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppTheme.spaceL),
            Expanded(child: _buildDataTable()),
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
            Text(S.manageCategories, style: AppTheme.pageTitle),
            const SizedBox(height: 4),
            Text(
              S.manageCategoriesSub,
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
              hintText: S.searchInCategories,
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showCategoryDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: Text(S.addCategory),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: StreamBuilder<List<CategoryModel>>(
        stream: _fs.streamCategories(),
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
                    Icons.category_outlined,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    S.noCategoriesYet,
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          var cats = snap.data!;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            cats = cats
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(q) ||
                      c.description.toLowerCase().contains(q),
                )
                .toList();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: AppTheme.smallText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                dataTextStyle: AppTheme.bodyText,
                dividerThickness: 1,
                columnSpacing: 32,
                headingRowHeight: 48,
                dataRowMinHeight: 64,
                dataRowMaxHeight: 64,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: AppTheme.borderColor,
                    width: 1,
                  ),
                ),
                columns: [
                  const DataColumn(label: Text('Category')),
                  const DataColumn(label: Text('Description')),
                  DataColumn(label: Text(S.mealsCount)),
                  DataColumn(label: Text(S.completedOrders)),
                  DataColumn(label: Text(S.revenue)),
                  const DataColumn(label: Text('Actions')),
                ],
                rows: cats.map((c) => _buildDataRow(c)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(CategoryModel c) {
    final stats = _analytics[c.id];
    final mealsCount = stats?.mealsCount ?? 0;
    final completedOrders = stats?.completedOrders ?? 0;
    final revenue = stats?.revenue ?? 0;

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: c.image.isEmpty
                    ? Icon(Icons.category_outlined, color: AppTheme.textMuted)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          c.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported_outlined,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    c.name,
                    style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (c.nameAr.isNotEmpty)
                    Text(
                      c.nameAr,
                      style: AppTheme.smallText.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                c.description.isNotEmpty ? c.description : 'No description',
                style: AppTheme.smallText,
                overflow: TextOverflow.ellipsis,
              ),
              if (c.descriptionAr.isNotEmpty)
                Text(
                  c.descriptionAr,
                  style: AppTheme.smallText.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        DataCell(
          Text(
            _analyticsLoaded ? mealsCount.toString() : '...',
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(
          Text(
            _analyticsLoaded ? completedOrders.toString() : '...',
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(
          Text(
            _analyticsLoaded ? '${revenue.toStringAsFixed(0)} EGP' : '...',
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 18),
                color: AppTheme.info,
                tooltip: S.viewDetails,
                onPressed: () => _navigateToDetail(c),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppTheme.textSecondary,
                tooltip: S.edit,
                onPressed: () => _showCategoryDialog(c),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppTheme.error,
                tooltip: S.delete,
                onPressed: () => _confirmDelete(c),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(CategoryModel c) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: c)),
    );
  }

  void _showCategoryDialog([CategoryModel? category]) {
    final nameC = TextEditingController(text: category?.name ?? '');
    final nameArC = TextEditingController(text: category?.nameAr ?? '');
    final descC = TextEditingController(text: category?.description ?? '');
    final descArC = TextEditingController(text: category?.descriptionAr ?? '');
    final imgC = TextEditingController(text: category?.image ?? '');
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            category == null ? S.addCategory : S.editCategory,
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
                      labelText: 'اسم القسم (EN)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: nameArC,
                    decoration: const InputDecoration(
                      labelText: 'اسم القسم (AR)',
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
                  ImageUploadField(
                    label: 'صورة القسم (Category Image)',
                    currentImageUrl: imgC.text,
                    folderName: 'categories',
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
                      final newCat = CategoryModel(
                        id: category?.id ?? '',
                        name: nameC.text.trim(),
                        nameAr: nameArC.text.trim(),
                        description: descC.text.trim(),
                        descriptionAr: descArC.text.trim(),
                        image: imgC.text.trim(),
                      );
                      bool ok;
                      if (category == null) {
                        ok = await _fs.addCategory(newCat);
                      } else {
                        ok = await _fs.updateCategory(newCat);
                      }
                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              category == null ? S.successAdd : S.successEdit,
                            ),
                          ),
                        );
                        _loadAnalytics();
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

  void _confirmDelete(CategoryModel c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.confirmDelete,
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(S.deleteConfirmMsg(c.name), style: AppTheme.bodyText),
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
              final ok = await _fs.deleteCategory(c.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(ok ? S.successDelete : S.errorOccurred)),
              );
              _loadAnalytics();
            },
            child: Text(S.delete),
          ),
        ],
      ),
    );
  }
}
